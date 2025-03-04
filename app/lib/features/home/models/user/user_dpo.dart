import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dpo.freezed.dart';

@freezed
class UserDpo with _$UserDpo {
  factory UserDpo({
    String? username,
  }) = _UserDpo;
}
