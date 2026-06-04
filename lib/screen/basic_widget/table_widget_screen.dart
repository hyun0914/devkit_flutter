import 'package:flutter/material.dart';

import '../widget/default_scaffold.dart';

class TableWidgetScreen extends StatefulWidget {
  const TableWidgetScreen({super.key});

  @override
  State<TableWidgetScreen> createState() => _TableWidgetScreenState();
}

class _TableWidgetScreenState extends State<TableWidgetScreen> {
  // DataTable 정렬 상태
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  // DataTable 행 선택 상태
  final List<bool> _selected = [false, false, false, false];

  final _employees = <Map<String, dynamic>>[
    {'name': '김철수', 'dept': '개발팀', 'salary': 4500000, 'years': 3},
    {'name': '이영희', 'dept': '디자인팀', 'salary': 4200000, 'years': 5},
    {'name': '박민수', 'dept': '개발팀', 'salary': 5000000, 'years': 7},
    {'name': '최지연', 'dept': '기획팀', 'salary': 3800000, 'years': 2},
  ];

  late List<Map<String, dynamic>> _sortedEmployees;

  @override
  void initState() {
    super.initState();
    _sortedEmployees = List.from(_employees);
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      const keys = ['name', 'dept', 'salary', 'years'];
      final key = keys[columnIndex];
      _sortedEmployees.sort((a, b) {
        final av = a[key];
        final bv = b[key];
        final cmp = av is String
            ? av.compareTo(bv as String)
            : (av as int).compareTo(bv as int);
        return ascending ? cmp : -cmp;
      });
    });
  }

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
            // ── Table 섹션 헤더 ──────────────────────────────────────────
            Text(
              'Table 위젯 예제',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '커스텀 레이아웃에 적합한 저수준 테이블',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),
            _buildSectionHeader(theme, '기본 테이블'),
            const SizedBox(height: 12),
            _buildBasicTable(theme),

            const SizedBox(height: 24),
            _buildSectionHeader(theme, '월별 통계'),
            const SizedBox(height: 12),
            _buildMonthlyStatsTable(theme),

            const SizedBox(height: 24),
            _buildSectionHeader(theme, '성적표'),
            const SizedBox(height: 12),
            _buildGradeTable(theme),

            const SizedBox(height: 24),
            _buildSectionHeader(theme, '가격표'),
            const SizedBox(height: 12),
            _buildPriceTable(theme),

            // ── DataTable 구분 ───────────────────────────────────────────
            const SizedBox(height: 32),
            Divider(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
            const SizedBox(height: 16),

            Text(
              'DataTable 위젯 예제',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Material Design 표준 — 정렬·행 선택 기능 내장',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),
            _buildSectionHeader(theme, '기본 DataTable'),
            const SizedBox(height: 12),
            _buildBasicDataTable(theme),

            const SizedBox(height: 24),
            _buildSectionHeader(theme, 'DataTable (컬럼 정렬)'),
            const SizedBox(height: 4),
            Text(
              '헤더를 탭하면 오름/내림차순으로 정렬됩니다',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            _buildSortableDataTable(theme),

            const SizedBox(height: 24),
            _buildSectionHeader(theme, 'DataTable (행 선택)'),
            const SizedBox(height: 4),
            Text(
              '체크박스로 행을 선택할 수 있습니다',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            _buildSelectableDataTable(theme),

            const SizedBox(height: 24),
            _buildInfoCard(theme),
          ],
        ),
      ),
    );
  }

  // ── DataTable: 기본 ────────────────────────────────────────────────────────
  Widget _buildBasicDataTable(ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(
          theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
        ),
        border: TableBorder.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        columns: const [
          DataColumn(label: Text('이름')),
          DataColumn(label: Text('부서')),
          DataColumn(label: Text('연봉'), numeric: true),
          DataColumn(label: Text('연차'), numeric: true),
        ],
        rows: _employees
            .map((e) => DataRow(cells: [
                  DataCell(Text(e['name'] as String)),
                  DataCell(Text(e['dept'] as String)),
                  DataCell(Text('${(e['salary'] as int) ~/ 10000}만원')),
                  DataCell(Text('${e['years']}년')),
                ]))
            .toList(),
      ),
    );
  }

  // ── DataTable: 정렬 ────────────────────────────────────────────────────────
  Widget _buildSortableDataTable(ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAscending,
        headingRowColor: WidgetStateProperty.all(
          theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
        ),
        border: TableBorder.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        columns: [
          DataColumn(
            label: const Text('이름'),
            onSort: _onSort,
          ),
          DataColumn(
            label: const Text('부서'),
            onSort: _onSort,
          ),
          DataColumn(
            label: const Text('연봉'),
            numeric: true,
            onSort: _onSort,
          ),
          DataColumn(
            label: const Text('연차'),
            numeric: true,
            onSort: _onSort,
          ),
        ],
        rows: _sortedEmployees
            .map((e) => DataRow(cells: [
                  DataCell(Text(e['name'] as String)),
                  DataCell(Text(e['dept'] as String)),
                  DataCell(Text('${(e['salary'] as int) ~/ 10000}만원')),
                  DataCell(Text('${e['years']}년')),
                ]))
            .toList(),
      ),
    );
  }

  // ── DataTable: 행 선택 ─────────────────────────────────────────────────────
  Widget _buildSelectableDataTable(ThemeData theme) {
    final selectedCount = _selected.where((s) => s).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: selectedCount > 0
              ? Padding(
                  key: const ValueKey('count'),
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle,
                          size: 16, color: theme.colorScheme.primary),
                      const SizedBox(width: 6),
                      Text(
                        '$selectedCount개 선택됨',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(key: ValueKey('empty')),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
              theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
            ),
            border: TableBorder.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            columns: const [
              DataColumn(label: Text('이름')),
              DataColumn(label: Text('부서')),
              DataColumn(label: Text('연봉'), numeric: true),
              DataColumn(label: Text('연차'), numeric: true),
            ],
            rows: List.generate(
              _employees.length,
              (i) => DataRow(
                selected: _selected[i],
                onSelectChanged: (val) =>
                    setState(() => _selected[i] = val ?? false),
                cells: [
                  DataCell(Text(_employees[i]['name'] as String)),
                  DataCell(Text(_employees[i]['dept'] as String)),
                  DataCell(Text(
                      '${(_employees[i]['salary'] as int) ~/ 10000}만원')),
                  DataCell(Text('${_employees[i]['years']}년')),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── 섹션 헤더 ──────────────────────────────────────────────────────────────
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

  // ── 기본 테이블 ────────────────────────────────────────────────────────────
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
            TableRow(
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
              ),
              children: [
                _buildTableCell(theme, '항목', isHeader: true),
                _buildTableCell(theme, '수량', isHeader: true),
                _buildTableCell(theme, '단위', isHeader: true),
              ],
            ),
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

  // ── 월별 통계 테이블 ────────────────────────────────────────────────────────
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
                for (int i = 0; i < months.length; i++)
                  TableRow(
                    children: [
                      _buildTableCell(
                        theme,
                        months[i],
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                      ),
                      _buildTableCell(theme, '${data[i][0]}'),
                      _buildTableCell(theme, '${data[i][1]}'),
                      _buildTableCell(theme, '${data[i][2]}'),
                      _buildTableCell(theme, '${data[i][3]}'),
                    ],
                  ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
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
                      _buildTableCell(theme, '합계',
                          isHeader: true,
                          textColor: theme.colorScheme.primary),
                      _buildTableCell(theme, '${totals[0]}',
                          isHeader: true,
                          textColor: theme.colorScheme.primary),
                      _buildTableCell(theme, '${totals[1]}',
                          isHeader: true,
                          textColor: theme.colorScheme.primary),
                      _buildTableCell(theme, '${totals[2]}',
                          isHeader: true,
                          textColor: theme.colorScheme.primary),
                      _buildTableCell(theme, '${totals[3]}',
                          isHeader: true,
                          textColor: theme.colorScheme.primary),
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

  // ── 성적표 테이블 ──────────────────────────────────────────────────────────
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
            TableRow(
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
              ),
              children: [
                _buildTableCell(theme, '이름', isHeader: true),
                _buildTableCell(theme, '국어', isHeader: true),
                _buildTableCell(theme, '영어', isHeader: true),
                _buildTableCell(theme, '수학', isHeader: true),
                _buildTableCell(theme, '평균', isHeader: true),
              ],
            ),
            ...students.map((student) {
              final avg =
                  ((student.$2 + student.$3 + student.$4) / 3).toStringAsFixed(1);
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

  // ── 가격표 테이블 ──────────────────────────────────────────────────────────
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
            TableRow(
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.tertiaryContainer.withValues(alpha: 0.5),
              ),
              children: [
                _buildTableCell(theme, '플랜', isHeader: true),
                _buildTableCell(theme, '가격', isHeader: true),
                _buildTableCell(theme, '기능A', isHeader: true),
                _buildTableCell(theme, '기능B', isHeader: true),
                _buildTableCell(theme, '기능C', isHeader: true),
              ],
            ),
            ...items.map((item) => TableRow(
                  children: [
                    _buildTableCell(theme, item.$1,
                        fontWeight: FontWeight.w600),
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

  // ── 테이블 셀 ──────────────────────────────────────────────────────────────
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
            fontWeight:
                fontWeight ?? (isHeader ? FontWeight.bold : FontWeight.normal),
            color: textColor ??
                (isHeader ? theme.colorScheme.onSurfaceVariant : null),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // ── 정보 카드 ──────────────────────────────────────────────────────────────
  Widget _buildInfoCard(ThemeData theme) {
    return Container(
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
              Icon(Icons.info_outline,
                  color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                '💡 Table vs DataTable',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          _buildInfoSection(
            theme,
            'Table',
            '• columnWidths: 열 너비 지정\n'
                '• border: 테두리 스타일\n'
                '• defaultVerticalAlignment: 수직 정렬\n'
                '• TableRow / FlexColumnWidth\n'
                '→ 자유로운 커스텀 레이아웃에 적합',
          ),
          Divider(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
          _buildInfoSection(
            theme,
            'DataTable',
            '• DataColumn(onSort, numeric): 정렬 가능한 헤더\n'
                '• DataRow(selected, onSelectChanged): 행 선택·체크박스\n'
                '• sortColumnIndex / sortAscending: 정렬 상태 표시\n'
                '• PaginatedDataTable: 페이지네이션 확장\n'
                '→ 정렬·선택이 필요한 데이터 목록에 적합',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(ThemeData theme, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
