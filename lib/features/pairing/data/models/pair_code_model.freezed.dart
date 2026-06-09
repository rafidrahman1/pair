// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pair_code_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PairCodeModel {

 String get code; String get ownerId;@TimestampConverter() DateTime get expiresAt; bool get used;
/// Create a copy of PairCodeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PairCodeModelCopyWith<PairCodeModel> get copyWith => _$PairCodeModelCopyWithImpl<PairCodeModel>(this as PairCodeModel, _$identity);

  /// Serializes this PairCodeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PairCodeModel&&(identical(other.code, code) || other.code == code)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.used, used) || other.used == used));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,ownerId,expiresAt,used);

@override
String toString() {
  return 'PairCodeModel(code: $code, ownerId: $ownerId, expiresAt: $expiresAt, used: $used)';
}


}

/// @nodoc
abstract mixin class $PairCodeModelCopyWith<$Res>  {
  factory $PairCodeModelCopyWith(PairCodeModel value, $Res Function(PairCodeModel) _then) = _$PairCodeModelCopyWithImpl;
@useResult
$Res call({
 String code, String ownerId,@TimestampConverter() DateTime expiresAt, bool used
});




}
/// @nodoc
class _$PairCodeModelCopyWithImpl<$Res>
    implements $PairCodeModelCopyWith<$Res> {
  _$PairCodeModelCopyWithImpl(this._self, this._then);

  final PairCodeModel _self;
  final $Res Function(PairCodeModel) _then;

/// Create a copy of PairCodeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? ownerId = null,Object? expiresAt = null,Object? used = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PairCodeModel].
extension PairCodeModelPatterns on PairCodeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PairCodeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PairCodeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PairCodeModel value)  $default,){
final _that = this;
switch (_that) {
case _PairCodeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PairCodeModel value)?  $default,){
final _that = this;
switch (_that) {
case _PairCodeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String ownerId, @TimestampConverter()  DateTime expiresAt,  bool used)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PairCodeModel() when $default != null:
return $default(_that.code,_that.ownerId,_that.expiresAt,_that.used);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String ownerId, @TimestampConverter()  DateTime expiresAt,  bool used)  $default,) {final _that = this;
switch (_that) {
case _PairCodeModel():
return $default(_that.code,_that.ownerId,_that.expiresAt,_that.used);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String ownerId, @TimestampConverter()  DateTime expiresAt,  bool used)?  $default,) {final _that = this;
switch (_that) {
case _PairCodeModel() when $default != null:
return $default(_that.code,_that.ownerId,_that.expiresAt,_that.used);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PairCodeModel extends PairCodeModel {
  const _PairCodeModel({required this.code, required this.ownerId, @TimestampConverter() required this.expiresAt, this.used = false}): super._();
  factory _PairCodeModel.fromJson(Map<String, dynamic> json) => _$PairCodeModelFromJson(json);

@override final  String code;
@override final  String ownerId;
@override@TimestampConverter() final  DateTime expiresAt;
@override@JsonKey() final  bool used;

/// Create a copy of PairCodeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PairCodeModelCopyWith<_PairCodeModel> get copyWith => __$PairCodeModelCopyWithImpl<_PairCodeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PairCodeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PairCodeModel&&(identical(other.code, code) || other.code == code)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.used, used) || other.used == used));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,ownerId,expiresAt,used);

@override
String toString() {
  return 'PairCodeModel(code: $code, ownerId: $ownerId, expiresAt: $expiresAt, used: $used)';
}


}

/// @nodoc
abstract mixin class _$PairCodeModelCopyWith<$Res> implements $PairCodeModelCopyWith<$Res> {
  factory _$PairCodeModelCopyWith(_PairCodeModel value, $Res Function(_PairCodeModel) _then) = __$PairCodeModelCopyWithImpl;
@override @useResult
$Res call({
 String code, String ownerId,@TimestampConverter() DateTime expiresAt, bool used
});




}
/// @nodoc
class __$PairCodeModelCopyWithImpl<$Res>
    implements _$PairCodeModelCopyWith<$Res> {
  __$PairCodeModelCopyWithImpl(this._self, this._then);

  final _PairCodeModel _self;
  final $Res Function(_PairCodeModel) _then;

/// Create a copy of PairCodeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? ownerId = null,Object? expiresAt = null,Object? used = null,}) {
  return _then(_PairCodeModel(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
