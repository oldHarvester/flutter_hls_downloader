// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hls_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HlsEntryModelImpl _$$HlsEntryModelImplFromJson(Map<String, dynamic> json) =>
    _$HlsEntryModelImpl(
      master: json['master'] as String?,
      enc_key: json['enc_key'] as String?,
      salt: json['salt'] as String?,
      is_encrypt: json['is_encrypt'] as bool?,
    );

Map<String, dynamic> _$$HlsEntryModelImplToJson(_$HlsEntryModelImpl instance) =>
    <String, dynamic>{
      'master': instance.master,
      'enc_key': instance.enc_key,
      'salt': instance.salt,
      'is_encrypt': instance.is_encrypt,
    };
