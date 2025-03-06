import 'package:cabquiz/features/quiz/models/question_dpo/question_dpo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'option_dto.freezed.dart';
part 'option_dto.g.dart';

@freezed
class OptionDto with _$OptionDto {
  factory OptionDto({
    required String text,
    required int score,
  }) = _OptionDto;

  const OptionDto._();

  AnswerDpo toDpo(int index) {
    return AnswerDpo(answerText: text, index: index, score: score);
  }

  factory OptionDto.fromJson(Map<String, dynamic> json) =>
      _$OptionDtoFromJson(json);
}
