import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hyper_media/app/types/app_type.dart';

import 'watch_comic_view.dart';

enum ScrollType { list, page }

class AutoScrollController {
  AutoScrollController({required this.scrollType});
  ScrollType scrollType;
  _AutoScrollWidgetState? _state;

  AutoScrollStatus autoScrollStatus = AutoScrollStatus.noActive;

  ScrollController? _scrollController;
  PageController? _pageController;

  double _timeAutoScroll = 5;

  double get timeAutoScroll => _timeAutoScroll;

  double? _height;

  final Map<int, ImageComic> _mapImage = {};

  double? _maxScrollExtent;

  VoidCallback? onCompleteCallback;

  Timer? _autoScrollPageTimer;

  void _bind(_AutoScrollWidgetState state) {
    _state = state;
  }

  void setHeight(double height) {
    _height = height;
  }

  Function(
    double maxScrollExtent,
    double offset,
    double height,
  )? onScrollLister;

  void changeTimeAutoScroll(double value) {
    if (value == 0) value = 0.1;
    _timeAutoScroll = value;
    _handlerAutoToScroll();
  }

  int getInitialPageImage() {
    if (_scrollController == null) return 0;
    final listImageModel = _mapImage.values.toList();
    if (listImageModel.isEmpty) return 0;
    if (!_scrollController!.hasClients) return 0;
    final offsetScroll = _scrollController!.offset;
    double heightList = 0.0;
    listImageModel.sort((a, b) => a.index.compareTo(b.index));
    for (var item in listImageModel) {
      if (offsetScroll <= heightList) return item.index;
      heightList = heightList + item.height;
    }
    return 0;
  }

  void onChangeScrollType(ScrollType type) {
    scrollType = type;
    _state?._load();
  }

  void initScrollController() {
    double initialScrollOffset = 0.0;
    if (_pageController != null) {
      final imageComic = _mapImage[_pageController?.page?.toInt() ?? 0];
      if (imageComic != null) {
        initialScrollOffset = imageComic.index * imageComic.height;
        if (imageComic.index + 1 == _mapImage.length) {
          initialScrollOffset = initialScrollOffset - imageComic.height;
        }
      }
    }
    _scrollController =
        ScrollController(initialScrollOffset: initialScrollOffset);
    _scrollController?.addListener(() {
      if (_maxScrollExtent != _scrollController!.position.maxScrollExtent) {
        _maxScrollExtent = _scrollController!.position.maxScrollExtent;
      }
      onScrollLister?.call(
          _maxScrollExtent!, _scrollController!.offset, _height!);
      update();
    });
    scrollType = ScrollType.list;
    _maxScrollExtent = null;
    _pageController?.dispose();
    _pageController = null;
  }

  void initPageScroll() {
    _pageController = PageController(initialPage: getInitialPageImage());
    _pageController?.addListener(() {
      if (_maxScrollExtent != _pageController!.position.maxScrollExtent) {
        _maxScrollExtent = _pageController!.position.maxScrollExtent;
      }
      onScrollLister?.call(
          _maxScrollExtent!, _pageController!.offset, _height!);
      update();
    });
    scrollType = ScrollType.page;
    _maxScrollExtent = null;
    _scrollController?.dispose();
    _scrollController = null;
  }

  void onChangeMapImage(ImageComic value) {
    if (_mapImage.containsKey(value.index)) return;
    _mapImage[value.index] = value;
  }

  void clean() {
    _mapImage.clear();
  }

  void _scrollComplete() {
    autoScrollStatus = AutoScrollStatus.complete;
    _state?._changeStatus(autoScrollStatus);
    onCompleteCallback?.call();
  }

