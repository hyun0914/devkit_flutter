import 'package:flutter/material.dart';

import '../widget/default_scaffold.dart';

class FlexibleExpandedScreen extends StatelessWidget {
  const FlexibleExpandedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('Flexible & Expanded'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              'Flexible & Expanded',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '공간을 유연하게 분배하는 위젯들',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // Expanded vs Flexible
            _buildSectionHeader(theme, 'Expanded vs Flexible'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'Expanded (남은 공간 모두 차지)',
              child: Row(
                children: [
                  _buildBox(theme, '고정', 80, Colors.orange),
                  Expanded(
                    child: _buildBox(theme, 'Expanded', null, Colors.blue),
                  ),
                  _buildBox(theme, '고정', 80, Colors.orange),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'Flexible (필요한 만큼만)',
              child: Row(
                children: [
                  _buildBox(theme, '고정', 80, Colors.orange),
                  Flexible(
                    child: _buildBox(theme, 'Flexible', null, Colors.green),
                  ),
                  _buildBox(theme, '고정', 80, Colors.orange),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // FlexFit.tight vs loose
            _buildSectionHeader(theme, 'FlexFit.tight vs loose'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'FlexFit.tight (공간 채움)',
              child: Row(
                children: [
                  _buildBox(theme, '고정', 150, Colors.orange),
                  Flexible(
                    fit: FlexFit.tight,
                    child: _buildBox(theme, 'tight', null, Colors.blue),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'FlexFit.loose (내용 크기)',
              child: Row(
                children: [
                  _buildBox(theme, '고정', 150, Colors.orange),
                  Flexible(
                    fit: FlexFit.loose,
                    child: _buildBox(theme, 'loose', null, Colors.green),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // flex 비율
            _buildSectionHeader(theme, 'flex 비율로 공간 분배'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'flex: 1:2:3 비율',
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: _buildBox(theme, 'flex: 1', null, Colors.cyan),
                  ),
                  Flexible(
                    flex: 2,
                    child: _buildBox(theme, 'flex: 2', null, Colors.orange),
                  ),
                  Flexible(
                    flex: 3,
                    child: _buildBox(theme, 'flex: 3', null, Colors.purple),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '1:1:1 동일 비율 (Expanded)',
              child: Row(
                children: [
                  Expanded(child: _buildBox(theme, '1', null, Colors.red)),
                  Expanded(child: _buildBox(theme, '1', null, Colors.green)),
                  Expanded(child: _buildBox(theme, '1', null, Colors.blue)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 복잡한 레이아웃
            _buildSectionHeader(theme, '복잡한 레이아웃'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '고정 + Flexible + 고정',
              child: Row(
                children: [
                  _buildBox(theme, '고정', 60, Colors.orange),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: _buildBox(theme, 'flex: 2', null, Colors.blue),
                  ),
                  _buildBox(theme, '고정', 60, Colors.orange),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'tight + loose 혼합',
              child: Row(
                children: [
                  _buildBox(theme, '고정', 80, Colors.orange),
                  Flexible(
                    fit: FlexFit.tight,
                    child: _buildBox(theme, 'tight', null, Colors.blue),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: _buildBox(theme, 'loose', null, Colors.green),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 텍스트 오버플로우 처리
            _buildSectionHeader(theme, '텍스트 오버플로우 처리'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'Expanded (텍스트 잘림)',
              child: Row(
                children: [
                  _buildBox(theme, '고정', 80, Colors.orange),
                  Expanded(
                    child: Container(
                      height: 60,
                      color: Colors.red.withValues(alpha: 0.7),
                      alignment: Alignment.center,
                      child: const Text(
                        '매우 긴 텍스트 입니다 1234567890 !!!!!!!!!',
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  _buildBox(theme, '고정', 80, Colors.orange),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'Flexible (텍스트 넘침 방지)',
              child: Row(
                children: [
                  _buildBox(theme, '고정', 80, Colors.orange),
                  Flexible(
                    child: Container(
                      height: 60,
                      color: Colors.green.withValues(alpha: 0.7),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: const Text(
                        '매우 긴 텍스트 입니다 1234567890 !!!!!!!!!',
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  _buildBox(theme, '고정', 80, Colors.orange),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 비교표
            _buildComparisonTable(theme),

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
                        '💡 핵심 정리',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  _buildInfoItem(theme, 'Expanded = Flexible(fit: FlexFit.tight)'),
                  _buildInfoItem(theme, 'flex: 공간 비율 (기본값 1)'),
                  _buildInfoItem(theme, 'FlexFit.tight: 공간 채움'),
                  _buildInfoItem(theme, 'FlexFit.loose: 내용 크기만큼'),
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
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Container(
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  // 박스
  Widget _buildBox(ThemeData theme, String label, double? width, Color color) {
    return Container(
      width: width,
      height: 60,
      color: color.withValues(alpha: 0.7),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
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
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
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
                    _buildTableCell(theme, 'Expanded', isHeader: true),
                    _buildTableCell(theme, 'Flexible', isHeader: true),
                  ],
                ),
                // 데이터
                ...[
                  ('FlexFit', 'tight', 'loose (기본)'),
                  ('공간 채움', '✓', '옵션'),
                  ('flex 사용', '✓', '✓'),
                  ('용도', '남은 공간 채움', '유연한 크기'),
                ].map((row) => TableRow(
                      children: [
                        _buildTableCell(theme, row.$1),
                        _buildTableCell(theme, row.$2),
                        _buildTableCell(theme, row.$3),
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

  // 정보 아이템
  Widget _buildInfoItem(ThemeData theme, String text) {
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
