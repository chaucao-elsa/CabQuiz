import 'package:cabquiz/features/failure/failure.dart';
import 'package:cabquiz/features/quiz/domain/dto/room_dto/room_dto.dart';
import 'package:cabquiz/features/quiz/domain/repository/quiz_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';

class QuizFirebaseRepository implements QuizRepository {
  late final FirebaseFirestore firestore;

  QuizFirebaseRepository() {
    firestore = FirebaseFirestore.instance;
  }

  @override
  Future<Either<Failure, Stream<RoomDto>>> listenToRoom(
      {required int roomId}) async {
    try {
      return Right(
        firestore.collection('rooms').doc('room_$roomId').snapshots().map(
              (snapshot) => RoomDto.fromFirestore(snapshot),
            ),
      );
    } on FirebaseException catch (e) {
      return Left(Failure.fromFirestoreError(e));
    } catch (e) {
      return Left(Failure.fromAppError(e as Exception));
    }
  }

  @override
  Future<Either<Failure, Stream<int?>>> listenToUserScore({
    required int roomId,
    required String username,
  }) async {
    try {
      return Right(
        firestore
            .collection('rooms')
            .doc('room_$roomId')
            .collection('participants')
            .doc(username)
            .snapshots()
            .map((snapshot) => snapshot.data()?['score'] as int?),
      );
    } on FirebaseException catch (e) {
      return Left(Failure.fromFirestoreError(e));
    } catch (e) {
      return Left(Failure.fromAppError(e as Exception));
    }
  }

  @override
  Future<Either<Failure, void>> sendAnswer(
      {required int roomId,
      required String username,
      required int answerIndex}) async {
    try {
      await firestore
          .collection('rooms')
          .doc('room_$roomId')
          .collection('participants')
          .doc(username)
          .update({
        'last_answer': answerIndex,
        'answer_time': FieldValue.serverTimestamp(),
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(Failure.fromFirestoreError(e));
    } catch (e) {
      return Left(Failure.fromAppError(e as Exception));
    }
  }
}
