import 'package:flutter/material.dart';
import 'package:hyper_media/app/extensions/index.dart';

class TagExtension extends StatelessWidget {
  const TagExtension({super.key, required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: color,
          )),
      child: Text(
        text,
        style: textTheme.labelSmall?.copyWith(fontSize: 8),
      ),
    );
  }
}
