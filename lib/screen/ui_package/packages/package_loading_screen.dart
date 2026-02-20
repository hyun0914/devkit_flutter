import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spoiler_widget/spoiler_widget.dart';

import '../../widget/default_scaffold.dart';

class PackageLoadingScreen extends StatelessWidget {
  const PackageLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
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
            _buildSectionHeader(theme, 'Shimmer'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
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
            _buildExampleCard(
              theme: theme,
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
            _buildSectionHeader(theme, 'Skeletonizer'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
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
            _buildSectionHeader(theme, 'SpinKit - 로딩 스피너'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
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
            _buildSectionHeader(theme, 'Spoiler Widget'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
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
            _buildExampleCard(
              theme: theme,
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '💡 사용 팁',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'Shimmer: 간단한 로딩 효과',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'Skeletonizer: 실제 UI 구조 미리 보기',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'SpinKit: 다양한 로딩 스피너',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'SpoilerWidget: 스포일러 방지',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 섹션 헤더
  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  // 예제 카드
  Widget _buildExampleCard({
    required ThemeData theme,
    required String title,
    required String description,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  // 정보 아이템
  Widget _buildInfoItem({
    required ThemeData theme,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          Icons.check_circle,
          size: 16,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
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