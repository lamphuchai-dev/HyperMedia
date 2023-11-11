import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'web_view_state.dart';

class WebViewCubit extends Cubit<WebViewState> {
  WebViewCubit() : super(WebViewInitial());

  void onInit() {}
}
