import 'package:flutter/material.dart';

class MenuComicAnimationController {
  _MenuComicAnimationState? _state;

  void _bind(_MenuComicAnimationState state) {
    _state = state;
  }

  void showBaseMenu() {
    _state?._showBaseMenu();
  }

  void showAutoScrollMenu() {
    _state?._showAutoScrollMenu();
  }

  void changeMenu() {
    _state?._changeMenu();
  }

  void hide() {
    _state?._hideMenu();
  }
}

class MenuComicAnimation extends StatefulWidget {
  const MenuComicAnimation(
      {super.key,
      required this.base,
      required this.autoScroll,
      required this.controller});
  final Widget base;
  final Widget autoScroll;
  final MenuComicAnimationController controller;

  @override
  State<MenuComicAnimation> createState() => _MenuComicAnimationState();
}

class _MenuComicAnimationState extends State<MenuComicAnimation>
    with TickerProviderStateMixin {
  late AnimationController _baseAnimationController;
  late AnimationController _autoScrollAnimationController;
  late Animation<double> _animationFade;

  bool _currentOnTouchScreen = false;

  bool _menuBase = true;

  @override
  void initState() {
    super.initState();
    _baseAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    _autoScrollAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _animationFade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _baseAnimationController, curve: Curves.easeInOut));
    _baseAnimationController.addListener(() {});
    widget.controller._bind(this);
  }

  void _showBaseMenu() async {
    if (_autoScrollAnimationController.status == AnimationStatus.completed) {
      await _autoScrollAnimationController.reverse();
    }
    await _baseAnimationController.forward();
    _menuBase = true;
  }

  void _showAutoScrollMenu() async {
    if (_baseAnimationController.status == AnimationStatus.completed) {
      await _baseAnimationController.reverse();
    }
    _autoScrollAnimationController.forward();
    _menuBase = false;
  }

  void _hideMenu() async {
    if (_menuBase) {
      _baseAnimationController.reverse();
    } else {
      _autoScrollAnimationController.reverse();
      _menuBase = true;
    }
  }

  void _changeMenu() {
    _menuBase = !_menuBase;
  }

  void _onTapScreen() {
    if (_isShowMenu || _currentOnTouchScreen) return;
    _onChangeIsShowMenu(true);
    _currentOnTouchScreen = false;
  }

  bool get _isShowMenu {
    if (_menuBase) {
      return _baseAnimationController.status == AnimationStatus.completed;
    } else {
      return _autoScrollAnimationController.status == AnimationStatus.completed;
    }
  }

  // chạm vào màn hình để đọc, ẩn panel nếu đang được hiện thị
  void _onTouchScreen() async {
    _currentOnTouchScreen = false;
    if (!_isShowMenu) return;
    _onChangeIsShowMenu(false);
    _currentOnTouchScreen = true;
  }

  void _onChangeIsShowMenu(bool value) async {
    if (value) {
      if (_menuBase) {
        _baseAnimationController.forward();
      } else {
        _autoScrollAnimationController.forward();
      }
    } else {
      if (_menuBase) {
        _baseAnimationController.reverse();
      } else {
        _autoScrollAnimationController.reverse();
      }
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
          // child: const ColoredBox(color: Colors.transparent),
        )),
        Positioned(
            child: AnimatedBuilder(
          animation: _animationFade,
          builder: (context, child) => FadeTransition(
            opacity: _animationFade,
            child: child,
          ),
          child: widget.base,
        )),
        Align(
          alignment: Alignment.centerRight,
          child: AnimatedBuilder(
            animation: _autoScrollAnimationController,
            builder: (context, child) => SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: _autoScrollAnimationController,
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
    _baseAnimationController.dispose();
    _autoScrollAnimationController.dispose();
    super.dispose();
  }
}
