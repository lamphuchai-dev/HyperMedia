import 'package:flutter/material.dart';

class AnimatedFade extends StatefulWidget {
  const AnimatedFade(
      {super.key,
      required this.status,
      this.duration,
      this.curve,
      required this.child});
  final bool status;
  final Duration? duration;
  final Curve? curve;
  final Widget child;

  @override
  State<AnimatedFade> createState() => _AnimatedFadeState();
}

class _AnimatedFadeState extends State<AnimatedFade>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animationFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animationFade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _controller, curve: widget.curve ?? Curves.linear));
    if (widget.status) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _animationFade,
          child: child,
        );
      },
      child: widget.child,
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedFade oldWidget) {
    if (widget.status != oldWidget.status) {
      if (widget.status) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
