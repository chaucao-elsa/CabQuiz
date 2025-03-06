import 'package:cabquiz/features/home/blocs/fetch_rooms_cubit/fetch_rooms_cubit.dart';
import 'package:cabquiz/features/home/blocs/join_room_cubit/join_room_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoomListWidget extends StatefulWidget {
  const RoomListWidget({super.key});

  @override
  State<RoomListWidget> createState() => _RoomListWidgetState();
}

class _RoomListWidgetState extends State<RoomListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      alignment: Alignment.center,
      child: BlocBuilder<FetchRoomsCubit, FetchRoomsState>(
        builder: (context, state) {
          return switch (state) {
            FetchRoomsLoading() => const SizedBox(
                height: 32,
                width: 32,
                child: CircularProgressIndicator(),
              ),
            FetchRoomsFailure() => const Text('error'),
            FetchRoomsSuccess(rooms: final rooms) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Rooms',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      itemCount: rooms.length,
                      itemBuilder: (_, index) => InkWell(
                        onTap: () {
                          context
                              .read<JoinRoomCubit>()
                              .setTopic(rooms[index].topic);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${rooms[index].topic}: ${rooms[index].players} players',
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: Colors.grey[600],
                              ),
                            ],
                          ),
                        ),
                      ),
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                    ),
                  ),
                ],
              ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}
