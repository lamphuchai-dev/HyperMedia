import 'package:flutter/material.dart';
import 'package:hyper_media/app/constants/index.dart';

class ToastWidget extends StatelessWidget {
  const ToastWidget({super.key, required this.msg});
  final String msg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: AppColors.primary,
      ),
      child: Text(msg),
    );
  }
}
