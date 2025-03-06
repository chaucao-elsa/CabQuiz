/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

const db = admin.firestore();

// Rotate questions for all rooms every 15 seconds
exports.rotateQuestionForAllRooms = functions.region('asia-southeast1').pubsub
    .schedule('every 1 minutes')
    .onRun(async (context) => {
        const rotationCount = 4; // Number of rotations per minute
        const rotationInterval = 14750; // 14.75 seconds in milliseconds, overhead for the function to run

        for (let i = 0; i < rotationCount; i++) {
            await rotateQuestionsAndCalculateScores();

            // If this is not the last iteration, wait for the next rotation
            if (i < rotationCount - 1) {
                await new Promise(resolve => setTimeout(resolve, rotationInterval));
            }
        }

        console.log("Completed all rotations for this minute.");
    });

// Constants for scoring
const MAX_SCORE = 100;
const MIN_SCORE = 20;
const TOTAL_TIME = 15;

const rotateQuestionsAndCalculateScores = async (context) => {
    const roomsRef = db.collection('rooms');
    const questionsRef = db.collection('questions');

    // Get all rooms
    const roomsSnapshot = await roomsRef.get();

    if (roomsSnapshot.empty) {
        console.error("No rooms found!");
        return;
    }

    // Get the count of questions
    const snapshot = await questionsRef.count().get();
    const questionCount = snapshot.data().count;

    // Iterate through each room and rotate the question
    const batch = db.batch();

    for (const roomDoc of roomsSnapshot.docs) {
        const roomData = roomDoc.data();
        const roomId = roomDoc.id;

        // Generate a random question ID
        const randomQuestionId = `question_${Math.floor(Math.random() * questionCount)}`;

        // Get the random question
        const randomQuestionDoc = await questionsRef.doc(randomQuestionId).get();
        const randomQuestion = { id: randomQuestionDoc.id, ...randomQuestionDoc.data() };

        // Get only participants who have answered the last question
        const participantsRef = roomDoc.ref.collection('participants');
        const participantsSnapshot = await participantsRef
            .where('last_answer', '!=', null)
            .get();

        participantsSnapshot.forEach(participantDoc => {
            const participantData = participantDoc.data();
            const userId = participantDoc.id;

            // Calculate score if the user answered the last question
            if (participantData.answer_time !== undefined) {
                // Check if the answer is correct
                if (participantData.last_answer === roomData.current_question.correct_option) {
                    // Calculate time taken to answer
                    const timeTaken = Math.min((participantData.answer_time.toMillis() - roomData.start_time.toMillis()) / 1000, TOTAL_TIME);

                    // Calculate score based on time taken (faster answers get more points)
                    let score = MAX_SCORE - ((MAX_SCORE - MIN_SCORE) * timeTaken) / TOTAL_TIME;
                    score = Math.round(score);

                    // Update user's score
                    batch.update(participantDoc.ref, {
                        score: admin.firestore.FieldValue.increment(score),
                        answer_time: admin.firestore.FieldValue.delete(),
                        last_answer: admin.firestore.FieldValue.delete()
                    });

                    console.log(`User ${userId} in room ${roomId} earned ${score} points!`);
                } else {
                    // If the answer is incorrect, just remove the answer_time and last_answer fields
                    batch.update(participantDoc.ref, {
                        answer_time: admin.firestore.FieldValue.delete(),
                        last_answer: admin.firestore.FieldValue.delete()
                    });
                }
            }
        });

        // Update the room with the new current question
        batch.update(roomDoc.ref, {
            current_question: randomQuestion,
            start_time: admin.firestore.FieldValue.serverTimestamp()
        });

        console.log(`Room ${roomId} rotated to question: ${randomQuestion.question_text}`);
    }

    // Commit the batch update for all rooms
    await batch.commit();

    console.log("All rooms updated with new questions and scores calculated!");
};
