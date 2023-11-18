import 'package:flutter/material.dart';

class MenuNovelAnimationController {
  _MenuNovelAnimationState? _state;

  void _bind(_MenuNovelAnimationState state) {
    _state = state;
  }

  void showBaseMenu() {
    _state?._showBaseMenu();
  }

  void showAutoScrollMenu() {
    _state?._showAutoScrollMenu();
  }

  void changeMenu(MenuNovelType menu) {
    _state?._changeMenu(menu);
  }

  Future<void> hide() async {
    await _state?._hideMenu();
  }
}

enum MenuNovelType { base, autoScroll, audio }

class MenuNovelAnimation extends StatefulWidget {
  const MenuNovelAnimation(
      {super.key,
      required this.top,
      required this.bottom,
      required this.audio,
      required this.autoScroll,
      required this.controller});
  final Widget top;
  final Widget bottom;
  final Widget audio;

  final Widget autoScroll;
  final MenuNovelAnimationController controller;

  @override
  State<MenuNovelAnimation> createState() => _MenuNovelAnimationState();
}

class _MenuNovelAnimationState extends State<MenuNovelAnimation>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool _currentOnTouchScreen = false;

  MenuNovelType _menuNovelType = MenuNovelType.base;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    widget.controller._bind(this);
  }

  void _showBaseMenu() async {
    if (_menuNovelType != MenuNovelType.base) {
      if (_isShowMenu) {
        await _hideMenu();
      }
      setState(() {
        _menuNovelType = MenuNovelType.base;
      });
    }

    _animationController.forward();
  }

  void _showAutoScrollMenu() async {
    if (_menuNovelType != MenuNovelType.autoScroll) {
      if (_isShowMenu) {
        await _hideMenu();
      }
      setState(() {
        _menuNovelType = MenuNovelType.autoScroll;
      });
    }

    _animationController.forward();
  }

  Future<void> _hideMenu() async {
    await _animationController.reverse();
  }

  void _changeMenu(MenuNovelType menu) {
    setState(() {
      _menuNovelType = menu;
    });
  }

  void _onTapScreen() {
    if (_isShowMenu || _currentOnTouchScreen) return;
    _onChangeIsShowMenu(true);
    _currentOnTouchScreen = false;
  }

  bool get _isShowMenu =>
      _animationController.status == AnimationStatus.completed;

  // chạm vào màn hình để đọc, ẩn panel nếu đang được hiện thị
  void _onTouchScreen() async {
    _currentOnTouchScreen = false;
    if (!_isShowMenu) return;
    _onChangeIsShowMenu(false);
    _currentOnTouchScreen = true;
  }

  void _onChangeIsShowMenu(bool value) async {
    if (_animationController.status == AnimationStatus.completed) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
            child: GestureDetector(
          onTap: _onTapScreen,
          onPanDown: (_) => _onTouchScreen(),
        )),
        if (_menuNovelType == MenuNovelType.base)
          Align(
            alignment: Alignment.topCenter,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) => SlideTransition(
                position:
                    Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
                        .animate(CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.easeOutQuad)),
                child: child,
              ),
              child: widget.top,
            ),
          ),
        if (_menuNovelType == MenuNovelType.base)
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) => SlideTransition(
                position:
                    Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                        .animate(CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.easeOutQuad)),
                child: child,
              ),
              child: widget.bottom,
            ),
          ),
        if (_menuNovelType == MenuNovelType.autoScroll)
          Align(
            alignment: Alignment.centerRight,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) => SlideTransition(
                position:
                    Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                        .animate(CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.easeOutQuad)),
                child: child,
              ),
              child: widget.autoScroll,
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}


// class MenuNovelAnimation extends StatefulWidget {
//   const MenuNovelAnimation(
//       {super.key,
//       required this.top,
//       required this.bottom,
//       required this.audio,
//       required this.autoScroll,
//       required this.controller});
//   final Widget top;
//   final Widget bottom;
//   final Widget audio;

//   final Widget autoScroll;
//   final MenuNovelAnimationController controller;

//   @override
//   State<MenuNovelAnimation> createState() => _MenuNovelAnimationState();
// }

// class _MenuNovelAnimationState extends State<MenuNovelAnimation>
//     with TickerProviderStateMixin {
//   late AnimationController _baseAnimationController;
//   late AnimationController _autoScrollAnimationController;

//   bool _currentOnTouchScreen = false;

//   MenuNovelType _menuNovelType = MenuNovelType.base;

//   @override
//   void initState() {
//     super.initState();
//     _baseAnimationController = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 400));
//     _autoScrollAnimationController = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 400));
//     widget.controller._bind(this);
//   }

//   void _showBaseMenu() async {
//     if (_menuNovelType == MenuNovelType.base) {}
//   }

//   void _showAutoScrollMenu() async {}

//   void _hideMenu() async {}

//   void _changeMenu() {
//     // _menuBase = !_menuBase;
//   }

//   void _onTapScreen() {
//     if (_isShowMenu || _currentOnTouchScreen) return;
//     _onChangeIsShowMenu(true);
//     _currentOnTouchScreen = false;
//   }

//   bool get _isShowMenu =>
//       _baseAnimationController.status == AnimationStatus.completed;

//   // chạm vào màn hình để đọc, ẩn panel nếu đang được hiện thị
//   void _onTouchScreen() async {
//     _currentOnTouchScreen = false;
//     if (!_isShowMenu) return;
//     _onChangeIsShowMenu(false);
//     _currentOnTouchScreen = true;
//   }

//   void _onChangeIsShowMenu(bool value) async {
//     // if (_animationController.status == AnimationStatus.completed) {
//     //   _animationController.reverse();
//     // } else {
//     //   _animationController.forward();
//     // }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         Positioned.fill(
//             child: GestureDetector(
//           onTap: _onTapScreen,
//           onPanDown: (_) => _onTouchScreen(),
//         )),
//         Align(
//           alignment: Alignment.topCenter,
//           child: AnimatedBuilder(
//             animation: _baseAnimationController,
//             builder: (context, child) => SlideTransition(
//               position:
//                   Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
//                       .animate(CurvedAnimation(
//                           parent: _baseAnimationController,
//                           curve: Curves.easeOutQuad)),
//               child: child,
//             ),
//           ),
//         ),
//         Align(
//           alignment: Alignment.bottomCenter,
//           child: AnimatedBuilder(
//             animation: _baseAnimationController,
//             builder: (context, child) => SlideTransition(
//               position:
//                   Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
//                       .animate(CurvedAnimation(
//                           parent: _baseAnimationController,
//                           curve: Curves.easeOutQuad)),
//               child: child,
//             ),
//           ),
//         ),
//         Align(
//           alignment: Alignment.centerRight,
//           child: AnimatedBuilder(
//             animation: _autoScrollAnimationController,
//             builder: (context, child) => SlideTransition(
//               position:
//                   Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
//                       .animate(CurvedAnimation(
//                           parent: _baseAnimationController,
//                           curve: Curves.easeOutQuad)),
//               child: child,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     _autoScrollAnimationController.dispose();
//     _baseAnimationController.dispose();
//     super.dispose();
//   }
// }
