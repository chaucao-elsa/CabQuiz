// sample api repository
import 'package:cabquiz/features/failure/failure.dart';
import 'package:cabquiz/features/home/domain/dto/user/user_dto.dart';
import 'package:cabquiz/features/home/domain/repository/home_repository.dart';
import 'package:cabquiz/features/quiz/domain/dto/room_dto/room_dto.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

// this is a sample api repository using dio as http client
class HomeApiRepository implements HomeRepository {
  final Dio dio;

  HomeApiRepository({required this.dio});

  @override
  Future<Either<Failure, List<RoomDto>>> getRooms() async {
    try {
      final response = await dio.get('/rooms');
      return Right(response.data);
    } on DioException catch (e) {
      return Left(Failure.fromDioError(e));
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
      final response =
          await dio.post('/rooms/$topic/join', data: user.toJson());
      return Right(response.data);
    } on DioException catch (e) {
      return Left(Failure.fromDioError(e));
    } catch (e) {
      return Left(Failure.fromAppError(e as Exception));
    }
  }
}
