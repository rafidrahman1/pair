// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'period_data_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PeriodDataModel {

 String get uid; bool get isOnPeriod;@TimestampConverter() DateTime? get lastPeriodStart; String? get currentFlow;@TimestampConverter() DateTime? get lastFlowDate;@TimestampConverter() DateTime get updatedAt;
/// Create a copy of PeriodDataModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PeriodDataModelCopyWith<PeriodDataModel> get copyWith => _$PeriodDataModelCopyWithImpl<PeriodDataModel>(this as PeriodDataModel, _$identity);

  /// Serializes this PeriodDataModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PeriodDataModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.isOnPeriod, isOnPeriod) || other.isOnPeriod == isOnPeriod)&&(identical(other.lastPeriodStart, lastPeriodStart) || other.lastPeriodStart == lastPeriodStart)&&(identical(other.currentFlow, currentFlow) || other.currentFlow == currentFlow)&&(identical(other.lastFlowDate, lastFlowDate) || other.lastFlowDate == lastFlowDate)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,isOnPeriod,lastPeriodStart,currentFlow,lastFlowDate,updatedAt);

@override
String toString() {
  return 'PeriodDataModel(uid: $uid, isOnPeriod: $isOnPeriod, lastPeriodStart: $lastPeriodStart, currentFlow: $currentFlow, lastFlowDate: $lastFlowDate, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PeriodDataModelCopyWith<$Res>  {
  factory $PeriodDataModelCopyWith(PeriodDataModel value, $Res Function(PeriodDataModel) _then) = _$PeriodDataModelCopyWithImpl;
@useResult
$Res call({
 String uid, bool isOnPeriod,@TimestampConverter() DateTime? lastPeriodStart, String? currentFlow,@TimestampConverter() DateTime? lastFlowDate,@TimestampConverter() DateTime updatedAt
});




}
/// @nodoc
class _$PeriodDataModelCopyWithImpl<$Res>
    implements $PeriodDataModelCopyWith<$Res> {
  _$PeriodDataModelCopyWithImpl(this._self, this._then);

  final PeriodDataModel _self;
  final $Res Function(PeriodDataModel) _then;

/// Create a copy of PeriodDataModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? isOnPeriod = null,Object? lastPeriodStart = freezed,Object? currentFlow = freezed,Object? lastFlowDate = freezed,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,isOnPeriod: null == isOnPeriod ? _self.isOnPeriod : isOnPeriod // ignore: cast_nullable_to_non_nullable
as bool,lastPeriodStart: freezed == lastPeriodStart ? _self.lastPeriodStart : lastPeriodStart // ignore: cast_nullable_to_non_nullable
as DateTime?,currentFlow: freezed == currentFlow ? _self.currentFlow : currentFlow // ignore: cast_nullable_to_non_nullable
as String?,lastFlowDate: freezed == lastFlowDate ? _self.lastFlowDate : lastFlowDate // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PeriodDataModel].
extension PeriodDataModelPatterns on PeriodDataModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PeriodDataModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PeriodDataModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PeriodDataModel value)  $default,){
final _that = this;
switch (_that) {
case _PeriodDataModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PeriodDataModel value)?  $default,){
final _that = this;
switch (_that) {
case _PeriodDataModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  bool isOnPeriod, @TimestampConverter()  DateTime? lastPeriodStart,  String? currentFlow, @TimestampConverter()  DateTime? lastFlowDate, @TimestampConverter()  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PeriodDataModel() when $default != null:
return $default(_that.uid,_that.isOnPeriod,_that.lastPeriodStart,_that.currentFlow,_that.lastFlowDate,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  bool isOnPeriod, @TimestampConverter()  DateTime? lastPeriodStart,  String? currentFlow, @TimestampConverter()  DateTime? lastFlowDate, @TimestampConverter()  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PeriodDataModel():
return $default(_that.uid,_that.isOnPeriod,_that.lastPeriodStart,_that.currentFlow,_that.lastFlowDate,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  bool isOnPeriod, @TimestampConverter()  DateTime? lastPeriodStart,  String? currentFlow, @TimestampConverter()  DateTime? lastFlowDate, @TimestampConverter()  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PeriodDataModel() when $default != null:
return $default(_that.uid,_that.isOnPeriod,_that.lastPeriodStart,_that.currentFlow,_that.lastFlowDate,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PeriodDataModel extends PeriodDataModel {
  const _PeriodDataModel({required this.uid, required this.isOnPeriod, @TimestampConverter() this.lastPeriodStart, this.currentFlow, @TimestampConverter() this.lastFlowDate, @TimestampConverter() required this.updatedAt}): super._();
  factory _PeriodDataModel.fromJson(Map<String, dynamic> json) => _$PeriodDataModelFromJson(json);

@override final  String uid;
@override final  bool isOnPeriod;
@override@TimestampConverter() final  DateTime? lastPeriodStart;
@override final  String? currentFlow;
@override@TimestampConverter() final  DateTime? lastFlowDate;
@override@TimestampConverter() final  DateTime updatedAt;

/// Create a copy of PeriodDataModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PeriodDataModelCopyWith<_PeriodDataModel> get copyWith => __$PeriodDataModelCopyWithImpl<_PeriodDataModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PeriodDataModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PeriodDataModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.isOnPeriod, isOnPeriod) || other.isOnPeriod == isOnPeriod)&&(identical(other.lastPeriodStart, lastPeriodStart) || other.lastPeriodStart == lastPeriodStart)&&(identical(other.currentFlow, currentFlow) || other.currentFlow == currentFlow)&&(identical(other.lastFlowDate, lastFlowDate) || other.lastFlowDate == lastFlowDate)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,isOnPeriod,lastPeriodStart,currentFlow,lastFlowDate,updatedAt);

@override
String toString() {
  return 'PeriodDataModel(uid: $uid, isOnPeriod: $isOnPeriod, lastPeriodStart: $lastPeriodStart, currentFlow: $currentFlow, lastFlowDate: $lastFlowDate, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PeriodDataModelCopyWith<$Res> implements $PeriodDataModelCopyWith<$Res> {
  factory _$PeriodDataModelCopyWith(_PeriodDataModel value, $Res Function(_PeriodDataModel) _then) = __$PeriodDataModelCopyWithImpl;
@override @useResult
$Res call({
 String uid, bool isOnPeriod,@TimestampConverter() DateTime? lastPeriodStart, String? currentFlow,@TimestampConverter() DateTime? lastFlowDate,@TimestampConverter() DateTime updatedAt
});




}
/// @nodoc
class __$PeriodDataModelCopyWithImpl<$Res>
    implements _$PeriodDataModelCopyWith<$Res> {
  __$PeriodDataModelCopyWithImpl(this._self, this._then);

  final _PeriodDataModel _self;
  final $Res Function(_PeriodDataModel) _then;

/// Create a copy of PeriodDataModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? isOnPeriod = null,Object? lastPeriodStart = freezed,Object? currentFlow = freezed,Object? lastFlowDate = freezed,Object? updatedAt = null,}) {
  return _then(_PeriodDataModel(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,isOnPeriod: null == isOnPeriod ? _self.isOnPeriod : isOnPeriod // ignore: cast_nullable_to_non_nullable
as bool,lastPeriodStart: freezed == lastPeriodStart ? _self.lastPeriodStart : lastPeriodStart // ignore: cast_nullable_to_non_nullable
as DateTime?,currentFlow: freezed == currentFlow ? _self.currentFlow : currentFlow // ignore: cast_nullable_to_non_nullable
as String?,lastFlowDate: freezed == lastFlowDate ? _self.lastFlowDate : lastFlowDate // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
