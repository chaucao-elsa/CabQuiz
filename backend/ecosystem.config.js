module.exports = {
  apps: [
    {
      name: "cabquiz.question.free",
      script: "question.free.js",
      cwd: "/home/debian/CabQuiz/backend",
      autorestart: false,
    },
    {
      name: "cabquiz.room.evaluate.worker_1",
      script: "node room.evaluate.js worker_1",
      cwd: "/home/debian/CabQuiz/backend",
      autorestart: false,
    },
    {
      name: "cabquiz.room.evaluate.worker_2",
      script: "node room.evaluate.js worker_2",
      cwd: "/home/debian/CabQuiz/backend",
      autorestart: false,
    },
    {
      name: "cabquiz.room.evaluate.worker_3",
      script: "node room.evaluate.js worker_3",
      cwd: "/home/debian/CabQuiz/backend",
      autorestart: false,
    },
    {
      name: "cabquiz.room.evaluate.worker_4",
      script: "node room.evaluate.js worker_4",
      cwd: "/home/debian/CabQuiz/backend",
      autorestart: false,
    },
    {
      name: "cabquiz.room.evaluate.worker_5",
      script: "node room.evaluate.js worker_5",
      cwd: "/home/debian/CabQuiz/backend",
      autorestart: false,
    },
    {
      name: "cabquiz.question.context.generate.worker_1",
      script: "node question.context.generate.js worker_1",
      cwd: "/home/debian/CabQuiz/backend",
      autorestart: false,
    },
    {
      name: "cabquiz.question.context.generate.worker_2",
      script: "node question.context.generate.js worker_2",
      cwd: "/home/debian/CabQuiz/backend",
      autorestart: false,
    },
    {
      name: "cabquiz.question.context.generate.worker_3",
      script: "node question.context.generate.js worker_3",
      cwd: "/home/debian/CabQuiz/backend",
      autorestart: false,
    },
    {
      name: "cabquiz.question.context.generate.worker_4",
      script: "node question.context.generate.js worker_4",
      cwd: "/home/debian/CabQuiz/backend",
      autorestart: false,
    },
    {
      name: "cabquiz.question.context.generate.worker_5",
      script: "node question.context.generate.js worker_5",
      cwd: "/home/debian/CabQuiz/backend",
      autorestart: false,
    },
  ],
};
