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
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildAnswerButton(question.options[0], 0)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildAnswerButton(question.options[2], 2)),
                ],
              )
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildAnswerButton(question.options[1], 1)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildAnswerButton(question.options[3], 3)),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerButton(AnswerDpo answer, int index) {
    final isSelected = selectedAnswer == index;
    return SizedBox(
      height: 100,
      child: ElevatedButton(
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
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            answer.answerText,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
