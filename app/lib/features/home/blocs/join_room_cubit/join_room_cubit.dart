import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cabquiz/features/home/domain/dto/user/user_dto.dart';
import 'package:cabquiz/features/home/domain/repository/home_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'join_room_cubit.freezed.dart';
part 'join_room_state.dart';

class JoinRoomCubit extends Cubit<JoinRoomState> {
  JoinRoomCubit({required this.repository}) : super(const JoinRoomState());

  final HomeRepository repository;

  void setUsername(String? username) {
    emit(state.copyWith(username: username));
  }

  void setTopic(String? topic) {
    emit(state.copyWith(topic: topic));
  }

  Future<void> joinRoom() async {
    emit(state.copyWith(status: JoinRoomStatus.loading));

    if (state.username == null || state.topic == null) {
      emit(state.copyWith(
        status: JoinRoomStatus.failure,
        errorMessage: 'Username and topic are required',
      ));
      return;
    }

    final result = await repository.joinRoom(
      user: UserDto(username: state.username!),
      topic: state.topic!,
    );

    result.fold(
      (l) => emit(state.copyWith(
        status: JoinRoomStatus.failure,
        errorMessage: l.message,
      )),
      (r) => emit(state.copyWith(status: JoinRoomStatus.success)),
    );
  }

  void resetStatus() {
    emit(state.copyWith(status: JoinRoomStatus.initial));
  }
}
