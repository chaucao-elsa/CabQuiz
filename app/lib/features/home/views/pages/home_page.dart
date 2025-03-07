import 'package:auto_route/auto_route.dart';
import 'package:cabquiz/features/home/blocs/fetch_rooms_cubit/fetch_rooms_cubit.dart';
import 'package:cabquiz/features/home/blocs/join_room_cubit/join_room_cubit.dart';
import 'package:cabquiz/features/home/domain/repository/home_firebase_repository.dart';
import 'package:cabquiz/features/home/domain/repository/home_repository.dart';
import 'package:cabquiz/features/home/views/widgets/enter_room_text_field_widget.dart';
import 'package:cabquiz/routes/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:random_avatar/random_avatar.dart';

@RoutePage()
class HomePage extends StatefulWidget implements AutoRouteWrapper {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return RepositoryProvider<HomeRepository>(
      create: (context) => HomeFirebaseRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => FetchRoomsCubit(
              repository: context.read<HomeRepository>(),
            )..fetchRooms(),
          ),
          BlocProvider(
            create: (context) => JoinRoomCubit(
              repository: context.read<HomeRepository>(),
            ),
          ),
        ],
        child: this,
      ),
    );
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join a Room'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              BlocSelector<JoinRoomCubit, JoinRoomState, String>(
                selector: (state) => state.username ?? 'chaucao',
                builder: (context, username) {
                  return Center(
                    child: RandomAvatar(
                      username.isNotEmpty ? username : 'chaucao',
                      width: 120,
                      height: 120,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text('Username'),
              const SizedBox(height: 16),
              TextField(
                onChanged: context.read<JoinRoomCubit>().setUsername,
                decoration: InputDecoration(
                  hintText: 'chaucao',
                  hintStyle: TextStyle(
                    color: Colors.black.withAlpha(50),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Room topic'),
              const SizedBox(height: 16),
              const EnterRoomTextFieldWidget(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          width: double.infinity,
          height: 58,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          margin: const EdgeInsets.symmetric(vertical: 24),
          child: BlocConsumer<JoinRoomCubit, JoinRoomState>(
            listener: (context, state) {
              if (state.status == JoinRoomStatus.loading) {
                EasyLoading.show();
              } else if (state.status == JoinRoomStatus.failure &&
                  state.errorMessage != null) {
                EasyLoading.showError(state.errorMessage!);
              } else if (state.status == JoinRoomStatus.success) {
                EasyLoading.dismiss();
                context.router.push(QuizRoute(
                  roomId: state.topic!.toLowerCase().replaceAll(' ', '-'),
                  username: state.username!,
                ));
              }
              context.read<JoinRoomCubit>().resetStatus();
            },
            builder: (context, state) {
              return ElevatedButton(
                onPressed: state.filled
                    ? () {
                        context.read<JoinRoomCubit>().joinRoom();
                      }
                    : null,
                child: const Text('Join'),
              );
            },
          ),
        ),
      ),
    );
  }
}
