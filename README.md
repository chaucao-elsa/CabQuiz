# CabQuiz

![simulator_screenshot_7FFADA1E-D909-4C9E-AA41-DEBB0575E34E](https://github.com/user-attachments/assets/e62370f8-2e89-4039-bf2c-2c4607e40d85)

![simulator_screenshot_A76A44D6-533F-49F9-8DD6-8C9390E6D2A4](https://github.com/user-attachments/assets/ad0831e7-a8d2-4e42-8405-8df9b7bc2c81)

![simulator_screenshot_7964912E-EB7F-4B80-83D5-29B15662264D](https://github.com/user-attachments/assets/5a736cf0-efb0-4d57-9f2d-9b8b9caadcff)

![simulator_screenshot_CBBF9382-2147-45EA-BE06-0383F0FF73C5](https://github.com/user-attachments/assets/aac7ac2e-07a4-4b64-bf55-559d7276e631)

# How to run.


## Run app
1. cd /app
2. run `flutter pub get` to get the dependencies
3. run `flutter pub run build_runner build` to generate code
3. run `flutter run` to run the app




# App Architecture

![App Architecture Diagram](https://bloclibrary.dev/_astro/bloc_architecture_full.CYn-T9Ox_Z20Hwr9.webp)

- App following recommended architecture of Bloc Library https://bloclibrary.dev/architecture/

## App Features Folder Structure

```
lib/features/
├── feature_name/
│   ├── blocs/
│   │   └── feature_cubit/
│   │       ├── feature_cubit.dart
│   │       ├── feature_state.dart
│   │       └── feature_cubit.freezed.dart
│   ├── domain/
│   │   ├── dto/
│   │   │   └── feature_dto.dart
│   │   └── repositories/
│   │       ├── feature_repository.dart
│   │       └── feature_remote_repository.dart
│   ├── models/
│   │   └── feature_dpo.dart
│   ├── services/
│   │   └── feature_service.dart
│   └── views/
│       ├── pages/
│       │   └── feature_page.dart
│       └── widgets/
│           └── feature_widget.dart
```

## Explanation

- UI talking with Bloc/Cubit, Cubit talk with Repository 
- DTO (Data Transfer Object) is a data class that match with API response
- Currently, repository is communicating with Firebase, API or any other services, the data should be match to DTO. API client, Firebase client, can be injected to repository
- Cubit is taking data from repository and transform to DPO (Data Presentation Object) and State. Repository can be injected to Cubit
- State is the final data structure that UI will use to build UI


- This is a simplified version of TDD Clean Architecture, the goal is to separate business logic and UI logic, make sure it is easy to test and maintain and changed. For example, if the api response structure is changed, we only need to change the DTO and the related API client, the Cubit and Repository are not affected. The same apply for other layers.




# Firebase Firestore Database

## Reason
1. Firebase Firestore is easy to setup and use, has good support for real-time data and cloud function
2. I have experience working with Firebase before.
3. Fit within the deadline (24h) and project scope

## Firestore Database Schema

#### 1. **`rooms` Collection**
   - **Document ID:** `room_<room_number>` (e.g., `room_1`)
     - **Fields:**
       - `current_question`: 
         - `question_text` (string): Text of the current question.
         - `options` (array of strings): List of 4 options for the question.
         - `correct_option` (integer): Index of the correct answer (0-3).
       - `question_index` (integer): The index of the current question in the rotation.
       - `start_time` (timestamp): Timestamp of when the current question started.

     - **Sub-collection:** `participants`
       - **Document ID:** Unique user ID (e.g., `user_abc`)
         - **Fields:**
           - `name` (string): User's name.
           - `score` (integer): Total score of the user.
           - `last_answer` (integer): Last answer given by the user (index of the option).
           - `answer_time` (timestamp): Timestamp of when the user answered the question.

#### 2. **`questions` Collection**
   - **Document ID:** Unique question ID (e.g., `question_1`)
     - **Fields:**
       - `question_text` (string): Text of the question.
       - `options` (array of strings): List of 4 options for the question.
       - `correct_option` (integer): Index of the correct answer (0-3).

### Firebase Cloud Function Overview

#### Function: `rotateQuestionsAndCalculateScores`
- **Trigger:** Runs every 15 seconds (run every 1 minute but the function runs every 15 seconds)
- **Purpose:** 
  - Rotates questions for each room in the `rooms` collection by selecting a random question from the `questions` collection.
  - Calculates user scores based of the time taken to answer the question
  - Increments the user's score maximum 100 points and minimum 20 points
  - Resets `last_answer` and `answer_time` fields for all users in preparation for the next question.

# room for improvement

- Add authentication
- Add total score features
- better and more scalable  way to rotate questions
- Add more test coverage and improve test data
- Web support
