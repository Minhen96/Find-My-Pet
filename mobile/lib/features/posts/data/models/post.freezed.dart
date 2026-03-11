// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Post {

 String get id; PostType get type; String? get description; List<String> get images; dynamic get location; DateTime? get lastSeenAt; bool get isResolved; User? get poster; PetProfile? get petProfile; AnimalType? get animalType; String? get breed; String? get color; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostCopyWith<Post> get copyWith => _$PostCopyWithImpl<Post>(this as Post, _$identity);

  /// Serializes this Post to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Post&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.images, images)&&const DeepCollectionEquality().equals(other.location, location)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.isResolved, isResolved) || other.isResolved == isResolved)&&(identical(other.poster, poster) || other.poster == poster)&&(identical(other.petProfile, petProfile) || other.petProfile == petProfile)&&(identical(other.animalType, animalType) || other.animalType == animalType)&&(identical(other.breed, breed) || other.breed == breed)&&(identical(other.color, color) || other.color == color)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,description,const DeepCollectionEquality().hash(images),const DeepCollectionEquality().hash(location),lastSeenAt,isResolved,poster,petProfile,animalType,breed,color,createdAt,updatedAt);

@override
String toString() {
  return 'Post(id: $id, type: $type, description: $description, images: $images, location: $location, lastSeenAt: $lastSeenAt, isResolved: $isResolved, poster: $poster, petProfile: $petProfile, animalType: $animalType, breed: $breed, color: $color, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PostCopyWith<$Res>  {
  factory $PostCopyWith(Post value, $Res Function(Post) _then) = _$PostCopyWithImpl;
@useResult
$Res call({
 String id, PostType type, String? description, List<String> images, dynamic location, DateTime? lastSeenAt, bool isResolved, User? poster, PetProfile? petProfile, AnimalType? animalType, String? breed, String? color, DateTime createdAt, DateTime updatedAt
});


$UserCopyWith<$Res>? get poster;$PetProfileCopyWith<$Res>? get petProfile;

}
/// @nodoc
class _$PostCopyWithImpl<$Res>
    implements $PostCopyWith<$Res> {
  _$PostCopyWithImpl(this._self, this._then);

  final Post _self;
  final $Res Function(Post) _then;

/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? description = freezed,Object? images = null,Object? location = freezed,Object? lastSeenAt = freezed,Object? isResolved = null,Object? poster = freezed,Object? petProfile = freezed,Object? animalType = freezed,Object? breed = freezed,Object? color = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PostType,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as dynamic,lastSeenAt: freezed == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isResolved: null == isResolved ? _self.isResolved : isResolved // ignore: cast_nullable_to_non_nullable
as bool,poster: freezed == poster ? _self.poster : poster // ignore: cast_nullable_to_non_nullable
as User?,petProfile: freezed == petProfile ? _self.petProfile : petProfile // ignore: cast_nullable_to_non_nullable
as PetProfile?,animalType: freezed == animalType ? _self.animalType : animalType // ignore: cast_nullable_to_non_nullable
as AnimalType?,breed: freezed == breed ? _self.breed : breed // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get poster {
    if (_self.poster == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.poster!, (value) {
    return _then(_self.copyWith(poster: value));
  });
}/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PetProfileCopyWith<$Res>? get petProfile {
    if (_self.petProfile == null) {
    return null;
  }

  return $PetProfileCopyWith<$Res>(_self.petProfile!, (value) {
    return _then(_self.copyWith(petProfile: value));
  });
}
}


