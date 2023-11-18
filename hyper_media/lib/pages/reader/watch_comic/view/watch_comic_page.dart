import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/app/extensions/context_extension.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/widgets/widget.dart';
import '../cubit/watch_comic_cubit.dart';
import '../widgets/menu_comic_animation.dart';
import '../widgets/widgets.dart';

class WatchComicPage extends StatefulWidget {
  const WatchComicPage({super.key});

  @override
  State<WatchComicPage> createState() => _WatchComicPageState();
}

class _WatchComicPageState extends State<WatchComicPage> {
  late WatchComicCubit _watchComicCubit;
  Map<String, String>? _headers;

  @override
  void initState() {
    _watchComicCubit = context.read<WatchComicCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _watchComicCubit.setup(context.height);
    });
    _headers = {"Referer": _watchComicCubit.state.watchChapter.host};

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
            child: BlocConsumer<WatchComicCubit, WatchComicState>(
          listenWhen: (previous, current) {
            // Kiểm tra điều kiện để tự động chạy autoScroll khi qua chương mới
            // Qua chương đã có nội dung
            if (previous.watchChapter.index != current.watchChapter.index &&
                current.watchStatus == StatusType.loaded) {
              return true;
              // Qua chương chưa có nội dung , loaded xong nội dung
            } else if (previous.watchChapter.index ==
                    current.watchChapter.index &&
                previous.watchStatus != StatusType.loaded &&
                current.watchStatus == StatusType.loaded) {
              return true;
            } else {
              return false;
            }
          },
          listener: (context, state) {
            _watchComicCubit.onCheckAutoScrollNextChapter();
          },
          buildWhen: (previous, current) =>
              previous.watchStatus != current.watchStatus ||
              previous.watchChapter != current.watchChapter,
          builder: (context, state) {
            return switch (state.watchStatus) {
              StatusType.loading => const LoadingWidget(),
              StatusType.loaded => ValueListenableBuilder(
                  valueListenable: _watchComicCubit.autoScrollValue,
                  builder: (context, value, child) {
                    return SingleChildScrollView(
                      physics: value == AutoScrollStatus.active
                          ? const NeverScrollableScrollPhysics()
                          : null,
                      controller: _watchComicCubit.scrollController,
                      child: Column(
                          children: (_watchComicCubit
                                      .state.watchChapter.contentComic ??
                                  [])
                              .map((src) {
                        if (src.startsWith("http")) {
                          return CacheNetWorkImage(
                            src,
                            fit: BoxFit.fitWidth,
                            // width: width,
                            headers: _headers,
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
                      }).toList()),
                    );
                  },
                ),
              _ => const SizedBox()
            };
          },
        )),
        Positioned.fill(
            child: MenuComicAnimation(
          controller: _watchComicCubit.menuWatchController,
          base: BaseMenuComic(
            watchComicCubit: _watchComicCubit,
          ),
          autoScroll: AutoScrollMenu(
            watchComicCubit: _watchComicCubit,
          ),
        )),
        Positioned(
            height: 20,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ValueListenableBuilder(
                valueListenable: _watchComicCubit.progressWatchValue,
                builder: (context, value, child) {
                  // if (value == null) return const SizedBox();
                  return Row(
                    children: [
                      BlocBuilder<WatchComicCubit, WatchComicState>(
                        buildWhen: (previous, current) =>
                            previous.watchChapter != current.watchChapter,
                        builder: (context, state) {
                          return Text(
                            _watchComicCubit.progressReader,
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                      const Expanded(child: SizedBox()),
                      if (value != null)
                        Row(
                          children: [
                            Text(
                              value.getProgressPage,
                              style: const TextStyle(fontSize: 10),
                            ),
                            Gaps.wGap8,
                            Text(
                              value.getPercent,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        )
                    ],
                  );
                },
              ),
            ))
      ],
    ));
  }
}
