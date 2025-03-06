require("dotenv").config();
const { OpenAI } = require("openai");

const OPENAI_API_KEY = process.env.OPENAI_API_KEY;
if (!OPENAI_API_KEY) {
  throw new Error("OPENAI_API_KEY must be set");
}

module.exports = new OpenAI({ apiKey: OPENAI_API_KEY });
