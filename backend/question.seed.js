require("./firebase-admin");
const admin = require("firebase-admin");

const {
  ROOM_STATUS_STARTING_NO_QUESION_WORKER,
  ROOM_STATUS_STARTING_HAS_QUESTION_WORKER,
  QUESTION_TYPE,
  COLLECTIONS,
} = require("./constants");
const openai = require("./openai");

main();

async function main() {
  const room = await selectRoom();
  if (!room) {
    console.log("NO_ROOM");
    await new Promise((resolve) => setTimeout(resolve, 5000));
    return main();
  }

  if (!room.type || !QUESTION_TYPE[room.type]) {
    console.log(`[${room.id}] Unknown room type ${room.type}`);
    return main();
  }

  let count = Number(room.question_count || 10);
  console.log(`[${room.id}] remaining ${count} questions`);

  while (count > 0) {
    try {
      const question = await genQuestion(room);
      await addQuestionToRoom(room, question);
      console.log(`[${room.id}] remaining ${--count} questions`);
    } catch (err) {
      console.log(`[${room.id}] ${err.message} | ${err.stack}`);
    }
  }

  return main();
}

async function selectRoom() {
  return admin.firestore().runTransaction(async (tx) => {
    const snapshots = await tx.get(
      admin
        .firestore()
        .collection(COLLECTIONS.ROOM)
        .where("status", "==", ROOM_STATUS_STARTING_NO_QUESION_WORKER)
        .limit(1)
    );

    if (snapshots.size === 0) return null;
    tx.update(snapshots.docs[0].ref, {
      status: ROOM_STATUS_STARTING_HAS_QUESTION_WORKER,
    });

    return snapshots.docs[0].data();
  });
}

async function addQuestionToRoom(room, question) {
  await admin.firestore().runTransaction(async (tx) => {
    const ref = admin.firestore().collection(COLLECTIONS.ROOM).doc(room.id);
    tx.update(ref, {
      questions: admin.firestore.FieldValue.arrayUnion(question),
    });
  });
}

async function genQuestion(room) {
  const dto = {
    model: "gpt-4",
    messages: [],
  };

  if (QUESTION_TYPE[room.type].system) {
    dto.messages.push({
      role: "system",
      content: QUESTION_TYPE[room.type].system,
    });
  }
  dto.messages.push({
    role: "user",
    content: QUESTION_TYPE[room.type].user,
  });

  const response = await openai.chat.completions.create(dto);
  const content = response.choices[0].message.content
    .replace("```json", "")
    .replace("```");
  return JSON.parse(content);
}
