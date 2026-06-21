import 'package:flutter/material.dart';

import '../widget/default_scaffold.dart';

class HideWidgetsScreen extends StatefulWidget {
  const HideWidgetsScreen({super.key});

  @override
  State<HideWidgetsScreen> createState() => _HideWidgetsScreenState();
}

class _HideWidgetsScreenState extends State<HideWidgetsScreen> {
  bool _isVisible = true;
  bool _fadeVisible = true;
  String _measuredSize = '';
  final GlobalKey _offstageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(title: const Text('위젯 숨기기')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    '위젯 숨기기 방법',
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '5가지 방법의 차이점을 확인해보세요',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),

                  const SizedBox(height: 24),

                  // 0. if 조건문
                  _buildMethodCard(
                    theme: theme,
                    title: '0. if 조건문',
                    description: '가장 단순하고 성능 최적',
                    icon: Icons.code,
                    color: Colors.indigo,
                    child: Column(
                      spacing: 12,
                      children: [
                        _buildDemoBox(
                          theme: theme,
                          label: 'if (_isVisible) Widget() → 완전 제거',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildSmallBox(theme, '이전'),
                              if (_isVisible)
                                _buildTargetWidget(theme, 'if 조건문'),
                              _buildSmallBox(theme, '이후'),
                            ],
                          ),
                        ),
                        _buildInfoText(
                          theme: theme,
                          text: '✓ 위젯 트리에서 완전 제거 → 공간·State 소멸\n'
                              '✓ Visibility보다 간결하며 가장 성능 유리\n'
                              '✓ State 유지가 불필요한 경우 1순위 선택',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 1. Visibility
                  _buildMethodCard(
                    theme: theme,
                    title: '1. Visibility',
                    description: '공간 유지 옵션 제공',
                    icon: Icons.visibility_off,
                    color: theme.colorScheme.primary,
                    child: Column(
                      spacing: 12,
                      children: [
                        _buildDemoBox(
                          theme: theme,
                          label: 'visible: $_isVisible',
                          child: Visibility(
                            visible: _isVisible,
                            child: _buildTargetWidget(theme, 'Visibility'),
                          ),
                        ),
                        _buildDemoBox(
                          theme: theme,
                          label: 'maintainSize: true (공간 유지)',
                          child: Visibility(
                            visible: _isVisible,
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            child: _buildTargetWidget(theme, 'Visibility'),
                          ),
                        ),
                        _buildInfoText(
                          theme: theme,
                          text: '✓ visible: false → SizedBox.shrink() 교체, 공간·State 소멸\n'
                              '✓ maintainSize → 공간 유지 (maintainAnimation + maintainState 필수)\n'
                              '✓ maintainState → State 유지\n'
                              '✓ maintainAnimation → 애니메이션 유지\n'
                              '✓ maintainInteractivity → 터치 유지\n'
                              '내부: maintainSize+State → Opacity(0) / 그 외 → Offstage 사용',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 2. Offstage
                  _buildMethodCard(
                    theme: theme,
                    title: '2. Offstage',
                    description: '공간 없이 State 유지, 크기 측정 가능',
                    icon: Icons.layers_clear,
                    color: theme.colorScheme.secondary,
                    child: Column(
                      spacing: 12,
                      children: [
                        _buildDemoBox(
                          theme: theme,
                          label: 'offstage: ${!_isVisible}',
                          child: Offstage(
                            offstage: !_isVisible,
                            child: _buildTargetWidget(theme, 'Offstage'),
                          ),
                        ),
                        _buildDemoBox(
                          theme: theme,
                          label: 'offstage: true → GlobalKey로 크기 사전 측정',
                          child: Column(
                            spacing: 8,
                            children: [
                              Offstage(
                                offstage: true,
                                child: Container(
                                  key: _offstageKey,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  color: theme.colorScheme.primaryContainer,
                                  child: const Text('화면에 없지만 측정 가능한 위젯'),
                                ),
                              ),
                              FilledButton.tonal(
                                onPressed: () {
                                  final ctx = _offstageKey.currentContext;
                                  if (ctx != null) {
                                    final box =
                                        ctx.findRenderObject() as RenderBox;
                                    setState(() {
                                      _measuredSize =
                                          '${box.size.width.toStringAsFixed(1)} × ${box.size.height.toStringAsFixed(1)} px';
                                    });
                                  }
                                },
                                child: const Text('크기 측정'),
                              ),
                              if (_measuredSize.isNotEmpty)
                                Text(
                                  '측정값: $_measuredSize',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        _buildInfoText(
                          theme: theme,
                          text: '✓ paint만 스킵, 레이아웃 수행 → 크기 측정 가능\n'
                              '✓ 공간 차지 안 함, State·애니메이션 유지, 터치 불가\n'
                              '핵심: offstage: true + GlobalKey → RenderBox로 크기 사전 측정\n'
                              '⚠ 스크린 리더(접근성)에서 인식 안 됨',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 3. Opacity
                  _buildMethodCard(
                    theme: theme,
                    title: '3. Opacity',
                    description: '공간 차지하며 투명화, 터치 이벤트 유지',
                    icon: Icons.opacity,
                    color: theme.colorScheme.tertiary,
                    child: Column(
                      spacing: 12,
                      children: [
                        _buildDemoBox(
                          theme: theme,
                          label: 'opacity: ${_isVisible ? '1.0' : '0.0'}',
                          child: Opacity(
                            opacity: _isVisible ? 1.0 : 0.0,
                            child: _buildTargetWidget(theme, 'Opacity'),
                          ),
                        ),
                        _buildDemoBox(
                          theme: theme,
                          label: 'opacity: 0.5 (반투명)',
                          child: Opacity(
                            opacity: 0.5,
                            child: _buildTargetWidget(theme, 'Opacity'),
                          ),
                        ),
                        _buildInfoText(
                          theme: theme,
                          text: '✓ 렌더링 모두 수행, 공간 차지\n'
                              '✓ opacity: 0이어도 터치 이벤트 그대로 발생\n'
                              '⚠ 복잡한 위젯에 opacity: 0 사용 시 렌더링 낭비\n'
                              '→ 페이드 효과는 AnimatedOpacity 권장',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 4. AnimatedOpacity
                  _buildMethodCard(
                    theme: theme,
                    title: '4. AnimatedOpacity',
                    description: '페이드 인/아웃 애니메이션',
                    icon: Icons.animation,
                    color: Colors.deepPurple,
                    child: Column(
                      spacing: 12,
                      children: [
                        _buildDemoBox(
                          theme: theme,
                          label: '부드러운 페이드 (별도 토글)',
                          child: Column(
                            spacing: 8,
                            children: [
                              AnimatedOpacity(
                                opacity: _fadeVisible ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 400),
                                child:
                                    _buildTargetWidget(theme, 'AnimatedOpacity'),
                              ),
                              TextButton(
                                onPressed: () => setState(
                                    () => _fadeVisible = !_fadeVisible),
                                child: Text(
                                    _fadeVisible ? '페이드 아웃' : '페이드 인'),
                              ),
                            ],
                          ),
                        ),
                        _buildInfoText(
                          theme: theme,
                          text: '✓ Opacity의 애니메이션 버전 — duration / curve 지원\n'
                              '✓ opacity: 0이어도 공간 유지, 터치 이벤트 발생\n'
                              '→ 사라질 때 공간까지 없애려면 AnimatedOpacity + AnimatedSize 조합',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 비교표
                  _buildComparisonTable(theme),

                  const SizedBox(height: 24),

                  // 권장 사항
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: theme.colorScheme.outline
                              .withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.recommend,
                                color: theme.colorScheme.primary, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              '💡 언제 뭘 쓸까',
                              style: theme.textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        _buildRecommendation(
                          theme: theme,
                          method: 'if 조건문',
                          useCase: '완전 제거 (공간·State 불필요) — 가장 성능 유리',
                        ),
                        _buildRecommendation(
                          theme: theme,
                          method: 'Visibility',
                          useCase: '일반적인 show/hide (공간 제거)',
                        ),
                        _buildRecommendation(
                          theme: theme,
                          method: 'Visibility(maintain)',
                          useCase: '공간 유지 + State 유지',
                        ),
                        _buildRecommendation(
                          theme: theme,
                          method: 'Offstage',
                          useCase: '공간 없이 State 유지 + 크기 사전 측정',
                        ),
                        _buildRecommendation(
                          theme: theme,
                          method: 'AnimatedOpacity',
                          useCase: '투명도 애니메이션 (페이드 인/아웃)',
                        ),
                        _buildRecommendation(
                          theme: theme,
                          method: 'Opacity',
                          useCase: '공간 유지 + 터치 이벤트 살려야 할 때',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 하단 토글 버튼
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () =>
                        setState(() => _isVisible = !_isVisible),
                    icon: Icon(
                        _isVisible ? Icons.visibility_off : Icons.visibility),
                    label: Text(_isVisible ? '위젯 숨기기' : '위젯 보이기'),
                    style: FilledButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: 16)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallBox(ThemeData theme, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: theme.textTheme.labelSmall),
    );
  }

  Widget _buildMethodCard({
    required ThemeData theme,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    Text(description,
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildDemoBox({
    required ThemeData theme,
    required String label,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 60),
            alignment: Alignment.center,
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildTargetWidget(ThemeData theme, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoText({required ThemeData theme, required String text}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildComparisonTable(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '📊 비교표',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(12)),
            child: Table(
              border: TableBorder.symmetric(
                inside: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2)),
              ),
              columnWidths: const {
                0: FlexColumnWidth(2.2),
                1: FlexColumnWidth(1.4),
                2: FlexColumnWidth(1.6),
                3: FlexColumnWidth(1.6),
                4: FlexColumnWidth(1.6),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest),
                  children: [
                    _buildCell(theme, '', isHeader: true),
                    _buildCell(theme, 'Vis\n기본', isHeader: true),
                    _buildCell(theme, 'Vis\nsize', isHeader: true),
                    _buildCell(theme, 'Off\nstage', isHeader: true),
                    _buildCell(theme, 'Opacity\n(0)', isHeader: true),
                  ],
                ),
                ...[
                  ('공간 차지', '❌', '✅', '❌', '✅'),
                  ('State 유지', '❌', '✅', '✅', '✅'),
                  ('렌더링', '❌', '✅', '레이아웃', '✅'),
                  ('터치 가능', '❌', '❌', '❌', '✅'),
                  ('크기 측정', '❌', '✅', '✅', '✅'),
                ].map(
                  (row) => TableRow(
                    children: [
                      _buildCell(theme, row.$1),
                      _buildCell(theme, row.$2),
                      _buildCell(theme, row.$3),
                      _buildCell(theme, row.$4),
                      _buildCell(theme, row.$5),
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

  Widget _buildCell(ThemeData theme, String text, {bool isHeader = false}) {
    return Container(
      height: isHeader ? 48 : 40,
      padding: const EdgeInsets.all(6),
      child: Center(
        child: Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            color: isHeader ? theme.colorScheme.onSurfaceVariant : null,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildRecommendation({
    required ThemeData theme,
    required String method,
    required String useCase,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.arrow_right, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              children: [
                TextSpan(
                  text: '$method: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: useCase),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
