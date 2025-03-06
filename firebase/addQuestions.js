const admin = require("firebase-admin");
const serviceAccount = require("./firebase_service_account.json");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

const questions = [
    {
        question_text: "What is the synonym of 'happy'?",
        options: ["Sad", "Joyful", "Angry", "Bored"],
        correct_option: 1
    },
    {
        question_text: "What is the antonym of 'fast'?",
        options: ["Slow", "Quick", "Speedy", "Swift"],
        correct_option: 0
    },
    {
        question_text: "Which word is a noun?",
        options: ["Run", "Beautiful", "Dog", "Quickly"],
        correct_option: 2
    },
    {
        question_text: "What is the past tense of 'run'?",
        options: ["Running", "Ran", "Run", "Runned"],
        correct_option: 1
    },
    {
        question_text: "Which is a verb?",
        options: ["Apple", "Walk", "Chair", "Blue"],
        correct_option: 1
    },
    {
        question_text: "Which is an adjective?",
        options: ["Happy", "Dance", "Book", "Quick"],
        correct_option: 3
    },
    {
        question_text: "What is the plural of 'child'?",
        options: ["Childs", "Children", "Childes", "Child"],
        correct_option: 1
    },
    {
        question_text: "Which is a pronoun?",
        options: ["He", "Jump", "Table", "Bright"],
        correct_option: 0
    },
    {
        question_text: "What is the synonym of 'big'?",
        options: ["Tiny", "Huge", "Light", "Small"],
        correct_option: 1
    },
    {
        question_text: "Which is a preposition?",
        options: ["Under", "Walk", "Orange", "Happy"],
        correct_option: 0
    },
    {
        question_text: "What is the opposite of 'hot'?",
        options: ["Warm", "Cold", "Tepid", "Boiling"],
        correct_option: 1
    },
    {
        question_text: "Which word means 'a large body of water'?",
        options: ["Lake", "Puddle", "River", "Ocean"],
        correct_option: 3
    },
    {
        question_text: "What is a synonym for 'beautiful'?",
        options: ["Ugly", "Pretty", "Plain", "Ordinary"],
        correct_option: 1
    },
    {
        question_text: "What is the past tense of 'eat'?",
        options: ["Eat", "Ate", "Eaten", "Eating"],
        correct_option: 1
    },
    {
        question_text: "Which word is an adverb?",
        options: ["Quick", "Quickly", "Quickness", "Quicken"],
        correct_option: 1
    },
    {
        question_text: "What is the opposite of 'brave'?",
        options: ["Cowardly", "Strong", "Fearless", "Bold"],
        correct_option: 0
    },
    {
        question_text: "Which word means 'to make something larger'?",
        options: ["Shrink", "Expand", "Collapse", "Reduce"],
        correct_option: 1
    },
    {
        question_text: "What is a synonym for 'intelligent'?",
        options: ["Dumb", "Clever", "Slow", "Ignorant"],
        correct_option: 1
    },
    {
        question_text: "Which is a fruit?",
        options: ["Carrot", "Potato", "Broccoli", "Apple"],
        correct_option: 3
    },
    {
        question_text: "What is the past participle of 'go'?",
        options: ["Went", "Going", "Gone", "Goed"],
        correct_option: 2
    },
    {
        question_text: "Which word is a conjunction?",
        options: ["However", "Quickly", "Jump", "Colorful"],
        correct_option: 0
    },
    {
        question_text: "What is the plural of 'mouse' (animal)?",
        options: ["Mouses", "Mice", "Meese", "Mouses"],
        correct_option: 1
    },
    {
        question_text: "Which word means 'to speak very quietly'?",
        options: ["Shout", "Whisper", "Yell", "Scream"],
        correct_option: 1
    },
    {
        question_text: "What is an antonym for 'ancient'?",
        options: ["Old", "Antique", "Modern", "Prehistoric"],
        correct_option: 2
    },
    {
        question_text: "Which word is a color?",
        options: ["Square", "Loud", "Blue", "Fast"],
        correct_option: 2
    },
    {
        "question_text": "What is a synonym for 'angry'?",
        "options": ["Happy", "Calm", "Furious", "Peaceful"],
        "correct_option": 2
    },
    {
        "question_text": "Which word means 'a piece of furniture for sitting'?",
        "options": ["Table", "Chair", "Door", "Floor"],
        "correct_option": 1
    },
    {
        "question_text": "What is the opposite of 'cheap'?",
        "options": ["Affordable", "Inexpensive", "Costly", "Bargain"],
        "correct_option": 2
    },
    {
        "question_text": "What is a synonym for 'start'?",
        "options": ["Finish", "Begin", "End", "Stop"],
        "correct_option": 1
    },
    {
        "question_text": "Which is a verb?",
        "options": ["Joy", "Run", "Happy", "Sun"],
        "correct_option": 1
    },
    {
        "question_text": "What is the plural of 'person'?",
        "options": ["Persons", "Peoples", "People", "Person"],
        "correct_option": 2
    },
    {
        "question_text": "What is a synonym for 'tired'?",
        "options": ["Exhausted", "Energetic", "Awake", "Vibrant"],
        "correct_option": 0
    },
    {
        "question_text": "What is the past tense of 'sing'?",
        "options": ["Sang", "Singed", "Sung", "Singing"],
        "correct_option": 0
    },
    {
        "question_text": "Which word is an adjective?",
        "options": ["Run", "Slow", "Quickly", "Yesterday"],
        "correct_option": 1
    },
    {
        "question_text": "What is the opposite of 'strong'?",
        "options": ["Weak", "Powerful", "Mighty", "Sturdy"],
        "correct_option": 0
    },
    {
        "question_text": "What is a synonym for 'rich'?",
        "options": ["Wealthy", "Poor", "Broke", "Cheap"],
        "correct_option": 0
    },
    {
        "question_text": "Which word is a pronoun?",
        "options": ["Jump", "They", "Run", "Quick"],
        "correct_option": 1
    },
    {
        "question_text": "What is the past participle of 'write'?",
        "options": ["Writed", "Writing", "Written", "Write"],
        "correct_option": 2
    },
    {
        "question_text": "Which word means 'to stop temporarily'?",
        "options": ["Start", "Pause", "Begin", "Continue"],
        "correct_option": 1
    },
    {
        "question_text": "What is an antonym for 'empty'?",
        "options": ["Full", "Vacant", "Open", "Hollow"],
        "correct_option": 0
    },
    {
        "question_text": "Which is a body part?",
        "options": ["Chair", "Table", "Leg", "Door"],
        "correct_option": 2
    },
    {
        "question_text": "What is the opposite of 'day'?",
        "options": ["Morning", "Night", "Afternoon", "Dusk"],
        "correct_option": 1
    },
    {
        "question_text": "What is a synonym for 'cold'?",
        "options": ["Warm", "Chilly", "Hot", "Humid"],
        "correct_option": 1
    },
    {
        "question_text": "Which word is a color?",
        "options": ["Round", "Red", "Sharp", "Tall"],
        "correct_option": 1
    },
    {
        "question_text": "What is the plural of 'goose'?",
        "options": ["Gooses", "Goose", "Geese", "Geeses"],
        "correct_option": 2
    },

    {
        "question_text": "What is the synonym of 'small'?",
        "options": ["Large", "Tiny", "Huge", "Massive"],
        "correct_option": 1
    },
    {
        "question_text": "Which word is a verb?",
        "options": ["Dog", "Beautiful", "Eat", "Apple"],
        "correct_option": 2
    },
    {
        "question_text": "What is the opposite of 'light'?",
        "options": ["Dark", "Bright", "Shiny", "Clear"],
        "correct_option": 0
    },
    {
        "question_text": "What is the plural of 'sheep'?",
        "options": ["Sheeps", "Sheep", "Sheepes", "Sheepe"],
        "correct_option": 1
    },
    {
        "question_text": "Which is a noun?",
        "options": ["Blue", "Run", "Table", "Slow"],
        "correct_option": 2
    },
    {
        "question_text": "What is a synonym for 'funny'?",
        "options": ["Boring", "Serious", "Amusing", "Sad"],
        "correct_option": 2
    },
    {
        "question_text": "What is the past tense of 'fly'?",
        "options": ["Flyed", "Flying", "Flew", "Flown"],
        "correct_option": 2
    },
    {
        "question_text": "Which is an adverb?",
        "options": ["Quickly", "Blue", "Tall", "Chair"],
        "correct_option": 0
    },
    {
        "question_text": "What is a synonym for 'quick'?",
        "options": ["Slow", "Fast", "Lethargic", "Calm"],
        "correct_option": 1
    },
    {
        "question_text": "What is the opposite of 'love'?",
        "options": ["Like", "Hate", "Care", "Adore"],
        "correct_option": 1
    },
    {
        "question_text": "Which word means 'a place to sleep'?",
        "options": ["Chair", "Table", "Bed", "Sofa"],
        "correct_option": 2
    },
    {
        "question_text": "What is a synonym for 'lazy'?",
        "options": ["Energetic", "Active", "Idle", "Busy"],
        "correct_option": 2
    },
    {
        "question_text": "What is the plural of 'foot'?",
        "options": ["Foots", "Feets", "Feet", "Foot"],
        "correct_option": 2
    },
    {
        "question_text": "What is the past participle of 'drink'?",
        "options": ["Drank", "Drunk", "Drinked", "Drinking"],
        "correct_option": 1
    },
    {
        "question_text": "Which word is a conjunction?",
        "options": ["Happy", "However", "Beautiful", "Strong"],
        "correct_option": 1
    },
    {
        "question_text": "What is an antonym for 'noisy'?",
        "options": ["Loud", "Silent", "Rowdy", "Boisterous"],
        "correct_option": 1
    },
    {
        "question_text": "Which word is a fruit?",
        "options": ["Cucumber", "Apple", "Carrot", "Potato"],
        "correct_option": 1
    },
    {
        "question_text": "What is a synonym for 'angry'?",
        "options": ["Calm", "Happy", "Furious", "Joyful"],
        "correct_option": 2
    },
    {
        "question_text": "What is the opposite of 'tall'?",
        "options": ["Short", "High", "Large", "Tiny"],
        "correct_option": 0
    },
    {
        "question_text": "What is a synonym for 'important'?",
        "options": ["Trivial", "Significant", "Minor", "Forgettable"],
        "correct_option": 1
    },
    {
        "question_text": "Which word is an adjective?",
        "options": ["Jump", "Beautiful", "Dance", "Dog"],
        "correct_option": 1
    },
    {
        "question_text": "What is the opposite of 'early'?",
        "options": ["Late", "Soon", "Fast", "Quick"],
        "correct_option": 0
    },
    {
        "question_text": "What is the plural of 'man'?",
        "options": ["Mens", "Mans", "Men", "Man"],
        "correct_option": 2
    },
    {
        "question_text": "Which word means 'to make something smaller'?",
        "options": ["Increase", "Expand", "Shrink", "Grow"],
        "correct_option": 2
    },
    {
        "question_text": "What is a synonym for 'calm'?",
        "options": ["Excited", "Relaxed", "Angry", "Upset"],
        "correct_option": 1
    },
    {
        "question_text": "What is a synonym for 'angry'?",
        "options": ["Happy", "Calm", "Irate", "Joyful"],
        "correct_option": 2
    },
    {
        "question_text": "What is the antonym of 'difficult'?",
        "options": ["Hard", "Simple", "Complex", "Complicated"],
        "correct_option": 1
    },
    {
        "question_text": "Which word is a verb?",
        "options": ["Happy", "Swift", "Jump", "Green"],
        "correct_option": 2
    },
    {
        "question_text": "What is the plural of 'fish'?",
        "options": ["Fishes", "Fish", "Fishs", "Fishies"],
        "correct_option": 1
    },
    {
        "question_text": "Which is a noun?",
        "options": ["Run", "Swim", "Tree", "Quickly"],
        "correct_option": 2
    },
    {
        "question_text": "What is a synonym for 'pretty'?",
        "options": ["Ugly", "Beautiful", "Rough", "Plain"],
        "correct_option": 1
    },
    {
        "question_text": "What is the past tense of 'sit'?",
        "options": ["Sitted", "Sit", "Sat", "Sitting"],
        "correct_option": 2
    },
    {
        "question_text": "Which is an adverb?",
        "options": ["Happy", "Quickly", "Tall", "Sun"],
        "correct_option": 1
    },
    {
        "question_text": "What is a synonym for 'strong'?",
        "options": ["Weak", "Powerful", "Fragile", "Delicate"],
        "correct_option": 1
    },
    {
        "question_text": "What is the opposite of 'hot'?",
        "options": ["Warm", "Cold", "Boiling", "Tepid"],
        "correct_option": 1
    },
    {
        "question_text": "Which word means 'a place to live'?",
        "options": ["Chair", "House", "Table", "Tree"],
        "correct_option": 1
    },
    {
        "question_text": "What is a synonym for 'lazy'?",
        "options": ["Industrious", "Energetic", "Idle", "Busy"],
        "correct_option": 2
    },
    {
        "question_text": "What is the plural of 'woman'?",
        "options": ["Women", "Womens", "Womans", "Woman"],
        "correct_option": 0
    },
    {
        "question_text": "What is the past participle of 'drink'?",
        "options": ["Drunk", "Drank", "Drinks", "Drinking"],
        "correct_option": 0
    },
    {
        "question_text": "Which word is a conjunction?",
        "options": ["And", "Running", "Beautiful", "Slow"],
        "correct_option": 0
    },
    {
        "question_text": "What is an antonym for 'happy'?",
        "options": ["Sad", "Joyful", "Excited", "Cheerful"],
        "correct_option": 0
    }

];

async function addQuestions() {
    const batch = db.batch();
    const questionsRef = db.collection('questions');

    questions.forEach((question, index) => {
        const docRef = questionsRef.doc(`question_${index}`);
        batch.set(docRef, question);
    });

    await batch.commit();
    console.log("Questions added to Firestore!");
}

addQuestions().catch(console.error);
