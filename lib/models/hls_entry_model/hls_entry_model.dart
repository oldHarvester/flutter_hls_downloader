import 'package:freezed_annotation/freezed_annotation.dart';

part 'hls_entry_model.freezed.dart';
part 'hls_entry_model.g.dart';

@freezed
class HlsEntryModel with _$HlsEntryModel {

  factory HlsEntryModel({
    String? master,
    String? enc_key,
    String? salt,
    bool? is_encrypt,
  }) = _HlsEntryModel;

  factory HlsEntryModel.fromJson(Map<String, dynamic> json) => _$HlsEntryModelFromJson(json);
}