const SYSTEM_PROMPT = `You are API service, only return JSON like this, no further text
{
    "context": "string",
    "question": "string",
    "options": {
      {
        "text": "string",
        "score": "number"
      },
      "A2": {
        "text": "string",
        "score": "number"
      },
      "A3": {
        "text": "string",
        "score": "number"
      },
      "A4": {
        "text": "string",
        "score": "number"
      }
    }
}`;

module.exports = { SYSTEM_PROMPT };
