// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:flutter_hls_parser_test/utils/extensions/list_extension.dart';
import 'package:flutter_hls_parser_test/utils/extensions/string_extension.dart';
import 'package:flutter_hls_parser_test/utils/functions.dart';
import 'package:flutter_hls_parser_test/utils/hls_parser/hls_constants.dart';

class HlsKey extends Equatable {
  const HlsKey({required this.key});
  final String key;

  @override
  String toString() {
    return key;
  }

  @override
  List<Object?> get props => [key];
}

class HlsParamValue extends Equatable {
  const HlsParamValue({required this.value});
  final String value;

  @override
  String toString() {
    return value;
  }

  HlsParamValue copyWith({
    String? value,
  }) {
    return HlsParamValue(
      value: value ?? this.value,
    );
  }

  @override
  List<Object?> get props => [value];
}

class HlsParam extends Equatable {
  const HlsParam({required this.parameter});
  final String parameter;

  @override
  String toString() {
    return parameter;
  }

  HlsParam copyWith({
    String? parameter,
  }) {
    return HlsParam(
      parameter: parameter ?? this.parameter,
    );
  }

  @override
  List<Object?> get props => [parameter];
}

class HlsPlaylistItem {
  const HlsPlaylistItem({
    required this.hlsKey,
    required this.hlsValueParameters,
    this.url,
  });

  final HlsKey hlsKey;
  final Map<HlsParam?, HlsParamValue> hlsValueParameters;
  final String? url;

  @override
  String toString() {
    if (hlsValueParameters.isEmpty) {
      if (url == null) {
        return '$hlsKey';
      } else {
        return '$hlsKey\n$url';
      }
    } else {
      final valuePairs = <String>[];

      for (var entry in hlsValueParameters.entries) {
        final temp = entry.key == null
            ? entry.value.toString()
            : '${entry.key}=${entry.value}';
        valuePairs.add(temp);
      }

      final temp =
          '$hlsKey:${valuePairs.join(', ')}${hlsKey == HlsKeyConstants.extInf ? ',' : ''}';
      if (url == null) {
        return temp;
      } else {
        return '$temp\n$url';
      }
    }
  }
}

class HlsPlaylistData {
  const HlsPlaylistData({
    required this.playlistItems,
  });

  final List<HlsPlaylistItem> playlistItems;

  @override
  String toString() {
    return playlistItems.map((e) => e.toString()).join('\n');
  }
}

class HlsParser {
  const HlsParser({
    required this.playlist,
    required this.playlistUrl,
  });

  // Playlist data that came in response
  final String playlist;
  // URL form where the playlist was requested
  final String playlistUrl;

  HlsPlaylistData get parsedData {
    final playlistLines = playlist.split('\n');
    final playlistItems = <HlsPlaylistItem>[];
    for (var i = 0; i < playlistLines.length; i++) {
      var line = playlistLines[i];

      if (line.endsWith(',')) {
        line = line.substring(0, line.length - 2);
      }

      final valueParameters = <HlsParam?, HlsParamValue>{};
      String key;
      if (line.isEmpty) {
        continue;
      }
      if (line.startsWith("#")) {
        final temp = line.splitWithExclude(pattern: ':', excludePattern: '"');
        key = temp.first;

        if (temp.length > 1) {
          final parametersLine = temp[1];
          final valueParametersStr = parametersLine.splitWithExclude(
              pattern: ',', excludePattern: '"');
          for (var parameter in valueParametersStr) {
            final temp = parameter.split('=');

            if (temp.length == 1) {
              /// ONLY VALUE PARAMETER
              valueParameters[null] = HlsParamValue(value: temp.first);
            } else {
              /// NAMED PARAMETER WITH VALUE
              var key = HlsParam(parameter: temp.first);
              var value = HlsParamValue(value: temp.last);

              if (key == HlsParamConstants.uri) {
                value = value.copyWith(
                  value:
                      '"${checkLinks(temp.last.replaceAll('"', ''), playlistUrl)}"',
                );
              } else if (key == HlsParamConstants.codecs) {
                value = value.copyWith(
                  value: checkLinks(temp.last, playlistUrl),
                );
              }

              valueParameters[key] = value;
            }
          }
        }
        if (playlistLines.hasItem(i + 1) &&
            playlistLines[i + 1].startsWith('#')) {
          /// NO URL FOUND
          playlistItems.add(
            HlsPlaylistItem(
              hlsKey: HlsKey(key: key),
              hlsValueParameters: valueParameters,
              url: null,
            ),
          );
        } else {
          /// URL FOUND
          if (playlistLines[i + 1].isNotEmpty) {
            playlistItems.add(
              HlsPlaylistItem(
                hlsKey: HlsKey(key: key),
                hlsValueParameters: valueParameters,
                url: checkLinks(playlistLines[i + 1], playlistUrl),
              ),
            );
          }
          i += 1;
        }
      }
    }

    return HlsPlaylistData(playlistItems: playlistItems);
  }
}
