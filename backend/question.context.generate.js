require("./firebase-admin");
const admin = require("firebase-admin");
const _ = require("lodash");

const openai = require("./openai");
const { SYSTEM_PROMPT } = require("./constants");
const { selectRoom } = require("./room.evaluate");

const PROMPT_CONTENT = `Create for me an English questions at CEFR B level for use in a Kahoot game about [topic_parameter]. The questions must meet the following criteria:

Structure of each question:
Context: A short paragraph of 2-5 sentences on [topic_parameter], appropriate for B1-B2 level
Question: Short, clear, easy to understand in 5-15 words

Four answer options, including:
One completely correct answer (+2 points)
One almost correct but not entirely suitable answer (1 points)
One incorrect but reasonable answer (-1 point)
One completely incorrect/absurd answer (-2 points)

Language areas to cover within [topic_parameter]:
- Vocabulary and terminology specific to [topic_parameter]
- Common expressions and idioms related to [topic_parameter]
- Practical communication situations involving [topic_parameter]
- Cultural aspects of [topic_parameter]
- Problem-solving language in [topic_parameter] contexts

Special requirements for Kahoot:
Brief context, no more than 50 words
Questions and answers must be short and concise for quick reading
Answers should not exceed 5-7 words each
Interesting, engaging content with a challenging nature
Suitable for a response time of 20-30 seconds`;

const workerId = process.argv[2];
const count = Number(process.argv[3] || 100);

if (process.argv[1] === __filename) main();

async function main() {
  if (!workerId) throw new Error("worker id must be set");

  const room = await selectRoom(workerId);
  if (!room) {
    console.log(`[${workerId}] NO_ROOM`);
    await new Promise((resolve) => setTimeout(resolve, 5000));
    return main();
  }

  await handler(room);
}

async function handler(room) {
  for (let i = 0; i < count; i++) {
    const question = await generate(room);
    question.id = `question_${Date.now()}_${i}`;
    question.room_id = room.id;
    question.schedule_at = Date.now();

    await admin
      .firestore()
      .collection("questions")
      .doc(question.id)
      .set(question);
    console.log(`[${question.id}] GENERATED`);
    await new Promise((resolve) => setTimeout(resolve, 3000));
  }
}

async function generate(room) {
  const dto = {
    model: "gpt-4",
    messages: [
      {
        role: "system",
        content: SYSTEM_PROMPT,
      },
      {
        role: "user",
        content: PROMPT_CONTENT.replaceAll("[topic_parameter]", room.topic),
      },
    ],
  };

  const response = await openai.chat.completions.create(dto);

  const content = response.choices[0].message.content;
  const question = JSON.parse(content);
  question.options = _.shuffle(
    Object.values(question.options).map((o) => ({
      score: Number(o.score),
      text: o.text,
    }))
  );

  return question;
}
