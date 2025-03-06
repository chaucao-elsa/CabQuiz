require("./firebase-admin");
const admin = require("firebase-admin");

if (process.argv[1] === __filename) main();

async function main() {
  const workerId = process.argv[2];
  if (!workerId) throw new Error("worker id must be set");

  await handler(workerId);
}

async function handler(workerId) {
  const room = await selectRoom(workerId);
  if (!room) {
    console.log(`[${logs.join(" / ")}] NO_ROOM`);
    await new Promise((resolve) => setTimeout(resolve, 3000));
    return main();
  }

  const logs = [workerId];
  logs.push(room.id);
  logs.push(room.current_question?.id);

  if (room.current_question) await evaluate(logs, workerId, room);

  const question = await selectQuestion(room);
  await admin.firestore().collection("rooms").doc(room.id).set(
    {
      current_question: question,
      start_time: admin.firestore.FieldValue.serverTimestamp(),
    },
    { merge: true }
  );

  await new Promise((resolve) => setTimeout(resolve, 14000));
  return handler(workerId);
}

async function selectRoom(workerId) {
  return admin.firestore().runTransaction(async (tx) => {
    const room = await tx
      .get(
        admin.firestore().collection("rooms").where("worker_id", "==", workerId)
      )
      .then((s) => (s.size > 0 ? s.docs[0].data() : null));

    if (room) return room;

    const ref = admin
      .firestore()
      .collection("rooms")
      .where("worker_id", "==", "-");
    const snapshots = await tx.get(ref);
    if (snapshots.size === 0) return null;

    const doc = snapshots.docs[0].data();
    console.log(JSON.stringify(doc, null, 2));
    tx.update(admin.firestore().collection("rooms").doc(doc.id), {
      worker_id: workerId,
    });
    return doc;
  });
}

async function selectQuestion(room) {
  return admin.firestore().runTransaction(async (tx) => {
    const ref = admin
      .firestore()
      .collection("questions")
      .where("room_id", "==", "-")
      .limit(1);
    const snapshots = await tx.get(ref);
    if (snapshots.size === 0) return null;

    tx.update(snapshots.docs[0].ref, { room_id: room.id });
    return snapshots.docs[0].data();
  });
}

async function evaluate(logs, workerId, room) {
  const participants = await admin
    .firestore()
    .collection("rooms")
    .doc(room.id)
    .collection("participants")
    .get()
    .then((snapshots) => snapshots.docs.map((s) => s.data()));
  if (participants.length === 0) {
    console.log(`[${logs.join(" / ")}] NO_PARTICIPANTS`);
    await new Promise((resolve) => setTimeout(resolve, 1000));
    return handler(workerId);
  }

  console.log(`[${logs.join(" / ")}] ${participants.length} PARTICIPANTS`);

  const batch = admin.firestore().batch();
  for (let participant of participants) {
    logs.push(participant.username);

    const participantRef = admin
      .firestore()
      .collection("rooms")
      .doc(room.id)
      .collection("participants")
      .doc(participant.username);

    if (participant.answer_time) {
      const answer =
        Number.isSafeInteger(participant.last_answer) &&
        room.current_question.options[participant.last_answer];

      const score = Number(answer && answer.score) || 0;

      console.log(`[${logs.join(" / ")}] ${score} score`);
      batch.update(participantRef, {
        score: admin.firestore.FieldValue.increment(score),
        answer_time: admin.firestore.FieldValue.delete(),
        last_answer: admin.firestore.FieldValue.delete(),
      });
    } else {
      console.log(`[${logs.join(" / ")}] NO_ANSWER`);

      batch.update(participantRef, {
        answer_time: admin.firestore.FieldValue.delete(),
        last_answer: admin.firestore.FieldValue.delete(),
      });
    }
  }
  await batch.commit();
}

module.exports = { selectRoom };
