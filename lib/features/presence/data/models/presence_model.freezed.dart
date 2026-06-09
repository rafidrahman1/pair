// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'presence_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PresenceModel {

 String get uid; bool get online;@TimestampConverter() DateTime get lastSeen;
/// Create a copy of PresenceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PresenceModelCopyWith<PresenceModel> get copyWith => _$PresenceModelCopyWithImpl<PresenceModel>(this as PresenceModel, _$identity);

  /// Serializes this PresenceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PresenceModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.online, online) || other.online == online)&&(identical(other.lastSeen, lastSeen) || other.lastSeen == lastSeen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,online,lastSeen);

@override
String toString() {
  return 'PresenceModel(uid: $uid, online: $online, lastSeen: $lastSeen)';
}


}

/// @nodoc
abstract mixin class $PresenceModelCopyWith<$Res>  {
  factory $PresenceModelCopyWith(PresenceModel value, $Res Function(PresenceModel) _then) = _$PresenceModelCopyWithImpl;
@useResult
$Res call({
 String uid, bool online,@TimestampConverter() DateTime lastSeen
});




}
/// @nodoc
class _$PresenceModelCopyWithImpl<$Res>
    implements $PresenceModelCopyWith<$Res> {
  _$PresenceModelCopyWithImpl(this._self, this._then);

  final PresenceModel _self;
  final $Res Function(PresenceModel) _then;

/// Create a copy of PresenceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? online = null,Object? lastSeen = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,online: null == online ? _self.online : online // ignore: cast_nullable_to_non_nullable
as bool,lastSeen: null == lastSeen ? _self.lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PresenceModel].
extension PresenceModelPatterns on PresenceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PresenceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PresenceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PresenceModel value)  $default,){
final _that = this;
switch (_that) {
case _PresenceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PresenceModel value)?  $default,){
final _that = this;
switch (_that) {
case _PresenceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  bool online, @TimestampConverter()  DateTime lastSeen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PresenceModel() when $default != null:
return $default(_that.uid,_that.online,_that.lastSeen);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  bool online, @TimestampConverter()  DateTime lastSeen)  $default,) {final _that = this;
switch (_that) {
case _PresenceModel():
return $default(_that.uid,_that.online,_that.lastSeen);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  bool online, @TimestampConverter()  DateTime lastSeen)?  $default,) {final _that = this;
switch (_that) {
case _PresenceModel() when $default != null:
return $default(_that.uid,_that.online,_that.lastSeen);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PresenceModel extends PresenceModel {
  const _PresenceModel({required this.uid, required this.online, @TimestampConverter() required this.lastSeen}): super._();
  factory _PresenceModel.fromJson(Map<String, dynamic> json) => _$PresenceModelFromJson(json);

@override final  String uid;
@override final  bool online;
@override@TimestampConverter() final  DateTime lastSeen;

/// Create a copy of PresenceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PresenceModelCopyWith<_PresenceModel> get copyWith => __$PresenceModelCopyWithImpl<_PresenceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PresenceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PresenceModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.online, online) || other.online == online)&&(identical(other.lastSeen, lastSeen) || other.lastSeen == lastSeen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,online,lastSeen);

@override
String toString() {
  return 'PresenceModel(uid: $uid, online: $online, lastSeen: $lastSeen)';
}


}

/// @nodoc
abstract mixin class _$PresenceModelCopyWith<$Res> implements $PresenceModelCopyWith<$Res> {
  factory _$PresenceModelCopyWith(_PresenceModel value, $Res Function(_PresenceModel) _then) = __$PresenceModelCopyWithImpl;
@override @useResult
$Res call({
 String uid, bool online,@TimestampConverter() DateTime lastSeen
});




}
/// @nodoc
class __$PresenceModelCopyWithImpl<$Res>
    implements _$PresenceModelCopyWith<$Res> {
  __$PresenceModelCopyWithImpl(this._self, this._then);

  final _PresenceModel _self;
  final $Res Function(_PresenceModel) _then;

/// Create a copy of PresenceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? online = null,Object? lastSeen = null,}) {
  return _then(_PresenceModel(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,online: null == online ? _self.online : online // ignore: cast_nullable_to_non_nullable
as bool,lastSeen: null == lastSeen ? _self.lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
