import 'package:equatable/equatable.dart';
import 'package:flutter_hls_parser_test/utils/functions.dart';

class HlsSegment extends Equatable {
  const HlsSegment({
    required this.duration,
    required this.videoLink,
  });

  final double duration;
  final String videoLink;

  @override
  List<Object?> get props => [duration, videoLink];
}

class SegmentPlaylistParsedModel {
  SegmentPlaylistParsedModel({required this.segments});

  final Set<HlsSegment> segments;

  factory SegmentPlaylistParsedModel.parseFrom(
      String segmentsData, String playlistUrl) {
    final segments = <HlsSegment>{};
    final segmentsLines = segmentsData.split('\n');

    for (var i = 0; i < segmentsLines.length; i++) {
      if (segmentsLines[i].contains("#EXTINF:")) {
        double? duration = double.tryParse(segmentsLines[i]
            .replaceFirst("#EXTINF:", '')
            .replaceFirst(',', ''));
        String? videoLink;
        if (i < segmentsLines.length - 1) {
          videoLink = segmentsLines[i + 1];
          i += 1;
          if (duration != null) {
            segments.add(
              HlsSegment(
                duration: duration,
                videoLink: checkLinks(videoLink, playlistUrl),
              ),
            );
          }
        }
      }
    }
    
    return SegmentPlaylistParsedModel(segments: segments);
  }
}
