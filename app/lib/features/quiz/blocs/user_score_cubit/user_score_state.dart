part of 'user_score_cubit.dart';

@freezed
class UserScoreState with _$UserScoreState {
  const factory UserScoreState.initial() = UserScoreInitial;
  const factory UserScoreState.connecting() = UserScoreConnecting;
  const factory UserScoreState.connected({
    @Default(0) int previousScore,
    @Default(0) int? currentScore,
  }) = UserScoreConnected;
  const factory UserScoreState.error(String errorMessage) = UserScoreError;
}
