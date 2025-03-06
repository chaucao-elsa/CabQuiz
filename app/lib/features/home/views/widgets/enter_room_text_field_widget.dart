import 'package:cabquiz/features/home/blocs/join_room_cubit/join_room_cubit.dart';
import 'package:cabquiz/features/home/views/widgets/room_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

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
  final int maxWords = 4;
  final int maxLength = 50; // Set a reasonable length for a room topic

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          onChanged: (value) {
            context.read<JoinRoomCubit>().setTopic(value);
          },
          keyboardType: TextInputType.text,
          maxLength: maxLength,
          autocorrect: false,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9\s]*$')),
            LengthLimitingTextInputFormatter(maxLength),
          ],
          decoration: const InputDecoration(
            hintText: 'Enter room name',
            suffixIconConstraints: BoxConstraints(
              maxHeight: 32,
            ),
          ),
        ),
        const SizedBox(height: 24),
        RoomListWidget(controller: controller),
      ],
    );
  }
}
