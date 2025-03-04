import 'package:cabquiz/features/failure/failure.dart';
import 'package:cabquiz/features/home/domain/dto/user/user_dto.dart';
import 'package:cabquiz/features/home/domain/repository/home_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';

class HomeFirebaseRepository implements HomeRepository {
  late final FirebaseFirestore firestore;

  HomeFirebaseRepository() {
    firestore = FirebaseFirestore.instance;
  }

  @override
  Future<Either<Failure, List<int>>> getRooms() async {
    try {
      final response = await firestore.collection('rooms').get();
      // convert list of room_id to list of int
      final roomIds = response.docs
          .map((doc) => int.parse(doc.id.split('_').last))
          .toList();
      return Right(roomIds);
    } on FirebaseException catch (e) {
      return Left(Failure.fromFirestoreError(e));
    } catch (e) {
      return Left(Failure.fromAppError(e as Exception));
    }
  }

  @override
  Future<Either<Failure, String>> joinRoom({
    required int roomId,
    required UserDto user,
  }) async {
    try {
      final roomRef = firestore.collection('rooms').doc('room_$roomId');

      // Check if room exists
      final roomDoc = await roomRef.get();
      if (!roomDoc.exists) {
        // Create room if it doesn't exist
        await roomRef.set({});
      }

      // Check if user already exists in the room
      final participants =
          await roomRef.collection('participants').doc(user.username).get();
      final userExists = participants.exists;

      if (!userExists) {
        // Add user to the room if they don't exist
        await roomRef
            .collection('participants')
            .doc(user.username)
            .set(user.toJson()..addAll({'score': 0}));
      }

      return Right('room_$roomId');
    } on FirebaseException catch (e) {
      return Left(Failure.fromFirestoreError(e));
    } catch (e) {
      return Left(Failure.fromAppError(e as Exception));
    }
  }
}
