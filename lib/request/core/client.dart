// Package imports:
import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';

/// 获取 Interceptor
LogInterceptor getInterceptor() {
  return LogInterceptor(
    request: false,
    requestBody: true,
    requestHeader: true,
    responseBody: true,
    responseHeader: false,
    error: true,
    logPrint: (object) {
      if (object is String) {
        debugPrint(object);
      } else {
        debugPrint(object.toString());
      }
    },
  );
}

/// 请求客户端
class SprClient {
  late Dio _dio;

  /// 构造函数
  SprClient() {
    _dio = Dio(BaseOptions());
    var interceptor = getInterceptor();
    _dio.interceptors.add(interceptor);
  }

  /// 获取 Dio 实例
  Dio get dio => _dio;
}
