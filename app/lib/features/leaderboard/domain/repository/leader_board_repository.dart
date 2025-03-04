import 'package:cabquiz/features/failure/failure.dart';
import 'package:cabquiz/features/leaderboard/domain/dto/leader_board_dto/leader_board_dto.dart';
import 'package:either_dart/either.dart';

abstract class LeaderBoardRepository {
  Future<Either<Failure, Stream<List<LeaderBoardDto>>>> listenToLeaderBoard({
    required int roomId,
  });
}
