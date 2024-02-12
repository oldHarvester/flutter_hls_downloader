import 'package:flutter_hls_parser_test/utils/hls_parser/hls_parser.dart';

class HlsParamConstants {
  static const resolution = HlsParam(parameter: "RESOLUTION");
  static const bandwidth = HlsParam(parameter: "BANDWIDTH");
  static const audio = HlsParam(parameter: "AUDIO");
  static const type = HlsParam(parameter: "TYPE");
  static const groupId = HlsParam(parameter: "GROUP-ID");
  static const uri = HlsParam(parameter: "URI");
  static const codecs = HlsParam(parameter: "CODECS");
  static const language = HlsParam(parameter: "LANGUAGE");
}

class HlsParamValueConstants {
  static const yes = HlsParamValue(value: "YES");
  static const audio = HlsParamValue(value: "AUDIO");
}

class HlsKeyConstants {
  static const extInf = HlsKey(key: "#EXTINF");
}
