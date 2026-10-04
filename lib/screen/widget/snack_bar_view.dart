import 'package:flutter/material.dart';

// 현재 SnackBar를 닫고 floating SnackBar를 표시하는 유틸리티 함수

void snackBarView({
  required BuildContext context,
  required String message,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
}
