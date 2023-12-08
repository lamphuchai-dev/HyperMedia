import 'package:flutter/material.dart';

enum LoadingActionType { init, progress, done }

class LoadingAction extends StatefulWidget {
  const LoadingAction(
      {super.key,
      required this.onAction,
      required this.init,
      required this.progress,
      required this.done,
      this.initialDone = false});
  final Future<void> Function() onAction;
  final Widget init;
  final Widget progress;
  final Widget done;
  final bool initialDone;

  @override
  State<LoadingAction> createState() => _LoadingActionState();
}

class _LoadingActionState extends State<LoadingAction> {
  LoadingActionType _type = LoadingActionType.init;
  @override
  void initState() {
    if (widget.initialDone) {
      _type = LoadingActionType.done;
    }
    super.initState();
  }

  void _action() async {
    try {
      setState(() {
        _type = LoadingActionType.progress;
      });
      await widget.onAction.call();
      setState(() {
        _type = LoadingActionType.done;
      });
    } catch (err) {
      setState(() {
        _type = LoadingActionType.init;
      });

      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return switch (_type) {
      LoadingActionType.init => GestureDetector(
          onTap: () {
            _action();
          },
          child: widget.init,
        ),
      LoadingActionType.progress => widget.progress,
      LoadingActionType.done => widget.done
    };
  }
}
