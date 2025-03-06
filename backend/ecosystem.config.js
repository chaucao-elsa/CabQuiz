module.exports = {
  apps: [
    {
      name: "cabquiz.question.free",
      script: "question.free.js",
      cwd: "/home/ubuntu/CabQuiz/backend",
    },
    {
      name: "cabquiz.room.evaluate.worker_1",
      script: "node room.evaluate.js worker_1",
      cwd: "/home/ubuntu/CabQuiz/backend",
    },
    {
      name: "cabquiz.question.context.generate.worker_1",
      script: "node question.context.generate.js worker_1",
      cwd: "/home/ubuntu/CabQuiz/backend",
    },
  ],
};
