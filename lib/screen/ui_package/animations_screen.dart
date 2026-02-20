import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../widget/default_scaffold.dart';

class AnimationsScreen extends StatefulWidget {
  const AnimationsScreen({super.key});

  @override
  State<AnimationsScreen> createState() => _AnimationsScreenState();
}

class _AnimationsScreenState extends State<AnimationsScreen> {
  int _selectedTab = 0;
  SharedAxisTransitionType _transitionType = SharedAxisTransitionType.horizontal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('애니메이션'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              '페이지 전환 애니메이션',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Hero, OpenContainer, SharedAxis, FadeThrough',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // 1. Hero Animation
            _buildSectionHeader(theme, '1. Hero (이미지 확대 전환)'),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                  const _HeroDetailScreen(heroTag: 'hero_image'),
                ),
              ),
              child: Hero(
                tag: 'hero_image',
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=800',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              theme: theme,
              text: '이미지 탭하면 부드럽게 확대되며 페이지 전환',
              color: theme.colorScheme.primary,
            ),

            const SizedBox(height: 24),

            // 2. OpenContainer
            _buildSectionHeader(theme, '2. OpenContainer (카드 → 상세)'),
            const SizedBox(height: 12),
            OpenContainer(
              closedElevation: 2,
              closedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              closedColor: theme.colorScheme.surfaceContainerHighest,
              openColor: theme.colorScheme.surface,
              transitionDuration: const Duration(milliseconds: 500),
              closedBuilder: (context, action) {
                return Container(
                  height: 150,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.restaurant,
                          size: 48,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '레스토랑 정보',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '탭해서 상세 정보 보기',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ],
                  ),
                );
              },
              openBuilder: (context, action) {
                return const _OpenContainerDetailScreen();
              },
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              theme: theme,
              text: '카드가 확장되며 상세 페이지로 전환 (Material Design)',
              color: Colors.blue,
            ),

            const SizedBox(height: 24),

            // 3. SharedAxisTransition
            _buildSectionHeader(theme, '3. SharedAxisTransition (페이지 전환)'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                spacing: 12,
                children: [
                  // 전환 타입 선택
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTransitionButton(
                        theme: theme,
                        label: '가로',
                        type: SharedAxisTransitionType.horizontal,
                        isSelected: _transitionType == SharedAxisTransitionType.horizontal,
                      ),
                      _buildTransitionButton(
                        theme: theme,
                        label: '세로',
                        type: SharedAxisTransitionType.vertical,
                        isSelected: _transitionType == SharedAxisTransitionType.vertical,
                      ),
                      _buildTransitionButton(
                        theme: theme,
                        label: '크기',
                        type: SharedAxisTransitionType.scaled,
                        isSelected: _transitionType == SharedAxisTransitionType.scaled,
                      ),
                    ],
                  ),
                  const Divider(),
                  // 애니메이션 프리뷰
                  SizedBox(
                    height: 200,
                    child: PageTransitionSwitcher(
                      transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
                        return SharedAxisTransition(
                          animation: primaryAnimation,
                          secondaryAnimation: secondaryAnimation,
                          transitionType: _transitionType,
                          child: child,
                        );
                      },
                      child: Container(
                        key: ValueKey(_selectedTab),
                        decoration: BoxDecoration(
                          color: [
                            Colors.blue.withValues(alpha: 0.2),
                            Colors.orange.withValues(alpha: 0.2),
                            Colors.green.withValues(alpha: 0.2),
                          ][_selectedTab],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                [Icons.home, Icons.search, Icons.settings][_selectedTab],
                                size: 64,
                                color: [Colors.blue, Colors.orange, Colors.green][_selectedTab],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                ['홈', '검색', '설정'][_selectedTab],
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 탭 버튼들
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTabButton(theme: theme, index: 0, icon: Icons.home, label: '홈'),
                      _buildTabButton(theme: theme, index: 1, icon: Icons.search, label: '검색'),
                      _buildTabButton(theme: theme, index: 2, icon: Icons.settings, label: '설정'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              theme: theme,
              text: '페이지 간 전환 시 부드러운 슬라이드/크기 애니메이션',
              color: Colors.orange,
            ),

            const SizedBox(height: 24),

            // 4. FadeThroughTransition
            _buildSectionHeader(theme, '4. FadeThroughTransition (컨텐츠 교체)'),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                showModal(
                  context: context,
                  builder: (context) => const _FadeScaleDialog(),
                );
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('모달 열기 (FadeScale)'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              theme: theme,
              text: '다이얼로그/모달이 부드럽게 페이드되며 나타남',
              color: Colors.green,
            ),

            const SizedBox(height: 24),

            // 비교표
            _buildSectionHeader(theme, '애니메이션 비교표'),
            const SizedBox(height: 12),
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
                children: [
                  _buildComparisonRow(
                    theme: theme,
                    animation: 'Hero',
                    usage: '이미지 확대, 제품 상세',
                    icon: Icons.image,
                  ),
                  const Divider(height: 16),
                  _buildComparisonRow(
                    theme: theme,
                    animation: 'OpenContainer',
                    usage: '카드 → 상세 페이지',
                    icon: Icons.open_in_new,
                  ),
                  const Divider(height: 16),
                  _buildComparisonRow(
                    theme: theme,
                    animation: 'SharedAxis',
                    usage: '탭 전환, 페이지 전환',
                    icon: Icons.swap_horiz,
                  ),
                  const Divider(height: 16),
                  _buildComparisonRow(
                    theme: theme,
                    animation: 'FadeScale',
                    usage: '다이얼로그, 모달',
                    icon: Icons.open_in_browser,
                  ),
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
                        '💡 실무 팁',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  _buildTipItem(theme: theme, text: 'Hero: 같은 요소의 위치/크기 변화'),
                  _buildTipItem(theme: theme, text: 'OpenContainer: Material Design 스타일'),
                  _buildTipItem(theme: theme, text: 'SharedAxis: 관계 있는 페이지 간 전환'),
                  _buildTipItem(theme: theme, text: 'FadeScale: 모달/다이얼로그에 적합'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildInfoCard({
    required ThemeData theme,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.touch_app, size: 16, color: color),
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
      ),
    );
  }

  Widget _buildTransitionButton({
    required ThemeData theme,
    required String label,
    required SharedAxisTransitionType type,
    required bool isSelected,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FilledButton(
          onPressed: () => setState(() => _transitionType = type),
          style: FilledButton.styleFrom(
            backgroundColor: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerHighest,
            foregroundColor: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
          ),
          child: Text(label),
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required ThemeData theme,
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FilledButton.icon(
          onPressed: () => setState(() => _selectedTab = index),
          style: FilledButton.styleFrom(
            backgroundColor: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainer,
            foregroundColor: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
          ),
          icon: Icon(icon, size: 20),
          label: Text(label),
        ),
      ),
    );
  }

  Widget _buildComparisonRow({
    required ThemeData theme,
    required String animation,
    required String usage,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                animation,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                usage,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTipItem({
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

// Hero 상세 화면
class _HeroDetailScreen extends StatelessWidget {
  final String heroTag;

  const _HeroDetailScreen({required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Hero(
          tag: heroTag,
          child: InteractiveViewer(
            child: Image.network(
              'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=1200',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.black.withValues(alpha: 0.5),
          child: Text(
            '💡 핀치 줌으로 확대/축소 가능',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// OpenContainer 상세 화면
class _OpenContainerDetailScreen extends StatelessWidget {
  const _OpenContainerDetailScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('레스토랑 상세'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    Icons.restaurant,
                    size: 100,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '맛있는 레스토랑',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '서울시 강남구',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '영업시간: 10:00 - 22:00',
                style: theme.textTheme.bodyMedium,
              ),
              Text(
                '전화번호: 02-1234-5678',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// FadeScale 다이얼로그
class _FadeScaleDialog extends StatelessWidget {
  const _FadeScaleDialog();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      icon: Icon(
        Icons.check_circle,
        color: theme.colorScheme.primary,
        size: 48,
      ),
      title: const Text('성공!'),
      content: const Text('FadeScale 애니메이션으로\n부드럽게 나타났습니다.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('닫기'),
        ),
      ],
    );
  }
}