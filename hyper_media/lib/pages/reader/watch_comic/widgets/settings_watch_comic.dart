part of '../view/watch_comic_view.dart';

class SettingsWatchComic extends StatelessWidget {
  const SettingsWatchComic({super.key, required this.watchComicCubit});
  final WatchComicCubit watchComicCubit;

  @override
  Widget build(BuildContext context) {
    return ThemeBuildWidget(
        builder: (context, themeData, textTheme, colorScheme) {
      return BaseBottomSheetUi(
        header: _Header(
          onTapDetail: () {},
          onTapShare: () {
            // CommonUtils.share("");
          },
          onTapMore: () {},
        ),
        child:
            BlocSelector<WatchComicCubit, WatchComicState, WatchComicSettings>(
          bloc: watchComicCubit,
          selector: (state) {
            return state.settings;
          },
          builder: (context, settings) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Gaps.hGap4,
                  _BlockCard(
                    title: "common.background".tr(),
                    child: SizedBox(
                      width: context.width,
                      child: CupertinoSlidingSegmentedControl<WatchBackground>(
                        thumbColor: colorScheme.primary,
                        groupValue: settings.background,
                        children: {
                          WatchBackground.light: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "common.light".tr(),
                              style: textTheme.bodyMedium,
                            ),
                          ),
                          WatchBackground.dark: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "common.dark".tr(),
                              style: textTheme.bodyMedium,
                            ),
                          ),
                        },
                        onValueChanged: (value) {
                          watchComicCubit.onChangeSettings(
                              settings.copyWith(background: value));
                        },
                      ),
                    ),
                  ),
                  Gaps.hGap8,
                  _BlockCard(
                    title: "common.reading_mode".tr(),
                    child: SizedBox(
                      width: context.width,
                      child: CupertinoSlidingSegmentedControl<WatchComicType>(
                        thumbColor: colorScheme.primary,
                        groupValue: settings.watchType,
                        children: {
                          WatchComicType.horizontal: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "common.horizontal".tr(),
                              style: textTheme.bodyMedium,
                            ),
                          ),
                          WatchComicType.vertical: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "common.vertical".tr(),
                              style: textTheme.bodyMedium,
                            ),
                          ),
                          WatchComicType.webtoon: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "webtoon",
                              style: textTheme.bodyMedium,
                            ),
                          )
                        },
                        onValueChanged: (value) {
                          watchComicCubit.onChangeSettings(
                              settings.copyWith(watchType: value));
                        },
                      ),
                    ),
                  ),
                  Gaps.hGap8,
                  _BlockCard(
                    title: "common.screen_orientation".tr(),
                    child: SizedBox(
                      width: context.width,
                      child: CupertinoSlidingSegmentedControl<WatchOrientation>(
                        thumbColor: colorScheme.primary,
                        groupValue: settings.orientation,
                        children: {
                          WatchOrientation.auto: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "common.auto".tr(),
                              style: textTheme.bodyMedium,
                            ),
                          ),
                          WatchOrientation.landscape: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "common.landscape".tr(),
                              style: textTheme.bodyMedium,
                            ),
                          ),
                          WatchOrientation.portrait: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "common.portrait".tr(),
                              style: textTheme.bodyMedium,
                            ),
                          ),
                        },
                        onValueChanged: (value) {
                          watchComicCubit.onChangeSettings(
                              settings.copyWith(orientation: value));
                        },
                      ),
                    ),
                  ),
                  Gaps.hGap8,
                  _BlockCard(
                      child: CustomSwitch(
                    value: settings.onTapControl,
                    label: "common.tap_to_next_chapter".tr(),
                    onChange: (value) {
                      watchComicCubit.onChangeSettings(
                          settings.copyWith(onTapControl: value));
                    },
                  )),
                  Gaps.hGap8,
                  _BlockCard(
                    child: CustomSwitch(
                      value: settings.longPressImage,
                      label: "common.hold_image_to_zoom".tr(),
                      onChange: (value) {
                        watchComicCubit.onChangeSettings(
                            settings.copyWith(longPressImage: value));
                      },
                    ),
                  ),
                  Gaps.hGap16,
                ],
              ),
            );
          },
        ),
      );
    });
  }
}

class _Header extends StatelessWidget {
  const _Header(
      {required this.onTapShare,
      required this.onTapDetail,
      required this.onTapMore});
  final VoidCallback onTapShare;
  final VoidCallback onTapDetail;
  final VoidCallback onTapMore;

  @override
  Widget build(BuildContext context) {
    return ThemeBuildWidget(
      builder: (context, themeData, textTheme, colorScheme) => SizedBox(
        height: 60,
        child: Row(
          children: [
            Gaps.wGap16,
            Expanded(
                child: Text(
              "common.settings".tr(),
              style: textTheme.titleLarge,
            )),
            IconButtonComic(
              size: const Size(35, 35),
              colorBackground: colorScheme.surface,
              icon: const Icon(
                Icons.share_rounded,
                size: 20,
              ),
              onTap: onTapShare,
            ),
            Gaps.wGap8,
            IconButtonComic(
              size: const Size(35, 35),
              colorBackground: colorScheme.surface,
              icon: const Icon(
                Icons.info_outline_rounded,
                size: 20,
              ),
              onTap: onTapDetail,
            ),
            Gaps.wGap8,
            IconButtonComic(
              size: const Size(35, 35),
              colorBackground: colorScheme.surface,
              icon: const Icon(
                Icons.more_vert_rounded,
                size: 20,
              ),
              onTap: onTapMore,
            ),
            Gaps.wGap12,
          ],
        ),
      ),
    );
  }
}

class _BlockCard extends StatelessWidget {
  const _BlockCard({this.title, required this.child});
  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ThemeBuildWidget(
        builder: (context, themeData, textTheme, colorScheme) {
      return Container(
        width: context.width,
        margin:
            const EdgeInsets.symmetric(horizontal: Dimens.horizontalPadding),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(Constants.radius)),
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: textTheme.titleMedium,
              ),
              Gaps.hGap8,
            ],
            child,
          ],
        ),
      );
    });
  }
}

// kiểm đọc
// nền đọc
// chạm qua chương -> kiểm đọc page
// định hướng
// nhấn giữ ảnh

