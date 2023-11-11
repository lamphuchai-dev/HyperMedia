import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hyper_media/app/constants/index.dart';

class CacheNetWorkImage extends StatelessWidget {
  const CacheNetWorkImage(
    this.url, {
    Key? key,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.fallback,
    this.headers,
    this.placeholder,
  }) : super(key: key);
  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? fallback;
  final Widget? placeholder;
  final Map<String, String>? headers;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      width: width,
      height: height,
      httpHeaders: headers,
      placeholder: (context, url) =>
          placeholder ??
          Image.asset(
            AppAssets.backgroundBook,
            fit: fit,
          ),
      errorWidget: (context, url, error) => Image.asset(
        AppAssets.backgroundBook,
        fit: fit,
      ),
    );
  }
}
