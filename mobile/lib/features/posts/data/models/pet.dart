import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile/features/auth/data/models/user.dart';

part 'pet.freezed.dart';
part 'pet.g.dart';

enum PetType {
  @JsonValue('DOG')
  dog,
  @JsonValue('CAT')
  cat,
  @JsonValue('BIRD')
  bird,
  @JsonValue('OTHER')
  other,
}

enum PetStatus {
  @JsonValue('LOST')
  lost,
  @JsonValue('FOUND')
  found,
  @JsonValue('STRAY')
  stray,
  @JsonValue('RESCUED')
  rescued,
  @JsonValue('MOMENT')
  moment,
}

@freezed
abstract class Pet with _$Pet {
  const factory Pet({
    required String id,
    String? name,
    required PetType type,
    required PetStatus status,
    required String breed,
    required String color,
    String? description,
    @Default([]) List<String> images,
    dynamic location,
    DateTime? lastSeenAt,
    @Default(false) bool isResolved,
    User? poster,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Pet;

  factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);
}
