import 'package:flutter/material.dart';

import '../widget/default_scaffold.dart';

class TableWidgetScreen extends StatelessWidget {
  const TableWidgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('Table 위젯'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              'Table 위젯 예제',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '다양한 테이블 스타일을 확인해보세요',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // 기본 테이블
            _buildSectionHeader(theme, '기본 테이블'),
            const SizedBox(height: 12),
            _buildBasicTable(theme),

            const SizedBox(height: 24),

            // 월별 통계 테이블
            _buildSectionHeader(theme, '월별 통계'),
            const SizedBox(height: 12),
            _buildMonthlyStatsTable(theme),

            const SizedBox(height: 24),

            // 성적표 테이블
            _buildSectionHeader(theme, '성적표'),
            const SizedBox(height: 12),
            _buildGradeTable(theme),

            const SizedBox(height: 24),

            // 가격표 테이블
            _buildSectionHeader(theme, '가격표'),
            const SizedBox(height: 12),
            _buildPriceTable(theme),

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
                        '💡 Table 위젯 속성',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '• columnWidths: 열 너비 지정\n'
                    '• border: 테두리 스타일\n'
                    '• defaultVerticalAlignment: 수직 정렬\n'
                    '• TableRow: 각 행 데이터\n'
                    '• FlexColumnWidth: 비율로 너비 지정',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
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

  // 기본 테이블
  Widget _buildBasicTable(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Table(
          border: TableBorder.symmetric(
            inside: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            // 헤더
            TableRow(
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
              ),
              children: [
                _buildTableCell(
                  theme,
                  '항목',
                  isHeader: true,
                ),
                _buildTableCell(
                  theme,
                  '수량',
                  isHeader: true,
                ),
                _buildTableCell(
                  theme,
                  '단위',
                  isHeader: true,
                ),
              ],
            ),
            // 데이터
            ...[
              ('사과', '10', 'kg'),
              ('바나나', '5', '송이'),
              ('오렌지', '8', 'kg'),
            ].map((item) => TableRow(
                  children: [
                    _buildTableCell(theme, item.$1),
                    _buildTableCell(theme, item.$2),
                    _buildTableCell(theme, item.$3),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  // 월별 통계 테이블
  Widget _buildMonthlyStatsTable(ThemeData theme) {
    final months = ['1월', '2월', '3월', '4월', '5월', '6월'];
    final data = [
      [15, 12, 8, 5],
      [18, 14, 10, 6],
      [20, 16, 12, 8],
      [22, 18, 14, 10],
      [25, 20, 16, 12],
      [28, 22, 18, 14],
    ];

    final totals = List.generate(
      4,
      (i) => data.map((row) => row[i]).reduce((a, b) => a + b),
    );

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            // 메인 테이블
            Table(
              border: TableBorder.symmetric(
                inside: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              columnWidths: const {
                0: FlexColumnWidth(80),
                1: FlexColumnWidth(60),
                2: FlexColumnWidth(60),
                3: FlexColumnWidth(60),
                4: FlexColumnWidth(60),
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
                    _buildTableCell(theme, '계획', isHeader: true),
                    _buildTableCell(theme, '완료', isHeader: true),
                    _buildTableCell(theme, '진행', isHeader: true),
                    _buildTableCell(theme, '대기', isHeader: true),
                  ],
                ),
                // 데이터
                for (int i = 0; i < months.length; i++)
                  TableRow(
                    children: [
                      _buildTableCell(
                        theme,
                        months[i],
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      ),
                      _buildTableCell(theme, '${data[i][0]}'),
                      _buildTableCell(theme, '${data[i][1]}'),
                      _buildTableCell(theme, '${data[i][2]}'),
                      _buildTableCell(theme, '${data[i][3]}'),
                    ],
                  ),
              ],
            ),
            // 합계 행
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(80),
                  1: FlexColumnWidth(60),
                  2: FlexColumnWidth(60),
                  3: FlexColumnWidth(60),
                  4: FlexColumnWidth(60),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      _buildTableCell(
                        theme,
                        '합계',
                        isHeader: true,
                        textColor: theme.colorScheme.primary,
                      ),
                      _buildTableCell(
                        theme,
                        '${totals[0]}',
                        isHeader: true,
                        textColor: theme.colorScheme.primary,
                      ),
                      _buildTableCell(
                        theme,
                        '${totals[1]}',
                        isHeader: true,
                        textColor: theme.colorScheme.primary,
                      ),
                      _buildTableCell(
                        theme,
                        '${totals[2]}',
                        isHeader: true,
                        textColor: theme.colorScheme.primary,
                      ),
                      _buildTableCell(
                        theme,
                        '${totals[3]}',
                        isHeader: true,
                        textColor: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 성적표 테이블
  Widget _buildGradeTable(ThemeData theme) {
    final students = [
      ('김철수', 85, 90, 88),
      ('이영희', 92, 88, 95),
      ('박민수', 78, 82, 80),
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Table(
          border: TableBorder.symmetric(
            inside: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            // 헤더
            TableRow(
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
              ),
              children: [
                _buildTableCell(theme, '이름', isHeader: true),
                _buildTableCell(theme, '국어', isHeader: true),
                _buildTableCell(theme, '영어', isHeader: true),
                _buildTableCell(theme, '수학', isHeader: true),
                _buildTableCell(theme, '평균', isHeader: true),
              ],
            ),
            // 데이터
            ...students.map((student) {
              final avg = ((student.$2 + student.$3 + student.$4) / 3)
                  .toStringAsFixed(1);
              return TableRow(
                children: [
                  _buildTableCell(theme, student.$1),
                  _buildTableCell(theme, '${student.$2}'),
                  _buildTableCell(theme, '${student.$3}'),
                  _buildTableCell(theme, '${student.$4}'),
                  _buildTableCell(
                    theme,
                    avg,
                    textColor: theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  // 가격표 테이블
  Widget _buildPriceTable(ThemeData theme) {
    final items = [
      ('기본 플랜', '월 9,900원', '✓', '✓', '✗'),
      ('프로 플랜', '월 19,900원', '✓', '✓', '✓'),
      ('엔터프라이즈', '문의', '✓', '✓', '✓'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Table(
          border: TableBorder.symmetric(
            inside: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            // 헤더
            TableRow(
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.5),
              ),
              children: [
                _buildTableCell(theme, '플랜', isHeader: true),
                _buildTableCell(theme, '가격', isHeader: true),
                _buildTableCell(theme, '기능A', isHeader: true),
                _buildTableCell(theme, '기능B', isHeader: true),
                _buildTableCell(theme, '기능C', isHeader: true),
              ],
            ),
            // 데이터
            ...items.map((item) => TableRow(
                  children: [
                    _buildTableCell(theme, item.$1, fontWeight: FontWeight.w600),
                    _buildTableCell(
                      theme,
                      item.$2,
                      textColor: theme.colorScheme.tertiary,
                      fontWeight: FontWeight.bold,
                    ),
                    _buildTableCell(
                      theme,
                      item.$3,
                      textColor: item.$3 == '✓'
                          ? Colors.green
                          : theme.colorScheme.outline,
                    ),
                    _buildTableCell(
                      theme,
                      item.$4,
                      textColor: item.$4 == '✓'
                          ? Colors.green
                          : theme.colorScheme.outline,
                    ),
                    _buildTableCell(
                      theme,
                      item.$5,
                      textColor: item.$5 == '✓'
                          ? Colors.green
                          : theme.colorScheme.outline,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  // 테이블 셀
  Widget _buildTableCell(
    ThemeData theme,
    String text, {
    bool isHeader = false,
    Color? backgroundColor,
    Color? textColor,
    FontWeight? fontWeight,
  }) {
    return Container(
      height: isHeader ? 44 : 40,
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Center(
        child: Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: fontWeight ?? (isHeader ? FontWeight.bold : FontWeight.normal),
            color: textColor ?? (isHeader ? theme.colorScheme.onSurfaceVariant : null),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
