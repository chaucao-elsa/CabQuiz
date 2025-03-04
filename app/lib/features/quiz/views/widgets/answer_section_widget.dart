import 'package:cabquiz/features/quiz/models/question_dpo/question_dpo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnswerSectionWidget extends StatelessWidget {
  const AnswerSectionWidget({
    super.key,
    required this.question,
    required this.selectedAnswer,
    required this.onAnswerSelected,
  });

  final QuestionDpo question;
  final int? selectedAnswer;
  final Function(int)? onAnswerSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.1,
      ),
      itemCount: question.options.length,
      itemBuilder: (context, index) {
        final answer = question.options[index];
        final isSelected = selectedAnswer == index;
        return ElevatedButton(
          // if isSelected, keep the button active but do nothing
          onPressed: isSelected
              ? () {}
              : onAnswerSelected != null
                  ? () => onAnswerSelected!(index)
                  : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: answer.color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            answer.answerText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
