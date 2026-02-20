import 'package:flutter/material.dart';

import '../widget/default_scaffold.dart';

class HideWidgetsScreen extends StatefulWidget {
  const HideWidgetsScreen({super.key});

  @override
  State<HideWidgetsScreen> createState() => _HideWidgetsScreenState();
}

class _HideWidgetsScreenState extends State<HideWidgetsScreen> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('위젯 숨기기'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 헤더
                  Text(
                    '위젯 숨기기 방법',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '3가지 방법의 차이점을 확인해보세요',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 방법 1: Visibility
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
                          label: 'visible: ${_isVisible ? 'true' : 'false'}',
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
                          text: '✓ 위젯 트리에서 제거\n'
                              '✓ 공간 유지 가능 (maintainSize)\n'
                              '✓ 상태 유지 가능 (maintainState)',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 방법 2: Offstage
                  _buildMethodCard(
                    theme: theme,
                    title: '2. Offstage',
                    description: '공간 차지 안함',
                    icon: Icons.layers_clear,
                    color: theme.colorScheme.secondary,
                    child: Column(
                      spacing: 12,
                      children: [
                        _buildDemoBox(
                          theme: theme,
                          label: 'offstage: ${!_isVisible ? 'true' : 'false'}',
                          child: Offstage(
                            offstage: !_isVisible,
                            child: _buildTargetWidget(theme, 'Offstage'),
                          ),
                        ),
                        _buildInfoText(
                          theme: theme,
                          text: '✓ 위젯 트리에 유지\n'
                              '✓ 렌더링 안됨\n'
                              '✓ 공간 차지 안함\n'
                              '✓ 상태 유지됨',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 방법 3: Opacity
                  _buildMethodCard(
                    theme: theme,
                    title: '3. Opacity',
                    description: '공간 차지하며 투명화',
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
                          text: '✓ 위젯 트리에 유지\n'
                              '✓ 렌더링됨 (성능 영향)\n'
                              '✓ 공간 차지함\n'
                              '✓ 클릭 불가 (opacity: 0일 때)',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 비교표
                  _buildComparisonTable(theme),

                  const SizedBox(height: 24),

                  // 사용 권장 사항
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
                              Icons.recommend,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '💡 권장 사항',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        _buildRecommendation(
                          theme: theme,
                          method: 'Visibility',
                          useCase: '일반적인 show/hide (공간 제거)',
                        ),
                        _buildRecommendation(
                          theme: theme,
                          method: 'Offstage',
                          useCase: '위젯 상태 유지 필요',
                        ),
                        _buildRecommendation(
                          theme: theme,
                          method: 'Opacity',
                          useCase: '페이드 애니메이션',
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
                    onPressed: () {
                      setState(() {
                        _isVisible = !_isVisible;
                      });
                    },
                    icon: Icon(_isVisible ? Icons.visibility_off : Icons.visibility),
                    label: Text(_isVisible ? '위젯 숨기기' : '위젯 보이기'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 방법 카드
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
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
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

  // 데모 박스
  Widget _buildDemoBox({
    required ThemeData theme,
    required String label,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
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

  // 타겟 위젯
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

  // 정보 텍스트
  Widget _buildInfoText({
    required ThemeData theme,
    required String text,
  }) {
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

  // 비교표
  Widget _buildComparisonTable(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '📊 비교표',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(12)),
            child: Table(
              border: TableBorder.symmetric(
                inside: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1.5),
                2: FlexColumnWidth(1.5),
                3: FlexColumnWidth(1.5),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // 헤더
                TableRow(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                  ),
                  children: [
                    _buildTableCell(theme, '', isHeader: true),
                    _buildTableCell(theme, 'Visibility', isHeader: true),
                    _buildTableCell(theme, 'Offstage', isHeader: true),
                    _buildTableCell(theme, 'Opacity', isHeader: true),
                  ],
                ),
                // 데이터
                ...[
                  ('공간 차지', '✗', '✗', '✓'),
                  ('상태 유지', '옵션', '✓', '✓'),
                  ('렌더링', '✗', '✗', '✓'),
                  ('성능', '⭐⭐⭐', '⭐⭐⭐', '⭐⭐'),
                ].map((row) => TableRow(
                      children: [
                        _buildTableCell(theme, row.$1),
                        _buildTableCell(theme, row.$2),
                        _buildTableCell(theme, row.$3),
                        _buildTableCell(theme, row.$4),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 테이블 셀
  Widget _buildTableCell(
    ThemeData theme,
    String text, {
    bool isHeader = false,
  }) {
    return Container(
      height: isHeader ? 44 : 40,
      padding: const EdgeInsets.all(8),
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

  // 권장 사항
  Widget _buildRecommendation({
    required ThemeData theme,
    required String method,
    required String useCase,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.arrow_right,
          size: 18,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
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
