import 'package:flutter/material.dart';

class IconButtonComic extends StatelessWidget {
  const IconButtonComic(
      {Key? key,
      this.colorBackground,
      required this.onTap,
      required this.icon,
      this.size = const Size(30, 30)})
      : super(key: key);
  final Color? colorBackground;
  final VoidCallback onTap;
  final Icon icon;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size.height,
        width: size.width,
        decoration: ShapeDecoration(
            shape: const StadiumBorder(),
            color: colorBackground ?? Colors.black87.withOpacity(0.7)),
        child: icon,
      ),
    );
  }
}
