import 'package:cabquiz/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'question_dpo.freezed.dart';

@freezed
class QuestionDpo with _$QuestionDpo {
  factory QuestionDpo({
    required String questionText,
    required List<AnswerDpo> options,
  }) = _QuestionDpo;

  const QuestionDpo._();
}

@freezed
class AnswerDpo with _$AnswerDpo {
  factory AnswerDpo({
    required int index,
    required String answerText,
  }) = _AnswerDpo;

  const AnswerDpo._();

  Color get color => switch (index) {
        0 => AppColors.firstAnswer,
        1 => AppColors.secondAnswer,
        2 => AppColors.thirdAnswer,
        3 => AppColors.fourthAnswer,
        _ => AppColors.greyScale50,
      };
}
