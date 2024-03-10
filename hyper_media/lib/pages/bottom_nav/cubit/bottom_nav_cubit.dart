import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app.dart';
import 'package:hyper_media/app/route/routes_name.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

part 'bottom_nav_state.dart';

class BottomNavCubit extends Cubit<BottomNavState> {
  BottomNavCubit() : super(const BottomNavState(indexSelected: 0)) {
    _streamSubscription = ReceiveSharingIntent.getMediaStream().listen((value) {
      if (value.isEmpty) return;
      _pushDetail(value.first);
    }, onError: (err) {
      // print("getIntentDataStream error: $err");
    });
  }

  late StreamSubscription _streamSubscription;
  void onInit() {
    // Get the media sharing coming from outside the app while the app is closed.
    ReceiveSharingIntent.getInitialMedia().then((value) {
      if (value.isEmpty) return;
      _pushDetail(value.first);
      // Tell the library that we are done processing the intent.
      ReceiveSharingIntent.reset();
    });
  }

  void _pushDetail(SharedMediaFile sharedMedia) {
    if (sharedMedia.type == SharedMediaType.url) {
      final context = navigatorKey.currentContext;
      if (context != null) {
        Navigator.pushNamed(context, RoutesName.detail,
            arguments: sharedMedia.path);
      }
    }
  }

  void onChangeIndex(int index) {
    emit(BottomNavState(indexSelected: index));
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
