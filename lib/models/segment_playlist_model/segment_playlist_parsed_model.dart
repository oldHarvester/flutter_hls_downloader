import 'package:equatable/equatable.dart';
import 'package:flutter_hls_parser_test/utils/hls_parser/hls_constants.dart';
import 'package:flutter_hls_parser_test/utils/hls_parser/hls_parser.dart';

class HlsSegment extends Equatable {
  const HlsSegment({
    required this.videoLink,
  });

  final String videoLink;

  @override
  List<Object?> get props => [videoLink];
}

class SegmentPlaylistParsedModel {
  SegmentPlaylistParsedModel({required this.segments});

  final Set<HlsSegment> segments;

  factory SegmentPlaylistParsedModel.fromParsedPlaylist(
      HlsPlaylistData playlistData) {
    final segments = <HlsSegment>{};

    for (var item in playlistData.playlistItems) {
      if (item.hlsKey == HlsKeyConstants.extInf) {
        segments.add(HlsSegment(videoLink: item.url!));
      }
    }

    return SegmentPlaylistParsedModel(segments: segments);
  }
}
