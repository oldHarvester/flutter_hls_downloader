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
  static const method = HlsParam(parameter: "METHOD");
  static const iv = HlsParam(parameter: "IV");
}

class HlsParamValueConstants {
  static const yes = HlsParamValue(value: "YES");
  static const audio = HlsParamValue(value: "AUDIO");
  static const aes128 = HlsParamValue(value: "AES-128");
}

class HlsKeyConstants {
  static const extInf = HlsKey(key: "#EXTINF");
  static const extXKey = HlsKey(key: "#EXT-X-KEY");
}
