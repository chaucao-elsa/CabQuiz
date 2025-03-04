part of 'join_room_cubit.dart';

@freezed
sealed class JoinRoomState with _$JoinRoomState {
  const factory JoinRoomState({
    String? username,
    int? roomId,
    @Default(JoinRoomStatus.initial) JoinRoomStatus status,
    String? errorMessage,
  }) = _JoinRoomState;

  const JoinRoomState._();

  bool get filled => username != null && roomId != null;
}

enum JoinRoomStatus {
  initial,
  loading,
  success,
  failure,
}
