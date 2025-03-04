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
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    BlocSelector<JoinRoomCubit, JoinRoomState, String>(
                      selector: (state) => state.username ?? 'chaucao',
                      builder: (context, username) {
                        return Center(
                          child: RandomAvatar(
                            username.isNotEmpty ? username : 'chaucao',
                            width: 120.w,
                            height: 120.w,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 24.h),
                    const Text('Username'),
                    SizedBox(height: 16.h),
                    TextField(
                      onChanged: context.read<JoinRoomCubit>().setUsername,
                      decoration: const InputDecoration(
                        hintText: 'chaucao',
                      ),
                    ),
                    SizedBox(height: 24.h),
                    const Text('Room number'),
                    SizedBox(height: 16.h),
                    const EnterRoomTextFieldWidget(),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 58.h,
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
                        roomId: state.roomId!,
                        username: state.username!,
                      ));
                    }
                    context.read<JoinRoomCubit>().resetStatus();
                  },
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state.filled
                          ? () {
                              // sometime you can use repository directly without cubit but not recommend
                              context.read<JoinRoomCubit>().joinRoom();
                            }
                          : null,
                      child: const Text('Join'),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
