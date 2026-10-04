import 'package:flutter/material.dart';

class Categories {
  static const String all = '전체';
  static const String basicWidget = '기본 위젯';
  static const String dataProcessing = '데이터 처리';
  static const String uiPackage = 'UI 패키지';
  static const String network = '네트워크';
  static const String imageFile = '이미지/파일';
  static const String advanced = '고급 기능';
  static const String stateManagement = '상태 관리';
  static const String favorites = '즐겨찾기';

  // 카테고리 탭 표시 순서
  static const ordered = [
    basicWidget,
    dataProcessing,
    uiPackage,
    network,
    imageFile,
    advanced,
    stateManagement,
  ];
}

class ExampleItem {
  final String title;
  final Widget screen;
  final String category;
  final IconData icon;
  final bool isPractical;

  ExampleItem({
    required this.title,
    required this.screen,
    required this.category,
    required this.icon,
    this.isPractical = true,
  });
}
