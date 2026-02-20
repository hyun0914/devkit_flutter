import 'package:flutter/material.dart';

import '../../widget/basic_header_delegate.dart';

class SliverTab extends StatelessWidget {
  const SliverTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        // 고정 헤더 (SliverPersistentHeader)
        SliverPersistentHeader(
          pinned: true,
          delegate: BasicHeaderDelegate(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primaryContainer,
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 4,
                  children: [
                    Icon(
                      Icons.push_pin,
                      color: theme.colorScheme.onPrimary,
                      size: 24,
                    ),
                    Text(
                      'Sliver 고정 헤더',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            maxHeight: 100,
            minHeight: 60,
          ),
        ),

        // 인트로 섹션
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(20),
            color: theme.colorScheme.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Text(
                  'Sliver 위젯 예제',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'CustomScrollView에서 사용하는 다양한 Sliver 위젯들',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),

        // SliverList 예제
        SliverToBoxAdapter(
          child: _buildSectionTitle(theme, 'SliverList'),
        ),
        DecoratedSliver(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildListItem(
                theme: theme,
                index: 1,
                title: 'SliverList 아이템 1',
                color: theme.colorScheme.primaryContainer,
              ),
              _buildListItem(
                theme: theme,
                index: 2,
                title: 'SliverList 아이템 2',
                color: theme.colorScheme.secondaryContainer,
              ),
              _buildListItem(
                theme: theme,
                index: 3,
                title: 'SliverList 아이템 3',
                color: theme.colorScheme.tertiaryContainer,
              ),
            ]),
          ),
        ),

        // SliverGrid 예제
        SliverToBoxAdapter(
          child: _buildSectionTitle(theme, 'SliverGrid'),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getColorByIndex(theme, index).withValues(alpha: 0.6),
                        _getColorByIndex(theme, index),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 8,
                      children: [
                        Icon(
                          _getIconByIndex(index),
                          color: Colors.white,
                          size: 32,
                        ),
                        Text(
                          'Grid ${index + 1}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: 6,
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        // SliverToBoxAdapter 예제
        SliverToBoxAdapter(
          child: _buildSectionTitle(theme, 'SliverToBoxAdapter'),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              spacing: 12,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    spacing: 8,
                    children: [
                      Icon(
                        Icons.widgets,
                        size: 48,
                        color: theme.colorScheme.primary,
                      ),
                      Text(
                        'SliverToBoxAdapter',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        '일반 위젯을 Sliver로 변환',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.secondary,
                        theme.colorScheme.secondaryContainer,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      'Gradient Container',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        // SliverAnimatedList 정보
        SliverToBoxAdapter(
          child: _buildSectionTitle(theme, '기타 Sliver 위젯'),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              spacing: 12,
              children: [
                _buildInfoCard(
                  theme: theme,
                  icon: Icons.animation,
                  title: 'SliverAnimatedList',
                  description: '애니메이션이 있는 리스트',
                ),
                _buildInfoCard(
                  theme: theme,
                  icon: Icons.space_bar,
                  title: 'SliverPadding',
                  description: 'Sliver에 패딩 추가',
                ),
                _buildInfoCard(
                  theme: theme,
                  icon: Icons.opacity,
                  title: 'SliverOpacity',
                  description: 'Sliver 투명도 조절',
                ),
                _buildInfoCard(
                  theme: theme,
                  icon: Icons.fullscreen,
                  title: 'SliverFillRemaining',
                  description: '남은 공간을 채우는 Sliver',
                ),
              ],
            ),
          ),
        ),

        // SliverFillRemaining
        SliverFillRemaining(
          hasScrollBody: false,
          child: Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3),
                  theme.colorScheme.tertiaryContainer,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 12,
                children: [
                  Icon(
                    Icons.expand,
                    size: 64,
                    color: theme.colorScheme.tertiary,
                  ),
                  Text(
                    'SliverFillRemaining',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.tertiary,
                    ),
                  ),
                  Text(
                    '남은 공간을 모두 채웁니다',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onTertiaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 섹션 타이틀
  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      color: theme.colorScheme.surface,
      child: Row(
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
      ),
    );
  }

  // 리스트 아이템
  Widget _buildListItem({
    required ThemeData theme,
    required int index,
    required String title,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$index',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  // 정보 카드
  Widget _buildInfoCard({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String description,
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 인덱스별 색상
  Color _getColorByIndex(ThemeData theme, int index) {
    final colors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }

  // 인덱스별 아이콘
  IconData _getIconByIndex(int index) {
    final icons = [
      Icons.star,
      Icons.favorite,
      Icons.bolt,
      Icons.celebration,
      Icons.rocket_launch,
      Icons.emoji_events,
    ];
    return icons[index % icons.length];
  }
}
