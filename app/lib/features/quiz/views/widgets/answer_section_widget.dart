import 'package:cabquiz/features/quiz/models/question_dpo/question_dpo.dart';
import 'package:flutter/material.dart';

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
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
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
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            answer.answerText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
