require("./firebase-admin");
const admin = require("firebase-admin");
const _ = require("lodash");
const { random } = require("./utils");

main();

async function main(limit = 100) {
  const stack = [await get(limit)];
  while (stack.length > 0) {
    const docs = stack.pop();
    const batch = admin.firestore().batch();
    for (let doc of docs) {
      console.log(`${doc.id} ...`);
      batch.update(doc.ref, {
        options: _.shuffle(doc.data().options).map((o) => {
          if (!o.score) o.score = 1;
          return o;
        }),
        schedule_at: Date.now() + 1000 * 60 * random(30, 60),
      });
    }
    await batch.commit();

    await new Promise((resolve) => setTimeout(resolve, 350000));
    stack.push(await get(limit));
  }
}

async function get(limit) {
  return admin
    .firestore()
    .collection("questions")
    .where("room_id", "!=", "-")
    .orderBy("schedule_at")
    .limit(limit)
    .get()
    .then((s) => s.docs);
}
