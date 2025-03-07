import 'package:cabquiz/features/quiz/domain/dto/question_dto/question_dto.dart';
import 'package:cabquiz/features/quiz/models/room_dpo/room_dpo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_dto.freezed.dart';
part 'room_dto.g.dart';

@freezed
class RoomDto with _$RoomDto {
  factory RoomDto({
    required String topic,
    DateTime? startTime,
    QuestionDto? question,
    @Default(0) int players,
  }) = _RoomDto;

  const RoomDto._();

  RoomDpo toDpo() => RoomDpo(
        topic: topic,
        startTime: startTime,
        question: question?.toDpo(),
        players: players,
      );

  factory RoomDto.fromFirestore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return RoomDto(
      topic: data['topic'] ?? '',
      startTime: data.containsKey('start_time')
          ? (data['start_time'] as Timestamp?)?.toDate()
          : null,
      question: data['current_question'] != null
          ? QuestionDto.fromJson(data['current_question'])
          : null,
      players: 0,
    );
  }

  factory RoomDto.fromJson(Map<String, dynamic> json) =>
      _$RoomDtoFromJson(json);
}
