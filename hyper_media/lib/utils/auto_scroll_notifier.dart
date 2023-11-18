import 'dart:async';

import 'package:flutter/material.dart';

import '../app/types/app_type.dart';

class AutoScrollNotifier extends ValueNotifier<AutoScrollStatus> {
  AutoScrollNotifier() : super(AutoScrollStatus.noActive);

  double? _height;
  double maxTime = 30.0;
  double minTime = 0.2;

  double _timeAutoScroll = 5;
  ValueNotifier<double> timeAuto = ValueNotifier<double>(5);

  ScrollController? _scrollController;

  Timer? _autoScrollTimer;

  double? _maxScrollExtent;

  VoidCallback? onCompleteCallback;

  void init(
      {required ScrollController scrollController, required double height}) {
    _height = height;
    _scrollController = scrollController;
  }

  void _scrollComplete() {
    if (_scrollController!.offset ==
        _scrollController!.position.maxScrollExtent) {
      value = AutoScrollStatus.complete;
      onCompleteCallback?.call();
    }
  }

  Future<void> _handlerAutoToScroll() async {
    if (_scrollController == null) return;
    assert(_scrollController!.positions.isNotEmpty,
        "ScrollController not attached to any scroll views");

    _maxScrollExtent = _scrollController!.position.maxScrollExtent;
    if (_scrollController!.offset == _maxScrollExtent) {
      _scrollComplete();
      return;
    }
    final heightText = _maxScrollExtent! - _scrollController!.offset;
    double timer = (heightText / _height!) * _timeAutoScroll;
    if (timer <= 0.3) timer = 0.5;
    _scrollController!
        .animateTo(_maxScrollExtent!,
            duration: Duration(milliseconds: (timer * 1000).toInt()),
            curve: Curves.linear)
        .then((value) {
      _scrollComplete();
    });
    if (value == AutoScrollStatus.active) return;
    value = AutoScrollStatus.active;
  }

  void _stop() {
    assert(_scrollController != null, "_scrollController == null");
    _scrollController?.position.hold(() {});
  }

  void start() {
    assert(_scrollController != null || _height != null,
        "_scrollController == null || _heigh == null");
    _handlerAutoToScroll();
  }

  void pause() {
    _stop();
    value = AutoScrollStatus.pause;
  }

  void close() {
    _stop();
    value = AutoScrollStatus.noActive;
  }

  void checkAutoNextChapter() {
    debugPrint("checkAutoNextChapter");
    if (value != AutoScrollStatus.complete) return;
    debugPrint("checkAutoNextChapter");
    Timer(const Duration(seconds: 2), () {
      start();
    });
  }

  void onChangeTimerAuto(double value) {
    if (_autoScrollTimer != null) _autoScrollTimer?.cancel();

    timeAuto.value = value;
    _autoScrollTimer = Timer(const Duration(milliseconds: 400), () {
      _timeAutoScroll = timeAuto.value;
      _handlerAutoToScroll();
    });
  }

  void onAction() {
    if (value == AutoScrollStatus.active) {
      pause();
    } else if (value == AutoScrollStatus.pause) {
      start();
    }
  }

  void update() {
    if (_scrollController == null ||
        _maxScrollExtent == null ||
        value != AutoScrollStatus.active) return;
    if (_maxScrollExtent! != _scrollController!.position.maxScrollExtent) {
      _handlerAutoToScroll();
      debugPrint("update autoScroll");
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    timeAuto.dispose();
    super.dispose();
  }
}
