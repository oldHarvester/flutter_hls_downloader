import 'package:equatable/equatable.dart';
import 'package:flutter_hls_parser_test/utils/hls_parser/hls_constants.dart';
import 'package:flutter_hls_parser_test/utils/hls_parser/hls_parser.dart';

class HlsSegment extends Equatable {
  const HlsSegment({
    required this.link,
  });

  final String link;
  
  String get path {
    final splittedLink = link.split('/')
      ..removeAt(0)
      ..removeAt(1);
    return splittedLink.join('/');
  }

  String get saveDir {
    final temp = path.split('/')..removeLast();
    return temp.join('/');
  }

  String absolutePath(String appDir) {
    return appDir + path;
  }

  String get fileName {
    return path.split('/').last;
  }

  @override
  List<Object?> get props => [link];
}

class SegmentPlaylistParsedModel {
  SegmentPlaylistParsedModel({required this.segments});

  final Set<HlsSegment> segments;

  factory SegmentPlaylistParsedModel.fromParsedPlaylist(
      HlsPlaylistData playlistData) {
    final segments = <HlsSegment>{};

    for (var item in playlistData.playlistItems) {
      if (item.hlsKey == HlsKeyConstants.extInf) {
        segments.add(HlsSegment(link: item.url!));
      }
    }

    return SegmentPlaylistParsedModel(segments: segments);
  }
}
