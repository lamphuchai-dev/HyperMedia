// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:equatable/equatable.dart';
// import 'package:extensions_client/js_runtime.dart';
import 'package:extensions_client/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js_runtime/js_runtime.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState(result: "", log: []));
  final _logger = Logger("HomeCubit");

  final _jsRuntime = JsRuntime();
  final TextEditingController urlTextEditingController =
      TextEditingController();
  final TextEditingController jsCodeTextEditingController =
      TextEditingController();

  void onInit() async {
    final init =
        await _jsRuntime.initRuntime(pathSource: "assets/js/extension.js");
    _logger.log("jsRuntime init : $init ");
    _jsRuntime.log.listen((event) {
      if (event is List) {
        final log = event.first;
        emit(state.copyWith(log: [
          ...state.log,
          LogModel(dateTime: DateTime.now(), log: log.toString())
        ]));
      }
    });
  }

  void onGo(BuildContext context) async {
    try {
      emit(state.copyWith(result: ""));
      final result = await _jsRuntime.runJsCode(
          jsScript: jsCodeTextEditingController.text);

      emit(state.copyWith(result: jsonEncode(result)));
    } on RuntimeException catch (error) {
      Flushbar(
        title: "ERROR ${error.type}",
        titleColor: Colors.red,
        message: error.error,
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(seconds: 3),
      ).show(context);
    } catch (error) {
      Flushbar(
        title: "ERROR",
        titleColor: Colors.red,
        message: error.toString(),
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(seconds: 3),
      ).show(context);
    }
  }

  void clearLog() {
    emit(state.copyWith(log: []));
  }
}
