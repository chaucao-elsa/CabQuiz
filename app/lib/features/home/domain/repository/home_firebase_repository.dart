import 'package:cabquiz/features/failure/failure.dart';
import 'package:cabquiz/features/home/domain/dto/user/user_dto.dart';
import 'package:cabquiz/features/home/domain/repository/home_repository.dart';
import 'package:cabquiz/features/quiz/domain/dto/room_dto/room_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';

class HomeFirebaseRepository implements HomeRepository {
  late final FirebaseFirestore firestore;

  HomeFirebaseRepository() {
    firestore = FirebaseFirestore.instance;
  }

  @override
  Future<Either<Failure, List<RoomDto>>> getRooms() async {
    try {
      final response = await firestore.collection('rooms').get();
      // convert list of room_id to list of int
      final rooms =
          response.docs.map((doc) => RoomDto.fromFirestore(doc)).toList();

      return Right(rooms);
    } on FirebaseException catch (e) {
      return Left(Failure.fromFirestoreError(e));
    } catch (e) {
      return Left(Failure.fromAppError(e as Exception));
    }
  }

  @override
  Future<Either<Failure, String>> joinRoom({
    required String topic,
    required UserDto user,
  }) async {
    try {
      // Convert topic to lowercase and replace spaces with hyphens
      final formattedTopic = topic.toLowerCase().replaceAll(' ', '-');

      final roomRef = firestore.collection('rooms').doc(formattedTopic);

      // Check if room exists
      final roomDoc = await roomRef.get();
      if (!roomDoc.exists) {
        // Create room if it doesn't exist
        await roomRef.set({
          'id': formattedTopic,
          'topic': topic,
          'worker_id': '-',
          'players': 0,
        });
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
        // increment room participant count
        await roomRef.update({'players': FieldValue.increment(1)});
      }

      return Right(formattedTopic);
    } on FirebaseException catch (e) {
      return Left(Failure.fromFirestoreError(e));
    } catch (e) {
      return Left(Failure.fromAppError(e as Exception));
    }
  }
}
