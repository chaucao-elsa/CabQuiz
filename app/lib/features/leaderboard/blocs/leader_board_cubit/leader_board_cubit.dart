import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cabquiz/features/leaderboard/domain/dto/leader_board_dto/leader_board_dto.dart';
import 'package:cabquiz/features/leaderboard/domain/repository/leader_board_repository.dart';
import 'package:cabquiz/features/leaderboard/models/leader_board_dpo/leader_board_dpo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'leader_board_cubit.freezed.dart';
part 'leader_board_state.dart';

class LeaderBoardCubit extends Cubit<LeaderBoardState> {
  LeaderBoardCubit({
    required this.leaderBoardRepository,
    required this.roomId,
  }) : super(const LeaderBoardState.initial());

  final LeaderBoardRepository leaderBoardRepository;
  final int roomId;
  StreamSubscription<List<LeaderBoardDto>>? _subscription;

  Future<void> connectToLeaderBoard() async {
    emit(const LeaderBoardState.connecting());

    final result = await leaderBoardRepository.listenToLeaderBoard(
      roomId: roomId,
    );

    result.fold(
      (l) => emit(LeaderBoardState.error(l.message)),
      (r) {
        _subscription = r.listen((leaderBoard) {
          emit(LeaderBoardState.connected(
            leaderBoard: leaderBoard.map((e) => e.toDpo()).toList(),
          ));
        });
      },
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
