// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'logger.dart';

abstract class TaskConcurrentRes {}


class ChapterComicEntry {
  final Completer _completer;
  final int index;
  final String url;
  final Map<String, String>? headers;
  final int bookId;
  ChapterComicEntry(
      {required this.url,
      this.headers,
      required this.index,
      required this.bookId})
      : _completer = Completer.sync();

  // @override
  Completer get getCompleter => _completer;

  @override
  String toString() {
    return 'ChapterComicEntry(_completer: $_completer, index: $index, url: $url, headers: $headers)';
  }
}



class Concurrent {
  final requestController = StreamController<ChapterComicEntry>();
  late final StreamSubscription<void> _subscription;

  final Future<TaskConcurrentRes> Function(ChapterComicEntry entry) runTask;


  Concurrent({required this.runTask, int? maxConcurrent}) {
    Stream<void> sendRequest(ChapterComicEntry entry) {
      return runTask
          .call(entry)
          .asStream()
          .doOnError(entry.getCompleter.completeError)
          .doOnData(entry.getCompleter.complete)
          .onErrorResumeNext(const Stream.empty());
    }

    _subscription = requestController.stream
        .flatMap(sendRequest, maxConcurrent: maxConcurrent)
        .listen(null);
  }

  Future add(ChapterComicEntry entry) async {
    requestController.add(entry);
    return entry.getCompleter.future;
  }

  void close() {
    _subscription.cancel().then((_) => requestController.close());
  }
}
