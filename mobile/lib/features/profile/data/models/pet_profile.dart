import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../posts/data/models/post.dart'; // For AnimalType

part 'pet_profile.freezed.dart';
part 'pet_profile.g.dart';

@freezed
abstract class PetProfile with _$PetProfile {
  const factory PetProfile({
    required String id,
    required String name,
    required AnimalType type,
    required String breed,
    int? age,
    String? gender,
    required String color,
    String? markings,
    String? healthNotes,
    String? microchipId,
    @Default([]) List<String> images,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PetProfile;

  factory PetProfile.fromJson(Map<String, dynamic> json) => _$PetProfileFromJson(json);
}
