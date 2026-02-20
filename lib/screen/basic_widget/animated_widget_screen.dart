import 'package:flutter/material.dart';

import '../widget/default_scaffold.dart';

class AnimatedWidgetScreen extends StatefulWidget {
  const AnimatedWidgetScreen({super.key});

  @override
  State<AnimatedWidgetScreen> createState() => _AnimatedWidgetScreenState();
}

class _AnimatedWidgetScreenState extends State<AnimatedWidgetScreen> {
  bool _selected = false;
  int _count = 0;
  double _opacity = 1.0;
  double _padding = 0.0;
  double _iconSize = 24.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('Animated 위젯'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              'Animated 위젯',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '다양한 애니메이션 효과를 확인해보세요',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // AnimatedContainer
            _buildSectionHeader(theme, '크기 & 색상'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'AnimatedContainer',
              description: '크기, 색상, 정렬이 부드럽게 변화',
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selected = !_selected;
                  });
                },
                child: Center(
                  child: AnimatedContainer(
                    width: _selected ? 200.0 : 100.0,
                    height: _selected ? 100.0 : 200.0,
                    decoration: BoxDecoration(
                      color: _selected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(_selected ? 50 : 10),
                    ),
                    alignment:
                        _selected ? Alignment.center : Alignment.topCenter,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                    child: Icon(
                      Icons.touch_app,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // AnimatedSize
            _buildExampleCard(
              theme: theme,
              title: 'AnimatedSize',
              description: '크기 변화에 자동으로 애니메이션 적용',
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selected = !_selected;
                  });
                },
                child: Center(
                  child: Container(
                    color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      child: FlutterLogo(
                        size: _selected ? 150.0 : 80.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 투명도 & 간격
            _buildSectionHeader(theme, '투명도 & 간격'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'AnimatedOpacity',
              description: '투명도가 부드럽게 변화',
              child: Column(
                spacing: 12,
                children: [
                  Center(
                    child: AnimatedOpacity(
                      opacity: _opacity,
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.visibility,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: () {
                      setState(() {
                        _opacity = _opacity == 0 ? 1.0 : 0.0;
                      });
                    },
                    child: Text(_opacity == 0 ? '보이기' : '숨기기'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _buildExampleCard(
              theme: theme,
              title: 'AnimatedPadding',
              description: '패딩이 부드럽게 변화',
              child: Column(
                spacing: 12,
                children: [
                  Container(
                    width: double.infinity,
                    height: 120,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: AnimatedPadding(
                      padding: EdgeInsets.all(_padding),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Padding: ${_padding.toInt()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: () {
                      setState(() {
                        _padding = _padding == 0.0 ? 40.0 : 0.0;
                      });
                    },
                    child: Text(_padding == 0 ? '패딩 추가' : '패딩 제거'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 전환 효과
            _buildSectionHeader(theme, '전환 효과'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'AnimatedSwitcher',
              description: '위젯 전환 시 페이드 효과',
              child: Column(
                spacing: 12,
                children: [
                  Container(
                    height: 80,
                    alignment: Alignment.center,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },
                      child: Text(
                        '$_count',
                        key: ValueKey<int>(_count),
                        style: theme.textTheme.displayLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () {
                      setState(() {
                        _count++;
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('카운트 증가'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _buildExampleCard(
              theme: theme,
              title: 'AnimatedCrossFade',
              description: '두 위젯 간 크로스페이드 전환',
              child: Column(
                spacing: 12,
                children: [
                  Center(
                    child: AnimatedCrossFade(
                      firstChild: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: const Icon(
                          Icons.circle,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                      secondChild: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.square,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                      crossFadeState: _selected
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 500),
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: () {
                      setState(() {
                        _selected = !_selected;
                      });
                    },
                    child: Text(_selected ? '네모로 변경' : '동그라미로 변경'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 고급 효과
            _buildSectionHeader(theme, '고급 효과'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'AnimatedPhysicalModel',
              description: '그림자와 elevation 애니메이션',
              child: Column(
                spacing: 12,
                children: [
                  Center(
                    child: AnimatedPhysicalModel(
                      shape: BoxShape.rectangle,
                      borderRadius:
                          _selected ? BorderRadius.circular(50) : BorderRadius.zero,
                      elevation: _selected ? 20.0 : 2.0,
                      color: _selected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.secondary,
                      shadowColor: _selected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.secondary,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      child: const SizedBox(
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: () {
                      setState(() {
                        _selected = !_selected;
                      });
                    },
                    child: const Text('그림자 변경'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _buildExampleCard(
              theme: theme,
              title: 'TweenAnimationBuilder',
              description: '사용자 정의 애니메이션',
              child: Column(
                spacing: 12,
                children: [
                  Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: _iconSize),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.elasticOut,
                      builder: (context, size, child) {
                        return Icon(
                          Icons.favorite,
                          size: size,
                          color: theme.colorScheme.error,
                        );
                      },
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: () {
                      setState(() {
                        _iconSize = _iconSize == 24.0 ? 80.0 : 24.0;
                      });
                    },
                    child: Text(_iconSize == 24 ? '크게' : '작게'),
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
                        '💡 Animated 위젯 종류',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'AnimatedContainer: 가장 범용적',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'AnimatedOpacity: 페이드 효과',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'AnimatedSwitcher: 위젯 교체',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'TweenAnimationBuilder: 커스텀 애니메이션',
                  ),
                  const Divider(),
                  Text(
                    '모든 Animated 위젯은 duration과 curve를 지정할 수 있습니다.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 리셋 버튼
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _selected = false;
                  _count = 0;
                  _opacity = 1.0;
                  _padding = 0.0;
                  _iconSize = 24.0;
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('모두 리셋'),
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
