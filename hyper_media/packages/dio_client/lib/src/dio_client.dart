import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';

import 'dio_client_exception.dart';
import 'dio_concurrent.dart';

class DioClient {
  final Dio _dio;

  Dio get dio => _dio;

  late PersistCookieJar _cookieJar;
  DioClient({Dio? dio}) : _dio = dio ?? Dio();

  DioClient.options({required BaseOptions options}) : _dio = Dio(options);

  bool _enableCookie = false;

  DioClientConcurrent? _dioClientConcurrent;

  void addLogInterceptor() {
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
          responseBody: true,
          error: true,
          requestHeader: false,
          responseHeader: false,
          request: false,
          requestBody: false
          // request: true,
          // requestHeader: true,
          // requestBody: true,
          // responseHeader: true,
          // responseBody: true,
          ));
    }
  }

  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  void clearInterceptors() {
    _dio.interceptors.clear();
  }

  Future<bool> enableCookie({required String dir}) async {
    try {
      if (_enableCookie) return true;
      _cookieJar = PersistCookieJar(
        ignoreExpires: true,
        storage: FileStorage("$dir/.cookies/"),
      );
      final cookieManager = CookieManager(_cookieJar);
      _dio.interceptors.add(cookieManager);
      _enableCookie = true;
      return true;
    } catch (error) {
      debugPrint(error.toString());
      return false;
    }
  }

  Future<void> cleanCookie(String uri) async {
    if (!_enableCookie) return;
    await _cookieJar.delete(Uri.parse(uri));
  }

  Future<void> setCookie(String uri, String cookies) async {
    if (!_enableCookie) return;
    final cookieList = cookies.split(';');
    for (final cookie in cookieList) {
      await _cookieJar.saveFromResponse(
        Uri.parse(uri),
        [Cookie.fromSetCookieValue(cookie)],
      );
    }
  }

  Future<dynamic> request<T>(
    String uri, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await _dio.request<T>(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on DioException catch (dioErr) {
      throw DioClientException.fromDioError(dioErr);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on DioException catch (dioErr) {
      throw DioClientException.fromDioError(dioErr);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> post(
    String uri, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      var response = await _dio.post(uri,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress);
      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on DioException catch (dioErr) {
      throw DioClientException.fromDioError(dioErr);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> put(
    String uri, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      var response = await _dio.put(uri,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress);
      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on DioException catch (dioErr) {
      throw DioClientException.fromDioError(dioErr);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> patch(
    String uri, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      var response = await _dio.patch(uri,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress);
      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on DioException catch (dioErr) {
      throw DioClientException.fromDioError(dioErr);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> delete(
    String uri, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      var response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on DioException catch (dioErr) {
      throw DioClientException.fromDioError(dioErr);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> download(
    String urlPath,
    dynamic savePath, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    ProgressCallback? onReceiveProgress,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      var response = await _dio.download(urlPath, savePath,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
          deleteOnError: deleteOnError);
      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on DioException catch (dioErr) {
      throw DioClientException.fromDioError(dioErr);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getWithConcurrent(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    _dioClientConcurrent ??=
        DioClientConcurrent(dioClient: this, maxConcurrent: 5);
    return _dioClientConcurrent!.get(uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress);
  }
}
