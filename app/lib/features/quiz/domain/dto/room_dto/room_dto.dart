import 'package:cabquiz/features/quiz/domain/dto/question_dto/question_dto.dart';
import 'package:cabquiz/features/quiz/models/room_dpo/room_dpo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_dto.freezed.dart';
part 'room_dto.g.dart';

@freezed
class RoomDto with _$RoomDto {
  factory RoomDto({
    required String roomId,
    DateTime? startTime,
    QuestionDto? question,
  }) = _RoomDto;

  const RoomDto._();

  RoomDpo toDpo() => RoomDpo(
        roomId: roomId,
        startTime: startTime,
        question: question?.toDpo(),
      );

  factory RoomDto.fromFirestore(DocumentSnapshot snapshot) {
    return RoomDto(
      roomId: snapshot.id,
      startTime: (snapshot['start_time'] as Timestamp?)?.toDate(),
      question: snapshot['current_question'] != null
          ? QuestionDto.fromJson(snapshot['current_question'])
          : null,
    );
  }

  factory RoomDto.fromJson(Map<String, dynamic> json) =>
      _$RoomDtoFromJson(json);
}
