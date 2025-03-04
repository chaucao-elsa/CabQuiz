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
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:random_avatar/random_avatar.dart';

@RoutePage()
class QuizPage extends StatelessWidget implements AutoRouteWrapper {
  const QuizPage({super.key, required this.roomId, required this.username});

  final int roomId;
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
        title: Text('Room $roomId'),
        leadingWidth: 100.w,
        leading: TextButton(
          onPressed: context.router.maybePop,
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
              width: 28.w,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          BlocBuilder<RoomCubit, RoomState>(
            builder: (context, state) {
              if (state is RoomConnected) {
                final question = state.room.question;
                final startTime = state.room.startTime;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      if (startTime != null)
                        QuestionTimerWidget(
                          key: ValueKey(startTime),
                          startTime: startTime,
                        ),
                      SizedBox(height: 12.h),
                      if (question != null)
                        Column(
                          children: [
                            _buildQuestionBoard(question),
                            SizedBox(height: 24.h),
                            AnswerSectionWidget(
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
                          ],
                        ),
                    ],
                  ),
                );
              } else if (state is RoomError) {
                return Center(child: Text(state.errorMessage));
              }
              return const Center(child: Text('connecting...'));
            },
          ),
          _buildCurrentUserInfo(),
        ],
      ),
    );
  }

  Widget _buildQuestionBoard(QuestionDpo question) {
    return Container(
      width: double.infinity,
      height: 210.h,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.greyScale50,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.greyScale200,
        ),
      ),
      child: Text(
        question.questionText,
        maxLines: 3,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCurrentUserInfo() {
    return BlocListener<UserScoreCubit, UserScoreState>(
      // detect when user score is increased
      listenWhen: (previous, current) =>
          previous is UserScoreConnected &&
          current is UserScoreConnected &&
          current.currentScore != null &&
          current.currentScore! > current.previousScore,
      listener: (context, state) {
        final currentState = state as UserScoreConnected;
        final scoreDifference =
            currentState.currentScore! - currentState.previousScore;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Correct! + $scoreDifference',
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
      child: BlocBuilder<UserScoreCubit, UserScoreState>(
        builder: (context, state) {
          if (state is UserScoreConnected) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RandomAvatar(
                  username,
                  width: 48.w,
                  height: 48.w,
                ),
                SizedBox(width: 12.w),
                Text(
                  '$username: ${state.currentScore ?? 0}',
                  style: TextStyle(
                    fontSize: 24.sp,
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
}
