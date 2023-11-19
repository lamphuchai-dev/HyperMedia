import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/widgets/widget.dart';

class IconExtension extends StatelessWidget {
  const IconExtension({super.key, this.icon});
  final String? icon;

  @override
  Widget build(BuildContext context) {
    if (icon == null || icon == "") return const Icon(Icons.extension);
    try {
      if (icon!.startsWith("http")) {
        return CacheNetWorkImage(icon!,
            placeholder: Center(
              child: SpinKitCircle(
                size: 25,
                color: context.colorScheme.primary,
              ),
            ));
      }
      final bytes = base64Decode(icon!);
      return Image.memory(bytes);
    } catch (error) {
      return const Icon(Icons.extension);
    }
  }
}
