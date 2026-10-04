import 'package:flutter/material.dart';

// SliverPersistentHeader의 동작을 정의하는 Delegate
// 스크롤 시 헤더의 최소/최대 크기를 제어

class BasicHeaderDelegate extends SliverPersistentHeaderDelegate {
  // shrinkRatio(0.0 = 펼침, 1.0 = 완전 축소)를 받아 헤더를 그리는 함수
  final Widget Function(BuildContext context, double shrinkRatio) builder;
  final double maxHeight;
  final double minHeight;

  BasicHeaderDelegate({
    required this.builder,
    required this.maxHeight,
    required this.minHeight,
  });

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    // shrinkOffset: 현재 스크롤 위치 (0 ~ maxExtent - minExtent)
    // overlapsContent: 헤더가 다른 콘텐츠와 겹치는지 여부

    // 헤더가 축소되는 비율 계산 (0.0 ~ 1.0)
    // 이 값으로 투명도·크기 등을 조절하면 스크롤에 반응하는 헤더를 만들 수 있음
    final shrinkRatio = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

    return SizedBox.expand(
      child: builder(context, shrinkRatio),
    );
  }

  // 헤더의 최대 높이
  @override
  double get maxExtent => maxHeight;

  // 헤더의 최소 높이
  @override
  double get minExtent => minHeight;

  // 헤더를 다시 빌드해야 하는지 여부
  // 속성이 변경되면 true 반환하여 리빌드 트리거
  @override
  bool shouldRebuild(BasicHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        builder != oldDelegate.builder;
  }
}