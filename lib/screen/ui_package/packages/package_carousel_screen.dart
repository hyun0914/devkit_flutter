import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:tab_container/tab_container.dart';

import '../../widget/default_scaffold.dart';

class PackageCarouselScreen extends StatelessWidget {
  const PackageCarouselScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Color> tabColors = [
      const Color(0xFFF29F05),
      const Color(0xFFF27052),
      const Color(0xFFBFA68F),
      const Color(0xFF04BF68),
    ];

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('캐러셀 & 탭'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              '캐러셀 & 탭',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '슬라이드 및 탭 위젯',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // FlutterCarousel
            _buildSectionHeader(theme, 'FlutterCarousel'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '기본 캐러셀',
              description: '자동 재생 + 인디케이터',
              child: FlutterCarousel(
                options: FlutterCarouselOptions(
                  height: 200,
                  showIndicator: true,
                  slideIndicator: CircularWaveSlideIndicator(),
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  enableInfiniteScroll: true,
                  viewportFraction: 0.9,
                ),
                items: List.generate(4, (index) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              tabColors[index],
                              tabColors[index].withValues(alpha: 0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image,
                                size: 60,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Slide ${index + 1}',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '확대 효과',
              description: 'enlargeCenterPage: true',
              child: FlutterCarousel(
                options: FlutterCarouselOptions(
                  height: 220,
                  showIndicator: true,
                  slideIndicator: CircularWaveSlideIndicator(),
                  autoPlay: false,
                  enableInfiniteScroll: true,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  viewportFraction: 0.8,
                ),
                items: List.generate(3, (index) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Card ${index + 1}',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '전체 너비',
              description: 'viewportFraction: 1.0',
              child: FlutterCarousel(
                options: FlutterCarouselOptions(
                  height: 180,
                  showIndicator: true,
                  slideIndicator: CircularSlideIndicator(),
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  viewportFraction: 1.0,
                ),
                items: [
                  _buildFullWidthSlide(
                    theme,
                    '첫 번째 슬라이드',
                    Icons.looks_one,
                    theme.colorScheme.primary,
                  ),
                  _buildFullWidthSlide(
                    theme,
                    '두 번째 슬라이드',
                    Icons.looks_two,
                    theme.colorScheme.secondary,
                  ),
                  _buildFullWidthSlide(
                    theme,
                    '세 번째 슬라이드',
                    Icons.looks_3,
                    theme.colorScheme.tertiary,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // TabContainer
            _buildSectionHeader(theme, 'TabContainer'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '왼쪽 탭',
              description: 'tabEdge: TabEdge.left',
              child: SizedBox(
                height: 200,
                child: TabContainer(
                  tabEdge: TabEdge.left,
                  colors: tabColors,
                  tabs: List.generate(
                    4,
                        (index) => Icon(
                      [Icons.home, Icons.search, Icons.settings, Icons.person][index],
                      color: Colors.white,
                    ),
                  ),
                  children: List.generate(
                    4,
                        (index) => Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Text(
                            'Tab ${index + 1}',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '탭 컨텐츠 ${index + 1}',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '오른쪽 탭',
              description: 'tabEdge: TabEdge.right',
              child: SizedBox(
                height: 200,
                child: TabContainer(
                  tabEdge: TabEdge.right,
                  colors: tabColors.reversed.toList(),
                  tabs: List.generate(
                    4,
                        (index) => Icon(
                      [Icons.favorite, Icons.shopping_cart, Icons.notifications, Icons.chat][index],
                      color: Colors.white,
                    ),
                  ),
                  children: List.generate(
                    4,
                        (index) => Container(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Icon(
                          [Icons.favorite, Icons.shopping_cart, Icons.notifications, Icons.chat][index],
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '상단 탭',
              description: 'tabEdge: TabEdge.top',
              child: SizedBox(
                height: 220,
                child: TabContainer(
                  tabEdge: TabEdge.top,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                    theme.colorScheme.tertiary,
                  ],
                  tabs: const [
                    Text('Tab 1', style: TextStyle(color: Colors.white)),
                    Text('Tab 2', style: TextStyle(color: Colors.white)),
                    Text('Tab 3', style: TextStyle(color: Colors.white)),
                  ],
                  children: List.generate(
                    3,
                        (index) => Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.tab,
                            size: 50,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Content ${index + 1}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 옵션 비교
            _buildSectionHeader(theme, 'FlutterCarousel 옵션'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            '옵션',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            '설명',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildOptionRow(theme, 'autoPlay', '자동 재생'),
                  _buildOptionRow(theme, 'enlargeCenterPage', '중앙 확대'),
                  _buildOptionRow(theme, 'viewportFraction', '화면 비율 (0~1)'),
                  _buildOptionRow(theme, 'enlargeFactor', '확대 정도'),
                  _buildOptionRow(theme, 'showIndicator', '인디케이터 표시'),
                ],
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
                    text: 'FlutterCarousel: 이미지 갤러리, 광고 배너',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'TabContainer: 카테고리 분류',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'viewportFraction: 0.9 권장 (좌우 미리보기)',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'TabEdge: left, right, top, bottom',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 전체 너비 슬라이드
  Widget _buildFullWidthSlide(
      ThemeData theme,
      String text,
      IconData icon,
      Color color,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 12,
          children: [
            Icon(icon, size: 60, color: Colors.white),
            Text(
              text,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
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

  // 옵션 행
  Widget _buildOptionRow(ThemeData theme, String option, String description) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              option,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              description,
              style: theme.textTheme.bodyMedium,
            ),
          ),
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