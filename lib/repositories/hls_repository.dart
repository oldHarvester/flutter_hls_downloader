import 'package:dio/dio.dart';
import 'package:flutter_hls_parser_test/config/endpoints.dart';
import 'package:flutter_hls_parser_test/models/hls_entry_model/hls_entry_model.dart';
import 'package:flutter_hls_parser_test/models/master_playlist_parsed_model/master_playlist_parsed_model.dart';
import 'package:flutter_hls_parser_test/models/segment_playlist_model/segment_playlist_parsed_model.dart';
import 'package:flutter_hls_parser_test/providers/client_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod/riverpod.dart';

final hlsRepositoryProvider = Provider(
  (ref) => HlsRepository(
    dio: ref.read(clientProvider),
  ),
);

class HlsRepository {
  const HlsRepository({
    required this.dio,
  });

  final Dio dio;

  Future<HlsEntryModel> fetchHlsEntry() async {
    try {
      final response = await dio.get(EndPoints.hlsMovie);
      return HlsEntryModel.fromJson(response.data);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> fetchHlsPlaylist() async {
    try {
      final hlsEntry = await fetchHlsEntry();
      if (hlsEntry.master == null) return;
      final response =
          await dio.get(hlsEntry.master!.replaceFirst(EndPoints.baseUrl, ''));
      print(response.data);
    } catch (e) {
      print(e);
    }
  }

  Future<MasterPlaylistParsedModel> fetchDataFromMasterPlaylist(
      String masterPlaylistUrl) async {
    try {
      final response = await dio.get(masterPlaylistUrl);
      return MasterPlaylistParsedModel.parseFromPlaylist(
        response.data,
        masterPlaylistUrl,
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<SegmentPlaylistParsedModel> fetchDataFromResolutionPlaylist(
      HlsResolution resolution) async {
    try {
      final response = await dio.get(resolution.playlistUrl);
      return SegmentPlaylistParsedModel.parseFrom(
        response.data,
        resolution.playlistUrl,
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> downloadSegment(
    HlsSegment hlsSegment, {
    void Function(double progress)? onDownloadProgressChanges,
  }) async {
    try {
      final appDirectory = await getApplicationDocumentsDirectory();
      final fileFullName = hlsSegment.videoLink.split('/').last;
      await dio.download(
        hlsSegment.videoLink,
        "${appDirectory.path}/segments/$fileFullName",
        onReceiveProgress: (count, total) {
          onDownloadProgressChanges?.call(count / total);
        },
      );
    } catch (e) {
      print(e);
    }
  }
}
