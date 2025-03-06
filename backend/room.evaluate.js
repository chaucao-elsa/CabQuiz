require("./firebase-admin");
const admin = require("firebase-admin");

const {
  ROOM_STATUS_ONGOING,
  ROOM_STATUS_ONGOING_EVALUATE,
  COLLECTIONS,
} = require("./constants");

main();

async function main() {
  const room = await selectRoom();
  if (!room) {
    console.log("NO_ROOM");
    await new Promise((resolve) => setTimeout(resolve, 3000));
    return main();
  }

  console.log(`[${room.id}] evaluating`);
  await handler(room.id);
  return main();
}

async function handler(roomId) {
  await new Promise((resolve) =>
    setTimeout(async () => {
      const room = await admin
        .firestore()
        .collection(COLLECTIONS.ROOM)
        .doc(roomId)
        .get()
        .then((s) => s.data());

      if (room.question_ongoing_index >= room.questions.length) {
        console.log(`[${room.id}] reached latest`);
        return;
      }

      console.log(`[${room.id}] round #${room.question_ongoing_index}`);
      const updates = {
        question_ongoing_index: room.question_ongoing_index + 1,
      };

      const question = room.questions[room.question_ongoing_index];
      const ids = Object.keys(room.participants);
      for (let id of ids) {
        const participant = room.participants[id];
        if (!participant.answer_index) participant.answer_index = -1;

        const option = question.options[participant.answer_index];
        if (typeof option.score === "number") {
          updates[`participants.${id}.score`] =
            participant.score + option.score;
        }
      }

      console.log(`[${room.id}] ${JSON.stringify(updates)}`);
      await admin
        .firestore()
        .collection(COLLECTIONS.ROOM)
        .doc(room.id)
        .set(updates, { merge: true });

      resolve();
    }, 15000)
  );

  return handler(roomId);
}

async function selectRoom() {
  return admin.firestore().runTransaction(async (tx) => {
    const snapshots = await tx.get(
      admin
        .firestore()
        .collection(COLLECTIONS.ROOM)
        .where("status", "==", ROOM_STATUS_ONGOING)
        .limit(1)
    );

    if (snapshots.size === 0) return null;
    tx.update(snapshots.docs[0].ref, {
      status: ROOM_STATUS_ONGOING_EVALUATE,
    });

    return snapshots.docs[0].data();
  });
}
