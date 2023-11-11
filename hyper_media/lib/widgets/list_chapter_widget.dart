// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/data/models/models.dart';

import 'animated_fade.dart';

enum UsePage { chapters, readChapter }

class ListChaptersWidget extends StatefulWidget {
  const ListChaptersWidget(
      {super.key,
      required this.chapters,
      required this.onTapChapter,
      this.indexSelect,
      this.padding,
      this.usePage = UsePage.chapters});
  final List<Chapter> chapters;
  final int? indexSelect;
  final ValueChanged<Chapter> onTapChapter;
  final EdgeInsetsGeometry? padding;
  final UsePage usePage;

  @override
  State<ListChaptersWidget> createState() => _ListChaptersWidgetState();
}

class _ListChaptersWidgetState extends State<ListChaptersWidget> {
  late ScrollController _scrollController;

  Timer? _sliderTime;
  final GlobalKey _globalKey = GlobalKey();
  final ValueNotifier<SliderCustom> _valueNotifier =
      ValueNotifier(SliderCustom(offset: 0.0));
  ChildModel? _childModel;
  @override
  void initState() {
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.indexSelect != null) {
        final valueJumTo = widget.indexSelect! * 56.0;
        if (valueJumTo > _scrollController.position.maxScrollExtent) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        } else {
          _scrollController.jumpTo(valueJumTo);
        }
      }
      _calculateChild();
    });

    _scrollController.addListener(() {
      if (_sliderTime != null) {
        _sliderTime?.cancel();
      }
      _sliderTime = Timer(const Duration(seconds: 1), () {
        _valueNotifier.value = _valueNotifier.value.copyWith(show: false);
      });
      if (!_valueNotifier.value.show) {
        _valueNotifier.value = _valueNotifier.value.copyWith(show: true);
      }
      if (_childModel == null) return;
      final value = (_scrollController.position.maxScrollExtent /
          (_childModel!.size.height - 56));
      _childModel = _childModel?.copyWith(value: value);
      _valueNotifier.value = _valueNotifier.value
          .copyWith(offset: _scrollController.offset / value);
    });

    super.initState();
  }

  void _calculateChild() {
    final renderBox =
        _globalKey.currentContext?.findRenderObject() as RenderBox;
    _childModel = ChildModel(
        size: renderBox.size,
        offset: renderBox.localToGlobal(Offset.zero),
        value: _scrollController.position.maxScrollExtent /
            (renderBox.size.height - 56));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    final colorScheme = context.colorScheme;
    return Stack(
      key: _globalKey,
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: switch (widget.usePage) {
              UsePage.chapters => ListView.separated(
                  padding: widget.padding,
                  itemCount: widget.chapters.length,
                  controller: _scrollController,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: colorScheme.surface,
                  ),
                  itemBuilder: (context, index) {
                    final chapter = widget.chapters[index];
                    return ListTile(
                      title: Text(
                        chapter.name,
                        style: textTheme.bodyMedium,
                      ),
                      onTap: () => widget.onTapChapter.call(chapter),
                    );
                  },
                ),
              UsePage.readChapter => ListView.builder(
                  itemCount: widget.chapters.length,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    final chapter = widget.chapters[index];
                    final colorItemSelected = widget.indexSelect == index
                        ? colorScheme.primary
                        : colorScheme.onSurface;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      tileColor: colorScheme.surface,
                      leading: SizedBox(
                        width: 40,
                        child: Icon(
                          Icons.circle,
                          size: 8,
                          color: colorItemSelected,
                        ),
                      ),
                      horizontalTitleGap: 0,
                      title: Text(
                        chapter.name,
                        style: textTheme.bodyMedium
                            ?.copyWith(color: colorItemSelected),
                      ),
                      onTap: () => widget.onTapChapter.call(chapter),
                    );
                  },
                ),
            },
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _valueNotifier,
          builder: (context, value, child) => Positioned(
              right: 0,
              top: value.offset,
              height: 45,
              width: 45,
              child: AnimatedFade(
                status: value.show,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (_childModel == null) return;
                    final dy = details.globalPosition.dy;
                    if (dy <= _childModel!.offset.dy + 45) return;
                    if (dy >
                        _childModel!.offset.dy + _childModel!.size.height) {
                      return;
                    }

                    final jumpToValue =
                        (dy - _childModel!.offset.dy - 45) * _childModel!.value;
                    if (jumpToValue >=
                        _scrollController.position.maxScrollExtent) return;
                    _scrollController.jumpTo(jumpToValue);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(30)),
                    child: const Icon(Icons.unfold_more_double_rounded),
                  ),
                ),
              )),
        )
      ],
    );
  }

  @override
  void didUpdateWidget(covariant ListChaptersWidget oldWidget) {
    if (widget.chapters.length != oldWidget.chapters.length) {
      _calculateChild();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _sliderTime?.cancel();
    super.dispose();
  }
}

class SliderCustom {
  final double offset;
  final bool show;
  SliderCustom({
    required this.offset,
    this.show = false,
  });

  SliderCustom copyWith({
    double? offset,
    bool? show,
  }) {
    return SliderCustom(
      offset: offset ?? this.offset,
      show: show ?? this.show,
    );
  }
}

class ChildModel {
  final Size size;
  final Offset offset;
  final double value;
  ChildModel({required this.size, required this.offset, required this.value});

  @override
  String toString() => 'ChildModel(size: $size, offset: $offset)';

  ChildModel copyWith({
    Size? size,
    Offset? offset,
    double? value,
  }) {
    return ChildModel(
      size: size ?? this.size,
      offset: offset ?? this.offset,
      value: value ?? this.value,
    );
  }
}
