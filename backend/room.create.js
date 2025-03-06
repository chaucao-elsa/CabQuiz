require("./firebase-admin");
const admin = require("firebase-admin");
const crypto = require("crypto");

const {
  COLLECTIONS,
  QUESTION_TYPE,
  ROOM_STATUS_STARTING_NO_QUESION_WORKER,
} = require("./constants");

async function main() {
  const name = process.argv[2];
  if (!name) throw new Error("name cannot be blank");

  const type = process.argv[3];
  if (!type) throw new Error("type cannot be blank");
  if (!QUESTION_TYPE[type]) {
    throw new Error(`type must be one of [${QUESTION_TYPE}]`);
  }

  const id = crypto
    .createHash("md5")
    .update(name + Date.now().toString())
    .digest("hex");

  const doc = {
    id,
    name,
    type,
    status: ROOM_STATUS_STARTING_NO_QUESION_WORKER,
    question_count: 10,
    question_ongoing_index: 0,
    questions: [],
    participants: {},
  };
  await admin.firestore().collection(COLLECTIONS.ROOM).doc(id).set(doc);

  console.log(doc);
}

main();
