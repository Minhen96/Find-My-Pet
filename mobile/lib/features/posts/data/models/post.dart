import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile/features/auth/data/models/user.dart';
import '../../../profile/data/models/pet_profile.dart';

part 'post.freezed.dart';
part 'post.g.dart';

enum PostType {
  @JsonValue('LOST')
  lost,
  @JsonValue('FOUND')
  found,
  @JsonValue('SIGHTED')
  sighted,
  @JsonValue('STRAY')
  stray,
  @JsonValue('RESCUED')
  rescued,
  @JsonValue('MOMENT')
  moment,
}

enum AnimalType {
  @JsonValue('DOG')
  dog,
  @JsonValue('CAT')
  cat,
  @JsonValue('BIRD')
  bird,
  @JsonValue('RABBIT')
  rabbit,
  @JsonValue('OTHER')
  other,
}

@freezed
abstract class Post with _$Post {
  const factory Post({
    required String id,
    required PostType type,
    String? description,
    @Default([]) List<String> images,
    dynamic location,
    DateTime? lastSeenAt,
    @Default(false) bool isResolved,
    User? poster,
    PetProfile? petProfile,
    AnimalType? animalType,
    String? breed,
    String? color,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}
