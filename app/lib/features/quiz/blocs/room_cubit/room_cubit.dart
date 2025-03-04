import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cabquiz/features/quiz/domain/dto/room_dto/room_dto.dart';
import 'package:cabquiz/features/quiz/domain/repository/quiz_repository.dart';
import 'package:cabquiz/features/quiz/models/room_dpo/room_dpo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_cubit.freezed.dart';
part 'room_state.dart';

class RoomCubit extends Cubit<RoomState> {
  RoomCubit({required this.quizRepository, required this.roomId})
      : super(const RoomState.initial());

  final QuizRepository quizRepository;
  final int roomId;

  StreamSubscription<RoomDto>? _subscription;

  Future<void> connectToRoom() async {
    emit(const RoomState.connecting());

    final result = await quizRepository.listenToRoom(roomId: roomId);

    result.fold(
      (l) => emit(RoomState.error(l.message)),
      (r) {
        _subscription = r.listen((room) {
          emit(RoomState.connected(room.toDpo()));
        });
      },
    );
  }

  void selectAnswer({required int answerIndex}) {
    if (state is RoomConnected) {
      final room = (state as RoomConnected).room;
      emit(RoomState.connected(room.copyWith(userAnswer: answerIndex)));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
