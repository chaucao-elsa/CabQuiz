part of 'leader_board_cubit.dart';

@freezed
class LeaderBoardState with _$LeaderBoardState {
  const factory LeaderBoardState.initial() = LeaderBoardInitial;
  const factory LeaderBoardState.connecting() = LeaderBoardConnecting;
  const factory LeaderBoardState.connected({
    required List<LeaderBoardDpo> leaderBoard,
  }) = LeaderBoardConnected;
  const factory LeaderBoardState.error(String errorMessage) = LeaderBoardError;
}
