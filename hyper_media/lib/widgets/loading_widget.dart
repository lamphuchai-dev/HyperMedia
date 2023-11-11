import 'package:flutter/material.dart';
import 'package:hyper_media/app/extensions/index.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({
    Key? key,
    this.color,
    this.radius = 20,
    this.child,
    this.duration = const Duration(milliseconds: 800),
  }) : super(key: key);

  final Color? color;
  final double radius;
  final Duration duration;
  final Widget? child;
  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationAnimationController;

  @override
  void initState() {
    super.initState();

    _rotationAnimationController =
        AnimationController(vsync: this, duration: widget.duration)..repeat();
  }

  @override
  void dispose() {
    _rotationAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Center(
        child: SizedBox(
      height: widget.radius * 2 + 15,
      width: widget.radius * 2 + 15,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(padding: const EdgeInsets.all(5), child: widget.child
                //  ?? Image.asset("./assets/icons/smart-home.png"),
                ),
          ),
          Positioned.fill(
              child: RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0)
                .animate(_rotationAnimationController),
            child: CustomPaint(
              size: Size(widget.radius * 2, widget.radius * 2),
              painter: _SpinningLinesPainter(
                color: widget.color ?? colorScheme.primary,
              ),
            ),
          ))
        ],
      ),
    ));
  }
}

class _SpinningLinesPainter extends CustomPainter {
  _SpinningLinesPainter({
    required Color color,
  }) : _linePaint = Paint()
          ..color = color
          ..strokeWidth = 1
          ..style = PaintingStyle.fill;

  final Paint _linePaint;

  @override
  void paint(Canvas canvas, Size size) {
    _drawSpin(canvas, size, _linePaint);
  }

  void _drawSpin(Canvas canvas, Size size, Paint paint) {
    final scaledSize = size;
    final spinnerSize = Size.square(scaledSize.longestSide);

    final startX = spinnerSize.width / 2;
    final startY = spinnerSize.topCenter(Offset.zero).dy;

    final radius = spinnerSize.width / 4;

    final endX = startX;
    final endY = spinnerSize.bottomCenter(Offset.zero).dy;

    int borderWith = 2;

    final path = Path();
    path.moveTo(startX, startY);
    path.arcToPoint(
      Offset(endX, endY),
      radius: Radius.circular(radius),
      clockwise: false,
    );
    path.arcToPoint(
      Offset(startX, startY + borderWith),
      radius: Radius.circular(radius),
    );
    path.lineTo(startX, startY);

    canvas.save();
    _translateCanvas(canvas, size, spinnerSize);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  void _translateCanvas(Canvas canvas, Size size, Size spinnerSize) {
    final offset = (size - spinnerSize as Offset) / 2;
    canvas.translate(offset.dx, offset.dy);
  }

  @override
  bool shouldRepaint(_SpinningLinesPainter oldDelegate) =>
      oldDelegate._linePaint != _linePaint;
}

// class LoadingWidget extends StatelessWidget {
//   const LoadingWidget({super.key, this.loading = true});

//   final bool loading;

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = context.colorScheme;
//     return Center(
//         child: loading
//             ? SpinKitFadingCube(
//                 color: colorScheme.primary,
//                 size: 50.0,
//               )
//             : Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 child: SpinKitThreeBounce(
//                   color: colorScheme.primary,
//                   size: 25.0,
//                 ),
//               ));
//   }
// }
