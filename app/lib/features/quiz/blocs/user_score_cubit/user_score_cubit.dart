import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cabquiz/features/quiz/domain/repository/quiz_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_score_cubit.freezed.dart';
part 'user_score_state.dart';

class UserScoreCubit extends Cubit<UserScoreState> {
  UserScoreCubit({
    required this.quizRepository,
    required this.roomId,
    required this.username,
  }) : super(const UserScoreState.initial());

  final QuizRepository quizRepository;
  final int roomId;
  final String username;
  StreamSubscription<int?>? _subscription;
  int _previousScore = 0;

  Future<void> connectToUserScore() async {
    emit(const UserScoreState.connecting());

    final result = await quizRepository.listenToUserScore(
      roomId: roomId,
      username: username,
    );

    result.fold(
      (l) => emit(UserScoreState.error(l.message)),
      (r) {
        _subscription = r.listen((score) {
          emit(UserScoreState.connected(
            previousScore: _previousScore,
            currentScore: score,
          ));
          _previousScore = score ?? 0;
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
