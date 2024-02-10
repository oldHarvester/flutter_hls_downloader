// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hls_entry_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HlsEntryModel _$HlsEntryModelFromJson(Map<String, dynamic> json) {
  return _HlsEntryModel.fromJson(json);
}

/// @nodoc
mixin _$HlsEntryModel {
  String? get master => throw _privateConstructorUsedError;
  String? get enc_key => throw _privateConstructorUsedError;
  String? get salt => throw _privateConstructorUsedError;
  bool? get is_encrypt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HlsEntryModelCopyWith<HlsEntryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HlsEntryModelCopyWith<$Res> {
  factory $HlsEntryModelCopyWith(
          HlsEntryModel value, $Res Function(HlsEntryModel) then) =
      _$HlsEntryModelCopyWithImpl<$Res, HlsEntryModel>;
  @useResult
  $Res call({String? master, String? enc_key, String? salt, bool? is_encrypt});
}

/// @nodoc
class _$HlsEntryModelCopyWithImpl<$Res, $Val extends HlsEntryModel>
    implements $HlsEntryModelCopyWith<$Res> {
  _$HlsEntryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? master = freezed,
    Object? enc_key = freezed,
    Object? salt = freezed,
    Object? is_encrypt = freezed,
  }) {
    return _then(_value.copyWith(
      master: freezed == master
          ? _value.master
          : master // ignore: cast_nullable_to_non_nullable
              as String?,
      enc_key: freezed == enc_key
          ? _value.enc_key
          : enc_key // ignore: cast_nullable_to_non_nullable
              as String?,
      salt: freezed == salt
          ? _value.salt
          : salt // ignore: cast_nullable_to_non_nullable
              as String?,
      is_encrypt: freezed == is_encrypt
          ? _value.is_encrypt
          : is_encrypt // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HlsEntryModelImplCopyWith<$Res>
    implements $HlsEntryModelCopyWith<$Res> {
  factory _$$HlsEntryModelImplCopyWith(
          _$HlsEntryModelImpl value, $Res Function(_$HlsEntryModelImpl) then) =
      __$$HlsEntryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? master, String? enc_key, String? salt, bool? is_encrypt});
}

/// @nodoc
class __$$HlsEntryModelImplCopyWithImpl<$Res>
    extends _$HlsEntryModelCopyWithImpl<$Res, _$HlsEntryModelImpl>
    implements _$$HlsEntryModelImplCopyWith<$Res> {
  __$$HlsEntryModelImplCopyWithImpl(
      _$HlsEntryModelImpl _value, $Res Function(_$HlsEntryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? master = freezed,
    Object? enc_key = freezed,
    Object? salt = freezed,
    Object? is_encrypt = freezed,
  }) {
    return _then(_$HlsEntryModelImpl(
      master: freezed == master
          ? _value.master
          : master // ignore: cast_nullable_to_non_nullable
              as String?,
      enc_key: freezed == enc_key
          ? _value.enc_key
          : enc_key // ignore: cast_nullable_to_non_nullable
              as String?,
      salt: freezed == salt
          ? _value.salt
          : salt // ignore: cast_nullable_to_non_nullable
              as String?,
      is_encrypt: freezed == is_encrypt
          ? _value.is_encrypt
          : is_encrypt // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HlsEntryModelImpl implements _HlsEntryModel {
  _$HlsEntryModelImpl({this.master, this.enc_key, this.salt, this.is_encrypt});

  factory _$HlsEntryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HlsEntryModelImplFromJson(json);

  @override
  final String? master;
  @override
  final String? enc_key;
  @override
  final String? salt;
  @override
  final bool? is_encrypt;

  @override
  String toString() {
    return 'HlsEntryModel(master: $master, enc_key: $enc_key, salt: $salt, is_encrypt: $is_encrypt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HlsEntryModelImpl &&
            (identical(other.master, master) || other.master == master) &&
            (identical(other.enc_key, enc_key) || other.enc_key == enc_key) &&
            (identical(other.salt, salt) || other.salt == salt) &&
            (identical(other.is_encrypt, is_encrypt) ||
                other.is_encrypt == is_encrypt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, master, enc_key, salt, is_encrypt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HlsEntryModelImplCopyWith<_$HlsEntryModelImpl> get copyWith =>
      __$$HlsEntryModelImplCopyWithImpl<_$HlsEntryModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HlsEntryModelImplToJson(
      this,
    );
  }
}

abstract class _HlsEntryModel implements HlsEntryModel {
  factory _HlsEntryModel(
      {final String? master,
      final String? enc_key,
      final String? salt,
      final bool? is_encrypt}) = _$HlsEntryModelImpl;

  factory _HlsEntryModel.fromJson(Map<String, dynamic> json) =
      _$HlsEntryModelImpl.fromJson;

  @override
  String? get master;
  @override
  String? get enc_key;
  @override
  String? get salt;
  @override
  bool? get is_encrypt;
  @override
  @JsonKey(ignore: true)
  _$$HlsEntryModelImplCopyWith<_$HlsEntryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
