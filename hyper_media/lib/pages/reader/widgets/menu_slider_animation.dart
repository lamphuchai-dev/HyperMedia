import 'package:flutter/material.dart';
import 'package:hyper_media/utils/system_utils.dart';

import '../cubit/reader_cubit.dart';


class MenuSliderAnimation extends StatefulWidget {
  const MenuSliderAnimation(
      {super.key,
      required this.menu,
      required this.bottomMenu,
      required this.topMenu,
      required this.autoScrollMenu,
      required this.mediaMenu,
      required this.controller});
  final MenuType menu;
  final Widget bottomMenu;
  final Widget topMenu;
  final Widget autoScrollMenu;
  final Widget mediaMenu;

  final AnimationController controller;

  @override
  State<MenuSliderAnimation> createState() => _MenuSliderAnimationState();
}

class _MenuSliderAnimationState extends State<MenuSliderAnimation> {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = widget.controller;
    _controller.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.forward:
          if (widget.menu == MenuType.audio) {
            SystemUtils.setSystemUIOverlayStyle();
          }
          break;

        case AnimationStatus.dismissed:
          // if (widget.menu == Menu.media) {
          //   print("object");
          //   SystemChromeService.setSystemUIOverlayStyle(
          //     Colors.white,
          //   );
          // }

          break;
        default:
          break;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.menu) {
      MenuType.base => Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) => SlideTransition(
                    position: Tween<Offset>(
                            begin: const Offset(0, -1), end: Offset.zero)
                        .animate(CurvedAnimation(
                            parent: _controller, curve: Curves.easeOutQuad)),
                    child: child,
                  ),
                  child: widget.topMenu,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) => SlideTransition(
                  position:
                      Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                          .animate(CurvedAnimation(
                              parent: _controller, curve: Curves.easeOutQuad)),
                  child: child,
                ),
                child: widget.bottomMenu,
              ),
            )
          ],
        ),
      MenuType.autoScroll => Align(
          alignment: Alignment.centerRight,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: _controller, curve: Curves.easeOutQuad)),
              child: child,
            ),
            child: widget.autoScrollMenu,
          ),
        ),
      MenuType.audio => Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: _controller, curve: Curves.easeOutQuad)),
              child: child,
            ),
            child: widget.mediaMenu,
          ),
        ),
    };
  }
}
