import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hls_parser_test/models/segment_playlist_model/segment_playlist_parsed_model.dart';
import 'package:flutter_hls_parser_test/utils/hls_parser/hls_constants.dart';
import 'package:flutter_hls_parser_test/utils/hls_parser/hls_parser.dart';

enum HlsResolutionType {
  v144p("/144p"),
  v240p("/240p"),
  v360p("/360p"),
  v480p("/480p"),
  v720p("/720p"),
  v1080p("/1080p");

  const HlsResolutionType(this.title);
  final String title;
}

class HlsResolution extends Equatable {
  const HlsResolution(
      {required this.resolution, required this.videoPlaylistUrl});

  final HlsResolutionType resolution;
  final String videoPlaylistUrl;

  @override
  List<Object?> get props => [resolution, videoPlaylistUrl];
}

class MasterPlaylistModel extends Equatable {
  const MasterPlaylistModel({
    required this.resolutions,
    required this.masterPlaylistData,
    required this.audioPlaylistUrl,
    required this.playlistLocale,
    this.segmentPlaylistKey,
  });

  final String audioPlaylistUrl;
  final Set<HlsResolution> resolutions;
  final HlsPlaylistData masterPlaylistData;
  final Locale playlistLocale;
  final HlsSegmentsPlaylistKey? segmentPlaylistKey;

  factory MasterPlaylistModel.fromParsedPlaylist(
      HlsPlaylistData parsedMasterPlaylist,
      [HlsSegmentsPlaylistKey? segmentPlaylistKey]) {
    final resolutions = <HlsResolution>{};
    String? audioUrl;
    Locale? locale;

    for (var item in parsedMasterPlaylist.playlistItems) {
      final videoUrl = item.url;
      if (videoUrl != null) {
        for (var resolution in HlsResolutionType.values) {
          if (videoUrl.contains(resolution.title)) {
            resolutions.add(
              HlsResolution(
                resolution: resolution,
                videoPlaylistUrl: videoUrl,
              ),
            );
          }
        }
      }

      if (item.hlsValueParameters[HlsParamConstants.codecs] != null &&
          item.hlsValueParameters[HlsParamConstants.resolution] == null) {
        audioUrl = item.url;
      }

      final language = item.hlsValueParameters[HlsParamConstants.language];

      if (locale == null && language != null) {
        locale = Locale(language.value.replaceAll('"', ''));
      }
    }

    if (audioUrl == null) {
      throw UnimplementedError("Make sure your playlist contains AUDIO URI");
    } else if (locale == null) {
      throw UnimplementedError("Make sure your playlist contains LANGUAGE");
    }

    return MasterPlaylistModel(
      resolutions: resolutions,
      masterPlaylistData: parsedMasterPlaylist,
      audioPlaylistUrl: audioUrl,
      playlistLocale: locale,
      segmentPlaylistKey: segmentPlaylistKey,
    );
  }

  @override
  List<Object?> get props => [
        audioPlaylistUrl,
        resolutions,
        masterPlaylistData,
        audioPlaylistUrl,
        segmentPlaylistKey
      ];
}
