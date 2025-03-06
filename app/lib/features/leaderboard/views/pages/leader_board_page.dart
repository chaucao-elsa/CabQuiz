import 'package:auto_route/auto_route.dart';
import 'package:cabquiz/features/leaderboard/blocs/leader_board_cubit/leader_board_cubit.dart';
import 'package:cabquiz/features/leaderboard/domain/repository/leader_board_firebase_repository.dart';
import 'package:cabquiz/features/leaderboard/domain/repository/leader_board_repository.dart';
import 'package:cabquiz/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_avatar/random_avatar.dart';

@RoutePage()
class LeaderBoardPage extends StatelessWidget implements AutoRouteWrapper {
  const LeaderBoardPage({
    super.key,
    required this.roomId,
    required this.username,
  });

  final int roomId;
  final String username;

  @override
  Widget wrappedRoute(BuildContext context) {
    return RepositoryProvider<LeaderBoardRepository>(
      create: (context) => LeaderBoardFirebaseRepository(),
      child: BlocProvider(
        create: (context) => LeaderBoardCubit(
          leaderBoardRepository: context.read<LeaderBoardRepository>(),
          roomId: roomId,
        )..connectToLeaderBoard(),
        child: this,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text(
          'Leader board',
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<LeaderBoardCubit, LeaderBoardState>(
        builder: (context, state) {
          if (state is LeaderBoardConnecting || state is LeaderBoardInitial) {
            return const Center(
              child: Text('Connecting to leader board...',
                  style: TextStyle(color: Colors.white)),
            );
          }

          if (state is LeaderBoardError) {
            return Center(
              child: Text(
                state.errorMessage,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final users = (state as LeaderBoardConnected).leaderBoard;

          return Column(
            children: [
              const SizedBox(height: 12),
              const Divider(
                color: Colors.white,
                height: 1,
                indent: 24,
                endIndent: 24,
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  itemBuilder: (context, index) {
                    final backgroundColor =
                        users[index].username == username ? Colors.white : null;
                    final foregroundColor = users[index].username == username
                        ? Colors.black
                        : Colors.white;

                    return Container(
                      height: 84,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                      ),
                      child: Row(
                        children: [
                          Text(
                            (index + 1).toString(),
                            style: TextStyle(
                              color: foregroundColor,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(width: 24),
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: RandomAvatar(
                              users[index].username,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              users[index].username,
                              style: TextStyle(
                                color: foregroundColor,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Text(
                            users[index].score.toString(),
                            style: TextStyle(
                              color: foregroundColor,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: users.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
