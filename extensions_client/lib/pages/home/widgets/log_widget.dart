import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_view/json_view.dart';

import '../cubit/home_cubit.dart';

class LogWidget extends StatefulWidget {
  const LogWidget({super.key});

  @override
  State<LogWidget> createState() => _LogWidgetState();
}

class _LogWidgetState extends State<LogWidget> {
  late ScrollController? _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listenWhen: (previous, current) => previous.log != current.log,
      listener: (context, state) {
        _scrollController?.jumpTo(_scrollController!.position.maxScrollExtent);
      },
      buildWhen: (previous, current) => previous.log != current.log,
      builder: (context, state) {
        return SingleChildScrollView(
          controller: _scrollController,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: state.log.map((e) => cardLog(e)).toList()),
        );
      },
    );
  }

  Widget cardLog(LogModel log) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text:
              "${log.dateTime.hour}:${log.dateTime.minute}:${log.dateTime.second}",
          style: const TextStyle(color: Colors.red)),
      const TextSpan(text: " : ", style: TextStyle(color: Colors.black)),
      TextSpan(text: log.log, style: const TextStyle(color: Colors.black))
    ]));
  }
}
