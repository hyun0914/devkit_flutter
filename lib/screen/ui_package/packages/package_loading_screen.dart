import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spoiler_widget/spoiler_widget.dart';

import '../../widget/example_widgets.dart';

class PackageLoadingScreen extends StatelessWidget {
  const PackageLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('로딩 & 스켈레톤'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              '로딩 & 스켈레톤',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '다양한 로딩 애니메이션과 스켈레톤 UI',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // Shimmer
            const SectionHeader('Shimmer'),
            const SizedBox(height: 12),
            ExampleCard(
              title: 'Shimmer 텍스트',
              description: '반짝이는 로딩 효과',
              child: Center(
                child: Shimmer.fromColors(
                  baseColor: theme.colorScheme.primary,
                  highlightColor: theme.colorScheme.secondary,
                  child: Text(
                    '로딩 중...',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ExampleCard(
              title: 'Shimmer 박스',
              description: '스켈레톤 UI용',
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  spacing: 12,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      spacing: 12,
                      children: [
                        Expanded(
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Skeletonizer
            const SectionHeader('Skeletonizer'),
            const SizedBox(height: 12),
            ExampleCard(
              title: 'Skeletonizer',
              description: '자동 스켈레톤 UI',
              child: const Skeletonizer(
                enabled: true,
                enableSwitchAnimation: true,
                child: Card(
                  child: ListTile(
                    leading: Icon(Icons.person, size: 40),
                    title: Text('홍길동'),
                    subtitle: Text('개발자 · 서울'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // SpinKit
            const SectionHeader('SpinKit - 로딩 스피너'),
            const SizedBox(height: 12),
            ExampleCard(
              title: 'SpinKit 8종',
              description: '다양한 로딩 애니메이션',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  _SpinKitItem(
                    name: 'Circle',
                    child: SpinKitRotatingCircle(
                      color: theme.colorScheme.primary,
                      size: 40,
                    ),
                  ),
                  _SpinKitItem(
                    name: 'Plain',
                    child: SpinKitRotatingPlain(
                      color: theme.colorScheme.primary,
                      size: 40,
                    ),
                  ),
                  _SpinKitItem(
                    name: 'Bounce',
                    child: SpinKitDoubleBounce(
                      color: theme.colorScheme.primary,
                      size: 40,
                    ),
                  ),
                  _SpinKitItem(
                    name: 'Ring',
                    child: SpinKitRing(
                      color: theme.colorScheme.primary,
                      size: 40,
                    ),
                  ),
                  _SpinKitItem(
                    name: 'Circle',
                    child: SpinKitCircle(
                      color: theme.colorScheme.primary,
                      size: 40,
                    ),
                  ),
                  _SpinKitItem(
                    name: 'Wave',
                    child: SpinKitWave(
                      color: theme.colorScheme.primary,
                      size: 40,
                    ),
                  ),
                  _SpinKitItem(
                    name: 'HourGlass',
                    child: SpinKitPouringHourGlassRefined(
                      color: theme.colorScheme.primary,
                      size: 40,
                    ),
                  ),
                  _SpinKitItem(
                    name: 'Grid',
                    child: SpinKitPulsingGrid(
                      color: theme.colorScheme.primary,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // SpoilerWidget
            const SectionHeader('Spoiler Widget'),
            const SizedBox(height: 12),
            ExampleCard(
              title: 'SpoilerTextWrapper',
              description: '텍스트를 탭하면 내용 표시',
              child: Column(
                spacing: 8,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.touch_app,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '아래 텍스트를 탭하세요',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: SpoilerTextWrapper(
                      config: TextSpoilerConfig(
                        isEnabled: true,
                        fadeConfig: const FadeConfig(
                          padding: 3.0,
                          edgeThickness: 20.0,
                        ),
                        enableGestureReveal: true,
                        onSpoilerVisibilityChanged: (isVisible) {
                          debugPrint('Spoiler is now: ${isVisible ? 'Visible' : 'Hidden'}');
                        },
                      ),
                      child: Text(
                        '스포일러 내용입니다! 클릭해보세요. 🔒',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ExampleCard(
              title: 'SpoilerOverlay',
              description: '이미지에 블러 효과',
              child: Center(
                child: SpoilerOverlay(
                  config: WidgetSpoilerConfig(
                    isEnabled: true,
                    fadeConfig: const FadeConfig(
                      padding: 3.0,
                      edgeThickness: 20.0,
                    ),
                    enableGestureReveal: true,
                    imageFilter: ImageFilter.blur(
                      sigmaX: 30.0,
                      sigmaY: 30.0,
                    ),
                    onSpoilerVisibilityChanged: (isVisible) {
                      debugPrint('Spoiler overlay is now: ${isVisible ? 'Visible' : 'Hidden'}');
                    },
                  ),
                  child: Container(
                    width: 200,
                    height: 120,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.lock,
                        size: 40,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 정보 카드
            InfoBox(
              icon: Icons.info_outline,
              title: '💡 사용 팁',
              children: [
                const InfoItem('Shimmer: 간단한 로딩 효과'),
                const InfoItem('Skeletonizer: 실제 UI 구조 미리 보기'),
                const InfoItem('SpinKit: 다양한 로딩 스피너'),
                const InfoItem('SpoilerWidget: 스포일러 방지'),
              ],
            ),
          ],
        ),
      ),
    );
  }



}

// SpinKit 아이템 위젯
class _SpinKitItem extends StatelessWidget {
  final String name;
  final Widget child;

  const _SpinKitItem({
    required this.name,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 80,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        spacing: 8,
        children: [
          SizedBox(
            height: 40,
            child: child,
          ),
          Text(
            name,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}