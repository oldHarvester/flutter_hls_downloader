import 'package:dio/dio.dart';
import 'package:flutter_hls_parser_test/config/endpoints.dart';
import 'package:riverpod/riverpod.dart';

final clientProvider = Provider(
  (ref) => Dio(
    BaseOptions(
      baseUrl: EndPoints.baseUrl,
    ),
  )..interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) {
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
      ),
    ),
);
