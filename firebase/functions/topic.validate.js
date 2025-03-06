const openai = require("./openai");

const PROMPT_CONTENT = `Check if the following parameter is a valid topic: "[topic_parameter]"
A topic is considered valid when:
- It's a word or phrase with meaning in natural language
- It refers to an activity, field, interest, or subject that humans might discuss
- It's not a random string of characters without meaning
- It's appropriate for English learning (not sensitive, explicit, offensive, or inappropriate for educational contexts)
Only answer "true" if the parameter is a valid topic.
Only answer "false" if the parameter is not a valid topic or if it contains sensitive/inappropriate content.
Examples:
- "travel" -> true
- "shopping" -> true 
- "go to work" -> true
- "ádnasjdbnasj" -> false
- "xzkqpr" -> false
- "adult content" -> false
- "illegal activities" -> false
- "explicit language" -> false`;

async function validateTopic(topic) {
  const dto = {
    model: "gpt-4",
    messages: [
      {
        role: "user",
        content: PROMPT_CONTENT.replaceAll("[topic_parameter]", topic),
      },
    ],
  };

  const response = await openai.chat.completions.create(dto);

  const content = response.choices[0].message.content;
  return content.toLowerCase() === "true";
}

module.exports = { validateTopic };
