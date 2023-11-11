// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/data/models/chapter.dart';
import 'package:hyper_media/pages/reader/cubit/reader_cubit.dart';
import 'package:hyper_media/widgets/widget.dart';

import 'reader_chapter.dart';

class ReaderPageChapter extends StatefulWidget {
  const ReaderPageChapter({
    Key? key,
    required this.index,
  }) : super(key: key);
  final int index;

  @override
  State<ReaderPageChapter> createState() => _ReaderPageChapterState();
}

class _ReaderPageChapterState extends State<ReaderPageChapter> {
  StatusType _status = StatusType.init;
  Chapter? _chapter;
  late ReaderCubit _readerCubit;
  @override
  void initState() {
    _readerCubit = context.read<ReaderCubit>();
    getContentChapter();
    super.initState();
  }

  Future<void> getContentChapter() async {
    try {
      if (mounted) {
        setState(() {
          _status = StatusType.loading;
        });
        _chapter = _readerCubit.getChapterByIndex(widget.index);
        if (_chapter != null) {
          _chapter = await _readerCubit.getContentByChapter(_chapter!);
          setState(() {
            _status = StatusType.loaded;
          });
        } else {
          if (mounted) {
            setState(() {
              _status = StatusType.error;
            });
          }
        }
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _status = StatusType.error;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = context.width;
    return switch (_status) {
      StatusType.loading => const LoadingWidget(),
      StatusType.loaded => SingleChildScrollView(
          // controller: _scrollController,
          // physics: _ReaderCubit.getPhysicsScroll,
          child: Builder(
            builder: (context) {
              if (_chapter!.contentNovel != null) {
                return Text(_chapter!.contentNovel!);
              } else if (_chapter!.contentComic != null) {
                final headers = {"Referer": _chapter!.host};

                return Column(
                    children: _chapter!.contentComic!.map((src) {
                  if (src.startsWith("http")) {
                    return CacheNetWorkImage(
                      src,
                      fit: BoxFit.fitWidth,
                      width: width,
                      headers: headers,
                      placeholder: Container(
                          height: 200,
                          alignment: Alignment.center,
                          child: const SpinKitPulse(
                            color: Colors.grey,
                          )),
                    );
                  } else if (!src.startsWith("http")) {
                    return ImageFileWidget(
                      pathFile: src,
                    );
                  }
                  return const SizedBox();
                }).toList());
              }
              return const Text("data");
            },
          ),
        ),
      _ => const SizedBox()
    };
  }
}
