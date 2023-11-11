import 'dart:ui';

import 'package:flutter/material.dart';

import 'cache_network_image.dart';

class BlurredBackdropImage extends StatelessWidget {
  const BlurredBackdropImage({super.key, required this.url, this.filter});
  final String url;
  final ImageFilter? filter;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          bottom: 1,
          right: 1,
          left: 1,
          child: CacheNetWorkImage(
            url,
          ),
        ),
        Positioned.fill(
          child: ClipRect(
            child: BackdropFilter(
              filter: filter ?? ImageFilter.blur(sigmaX: 9, sigmaY: 9.0),
              child: const SizedBox(),
            ),
          ),
        ),
      ],
    );
  }
}
