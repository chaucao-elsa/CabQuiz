import 'dart:async';

import 'package:cabquiz/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// AI generated code
class QuestionTimerWidget extends StatefulWidget {
  final DateTime startTime;

  const QuestionTimerWidget({super.key, required this.startTime});

  @override
  QuestionTimerWidgetState createState() => QuestionTimerWidgetState();
}

class QuestionTimerWidgetState extends State<QuestionTimerWidget> {
  late Timer _timer;
  int _secondsLeft = 15;

  @override
  void initState() {
    super.initState();
    _calculateInitialTimeLeft();
    _startTimer();
  }

  void _calculateInitialTimeLeft() {
    final elapsedSeconds =
        DateTime.now().difference(widget.startTime).inSeconds;
    final currentQuestionSeconds = elapsedSeconds % 15;
    setState(() {
      _secondsLeft = 15 - currentQuestionSeconds;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsLeft = (_secondsLeft - 1 + 15) % 15;
        if (_secondsLeft == 0) {
          _secondsLeft = 15;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 12.h),
        Text(
          'Time left: $_secondsLeft seconds',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: _secondsLeft / 15,
            minHeight: 8.h,
            backgroundColor: AppColors.greyScale200,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}