  Future<void> _handlerAutoToScroll() async {
    if (scrollType == ScrollType.list) {
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
      if (timer <= 0.1) timer = 0.2;
      _scrollController!
          .animateTo(_maxScrollExtent!,
              duration: Duration(milliseconds: (timer * 1000).toInt()),
              curve: Curves.linear)
          .then((value) {
        if (_scrollController!.offset == _maxScrollExtent) {
          _scrollComplete();
        }
      });
    } else {
      _maxScrollExtent = _pageController!.position.maxScrollExtent;
      if (_pageController!.offset == _maxScrollExtent) {
        _scrollComplete();
        return;
      }
      if (_autoScrollPageTimer != null) _autoScrollPageTimer!.cancel();
      _autoScrollPageTimer = Timer.periodic(
          Duration(seconds: _timeAutoScroll.clamp(1, 40).toInt()), (timer) {
        _maxScrollExtent = _pageController!.position.maxScrollExtent;
        if (_pageController!.offset == _maxScrollExtent) {
          _scrollComplete();
          return;
        }
        _pageController?.nextPage(
            duration: const Duration(milliseconds: 50), curve: Curves.linear);
      });
    }

    if (autoScrollStatus == AutoScrollStatus.active) return;
    autoScrollStatus = AutoScrollStatus.active;
    _state?._changeStatus(autoScrollStatus);
  }

  void enableAutoScroll() {
    _handlerAutoToScroll();
  }

  void update() {
    switch (scrollType) {
      case ScrollType.list:
        if (_scrollController == null ||
            _maxScrollExtent == null ||
            autoScrollStatus != AutoScrollStatus.active) return;
        if (_maxScrollExtent! != _scrollController!.position.maxScrollExtent) {
          _handlerAutoToScroll();
          debugPrint("update autoScroll");
        }
        break;
      case ScrollType.page:
        if (_pageController == null ||
            _maxScrollExtent == null ||
            autoScrollStatus != AutoScrollStatus.active) return;
        if (_maxScrollExtent! != _pageController!.position.maxScrollExtent) {
          _handlerAutoToScroll();
          debugPrint("update autoScroll");
        }
        break;
      default:
        break;
    }
  }

  void closeAutoScroll() {
    switch (scrollType) {
      case ScrollType.list:
        _scrollController?.position.hold(() {});
        break;
      case ScrollType.page:
        _autoScrollPageTimer?.cancel();
        break;
      default:
        break;
    }
    autoScrollStatus = AutoScrollStatus.noActive;
    _state?._changeStatus(AutoScrollStatus.noActive);
  }

  void jumpTo(double value) {
    switch (scrollType) {
      case ScrollType.list:
        _maxScrollExtent ??= _scrollController!.position.maxScrollExtent;
        _scrollController?.jumpTo((value / 100) * _maxScrollExtent!);
        break;
      case ScrollType.page:
        _maxScrollExtent ??= _pageController!.position.maxScrollExtent;
        _pageController?.jumpTo((value / 100) * _maxScrollExtent!);
        break;
      default:
        break;
    }
  }

  void dispose() {
    _autoScrollPageTimer?.cancel();
    _pageController?.dispose();
    _scrollController?.dispose();
  }
}

class AutoScrollWidget extends StatefulWidget {
  const AutoScrollWidget(
      {super.key,
      required this.controller,
      required this.builderList,
      required this.builderPage,
      required this.onChangeStatus});
  final AutoScrollController controller;
  final Widget Function(
      ScrollController? scrollController, ScrollPhysics? physics) builderList;
  final Widget Function(PageController? pageController, ScrollPhysics? physics)
      builderPage;
  final ValueChanged<AutoScrollStatus> onChangeStatus;

  @override
  State<AutoScrollWidget> createState() => _AutoScrollWidgetState();
}

class _AutoScrollWidgetState extends State<AutoScrollWidget> {
  late AutoScrollController _controller;

  AutoScrollStatus _autoScrollStatus = AutoScrollStatus.noActive;

  @override
  void initState() {
    _controller = widget.controller;
    _controller._bind(this);
    super.initState();
  }

  void _load() {
    setState(() {});
  }

  void _changeStatus(AutoScrollStatus status) {
    if (_autoScrollStatus == status) return;
    setState(() {
      _autoScrollStatus = status;
      widget.onChangeStatus(status);
    });
  }

  @override
  Widget build(BuildContext context) {
    return switch (_controller.scrollType) {
      ScrollType.list =>
        widget.builderList(_controller._scrollController, getScrollPhysics()),
      ScrollType.page =>
        widget.builderPage(_controller._pageController, getScrollPhysics()),
    };
  }

  ScrollPhysics? getScrollPhysics() {
    if (_autoScrollStatus == AutoScrollStatus.active) {
      return const NeverScrollableScrollPhysics();
    }
    return null;
  }
}
