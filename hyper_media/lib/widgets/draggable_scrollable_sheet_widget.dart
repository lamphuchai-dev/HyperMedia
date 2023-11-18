import 'package:flutter/material.dart';
import 'package:hyper_media/app/extensions/index.dart';

class DraggableScrollableSheetWidget extends StatelessWidget {
  const DraggableScrollableSheetWidget(
      {super.key,
      required this.builder,
      this.initialChildSize = 0.5,
      this.minChildSize = 0.25,
      this.maxChildSize = 1,
      this.controller});
  final Widget Function(BuildContext context, ScrollController scrollController)
      builder;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final DraggableScrollableController? controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: ColoredBox(
        color: Colors.transparent,
        child: DraggableScrollableSheet(
          initialChildSize: initialChildSize,
          minChildSize: minChildSize,
          maxChildSize: maxChildSize,
          controller: controller,
          builder: (context, scrollController) {
            return ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: ColoredBox(
                color: context.colorScheme.background,
                child: builder(context, scrollController),
              ),
            );
          },
        ),
      ),
    );
  }
}
