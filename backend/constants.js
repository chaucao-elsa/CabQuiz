const ROOM_STATUS_WAITING = 0; //00000
const ROOM_STATUS_STARTING_NO_QUESION_WORKER = 1; //00001
const ROOM_STATUS_STARTING_HAS_QUESTION_WORKER = 3; //00011
const ROOM_STATUS_ONGOING = 7; //00111
const ROOM_STATUS_ONGOING_EVALUATE = 15; //00111
const ROOM_STATUS_DONE = 31; //11111

const QUESTION_TYPE = {
  similar: {
    system: "You are an assistant helping users learn English.",
    user: `Generate a beginner-level English question.
  1. Include four answer options:
     - One correct answer.
     - Three distractors (common mistakes and similar-sounding words).
  2. Randomize the correct answer position.
  3. Ensure the correct answer is clearly indicated in the output.
  4. Use simple vocabulary and real-life contexts (e.g., shopping, greetings, daily routines).
  5. Only return the output as JSON format with these fields:
     - question (string)
     - options (array of 4 strings)
     - correct_answer_index (integer, 0-3)`,
  },
};

const COLLECTIONS = {
  ROOM: "cabquiz_room",
};

module.exports = {
  ROOM_STATUS_WAITING,
  ROOM_STATUS_STARTING_NO_QUESION_WORKER,
  ROOM_STATUS_STARTING_HAS_QUESTION_WORKER,
  ROOM_STATUS_ONGOING,
  ROOM_STATUS_ONGOING_EVALUATE,
  ROOM_STATUS_DONE,
  QUESTION_TYPE,
  COLLECTIONS,
};
