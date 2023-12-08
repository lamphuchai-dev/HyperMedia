import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/widgets/widget.dart';

class BookCoverImage extends StatefulWidget {
  const BookCoverImage({super.key, required this.cover, this.borderRadius});
  final String cover;
  final BorderRadiusGeometry? borderRadius;

  @override
  State<BookCoverImage> createState() => _BookCoverImageState();
}

class _BookCoverImageState extends State<BookCoverImage> {
  Uint8List? _bytes;

  @override
  void initState() {
    if (widget.cover != "" && !widget.cover.startsWith("http")) {
      _decodeCover();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    if (widget.cover.startsWith("http")) {
      return CacheNetWorkImage(
        widget.cover,
        fit: BoxFit.cover,
      );
    } else if (widget.cover != "") {
      return _byteLoading();
    }
    return Image.asset(
      AppAssets.backgroundBook,
      fit: BoxFit.cover,
    );
  }

  Widget _byteLoading() {
    if (_bytes == null) {
      return Image.asset(
        AppAssets.backgroundBook,
        fit: BoxFit.cover,
      );
    } else {
      return Image.memory(
        _bytes!,
        fit: BoxFit.cover,
      );
    }
  }

  void _decodeCover() {
    setState(() {
      _bytes = null;
    });
    _bytes = base64Decode(widget.cover);
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant BookCoverImage oldWidget) {
    if (oldWidget.cover != widget.cover &&
        widget.cover != "" &&
        !widget.cover.startsWith("http")) {
      _decodeCover();
    }
    super.didUpdateWidget(oldWidget);
  }
}
