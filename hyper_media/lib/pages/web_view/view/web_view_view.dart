import 'package:flutter/material.dart';
import '../cubit/web_view_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'web_view_page.dart';

class WebViewView extends StatelessWidget {
  const WebViewView({super.key, required this.url});
  static const String routeName = '/web_view_view';
  final String url;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WebViewCubit()..onInit(),
      child: WebViewPage(
        url: url,
      ),
    );
  }
}
