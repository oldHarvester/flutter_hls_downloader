import 'package:dio/dio.dart';
import 'package:flutter_hls_parser_test/config/endpoints.dart';
import 'package:flutter_hls_parser_test/models/hls_entry_model/hls_entry_model.dart';
import 'package:flutter_hls_parser_test/models/master_playlist_model/master_playlist_model.dart';
import 'package:flutter_hls_parser_test/models/segment_playlist_model/segment_playlist_parsed_model.dart';
import 'package:flutter_hls_parser_test/providers/client_provider.dart';
import 'package:flutter_hls_parser_test/utils/hls_parser/hls_parser.dart';
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
      rethrow;
    }
  }

  Future<MasterPlaylistModel> fetchDataFromMasterPlaylist(
      String masterPlaylistUrl) async {
    try {
      final response = await dio.get(masterPlaylistUrl);
      final parser = HlsParser(
        playlist: response.data,
        playlistUrl: masterPlaylistUrl,
      );
      return MasterPlaylistModel.fromParsedPlaylist(
        parser.parsedData,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<SegmentPlaylistParsedModel> fetchDataFromResolutionPlaylist(
      HlsResolution resolution) async {
    // try {
    //   final response = await dio.get(resolution.playlistUrl);
    //   return SegmentPlaylistParsedModel.parseFrom(
    //     response.data,
    //     '',
    //   );
    // } catch (e) {
    //   rethrow;
    // }
    throw Exception();
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
      rethrow;
    }
  }

  Future<void> downloadHlsVideo(
      {required MasterPlaylistModel masterPlaylistData,
      required HlsResolution hlsResolution}) async {}
}
