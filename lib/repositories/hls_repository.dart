import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:dio/dio.dart';
import 'package:flutter_hls_parser_test/config/endpoints.dart';
import 'package:flutter_hls_parser_test/models/hls_entry_model/hls_entry_model.dart';
import 'package:flutter_hls_parser_test/models/master_playlist_model/master_playlist_model.dart';
import 'package:flutter_hls_parser_test/models/segment_playlist_model/segment_playlist_parsed_model.dart';
import 'package:flutter_hls_parser_test/providers/client_provider.dart';
import 'package:flutter_hls_parser_test/utils/functions.dart';
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

  Future<MasterPlaylistModel> fetchDataFromMasterPlaylist() async {
    try {
      HlsSegmentsPlaylistKey? segmentPlaylistKey;
      final hlsEntry = await fetchHlsEntry();
      final masterPlaylistUrl = hlsEntry.master;
      if (masterPlaylistUrl == null) {
        throw UnimplementedError(
          "Make sure you have provided master playlist url!",
        );
      }
      if (hlsEntry.enc_key != null && hlsEntry.salt != null) {
        final saltResponse = await dio.get(hlsEntry.salt!);
        if (saltResponse.data is String) {
          segmentPlaylistKey = HlsSegmentsPlaylistKey(
            encKeyUrl: hlsEntry.enc_key!,
            salt: saltResponse.data,
          );
        }
      }
      final response = await dio.get(masterPlaylistUrl);
      final parser = HlsParser(
        playlist: response.data,
        playlistUrl: masterPlaylistUrl,
      );
      return MasterPlaylistModel.fromParsedPlaylist(
        parser.parsedData,
        segmentPlaylistKey,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<SegmentPlaylistParsedModel> fetchDataFromResolutionPlaylist(
      MasterPlaylistModel masterPlaylist, HlsResolution resolution) async {
    try {
      final response = await dio.get(resolution.videoPlaylistUrl);
      final parser = HlsParser(
        playlist: response.data,
        playlistUrl: resolution.videoPlaylistUrl,
        key: masterPlaylist.segmentPlaylistKey,
      );
      final parsed = parser.parsedData;
      return SegmentPlaylistParsedModel.fromParsedPlaylist(
        parsed,
        masterPlaylist.segmentPlaylistKey,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<SegmentPlaylistParsedModel> fetchAudioPlaylist(
      MasterPlaylistModel masterPlaylistData) async {
    try {
      final response = await dio.get(masterPlaylistData.audioPlaylistUrl);
      final parser = HlsParser(
        playlist: response.data,
        playlistUrl: masterPlaylistData.audioPlaylistUrl,
        key: masterPlaylistData.segmentPlaylistKey,
      );
      final parsed = parser.parsedData;
      return SegmentPlaylistParsedModel.fromParsedPlaylist(
        parsed,
        masterPlaylistData.segmentPlaylistKey,
      );
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
    final videoSegments = await fetchDataFromResolutionPlaylist(
      masterPlaylistData,
      hlsResolution,
    );
    final audioSegments = await fetchAudioPlaylist(masterPlaylistData);
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
      HlsSegmentsPlaylistKey? key,
      required MasterPlaylistModel masterPlaylistData,
      required HlsResolution hlsResolution,
      void Function(double progress)? onProgressChanges}) async {
    try {
      final videoSegments = await fetchDataFromResolutionPlaylist(
        masterPlaylistData,
        hlsResolution,
      );
      final audioSegments = await fetchAudioPlaylist(masterPlaylistData);

      final appDir = await getApplicationDocumentsDirectory();

      final queryParams = {"t": "token_placeholder"};
      final tasks = <DownloadTask>[
        if (key != null)
          DownloadTask(
            url: key.encKeyUrl,
            taskId: key.encKeyUrl,
            directory: key.saveDir,
            filename: key.fileName,
            urlQueryParameters: queryParams,
          ),
      ];
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

      await File(hlsUrlToLocal(
              appDir, masterPlaylistData.masterPlaylistData.playlistUrl))
          .writeAsString(
        await masterPlaylistData.masterPlaylistData.toLocalPlaylist(),
      );

      await File(hlsUrlToLocal(appDir, videoSegments.playlistData.playlistUrl))
          .writeAsString(
        await videoSegments.playlistData.toLocalPlaylist(),
      );
      await File(hlsUrlToLocal(appDir, audioSegments.playlistData.playlistUrl))
          .writeAsString(
        await audioSegments.playlistData.toLocalPlaylist(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
