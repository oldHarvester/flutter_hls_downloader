import 'package:background_downloader/background_downloader.dart';
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
    try {
      final response = await dio.get(resolution.videoPlaylistUrl);
      final parser = HlsParser(
          playlist: response.data, playlistUrl: resolution.videoPlaylistUrl);
      final parsed = parser.parsedData;
      return SegmentPlaylistParsedModel.fromParsedPlaylist(parsed);
    } catch (e) {
      rethrow;
    }
  }

  Future<SegmentPlaylistParsedModel> fetchAudioPlaylist(String url) async {
    try {
      final response = await dio.get(url);
      final parser = HlsParser(playlist: response.data, playlistUrl: url);
      final parsed = parser.parsedData;
      return SegmentPlaylistParsedModel.fromParsedPlaylist(parsed);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> downloadSegment(
    HlsSegment hlsSegment, {
    void Function(double progress)? onDownloadProgressChanges,
  }) async {
    try {
      final appDirectory = await getApplicationDocumentsDirectory();
      final fileFullName = hlsSegment.link.split('/').last;
      await dio.download(
        hlsSegment.link,
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
      required HlsResolution hlsResolution}) async {
    final tasks = <DownloadTask>[];
    try {
      final videoSegments =
          await fetchDataFromResolutionPlaylist(hlsResolution);
      final audioSegments =
          await fetchAudioPlaylist(masterPlaylistData.audioPlaylistUrl);
      tasks.addAll([
        ...videoSegments.segments.map(
          (e) => DownloadTask(
            url: e.link,
            taskId: e.link,
            directory: e.saveDir,
          ),
        ),
        ...audioSegments.segments.map(
          (e) => DownloadTask(
            url: e.link,
            taskId: e.link,
            directory: e.saveDir,
          ),
        ),
      ]);

      await FileDownloader().downloadBatch(
        tasks,
        batchProgressCallback: (succeeded, failed) {},
        taskProgressCallback: (update) {
          print(
              "expected size: ${update.expectedFileSize}, fileName: ${update.task.filename}");
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
