import 'package:cabquiz/features/failure/failure.dart';
import 'package:cabquiz/features/quiz/domain/dto/room_dto/room_dto.dart';
import 'package:either_dart/either.dart';

abstract class QuizRepository {
  Future<Either<Failure, Stream<RoomDto>>> listenToRoom({
    required int roomId,
  });

  Future<Either<Failure, Stream<int?>>> listenToUserScore({
    required int roomId,
    required String username,
  });

  Future<Either<Failure, void>> sendAnswer({
    required int roomId,
    required String username,
    required int answerIndex,
  });
}
