import 'package:cabquiz/features/home/domain/repository/home_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'fetch_rooms_cubit.freezed.dart';
part 'fetch_rooms_state.dart';

class FetchRoomsCubit extends Cubit<FetchRoomsState> {
  final HomeRepository repository;

  FetchRoomsCubit({required this.repository})
      : super(const FetchRoomsState.initial());

  Future<void> fetchRooms() async {
    emit(const FetchRoomsState.loading());
    await Future.delayed(const Duration(seconds: 1));
    final result = await repository.getRooms();
    result.fold(
      (l) => emit(FetchRoomsState.failure(l.message)),
      // convert dto to dpo here if needed
      (r) => emit(FetchRoomsState.success(r)),
    );
  }
}
