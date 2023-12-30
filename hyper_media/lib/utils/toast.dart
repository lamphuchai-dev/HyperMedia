import 'package:fluttertoast/fluttertoast.dart';
import 'package:hyper_media/app.dart';

class Toast {
  Toast();
  final FToast _fToast = FToast();

  void onInit() {
    _fToast.init(navigatorKey.currentContext!);
  }
}
