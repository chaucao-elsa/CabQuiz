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
  final int maxWords = 4;
  final int maxLength = 50; // Set a reasonable length for a room topic

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<JoinRoomCubit, JoinRoomState>(
      listener: (context, state) {
        controller.text = state.topic ?? '';
      },
      child: TextField(
        controller: controller,
        onChanged: (value) {
          // Filter out special characters, allowing only alphanumeric, spaces, and hyphens
          String filteredValue = value.replaceAll(RegExp(r'[^\w\s-]'), '');

          // Limit to maxWords
          final words = filteredValue.split(RegExp(r'\s+'));
          if (words.length > maxWords) {
            filteredValue = words.take(maxWords).join(' ');
          }

          context.read<JoinRoomCubit>().setTopic(filteredValue);
        },
        keyboardType: TextInputType.text,
        maxLength: maxLength,
        autocorrect: false,
        decoration: const InputDecoration(
          hintText: 'Enter room name',
          suffixIconConstraints: BoxConstraints(
            maxHeight: 32,
          ),
        ),
      ),
    );
  }
}
