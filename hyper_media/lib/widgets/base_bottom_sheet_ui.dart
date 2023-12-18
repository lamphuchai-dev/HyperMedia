import 'package:flutter/material.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/widgets/widget.dart';

class BaseBottomSheetUi extends StatelessWidget {
  const BaseBottomSheetUi(
      {super.key, this.header, required this.child, this.backgroundColor});
  final Widget? header;
  final Widget child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ThemeBuildWidget(
      builder: (context, themeData, textTheme, colorScheme) => ColoredBox(
        color: colorScheme.background,
        child: OrientationBuilder(
          builder: (context, orientation) {
            double maxHeight = context.height * 0.7;
            Widget childItem = child;
            if (orientation != Orientation.portrait) {
              maxHeight =
                  header != null ? context.height * 0.6 : context.height * 0.8;
              childItem = SizedBox(
                height: maxHeight,
                child: SingleChildScrollView(
                  child: childItem,
                ),
              );
            }
            return SafeArea(
              child: LimitedBox(
                maxHeight: maxHeight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 45,
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(8)),
                            height: 6,
                          ),
                        ),
                      ),
                    ),
                    if (header != null) header!,
                    childItem
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class BaseBottomSheetHeightUi extends StatelessWidget {
  const BaseBottomSheetHeightUi({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LimitedBox(
        maxHeight: context.height * 0.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 45,
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  decoration: const ShapeDecoration(
                      shape: StadiumBorder(), color: Colors.grey),
                  height: 6,
                ),
              ),
            ),
            Expanded(child: child)
          ],
        ),
      ),
    );
  }
}
