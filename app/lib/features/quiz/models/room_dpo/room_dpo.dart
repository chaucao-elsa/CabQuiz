import 'package:cabquiz/features/quiz/models/question_dpo/question_dpo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_dpo.freezed.dart';

@freezed
class RoomDpo with _$RoomDpo {
  factory RoomDpo({
    required String topic,
    DateTime? startTime,
    QuestionDpo? question,
    int? userAnswer,
    @Default(0) int players,
  }) = _RoomDpo;

  const RoomDpo._();

  String get id => topic.toLowerCase().replaceAll(' ', '-');
}
