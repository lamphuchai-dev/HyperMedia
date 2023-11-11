// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_element
import 'dart:async';

import 'package:dio_client/index.dart';
import 'package:rxdart/rxdart.dart';

class _Entry {
  final String uri;
  final Map<String, dynamic>? queryParameters;
  final Options? options;
  final CancelToken? cancelToken;
  void Function(int, int)? onReceiveProgress;

  final Completer<dynamic> completer;
  _Entry({
    required this.uri,
    this.queryParameters,
    this.options,
    this.cancelToken,
    this.onReceiveProgress,
    required this.completer,
  });
}

class DioClientConcurrent {
  final requestController = StreamController<_Entry>();
  late final StreamSubscription<void> _subscription;
  final DioClient _dioClient;

  DioClientConcurrent({required DioClient dioClient, int? maxConcurrent})
      : _dioClient = dioClient {
    Stream<void> sendRequest(_Entry entry) {
      return _dioClient
          .get(entry.uri,
              queryParameters: entry.queryParameters,
              options: entry.options,
              cancelToken: entry.cancelToken,
              onReceiveProgress: entry.onReceiveProgress)
          .asStream()
          .doOnError(entry.completer.completeError)
          .doOnData(entry.completer.complete)
          .onErrorResumeNext(const Stream.empty());
      // .doOnCancel(() => debugPrint('DioClientConcurrent: <--'));
    }

    _subscription = requestController.stream
        .flatMap(sendRequest, maxConcurrent: maxConcurrent)
        .listen(null);
  }

  Future<dynamic> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    final completer = Completer<dynamic>.sync();
    requestController.add(_Entry(
        uri: uri,
        queryParameters: queryParameters,
        options: options,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
        completer: completer));
    return completer.future;
  }

  void close() {
    _subscription.cancel().then((_) => requestController.close());
  }
}
