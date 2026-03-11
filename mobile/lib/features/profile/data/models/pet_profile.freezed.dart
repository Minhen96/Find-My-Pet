// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pet_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PetProfile {

 String get id; String get name; AnimalType get type; String get breed; int? get age; String? get gender; String get color; String? get markings; String? get healthNotes; String? get microchipId; List<String> get images; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of PetProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PetProfileCopyWith<PetProfile> get copyWith => _$PetProfileCopyWithImpl<PetProfile>(this as PetProfile, _$identity);

  /// Serializes this PetProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PetProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.breed, breed) || other.breed == breed)&&(identical(other.age, age) || other.age == age)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.color, color) || other.color == color)&&(identical(other.markings, markings) || other.markings == markings)&&(identical(other.healthNotes, healthNotes) || other.healthNotes == healthNotes)&&(identical(other.microchipId, microchipId) || other.microchipId == microchipId)&&const DeepCollectionEquality().equals(other.images, images)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,breed,age,gender,color,markings,healthNotes,microchipId,const DeepCollectionEquality().hash(images),createdAt,updatedAt);

@override
String toString() {
  return 'PetProfile(id: $id, name: $name, type: $type, breed: $breed, age: $age, gender: $gender, color: $color, markings: $markings, healthNotes: $healthNotes, microchipId: $microchipId, images: $images, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PetProfileCopyWith<$Res>  {
  factory $PetProfileCopyWith(PetProfile value, $Res Function(PetProfile) _then) = _$PetProfileCopyWithImpl;
@useResult
$Res call({
 String id, String name, AnimalType type, String breed, int? age, String? gender, String color, String? markings, String? healthNotes, String? microchipId, List<String> images, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$PetProfileCopyWithImpl<$Res>
    implements $PetProfileCopyWith<$Res> {
  _$PetProfileCopyWithImpl(this._self, this._then);

  final PetProfile _self;
  final $Res Function(PetProfile) _then;

/// Create a copy of PetProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? breed = null,Object? age = freezed,Object? gender = freezed,Object? color = null,Object? markings = freezed,Object? healthNotes = freezed,Object? microchipId = freezed,Object? images = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AnimalType,breed: null == breed ? _self.breed : breed // ignore: cast_nullable_to_non_nullable
as String,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,markings: freezed == markings ? _self.markings : markings // ignore: cast_nullable_to_non_nullable
as String?,healthNotes: freezed == healthNotes ? _self.healthNotes : healthNotes // ignore: cast_nullable_to_non_nullable
as String?,microchipId: freezed == microchipId ? _self.microchipId : microchipId // ignore: cast_nullable_to_non_nullable
as String?,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PetProfile].
extension PetProfilePatterns on PetProfile {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PetProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PetProfile() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PetProfile value)  $default,){
final _that = this;
switch (_that) {
case _PetProfile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PetProfile value)?  $default,){
final _that = this;
switch (_that) {
case _PetProfile() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  AnimalType type,  String breed,  int? age,  String? gender,  String color,  String? markings,  String? healthNotes,  String? microchipId,  List<String> images,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PetProfile() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.breed,_that.age,_that.gender,_that.color,_that.markings,_that.healthNotes,_that.microchipId,_that.images,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  AnimalType type,  String breed,  int? age,  String? gender,  String color,  String? markings,  String? healthNotes,  String? microchipId,  List<String> images,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PetProfile():
return $default(_that.id,_that.name,_that.type,_that.breed,_that.age,_that.gender,_that.color,_that.markings,_that.healthNotes,_that.microchipId,_that.images,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  AnimalType type,  String breed,  int? age,  String? gender,  String color,  String? markings,  String? healthNotes,  String? microchipId,  List<String> images,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PetProfile() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.breed,_that.age,_that.gender,_that.color,_that.markings,_that.healthNotes,_that.microchipId,_that.images,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PetProfile implements PetProfile {
  const _PetProfile({required this.id, required this.name, required this.type, required this.breed, this.age, this.gender, required this.color, this.markings, this.healthNotes, this.microchipId, final  List<String> images = const [], required this.createdAt, required this.updatedAt}): _images = images;
  factory _PetProfile.fromJson(Map<String, dynamic> json) => _$PetProfileFromJson(json);

@override final  String id;
@override final  String name;
@override final  AnimalType type;
@override final  String breed;
@override final  int? age;
@override final  String? gender;
@override final  String color;
@override final  String? markings;
@override final  String? healthNotes;
@override final  String? microchipId;
 final  List<String> _images;
@override@JsonKey() List<String> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of PetProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PetProfileCopyWith<_PetProfile> get copyWith => __$PetProfileCopyWithImpl<_PetProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PetProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PetProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.breed, breed) || other.breed == breed)&&(identical(other.age, age) || other.age == age)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.color, color) || other.color == color)&&(identical(other.markings, markings) || other.markings == markings)&&(identical(other.healthNotes, healthNotes) || other.healthNotes == healthNotes)&&(identical(other.microchipId, microchipId) || other.microchipId == microchipId)&&const DeepCollectionEquality().equals(other._images, _images)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,breed,age,gender,color,markings,healthNotes,microchipId,const DeepCollectionEquality().hash(_images),createdAt,updatedAt);

@override
String toString() {
  return 'PetProfile(id: $id, name: $name, type: $type, breed: $breed, age: $age, gender: $gender, color: $color, markings: $markings, healthNotes: $healthNotes, microchipId: $microchipId, images: $images, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PetProfileCopyWith<$Res> implements $PetProfileCopyWith<$Res> {
  factory _$PetProfileCopyWith(_PetProfile value, $Res Function(_PetProfile) _then) = __$PetProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, AnimalType type, String breed, int? age, String? gender, String color, String? markings, String? healthNotes, String? microchipId, List<String> images, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$PetProfileCopyWithImpl<$Res>
    implements _$PetProfileCopyWith<$Res> {
  __$PetProfileCopyWithImpl(this._self, this._then);

  final _PetProfile _self;
  final $Res Function(_PetProfile) _then;

/// Create a copy of PetProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? breed = null,Object? age = freezed,Object? gender = freezed,Object? color = null,Object? markings = freezed,Object? healthNotes = freezed,Object? microchipId = freezed,Object? images = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_PetProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AnimalType,breed: null == breed ? _self.breed : breed // ignore: cast_nullable_to_non_nullable
as String,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,markings: freezed == markings ? _self.markings : markings // ignore: cast_nullable_to_non_nullable
as String?,healthNotes: freezed == healthNotes ? _self.healthNotes : healthNotes // ignore: cast_nullable_to_non_nullable
as String?,microchipId: freezed == microchipId ? _self.microchipId : microchipId // ignore: cast_nullable_to_non_nullable
as String?,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
