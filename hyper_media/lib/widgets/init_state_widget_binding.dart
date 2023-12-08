import 'package:flutter/material.dart';

class InitStateWidgetBinding extends StatefulWidget {
  const InitStateWidgetBinding(
      {super.key, required this.child, required this.onCallback});
  final Widget child;
  final VoidCallback onCallback;

  @override
  State<InitStateWidgetBinding> createState() => _InitStateWidgetBindingState();
}

class _InitStateWidgetBindingState extends State<InitStateWidgetBinding> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
