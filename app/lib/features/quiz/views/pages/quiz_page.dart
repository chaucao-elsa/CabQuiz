import 'package:audioplayers/audioplayers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cabquiz/features/quiz/blocs/room_cubit/room_cubit.dart';
import 'package:cabquiz/features/quiz/blocs/user_score_cubit/user_score_cubit.dart';
import 'package:cabquiz/features/quiz/domain/repository/quiz_firebase_repository.dart';
import 'package:cabquiz/features/quiz/domain/repository/quiz_repository.dart';
import 'package:cabquiz/features/quiz/models/question_dpo/question_dpo.dart';
import 'package:cabquiz/features/quiz/views/widgets/answer_section_widget.dart';
import 'package:cabquiz/features/quiz/views/widgets/question_timer_widget.dart';
import 'package:cabquiz/resources/app_colors.dart';
import 'package:cabquiz/resources/assets.gen.dart';
import 'package:cabquiz/routes/app_router.gr.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:random_avatar/random_avatar.dart';

const kVictoryAudio = 'audio/victory.mp3';

@RoutePage()
class QuizPage extends StatelessWidget implements AutoRouteWrapper {
  const QuizPage({
    super.key,
    @PathParam('roomId') required this.roomId,
    @PathParam('username') required this.username,
  });

  final String roomId;
  final String username;

  @override
  Widget wrappedRoute(BuildContext context) {
    return RepositoryProvider<QuizRepository>(
      create: (context) => QuizFirebaseRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => RoomCubit(
              roomId: roomId,
              quizRepository: context.read<QuizRepository>(),
            )..connectToRoom(),
          ),
          BlocProvider(
            create: (context) => UserScoreCubit(
              roomId: roomId,
              username: username,
              quizRepository: context.read<QuizRepository>(),
            )..connectToUserScore(),
          ),
        ],
        child: this,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          roomId.replaceAll('-', ' '),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        leadingWidth: 100,
        leading: TextButton(
          onPressed: () {
            context.router.replace(const HomeRoute());
          },
          child: const Text('Leave'),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.router.push(LeaderBoardRoute(
                roomId: roomId,
                username: username,
              ));
            },
            icon: Assets.icons.moreCircle.svg(
              width: 28,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<RoomCubit, RoomState>(
              builder: (context, state) {
                if (state is RoomConnected) {
                  final question = state.room.question;
                  final startTime = state.room.startTime;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        if (startTime != null && question != null)
                          QuestionTimerWidget(
                            key: ValueKey(startTime),
                            startTime: startTime,
                          )
                        else
                          const Center(
                            child: Column(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text(
                                  'Waiting for first question...',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 12),
                        if (question != null) ...[
                          Flexible(
                            flex: 2,
                            child: _buildQuestionBoard(question),
                          ),
                          const SizedBox(height: 24),
                          Flexible(
                            flex: 3,
                            child: AnswerSectionWidget(
                              question: question,
                              selectedAnswer: state.room.userAnswer,
                              onAnswerSelected: state.room.userAnswer != null
                                  ? null
                                  : (index) {
                                      // sometime we can use repository without cubit (NOT RECOMMENDED)

                                      EasyLoading.show();
                                      final response = context
                                          .read<QuizRepository>()
                                          .sendAnswer(
                                            answerIndex: index,
                                            roomId: roomId,
                                            username: username,
                                          );
                                      EasyLoading.dismiss();
                                      response.fold(
                                        (l) => EasyLoading.showError(l.message),
                                        (r) => context
                                            .read<RoomCubit>()
                                            .selectAnswer(
                                              answerIndex: index,
                                            ),
                                      );
                                    },
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                } else if (state is RoomError) {
                  return Center(child: Text(state.errorMessage));
                }
                return const Center(child: Text('connecting...'));
              },
            ),
          ),
          _buildCurrentUserInfo(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildQuestionBoard(QuestionDpo question) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.greyScale50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.greyScale200,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            question.context,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            question.questionText,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 3,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentUserInfo() {
    return BlocListener<UserScoreCubit, UserScoreState>(
      // detect when user score changes
      listenWhen: (previous, current) =>
          previous is UserScoreConnected &&
          current is UserScoreConnected &&
          current.currentScore != null &&
          previous.currentScore != current.currentScore,
      listener: (context, state) {
        final currentState = state as UserScoreConnected;
        final scoreDifference =
            currentState.currentScore! - currentState.previousScore;

        if (scoreDifference > 0) {
          winningAnimation(context, scoreDifference);
        } else if (scoreDifference < 0) {
          // Incorrect answer - show failure animation
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.close, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'Incorrect! $scoreDifference',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      },
      child: BlocBuilder<UserScoreCubit, UserScoreState>(
        builder: (context, state) {
          if (state is UserScoreConnected) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    playAudio(kVictoryAudio);
                  },
                  child: RandomAvatar(
                    username,
                    width: 48,
                    height: 48,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '$username: ${state.currentScore ?? 0}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Future<void> winningAnimation(BuildContext context, int score) async {
    playAudio(kVictoryAudio);
    Confetti.launch(context,
        options: const ConfettiOptions(
          particleCount: 200,
          spread: 300,
          y: 0.6,
          x: 0.3,
        ));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'Correct! +$score',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(left: 24, right: 24, bottom: 80),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Future<void> playAudio(String asset) async {
    final audioPlayer = AudioPlayer(playerId: 'victory');
    await audioPlayer.play(AssetSource(asset));
  }
}
