import 'dart:io';

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
      final appDir = await getApplicationDocumentsDirectory();
      await dio.download(
        hlsSegment.link,
        hlsSegment.absolutePath(appDir.path),
        onReceiveProgress: (count, total) {
          onDownloadProgressChanges?.call(count / total);
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isFileExist(String path) {
    return File(path).exists();
  }

  Future<List<HlsSegment>> checkSegments(
      {required MasterPlaylistModel masterPlaylistData,
      required HlsResolution hlsResolution}) async {
    final videoSegments = await fetchDataFromResolutionPlaylist(hlsResolution);
    final audioSegments =
        await fetchAudioPlaylist(masterPlaylistData.audioPlaylistUrl);
    final appDir = await getApplicationDocumentsDirectory();
    final segments = [
      ...videoSegments.segments,
      ...audioSegments.segments,
    ];

    final notDownloadedYet = <HlsSegment>[];

    for (var segment in segments) {
      final path = segment.absolutePath(appDir.path);
      final isExist = await isFileExist(path);
      if (!isExist) {
        notDownloadedYet.add(segment);
      }
    }

    return notDownloadedYet;
  }

  Future<void> downloadHlsVideo(
      {required List<HlsSegment> segments,
      void Function(double progress)? onProgressChanges}) async {
    final tasks = <DownloadTask>[];
    try {
      final queryParams = {"t": "token_placeholder"};

      tasks.addAll(
        segments
            .map(
              (e) => DownloadTask(
                url: e.link,
                taskId: e.link,
                directory: e.saveDir,
                filename: e.fileName,
                urlQueryParameters: queryParams,
              ),
            )
            .toList(),
      );

      await FileDownloader().downloadBatch(
        tasks,
        batchProgressCallback: (succeeded, failed) {
          onProgressChanges?.call(succeeded / segments.length);
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
