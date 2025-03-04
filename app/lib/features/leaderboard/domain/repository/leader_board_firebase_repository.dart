import 'package:cabquiz/features/failure/failure.dart';
import 'package:cabquiz/features/leaderboard/domain/dto/leader_board_dto/leader_board_dto.dart';
import 'package:cabquiz/features/leaderboard/domain/repository/leader_board_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';

class LeaderBoardFirebaseRepository implements LeaderBoardRepository {
  late final FirebaseFirestore firestore;

  LeaderBoardFirebaseRepository() {
    firestore = FirebaseFirestore.instance;
  }

  @override
  Future<Either<Failure, Stream<List<LeaderBoardDto>>>> listenToLeaderBoard(
      {required int roomId}) async {
    try {
      return Right(
        firestore
            .collection('rooms')
            .doc('room_$roomId')
            .collection('participants')
            .orderBy('score', descending: true)
            .snapshots()
            .map((snapshot) =>
                snapshot.docs.map(LeaderBoardDto.fromFirestore).toList()),
      );
    } on FirebaseException catch (e) {
      return Left(Failure.fromFirestoreError(e));
    } catch (e) {
      return Left(Failure.fromAppError(e as Exception));
    }
  }
}
