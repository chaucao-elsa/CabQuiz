import 'package:cabquiz/features/home/blocs/fetch_rooms_cubit/fetch_rooms_cubit.dart';
import 'package:cabquiz/features/home/blocs/join_room_cubit/join_room_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnterRoomTextFieldWidget extends StatefulWidget {
  const EnterRoomTextFieldWidget({
    super.key,
  });

  @override
  State<EnterRoomTextFieldWidget> createState() =>
      _EnterRoomTextFieldWidgetState();
}

class _EnterRoomTextFieldWidgetState extends State<EnterRoomTextFieldWidget> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FetchRoomsCubit, FetchRoomsState>(
      listener: (context, state) {
        if (state is FetchRoomsSuccess &&
            state.rooms.isNotEmpty &&
            controller.text.isEmpty) {
          controller.text = state.rooms.first.toString();
          context.read<JoinRoomCubit>().setRoomId(controller.text);
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            TextField(
              controller: controller,
              onChanged: context.read<JoinRoomCubit>().setRoomId,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '1',
                suffixIconConstraints: const BoxConstraints(
                  maxHeight: 32,
                ),
                suffixIcon: switch (state) {
                  FetchRoomsLoading() => const SizedBox(
                      height: 32,
                      width: 32,
                      child: CircularProgressIndicator(),
                    ),
                  FetchRoomsFailure() => const Text('error'),
                  FetchRoomsSuccess() => IconButton(
                      onPressed: () {
                        // show modal bottom sheet with list of rooms
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          builder: (_) => ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                            itemCount: state.rooms.length,
                            itemBuilder: (_, index) => ListTile(
                              onTap: () {
                                context
                                    .read<JoinRoomCubit>()
                                    .setRoomId(state.rooms[index].toString());
                                controller.text = state.rooms[index].toString();
                                Navigator.pop(context);
                              },
                              title: Text(
                                'Room ${state.rooms[index]}',
                              ),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    ),
                  _ => const SizedBox.shrink(),
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
