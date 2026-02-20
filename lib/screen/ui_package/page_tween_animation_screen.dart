import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../widget/default_scaffold.dart';

class PageTweenAnimationScreen extends StatefulWidget {
  const PageTweenAnimationScreen({super.key});

  @override
  State<PageTweenAnimationScreen> createState() => _PageTweenAnimationScreenState();
}

class _PageTweenAnimationScreenState extends State<PageTweenAnimationScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  bool _isInfiniteMode = true; // 무한 스크롤 모드가 기본

  final List<CardData> _cards = [
    CardData(
      title: '자연의 아름다움',
      subtitle: '푸른 숲과 맑은 공기',
      color: Colors.green,
      icon: Icons.nature,
    ),
    CardData(
      title: '도시의 야경',
      subtitle: '화려한 네온사인',
      color: Colors.blue,
      icon: Icons.location_city,
    ),
    CardData(
      title: '바다의 평화',
      subtitle: '파도 소리와 함께',
      color: Colors.cyan,
      icon: Icons.water,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    _pageController = PageController(
      initialPage: _isInfiniteMode ? 1000 : 0,
      viewportFraction: 0.7,
    );
    _currentPage = _isInfiniteMode ? 1000 : 0;
  }

  void _toggleMode() {
    setState(() {
      _isInfiniteMode = !_isInfiniteMode;
      _pageController.dispose();
      _initializeController();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int get _actualIndex => _currentPage % _cards.length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('PageView + TweenAnimation'),
        actions: [
          // 모드 전환 버튼
          IconButton(
            icon: Icon(_isInfiniteMode ? Icons.all_inclusive : Icons.format_list_numbered),
            tooltip: _isInfiniteMode ? '일반 모드' : '무한 모드',
            onPressed: _toggleMode,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 모드 표시 헤더
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: _isInfiniteMode
                  ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                  : theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Row(
                    children: [
                      Icon(
                        _isInfiniteMode ? Icons.all_inclusive : Icons.format_list_numbered,
                        color: _isInfiniteMode
                            ? theme.colorScheme.primary
                            : theme.colorScheme.secondary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isInfiniteMode ? '🔄 무한 스크롤 모드 (실무 패턴)' : '📋 일반 모드 (교육용)',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _isInfiniteMode
                        ? '3개 카드가 끝없이 반복 • 실무 배너에서 많이 사용'
                        : '3개 카드를 순서대로 표시 • TweenAnimation 학습',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // PageView with TweenAnimation
            SizedBox(
              height: 320,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _isInfiniteMode ? null : _cards.length, // null = 무한
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final actualIndex = index % _cards.length;
                  final isSelected = _actualIndex == actualIndex;
                  final scale = isSelected ? 1.0 : 0.85;

                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: scale, end: scale),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Opacity(
                          opacity: isSelected ? 1.0 : 0.7,
                          child: _buildCard(
                            theme: theme,
                            data: _cards[actualIndex],
                            isSelected: isSelected,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // 페이지 인디케이터
            SmoothPageIndicator(
              controller: _pageController,
              count: _cards.length, // 항상 3개 표시
              effect: ScrollingDotsEffect(
                dotWidth: 8,
                dotHeight: 8,
                activeDotScale: 1.5,
                dotColor: theme.colorScheme.outlineVariant,
                activeDotColor: _isInfiniteMode
                    ? theme.colorScheme.primary
                    : theme.colorScheme.secondary,
                spacing: 12,
              ),
            ),

            const SizedBox(height: 24),

            // 현재 페이지 정보
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isInfiniteMode
                    ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                    : theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isInfiniteMode
                      ? theme.colorScheme.primary.withValues(alpha: 0.3)
                      : theme.colorScheme.secondary.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Row(
                    children: [
                      Icon(
                        _cards[_actualIndex].icon,
                        color: _isInfiniteMode
                            ? theme.colorScheme.primary
                            : theme.colorScheme.secondary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _cards[_actualIndex].title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _isInfiniteMode
                                ? theme.colorScheme.primary
                                : theme.colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _cards[_actualIndex].subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.swipe,
                            size: 16,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_actualIndex + 1} / ${_cards.length}',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      if (_isInfiniteMode)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.all_inclusive,
                                size: 14,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '무한',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 비교표
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
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
                spacing: 12,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.compare_arrows,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '모드 비교',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  _buildComparisonRow(
                    theme: theme,
                    label: '🔄 무한 모드',
                    description: 'initialPage: 1000, itemCount: null',
                    isActive: _isInfiniteMode,
                  ),
                  _buildComparisonRow(
                    theme: theme,
                    label: '📋 일반 모드',
                    description: 'initialPage: 0, itemCount: 3',
                    isActive: !_isInfiniteMode,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 정보 카드
            Container(
              margin: const EdgeInsets.all(16),
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
                        '💡 ${_isInfiniteMode ? "무한 스크롤 원리" : "TweenAnimation 효과"}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (_isInfiniteMode) ...[
                    _buildInfoItem(
                      theme: theme,
                      text: 'initialPage: 1000 - 중간부터 시작',
                    ),
                    _buildInfoItem(
                      theme: theme,
                      text: 'index % 3 - 실제 카드 인덱스 계산',
                    ),
                    _buildInfoItem(
                      theme: theme,
                      text: 'itemCount: null - 무한 스크롤',
                    ),
                    _buildInfoItem(
                      theme: theme,
                      text: '실무 배너/광고에서 많이 사용',
                    ),
                  ] else ...[
                    _buildInfoItem(
                      theme: theme,
                      text: 'viewportFraction: 0.7 - 양옆 카드 보임',
                    ),
                    _buildInfoItem(
                      theme: theme,
                      text: 'Transform.scale - 선택 시 확대',
                    ),
                    _buildInfoItem(
                      theme: theme,
                      text: 'Opacity - 미선택 카드 투명도',
                    ),
                    _buildInfoItem(
                      theme: theme,
                      text: 'Duration: 300ms - 부드러운 전환',
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 비교 행
  Widget _buildComparisonRow({
    required ThemeData theme,
    required String label,
    required String description,
    required bool isActive,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: isActive
            ? Border.all(
          color: theme.colorScheme.primary,
          width: 2,
        )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Row(
            children: [
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isActive ? theme.colorScheme.primary : null,
                ),
              ),
              if (isActive) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '현재',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  // 카드
  Widget _buildCard({
    required ThemeData theme,
    required CardData data,
    required bool isSelected,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            data.color,
            data.color.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: data.color.withValues(alpha: isSelected ? 0.4 : 0.2),
            blurRadius: isSelected ? 20 : 10,
            spreadRadius: isSelected ? 2 : 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 배경 패턴
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CustomPaint(
                painter: _DotPatternPainter(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
          ),

          // 콘텐츠
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 아이콘
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    data.icon,
                    size: 48,
                    color: Colors.white,
                  ),
                ),

                const Spacer(),

                // 텍스트
                Text(
                  data.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.subtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),

                const SizedBox(height: 16),

                // 선택 표시
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: data.color,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '선택됨',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: data.color,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
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

// 카드 데이터 모델
class CardData {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  CardData({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });
}

// 도트 패턴 페인터
class _DotPatternPainter extends CustomPainter {
  final Color color;

  _DotPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const spacing = 30.0;
    const dotRadius = 2.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}