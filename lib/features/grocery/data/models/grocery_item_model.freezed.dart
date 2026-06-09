// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grocery_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroceryItemModel {

 String get id; String get text; bool get isChecked; String get addedBy; String? get checkedBy;@TimestampConverter() DateTime get createdAt;@TimestampConverter() DateTime get updatedAt;
/// Create a copy of GroceryItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroceryItemModelCopyWith<GroceryItemModel> get copyWith => _$GroceryItemModelCopyWithImpl<GroceryItemModel>(this as GroceryItemModel, _$identity);

  /// Serializes this GroceryItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroceryItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.isChecked, isChecked) || other.isChecked == isChecked)&&(identical(other.addedBy, addedBy) || other.addedBy == addedBy)&&(identical(other.checkedBy, checkedBy) || other.checkedBy == checkedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,isChecked,addedBy,checkedBy,createdAt,updatedAt);

@override
String toString() {
  return 'GroceryItemModel(id: $id, text: $text, isChecked: $isChecked, addedBy: $addedBy, checkedBy: $checkedBy, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $GroceryItemModelCopyWith<$Res>  {
  factory $GroceryItemModelCopyWith(GroceryItemModel value, $Res Function(GroceryItemModel) _then) = _$GroceryItemModelCopyWithImpl;
@useResult
$Res call({
 String id, String text, bool isChecked, String addedBy, String? checkedBy,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt
});




}
/// @nodoc
class _$GroceryItemModelCopyWithImpl<$Res>
    implements $GroceryItemModelCopyWith<$Res> {
  _$GroceryItemModelCopyWithImpl(this._self, this._then);

  final GroceryItemModel _self;
  final $Res Function(GroceryItemModel) _then;

/// Create a copy of GroceryItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? isChecked = null,Object? addedBy = null,Object? checkedBy = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,isChecked: null == isChecked ? _self.isChecked : isChecked // ignore: cast_nullable_to_non_nullable
as bool,addedBy: null == addedBy ? _self.addedBy : addedBy // ignore: cast_nullable_to_non_nullable
as String,checkedBy: freezed == checkedBy ? _self.checkedBy : checkedBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [GroceryItemModel].
extension GroceryItemModelPatterns on GroceryItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroceryItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroceryItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroceryItemModel value)  $default,){
final _that = this;
switch (_that) {
case _GroceryItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroceryItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _GroceryItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String text,  bool isChecked,  String addedBy,  String? checkedBy, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroceryItemModel() when $default != null:
return $default(_that.id,_that.text,_that.isChecked,_that.addedBy,_that.checkedBy,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String text,  bool isChecked,  String addedBy,  String? checkedBy, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _GroceryItemModel():
return $default(_that.id,_that.text,_that.isChecked,_that.addedBy,_that.checkedBy,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String text,  bool isChecked,  String addedBy,  String? checkedBy, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _GroceryItemModel() when $default != null:
return $default(_that.id,_that.text,_that.isChecked,_that.addedBy,_that.checkedBy,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroceryItemModel extends GroceryItemModel {
  const _GroceryItemModel({required this.id, required this.text, this.isChecked = false, required this.addedBy, this.checkedBy, @TimestampConverter() required this.createdAt, @TimestampConverter() required this.updatedAt}): super._();
  factory _GroceryItemModel.fromJson(Map<String, dynamic> json) => _$GroceryItemModelFromJson(json);

@override final  String id;
@override final  String text;
@override@JsonKey() final  bool isChecked;
@override final  String addedBy;
@override final  String? checkedBy;
@override@TimestampConverter() final  DateTime createdAt;
@override@TimestampConverter() final  DateTime updatedAt;

/// Create a copy of GroceryItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroceryItemModelCopyWith<_GroceryItemModel> get copyWith => __$GroceryItemModelCopyWithImpl<_GroceryItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroceryItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroceryItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.isChecked, isChecked) || other.isChecked == isChecked)&&(identical(other.addedBy, addedBy) || other.addedBy == addedBy)&&(identical(other.checkedBy, checkedBy) || other.checkedBy == checkedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,isChecked,addedBy,checkedBy,createdAt,updatedAt);

@override
String toString() {
  return 'GroceryItemModel(id: $id, text: $text, isChecked: $isChecked, addedBy: $addedBy, checkedBy: $checkedBy, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$GroceryItemModelCopyWith<$Res> implements $GroceryItemModelCopyWith<$Res> {
  factory _$GroceryItemModelCopyWith(_GroceryItemModel value, $Res Function(_GroceryItemModel) _then) = __$GroceryItemModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String text, bool isChecked, String addedBy, String? checkedBy,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt
});




}
/// @nodoc
class __$GroceryItemModelCopyWithImpl<$Res>
    implements _$GroceryItemModelCopyWith<$Res> {
  __$GroceryItemModelCopyWithImpl(this._self, this._then);

  final _GroceryItemModel _self;
  final $Res Function(_GroceryItemModel) _then;

/// Create a copy of GroceryItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? isChecked = null,Object? addedBy = null,Object? checkedBy = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_GroceryItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,isChecked: null == isChecked ? _self.isChecked : isChecked // ignore: cast_nullable_to_non_nullable
as bool,addedBy: null == addedBy ? _self.addedBy : addedBy // ignore: cast_nullable_to_non_nullable
as String,checkedBy: freezed == checkedBy ? _self.checkedBy : checkedBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
