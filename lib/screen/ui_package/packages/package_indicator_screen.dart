import 'package:flutter/material.dart';
import 'package:card_slider/card_slider.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:pager/pager.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../widget/example_widgets.dart';

class PackageIndicatorScreen extends StatefulWidget {
  const PackageIndicatorScreen({super.key});

  @override
  State<PackageIndicatorScreen> createState() => _PackageIndicatorScreenState();
}

class _PackageIndicatorScreenState extends State<PackageIndicatorScreen> {
  final PageController _pageController = PageController();
  int _numberPaginatorPage = 0;
  int _pagerPage = 1;

  final List<Color> _cardColors = [
    const Color(0xFF1E85ED),
    const Color(0xFF8B4AF4),
    const Color(0xFFFBB42B),
    const Color(0xFF119F6F),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('인디케이터 & 페이지네이션'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              '인디케이터 & 페이지네이션',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '페이지 표시 및 페이지네이션',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // SmoothPageIndicator
            const SectionHeader('SmoothPageIndicator'),
            const SizedBox(height: 12),
            ExampleCard(
              title: 'Slide Effect',
              description: '슬라이드 애니메이션',
              child: Column(
                spacing: 16,
                children: [
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _cardColors[index],
                                _cardColors[index].withValues(alpha: 0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Page ${index + 1}',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 4,
                    effect: const SlideEffect(
                      spacing: 8.0,
                      radius: 16.0,
                      dotWidth: 20.0,
                      dotHeight: 20.0,
                      dotColor: Colors.grey,
                      activeDotColor: Colors.indigo,
                      paintStyle: PaintingStyle.stroke,
                      strokeWidth: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ExampleCard(
              title: '다양한 Effect',
              description: 'Worm, Expanding, Jumping',
              child: Column(
                spacing: 16,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 16,
                    children: [
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: 4,
                        effect: WormEffect(
                          dotWidth: 12,
                          dotHeight: 12,
                          activeDotColor: theme.colorScheme.primary,
                        ),
                      ),
                      Text('Worm', style: theme.textTheme.labelSmall),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 16,
                    children: [
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: 4,
                        effect: ExpandingDotsEffect(
                          dotWidth: 12,
                          dotHeight: 12,
                          activeDotColor: theme.colorScheme.secondary,
                        ),
                      ),
                      Text('Expanding', style: theme.textTheme.labelSmall),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 16,
                    children: [
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: 4,
                        effect: JumpingDotEffect(
                          dotWidth: 12,
                          dotHeight: 12,
                          activeDotColor: theme.colorScheme.tertiary,
                        ),
                      ),
                      Text('Jumping', style: theme.textTheme.labelSmall),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // CardSlider
            const SectionHeader('CardSlider'),
            const SizedBox(height: 12),
            ExampleCard(
              title: '카드 슬라이더',
              description: '3D 효과의 카드 슬라이더',
              child: SizedBox(
                height: 250,
                child: CardSlider(
                  cards: List.generate(
                    4,
                        (index) => Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            _cardColors[index],
                            _cardColors[index].withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Text(
                              '${index + 1}',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: _cardColors[index],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Card ${index + 1}',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Swipe to see more',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  bottomOffset: 0.0005,
                  itemDotWidth: 14,
                  cardHeight: 0.95,
                  itemDotOffset: 0.5,
                  itemDot: (itemDotWidth) {
                    return Container(
                      margin: const EdgeInsets.all(5),
                      width: 8 + itemDotWidth,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: theme.colorScheme.primary,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // NumberPaginator
            const SectionHeader('NumberPaginator'),
            const SizedBox(height: 12),
            ExampleCard(
              title: '숫자 페이지네이션',
              description: '페이지 번호 선택',
              child: Column(
                spacing: 12,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Page ${_numberPaginatorPage + 1}',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  NumberPaginator(
                    numberPages: 5,
                    initialPage: _numberPaginatorPage,
                    config: NumberPaginatorUIConfig(
                      buttonSelectedForegroundColor: Colors.white,
                      buttonUnselectedForegroundColor: theme.colorScheme.onSurface,
                      buttonUnselectedBackgroundColor: theme.colorScheme.surfaceContainerHighest,
                      buttonSelectedBackgroundColor: theme.colorScheme.primary,
                      buttonShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPageChange: (int index) {
                      setState(() {
                        _numberPaginatorPage = index;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Pager
            const SectionHeader('Pager'),
            const SizedBox(height: 12),
            ExampleCard(
              title: '심플 페이저',
              description: '< 1 2 3 4 5 >',
              child: Column(
                spacing: 12,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.secondary,
                          theme.colorScheme.secondaryContainer,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Page $_pagerPage / 5',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.onSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Pager(
                        currentPage: _pagerPage,
                        totalPages: 5,
                        onPageChanged: (page) {
                          setState(() {
                            _pagerPage = page;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 비교표
            const SectionHeader('비교표'),
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
                            '패키지',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            '특징',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildComparisonRow(
                    theme,
                    'SmoothPageIndicator',
                    '다양한 애니메이션 효과',
                  ),
                  _buildComparisonRow(
                    theme,
                    'CardSlider',
                    '3D 카드 슬라이더',
                  ),
                  _buildComparisonRow(
                    theme,
                    'NumberPaginator',
                    '숫자 버튼 페이지네이션',
                  ),
                  _buildComparisonRow(
                    theme,
                    'Pager',
                    '심플한 페이저',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 정보 카드
            InfoBox(
              icon: Icons.info_outline,
              title: '💡 사용 팁',
              children: [
                const InfoItem('SmoothPageIndicator: PageView와 함께 사용'),
                const InfoItem('CardSlider: 자체 슬라이더 내장'),
                const InfoItem('NumberPaginator: 많은 페이지에 적합'),
                const InfoItem('Pager: 심플한 UI'),
              ],
            ),
          ],
        ),
      ),
    );
  }



  // 비교표 행
  Widget _buildComparisonRow(ThemeData theme, String package, String feature) {
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
              package,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              feature,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

}