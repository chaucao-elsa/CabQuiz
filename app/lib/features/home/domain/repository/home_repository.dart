import 'package:cabquiz/features/failure/failure.dart';
import 'package:cabquiz/features/home/domain/dto/user/user_dto.dart';
import 'package:either_dart/either.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<int>>> getRooms();

  Future<Either<Failure, String>> joinRoom({
    required UserDto user,
    required int roomId,
  });
}
