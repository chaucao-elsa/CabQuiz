import 'package:cabquiz/features/quiz/domain/dto/option_dto/option_dto.dart';
import 'package:cabquiz/features/quiz/models/question_dpo/question_dpo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'question_dto.freezed.dart';
part 'question_dto.g.dart';

@freezed
class QuestionDto with _$QuestionDto {
  factory QuestionDto({
    @JsonKey(name: 'context') required String context,
    @JsonKey(name: 'question') required String questionText,
    @JsonKey(name: 'options') required List<OptionDto> options,

    // user shouldn't see correct answer
    // required String correctOption,
  }) = _QuestionDto;

  const QuestionDto._();

  QuestionDpo toDpo() {
    final answers = <AnswerDpo>[];
    for (var i = 0; i < options.length; i++) {
      answers.add(options[i].toDpo(i));
    }

    return QuestionDpo(
      context: context,
      questionText: questionText,
      options: answers,
    );
  }

  factory QuestionDto.fromJson(Map<String, dynamic> json) =>
      _$QuestionDtoFromJson(json);
}
