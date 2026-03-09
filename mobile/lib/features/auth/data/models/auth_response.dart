// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';

part 'auth_response.freezed.dart';
part 'auth_response.g.dart';

@Freezed(toJson: true, fromJson: true)
abstract class AuthResponse with _$AuthResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory AuthResponse({
    required User user,
    required String accessToken,
    required String refreshToken,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}
