import 'package:flutter/material.dart';

// SnackBar를 안전하게 표시하는 유틸리티 함수
// build 중에 호출해도 안전하도록 addPostFrameCallback 사용

void snackBarView({
  required BuildContext context,
  required String message,
  Duration duration = const Duration(seconds: 2),
  SnackBarAction? action,
  Color? backgroundColor,
  bool hideCurrentSnackBar = true,
}) {
  // build 중에 호출해도 안전하게 처리
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    if (hideCurrentSnackBar) {
      messenger.hideCurrentSnackBar();
    }

    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  });
}