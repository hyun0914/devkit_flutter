import 'package:flutter/material.dart';

// SliverPersistentHeader의 동작을 정의하는 Delegate
// 스크롤 시 헤더의 최소/최대 크기를 제어

class BasicHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double maxHeight;
  final double minHeight;

  BasicHeaderDelegate({
    required this.child,
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
    final shrinkRatio = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

    // 최소 크기일 때 추가 처리가 필요하다면 여기에 구현
    // 예: 투명도 조절, 아이콘 변경 등
    if (shrinkOffset >= maxExtent - minExtent) {
      // 완전히 축소된 상태
      debugPrint('헤더 완전 축소: shrinkRatio = $shrinkRatio');
    }

    return SizedBox.expand(
      child: child,
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
        child != oldDelegate.child;
  }
}