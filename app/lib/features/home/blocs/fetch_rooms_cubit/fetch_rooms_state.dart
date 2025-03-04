part of 'fetch_rooms_cubit.dart';

@freezed
sealed class FetchRoomsState with _$FetchRoomsState {
  const factory FetchRoomsState.initial() = FetchRoomsInitial;
  const factory FetchRoomsState.loading() = FetchRoomsLoading;
  const factory FetchRoomsState.success(List<int> rooms) = FetchRoomsSuccess;
  const factory FetchRoomsState.failure(String message) = FetchRoomsFailure;
}
