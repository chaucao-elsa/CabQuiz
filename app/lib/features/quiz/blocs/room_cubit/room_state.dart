part of 'room_cubit.dart';

@freezed
class RoomState with _$RoomState {
  const factory RoomState.initial() = RoomInitial;
  const factory RoomState.connecting() = RoomConnecting;
  const factory RoomState.connected(RoomDpo room) = RoomConnected;
  const factory RoomState.error(String errorMessage) = RoomError;
}
