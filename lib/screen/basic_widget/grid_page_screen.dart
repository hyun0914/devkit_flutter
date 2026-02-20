import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../widget/default_scaffold.dart';

class GridPageScreen extends StatefulWidget {
  const GridPageScreen({super.key});

  @override
  State<GridPageScreen> createState() => _GridPageScreenState();
}

class _GridPageScreenState extends State<GridPageScreen> {
  final PageController _pageController = PageController();
  final List<Color> colorsList = List.generate(60, (index) => _generateRandomColor());

  static Color _generateRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalPages = (colorsList.length / 12).ceil();

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('GridView + PageView'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('사용법'),
                  content: const Text(
                    '• 좌우로 스와이프하여 페이지 이동\n'
                        '• 총 60개의 랜덤 색상\n'
                        '• 페이지당 12개씩 표시 (3x4 그리드)',
                  ),
                  actions: [
                    FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('확인'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 헤더
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  'PageView + GridView',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '좌우로 스와이프하여 페이지 이동 ($totalPages 페이지)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // PageView + GridView
          Expanded(
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: totalPages,
                  itemBuilder: (context, pageIndex) {
                    int start = pageIndex * 12;
                    int end = start + 12;
                    if (end > colorsList.length) end = colorsList.length;
                    List<Color> pageColors = colorsList.sublist(start, end);

                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: GridView.builder(
                        itemCount: pageColors.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.0,
                        ),
                        itemBuilder: (context, gridIndex) {
                          final actualIndex = start + gridIndex;
                          return _buildColorCard(
                            theme: theme,
                            color: pageColors[gridIndex],
                            index: actualIndex,
                          );
                        },
                      ),
                    );
                  },
                ),

                // 페이지 인디케이터
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: totalPages,
                        effect: WormEffect(
                          dotWidth: 10,
                          dotHeight: 10,
                          spacing: 8,
                          activeDotColor: theme.colorScheme.primary,
                          dotColor: theme.colorScheme.outlineVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 하단 정보
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                spacing: 12,
                children: [
                  // 통계
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        theme: theme,
                        icon: Icons.palette,
                        label: '총 색상',
                        value: '${colorsList.length}개',
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      ),
                      _buildStatItem(
                        theme: theme,
                        icon: Icons.grid_view,
                        label: '페이지당',
                        value: '12개',
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      ),
                      _buildStatItem(
                        theme: theme,
                        icon: Icons.article,
                        label: '총 페이지',
                        value: '$totalPages개',
                      ),
                    ],
                  ),

                  // 재생성 버튼
                  FilledButton.icon(
                    onPressed: () {
                      setState(() {
                        colorsList.clear();
                        colorsList.addAll(
                          List.generate(60, (index) => _generateRandomColor()),
                        );
                      });
                      _pageController.jumpToPage(0);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('색상 재생성'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 색상 카드
  Widget _buildColorCard({
    required ThemeData theme,
    required Color color,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('색상 #${index + 1}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'RGB 값',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'R: ${color.red}\n'
                      'G: ${color.green}\n'
                      'B: ${color.blue}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 번호 배지
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${index + 1}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 통계 아이템
  Widget _buildStatItem({
    required ThemeData theme,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      spacing: 4,
      children: [
        Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 20,
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}