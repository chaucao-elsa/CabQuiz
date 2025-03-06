require("./firebase-admin");
const admin = require("firebase-admin");

main();

async function main(limit = 10) {
  const stack = [await get(limit)];
  while (stack.length > 0) {
    const refs = stack.pop();
    const batch = admin.firestore().batch();
    for (let ref of refs) {
      console.log(`${ref.id} ...`);
      batch.update(ref, { room_id: "-" });
    }
    await batch.commit();

    stack.push(await get(limit));
  }
}

async function get(limit) {
  return admin
    .firestore()
    .collection("questions")
    .where("room_id", "!=", "-")
    .limit(limit)
    .get()
    .then((s) => s.docs.map((d) => d.ref));
}
