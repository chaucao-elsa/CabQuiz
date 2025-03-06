require("./firebase-admin");
const admin = require("firebase-admin");
const _ = require("lodash");

main();

async function main(limit = 10) {
  const stack = [await get(limit)];
  while (stack.length > 0) {
    const docs = stack.pop();
    const batch = admin.firestore().batch();
    for (let doc of docs) {
      console.log(JSON.stringify(doc.data(), null, 2));
      console.log(`${doc.id} ...`);
      batch.update(doc.ref, {
        options: _.shuffle(doc.data().options),
        room_id: "-",
      });
    }
    await batch.commit();

    if (docs.length === limit) stack.push(await get(limit));
  }
}

async function get(limit) {
  return admin
    .firestore()
    .collection("questions")
    .where("room_id", "!=", "-")
    .limit(limit)
    .get()
    .then((s) => s.docs);
}
