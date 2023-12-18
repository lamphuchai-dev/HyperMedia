part of '../view/watch_novel_view.dart';

class SettingsWatchNovel extends StatelessWidget {
  const SettingsWatchNovel({super.key, required this.watchNovelCubit});
  final WatchNovelCubit watchNovelCubit;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WatchNovelCubit, WatchNovelState, WatchNovelSetting>(
      selector: (state) => state.settings,
      bloc: watchNovelCubit,
      builder: (context, settings) {
        return Theme(
          data: watchNovelCubit.themeData(context.appTheme),
          child: ThemeBuildWidget(
            builder: (context, themeData, textTheme, colorScheme) =>
                BaseBottomSheetUi(
              backgroundColor: colorScheme.background,
              child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        _ListThemeWatchNovel(
                          current: settings.themeWatchNovel,
                          themes: WatchNovelSetting.listMap(),
                          onChange: (theme) {
                            watchNovelCubit.onChangeSetting(
                                settings.copyWith(themeWatchNovel: theme));
                          },
                        ),
                        Row(
                          children: [
                            Text(
                              "Font size",
                              style: textTheme.labelMedium,
                            ),
                            Gaps.wGap16,
                            Gaps.wGap16,
                            Expanded(
                                child: Row(
                              children: [
                                IconButtonComic(
                                    onTap: () {
                                      final fontSize = settings.fontSize - 1;
                                      watchNovelCubit.onChangeSetting(
                                          settings.copyWith(
                                              fontSize: fontSize <= 0
                                                  ? 1
                                                  : fontSize));
                                    },
                                    icon: const Icon(Icons.remove_rounded)),
                                Expanded(
                                    child: Text(
                                  settings.fontSize.toString(),
                                  textAlign: TextAlign.center,
                                  style: textTheme.labelMedium,
                                )),
                                IconButtonComic(
                                    onTap: () {
                                      final fontSize = settings.fontSize + 1;
                                      watchNovelCubit.onChangeSetting(settings
                                          .copyWith(fontSize: fontSize));
                                    },
                                    icon: const Icon(Icons.add_rounded))
                              ],
                            ))
                          ],
                        ),
                        Gaps.hGap16,
                        Row(
                          children: [
                            Text(
                              "Dãn dòng",
                              style: textTheme.labelMedium,
                            ),
                            Gaps.wGap16,
                            Gaps.wGap16,
                            Expanded(
                                child: Row(
                              children: [
                                IconButtonComic(
                                    onTap: () {
                                      final textScaleFactor =
                                          settings.textScaleFactor - 1;
                                      watchNovelCubit.onChangeSetting(
                                          settings.copyWith(
                                              textScaleFactor:
                                                  textScaleFactor <= 0
                                                      ? 1
                                                      : textScaleFactor));
                                    },
                                    icon: const Icon(Icons.remove_rounded)),
                                Expanded(
                                    child: Text(
                                  settings.textScaleFactor.toString(),
                                  textAlign: TextAlign.center,
                                  style: textTheme.labelMedium,
                                )),
                                IconButtonComic(
                                    onTap: () {
                                      final textScaleFactor =
                                          settings.textScaleFactor + 1;
                                      watchNovelCubit.onChangeSetting(
                                          settings.copyWith(
                                              textScaleFactor:
                                                  textScaleFactor));
                                    },
                                    icon: const Icon(Icons.add_rounded))
                              ],
                            ))
                          ],
                        ),
                      ],
                    ),
                  ),
                  Gaps.hGap8,
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: WatchNovelType.values
                          .map((type) => Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    watchNovelCubit.onChangeSetting(
                                        settings.copyWith(watchType: type));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: settings.watchType == type
                                            ? colorScheme.primary
                                            : null,
                                        borderRadius: BorderRadius.circular(8),
                                        border: settings.watchType == type
                                            ? null
                                            : Border.all(
                                                width: 0.8,
                                                color: textTheme
                                                    .labelMedium!.color!)),
                                    child: Text(
                                      type.name,
                                      style: textTheme.labelMedium,
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  Gaps.hGap24
                ]),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ListThemeWatchNovel extends StatelessWidget {
  const _ListThemeWatchNovel(
      {required this.themes, required this.onChange, required this.current});

  final List<ThemeWatchNovel> themes;
  final ValueChanged<ThemeWatchNovel> onChange;
  final ThemeWatchNovel current;

  @override
  Widget build(BuildContext context) {
    return ThemeBuildWidget(
      builder: (context, themeData, textTheme, colorScheme) => SizedBox(
        height: 80,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: themes
                .map((e) => GestureDetector(
                      onTap: () {
                        onChange(e);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 2,
                                color: e == current
                                    ? colorScheme.primary
                                    : Colors.transparent),
                            shape: BoxShape.circle,
                            color: e.background),
                        child: Text(
                          "Aa",
                          style: TextStyle(fontSize: 18, color: e.text),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
