import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hyper_media/pages/reader/cubit/reader_cubit.dart';

class AutoScrollController extends ChangeNotifier {
  ScrollController? _scrollController;

  ControlStatus? _controlStatus;

  double _height = 0;

  ControlStatus get status => _controlStatus!;

  ScrollController? get scrollController => _scrollController;

  Timer? _autoScrollTimer;

  double maxTime = 30.0;
  double minTime = 0.2;

  double _timeAutoScroll = 5;

  ValueNotifier timeAuto = ValueNotifier<double>(5);

  set setScrollController(ScrollController controller) =>
      _scrollController = controller;

  void init(ScrollController scrollController) {
    _scrollController = scrollController;
    _controlStatus = ControlStatus.init;
  }

  set setHeight(double value) => _height = value;

  void onChangeTimerAuto(double value) {
    if (_autoScrollTimer != null) _autoScrollTimer?.cancel();

    timeAuto.value = value;
    _autoScrollTimer = Timer(const Duration(milliseconds: 400), () {
      _timeAutoScroll = timeAuto.value;
      _handlerAutoToScroll();
    });
  }

  void enable() {
    _handlerAutoToScroll();
  }

  Future<void> _handlerAutoToScroll() async {
    if (_scrollController == null) return;
    double maxScrollExtent = _scrollController!.position.maxScrollExtent;
    if (_scrollController!.offset == maxScrollExtent) {
      autoScrollComplete();
      return;
    }
    maxScrollExtent = _scrollController!.position.maxScrollExtent;
    final heightText = maxScrollExtent - _scrollController!.offset;
    double timer = (heightText / _height) * _timeAutoScroll;
    if (timer <= 0) timer = 0.5;
    _scrollController!
        .animateTo(maxScrollExtent,
            duration: Duration(seconds: timer.toInt()), curve: Curves.linear)
        .then((value) {
      autoScrollComplete();
    });
    if (_controlStatus == ControlStatus.start) return;
    _controlStatus = ControlStatus.start;
    notifyListeners();
  }

  void autoScrollComplete() {
    if (_scrollController!.offset ==
        _scrollController!.position.maxScrollExtent) {
      _controlStatus = ControlStatus.complete;
      notifyListeners();
    }
  }

  void pause() {
    _controlStatus = ControlStatus.pause;
    _scrollController?.position.hold(() {});
    notifyListeners();
  }

  void checkAutoNextChapter() {
    Timer(const Duration(milliseconds: 500), () {
      if (_controlStatus == ControlStatus.complete) {
        enable();
      }
    });
  }

  void start() {
    enable();
  }

  void closeAutoScroll() {
    _scrollController?.position.hold(() {});
    _controlStatus = ControlStatus.init;
    notifyListeners();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    timeAuto.dispose();
    super.dispose();
  }
}
