import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js_runtime/js_runtime.dart';
import 'package:json_view/json_view.dart';

import '../cubit/home_cubit.dart';

class ResultWidget extends StatefulWidget {
  const ResultWidget({super.key});

  @override
  State<ResultWidget> createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget> {
  late ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) => previous.result != current.result,
      builder: (context, state) {
        if (state.result == null) return const SizedBox();
        ResponseJsRuntime result = state.result!;
        return switch (result) {
          SuccessJsRuntime() => Success(successJsRuntime: result),
          ErrorJsRuntime(error: var error) => SingleChildScrollView(
              child: Text(
                error,
                style: const TextStyle(color: Colors.red),
              ),
            ),
        };
      },
    );
  }
}

class Success extends StatelessWidget {
  const Success({super.key, required this.successJsRuntime});
  final SuccessJsRuntime successJsRuntime;

  @override
  Widget build(BuildContext context) {
    if (successJsRuntime.data is String) {
      return Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                await Clipboard.setData(
                    ClipboardData(text: successJsRuntime.data));
              },
              child: const Text("Copy")),
          Expanded(
            child: SingleChildScrollView(
              child: Text(successJsRuntime.data),
            ),
          ),
        ],
      );
    }
    return JsonConfig(
      data: JsonConfigData(
        animation: true,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.ease,
        itemPadding: const EdgeInsets.only(left: 8),
        color: const JsonColorScheme(
            // stringColor: Colors.grey,
            ),
        style: const JsonStyleScheme(
          arrow: Icon(Icons.arrow_right),
        ),
      ),
      child: JsonView(json: successJsRuntime.data),
    );
  }
}
