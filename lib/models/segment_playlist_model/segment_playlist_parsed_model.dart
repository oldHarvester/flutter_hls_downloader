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

class HlsSegmentsPlaylistKey extends Equatable {
  const HlsSegmentsPlaylistKey({
    required this.encKeyUrl,
    required this.salt,
  });

  final String encKeyUrl;
  final String salt;

  String get path {
    final splittedLink = encKeyUrl.split('/')
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
  List<Object?> get props => [encKeyUrl, salt];
}

class SegmentPlaylistParsedModel {
  SegmentPlaylistParsedModel({
    required this.segments,
    required this.playlistData,
    this.playlistKey,
  });

  final Set<HlsSegment> segments;
  final HlsPlaylistData playlistData;
  final HlsSegmentsPlaylistKey? playlistKey;

  factory SegmentPlaylistParsedModel.fromParsedPlaylist(
      HlsPlaylistData playlistData,
      [HlsSegmentsPlaylistKey? playlistKey]) {
    final segments = <HlsSegment>{};

    for (var item in playlistData.playlistItems) {
      if (item.hlsKey == HlsKeyConstants.extInf) {
        segments.add(HlsSegment(link: item.url!));
      }
    }

    return SegmentPlaylistParsedModel(
      segments: segments,
      playlistData: playlistData,
      playlistKey: playlistKey,
    );
  }
}
