import 'package:equatable/equatable.dart';
import 'package:flutter_hls_parser_test/utils/functions.dart';

enum ResolutionType {
  v144p("144p"),
  v240p("240p"),
  v360p("360p"),
  v480p("480p"),
  v720p("720p"),
  v1080p("1080p");

  const ResolutionType(this.title);
  final String title;
}

class HlsResolution extends Equatable {
  const HlsResolution({required this.resolution, required this.playlistUrl});

  final ResolutionType resolution;
  final String playlistUrl;

  @override
  List<Object?> get props => [resolution, playlistUrl];
}

class MasterPlaylistParsedModel extends Equatable {
  const MasterPlaylistParsedModel({required this.resolutions});
  final Set<HlsResolution> resolutions;

  factory MasterPlaylistParsedModel.parseFromPlaylist(
      String masterPlaylistData, String masterPlaylistUrl) {
    final playlist = masterPlaylistData.split('\n');
    final tempResolutions = <HlsResolution>{};

    for (var line in playlist) {
      if (line.contains("144p")) {
        tempResolutions.add(
          HlsResolution(
            resolution: ResolutionType.v144p,
            playlistUrl: checkLinks(line, masterPlaylistUrl),
          ),
        );
      } else if (line.contains("240p")) {
        tempResolutions.add(
          HlsResolution(
            resolution: ResolutionType.v240p,
            playlistUrl: checkLinks(line, masterPlaylistUrl),
          ),
        );
      } else if (line.contains("360p")) {
        tempResolutions.add(
          HlsResolution(
            resolution: ResolutionType.v360p,
            playlistUrl: checkLinks(line, masterPlaylistUrl),
          ),
        );
      } else if (line.contains("480p")) {
        tempResolutions.add(
          HlsResolution(
            resolution: ResolutionType.v480p,
            playlistUrl: checkLinks(line, masterPlaylistUrl),
          ),
        );
      } else if (line.contains("720p")) {
        tempResolutions.add(
          HlsResolution(
            resolution: ResolutionType.v720p,
            playlistUrl: checkLinks(line, masterPlaylistUrl),
          ),
        );
      } else if (line.contains("1080p")) {
        tempResolutions.add(
          HlsResolution(
            resolution: ResolutionType.v1080p,
            playlistUrl: checkLinks(line, masterPlaylistUrl),
          ),
        );
      }
    }

    return MasterPlaylistParsedModel(resolutions: tempResolutions);
  }

  @override
  List<Object?> get props => [resolutions];
}
