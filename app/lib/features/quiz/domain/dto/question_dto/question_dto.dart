import 'package:cabquiz/features/quiz/models/question_dpo/question_dpo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'question_dto.freezed.dart';
part 'question_dto.g.dart';

@freezed
class QuestionDto with _$QuestionDto {
  factory QuestionDto({
    @JsonKey(name: 'question_text') required String questionText,
    @JsonKey(name: 'options') required List<String> options,

    // user shouldn't see correct answer
    // required String correctOption,
  }) = _QuestionDto;

  const QuestionDto._();

  QuestionDpo toDpo() {
    final answers = <AnswerDpo>[];
    for (var i = 0; i < options.length; i++) {
      answers.add(AnswerDpo(answerText: options[i], index: i));
    }

    return QuestionDpo(
      questionText: questionText,
      options: answers,
    );
  }

  factory QuestionDto.fromJson(Map<String, dynamic> json) =>
      _$QuestionDtoFromJson(json);
}
