import 'dart:io';

import 'package:flutter/widgets.dart';

class ImageFileWidget extends StatelessWidget {
  const ImageFileWidget({super.key, required this.pathFile});
  final String pathFile;

  @override
  Widget build(BuildContext context) {
    final file = File(pathFile);
    if (file.existsSync()) {
      return Image.file(File(pathFile));
    }
    return const SizedBox();
  }
}
