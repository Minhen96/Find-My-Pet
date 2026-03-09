// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Pet {

 String get id; PetType get type; PetStatus get status; String get breed; String get color; String? get description; List<String> get images; DateTime? get lastSeenAt; bool get isResolved; User? get poster; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Pet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PetCopyWith<Pet> get copyWith => _$PetCopyWithImpl<Pet>(this as Pet, _$identity);

  /// Serializes this Pet to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Pet&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.breed, breed) || other.breed == breed)&&(identical(other.color, color) || other.color == color)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.images, images)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.isResolved, isResolved) || other.isResolved == isResolved)&&const DeepCollectionEquality().equals(other.poster, poster)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,status,breed,color,description,const DeepCollectionEquality().hash(images),lastSeenAt,isResolved,const DeepCollectionEquality().hash(poster),createdAt,updatedAt);

@override
String toString() {
  return 'Pet(id: $id, type: $type, status: $status, breed: $breed, color: $color, description: $description, images: $images, lastSeenAt: $lastSeenAt, isResolved: $isResolved, poster: $poster, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PetCopyWith<$Res>  {
  factory $PetCopyWith(Pet value, $Res Function(Pet) _then) = _$PetCopyWithImpl;
@useResult
$Res call({
 String id, PetType type, PetStatus status, String breed, String color, String? description, List<String> images, DateTime? lastSeenAt, bool isResolved, User? poster, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$PetCopyWithImpl<$Res>
    implements $PetCopyWith<$Res> {
  _$PetCopyWithImpl(this._self, this._then);

  final Pet _self;
  final $Res Function(Pet) _then;

/// Create a copy of Pet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? status = null,Object? breed = null,Object? color = null,Object? description = freezed,Object? images = null,Object? lastSeenAt = freezed,Object? isResolved = null,Object? poster = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PetType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PetStatus,breed: null == breed ? _self.breed : breed // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>,lastSeenAt: freezed == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isResolved: null == isResolved ? _self.isResolved : isResolved // ignore: cast_nullable_to_non_nullable
as bool,poster: freezed == poster ? _self.poster : poster // ignore: cast_nullable_to_non_nullable
as User?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Pet].
extension PetPatterns on Pet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Pet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Pet() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Pet value)  $default,){
final _that = this;
switch (_that) {
case _Pet():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Pet value)?  $default,){
final _that = this;
switch (_that) {
case _Pet() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  PetType type,  PetStatus status,  String breed,  String color,  String? description,  List<String> images,  DateTime? lastSeenAt,  bool isResolved,  User? poster,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Pet() when $default != null:
return $default(_that.id,_that.type,_that.status,_that.breed,_that.color,_that.description,_that.images,_that.lastSeenAt,_that.isResolved,_that.poster,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  PetType type,  PetStatus status,  String breed,  String color,  String? description,  List<String> images,  DateTime? lastSeenAt,  bool isResolved,  User? poster,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Pet():
return $default(_that.id,_that.type,_that.status,_that.breed,_that.color,_that.description,_that.images,_that.lastSeenAt,_that.isResolved,_that.poster,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  PetType type,  PetStatus status,  String breed,  String color,  String? description,  List<String> images,  DateTime? lastSeenAt,  bool isResolved,  User? poster,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Pet() when $default != null:
return $default(_that.id,_that.type,_that.status,_that.breed,_that.color,_that.description,_that.images,_that.lastSeenAt,_that.isResolved,_that.poster,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Pet implements Pet {
  const _Pet({required this.id, required this.type, required this.status, required this.breed, required this.color, this.description, final  List<String> images = const [], this.lastSeenAt, this.isResolved = false, this.poster, required this.createdAt, required this.updatedAt}): _images = images;
  factory _Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);

@override final  String id;
@override final  PetType type;
@override final  PetStatus status;
@override final  String breed;
@override final  String color;
@override final  String? description;
 final  List<String> _images;
@override@JsonKey() List<String> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

@override final  DateTime? lastSeenAt;
@override@JsonKey() final  bool isResolved;
@override final  User? poster;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Pet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PetCopyWith<_Pet> get copyWith => __$PetCopyWithImpl<_Pet>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Pet&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.breed, breed) || other.breed == breed)&&(identical(other.color, color) || other.color == color)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._images, _images)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.isResolved, isResolved) || other.isResolved == isResolved)&&const DeepCollectionEquality().equals(other.poster, poster)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,status,breed,color,description,const DeepCollectionEquality().hash(_images),lastSeenAt,isResolved,const DeepCollectionEquality().hash(poster),createdAt,updatedAt);

@override
String toString() {
  return 'Pet(id: $id, type: $type, status: $status, breed: $breed, color: $color, description: $description, images: $images, lastSeenAt: $lastSeenAt, isResolved: $isResolved, poster: $poster, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PetCopyWith<$Res> implements $PetCopyWith<$Res> {
  factory _$PetCopyWith(_Pet value, $Res Function(_Pet) _then) = __$PetCopyWithImpl;
@override @useResult
$Res call({
 String id, PetType type, PetStatus status, String breed, String color, String? description, List<String> images, DateTime? lastSeenAt, bool isResolved, User? poster, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$PetCopyWithImpl<$Res>
    implements _$PetCopyWith<$Res> {
  __$PetCopyWithImpl(this._self, this._then);

  final _Pet _self;
  final $Res Function(_Pet) _then;

/// Create a copy of Pet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? status = null,Object? breed = null,Object? color = null,Object? description = freezed,Object? images = null,Object? lastSeenAt = freezed,Object? isResolved = null,Object? poster = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Pet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PetType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PetStatus,breed: null == breed ? _self.breed : breed // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>,lastSeenAt: freezed == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isResolved: null == isResolved ? _self.isResolved : isResolved // ignore: cast_nullable_to_non_nullable
as bool,poster: freezed == poster ? _self.poster : poster // ignore: cast_nullable_to_non_nullable
as User?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
