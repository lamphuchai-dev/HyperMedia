import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/widgets/widget.dart';
import '../cubit/watch_novel_cubit.dart';
import '../widgets/widgets.dart';

class WatchNovelPage extends StatefulWidget {
  const WatchNovelPage({super.key});

  @override
  State<WatchNovelPage> createState() => _WatchNovelPageState();
}

class _WatchNovelPageState extends State<WatchNovelPage> {
  late WatchNovelCubit _watchNovelCubit;

  @override
  void initState() {
    _watchNovelCubit = context.read<WatchNovelCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _watchNovelCubit.setup(context.height);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const ChaptersDrawer(),
      body: Stack(
        children: [
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocSelector<WatchNovelCubit, WatchNovelState, Chapter>(
                      selector: (state) => state.watchChapter,
                      builder: (context, chapter) {
                        return Text(
                          chapter.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        );
                      },
                    ),
                    Expanded(
                      child: BlocConsumer<WatchNovelCubit, WatchNovelState>(
                        listenWhen: (previous, current) {
                          // Kiểm tra điều kiện để tự động chạy autoScroll khi qua chương mới
                          // Qua chương đã có nội dung
                          if (previous.watchChapter.index !=
                                  current.watchChapter.index &&
                              current.status == StatusType.loaded) {
                            return true;
                            // Qua chương chưa có nội dung , loaded xong nội dung
                          } else if (previous.watchChapter.index ==
                                  current.watchChapter.index &&
                              previous.status != StatusType.loaded &&
                              current.status == StatusType.loaded) {
                            return true;
                          } else {
                            return false;
                          }
                        },
                        listener: (context, state) {
                          _watchNovelCubit.onCheckAutoScrollNextChapter();
                        },
                        buildWhen: (previous, current) =>
                            previous.status != current.status ||
                            previous.watchChapter != current.watchChapter,
                        builder: (context, state) {
                          return switch (state.status) {
                            StatusType.loading => const LoadingWidget(),
                            StatusType.loaded => ValueListenableBuilder(
                                valueListenable:
                                    _watchNovelCubit.autoScrollValue,
                                builder: (context, value, child) {
                                  return SingleChildScrollView(
                                    physics: value == AutoScrollStatus.active
                                        ? const NeverScrollableScrollPhysics()
                                        : null,
                                    controller:
                                        _watchNovelCubit.scrollController,
                                    child:
                                        Text(state.watchChapter.contentNovel!),
                                  );
                                },
                              ),
                            StatusType.error => Center(
                                child: Text(
                                    _watchNovelCubit.getMessage ?? "Error"),
                              ),
                            _ => const SizedBox()
                          };
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      child: ValueListenableBuilder(
                        valueListenable: _watchNovelCubit.progressWatchValue,
                        builder: (context, value, child) {
                          return Row(
                            children: [
                              BlocBuilder<WatchNovelCubit, WatchNovelState>(
                                buildWhen: (previous, current) =>
                                    previous.watchChapter !=
                                    current.watchChapter,
                                builder: (context, state) {
                                  return Text(
                                    _watchNovelCubit.progressReader,
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
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
              child: MenuNovelAnimation(
                  top: TopBaseMenu(watchNovelCubit: _watchNovelCubit),
                  bottom: BottomBaseMenu(watchNovelCubit: _watchNovelCubit),
                  audio: const SizedBox(),
                  autoScroll: AutoScrollMenu(watchNovelCubit: _watchNovelCubit),
                  controller: _watchNovelCubit.menuController))
        ],
      ),
    );
  }
}