/// Adds pattern-matching-related methods to [Post].
extension PostPatterns on Post {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Post value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Post() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Post value)  $default,){
final _that = this;
switch (_that) {
case _Post():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Post value)?  $default,){
final _that = this;
switch (_that) {
case _Post() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  PostType type,  String? description,  List<String> images,  dynamic location,  DateTime? lastSeenAt,  bool isResolved,  User? poster,  PetProfile? petProfile,  AnimalType? animalType,  String? breed,  String? color,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Post() when $default != null:
return $default(_that.id,_that.type,_that.description,_that.images,_that.location,_that.lastSeenAt,_that.isResolved,_that.poster,_that.petProfile,_that.animalType,_that.breed,_that.color,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  PostType type,  String? description,  List<String> images,  dynamic location,  DateTime? lastSeenAt,  bool isResolved,  User? poster,  PetProfile? petProfile,  AnimalType? animalType,  String? breed,  String? color,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Post():
return $default(_that.id,_that.type,_that.description,_that.images,_that.location,_that.lastSeenAt,_that.isResolved,_that.poster,_that.petProfile,_that.animalType,_that.breed,_that.color,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  PostType type,  String? description,  List<String> images,  dynamic location,  DateTime? lastSeenAt,  bool isResolved,  User? poster,  PetProfile? petProfile,  AnimalType? animalType,  String? breed,  String? color,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Post() when $default != null:
return $default(_that.id,_that.type,_that.description,_that.images,_that.location,_that.lastSeenAt,_that.isResolved,_that.poster,_that.petProfile,_that.animalType,_that.breed,_that.color,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Post implements Post {
  const _Post({required this.id, required this.type, this.description, final  List<String> images = const [], this.location, this.lastSeenAt, this.isResolved = false, this.poster, this.petProfile, this.animalType, this.breed, this.color, required this.createdAt, required this.updatedAt}): _images = images;
  factory _Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

@override final  String id;
@override final  PostType type;
@override final  String? description;
 final  List<String> _images;
@override@JsonKey() List<String> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

@override final  dynamic location;
@override final  DateTime? lastSeenAt;
@override@JsonKey() final  bool isResolved;
@override final  User? poster;
@override final  PetProfile? petProfile;
@override final  AnimalType? animalType;
@override final  String? breed;
@override final  String? color;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostCopyWith<_Post> get copyWith => __$PostCopyWithImpl<_Post>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Post&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._images, _images)&&const DeepCollectionEquality().equals(other.location, location)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.isResolved, isResolved) || other.isResolved == isResolved)&&(identical(other.poster, poster) || other.poster == poster)&&(identical(other.petProfile, petProfile) || other.petProfile == petProfile)&&(identical(other.animalType, animalType) || other.animalType == animalType)&&(identical(other.breed, breed) || other.breed == breed)&&(identical(other.color, color) || other.color == color)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,description,const DeepCollectionEquality().hash(_images),const DeepCollectionEquality().hash(location),lastSeenAt,isResolved,poster,petProfile,animalType,breed,color,createdAt,updatedAt);

@override
String toString() {
  return 'Post(id: $id, type: $type, description: $description, images: $images, location: $location, lastSeenAt: $lastSeenAt, isResolved: $isResolved, poster: $poster, petProfile: $petProfile, animalType: $animalType, breed: $breed, color: $color, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PostCopyWith<$Res> implements $PostCopyWith<$Res> {
  factory _$PostCopyWith(_Post value, $Res Function(_Post) _then) = __$PostCopyWithImpl;
@override @useResult
$Res call({
 String id, PostType type, String? description, List<String> images, dynamic location, DateTime? lastSeenAt, bool isResolved, User? poster, PetProfile? petProfile, AnimalType? animalType, String? breed, String? color, DateTime createdAt, DateTime updatedAt
});


@override $UserCopyWith<$Res>? get poster;@override $PetProfileCopyWith<$Res>? get petProfile;

}
/// @nodoc
class __$PostCopyWithImpl<$Res>
    implements _$PostCopyWith<$Res> {
  __$PostCopyWithImpl(this._self, this._then);

  final _Post _self;
  final $Res Function(_Post) _then;

/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? description = freezed,Object? images = null,Object? location = freezed,Object? lastSeenAt = freezed,Object? isResolved = null,Object? poster = freezed,Object? petProfile = freezed,Object? animalType = freezed,Object? breed = freezed,Object? color = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Post(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PostType,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as dynamic,lastSeenAt: freezed == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isResolved: null == isResolved ? _self.isResolved : isResolved // ignore: cast_nullable_to_non_nullable
as bool,poster: freezed == poster ? _self.poster : poster // ignore: cast_nullable_to_non_nullable
as User?,petProfile: freezed == petProfile ? _self.petProfile : petProfile // ignore: cast_nullable_to_non_nullable
as PetProfile?,animalType: freezed == animalType ? _self.animalType : animalType // ignore: cast_nullable_to_non_nullable
as AnimalType?,breed: freezed == breed ? _self.breed : breed // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get poster {
    if (_self.poster == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.poster!, (value) {
    return _then(_self.copyWith(poster: value));
  });
}/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PetProfileCopyWith<$Res>? get petProfile {
    if (_self.petProfile == null) {
    return null;
  }

  return $PetProfileCopyWith<$Res>(_self.petProfile!, (value) {
    return _then(_self.copyWith(petProfile: value));
  });
}
}

// dart format on
