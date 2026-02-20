import 'dart:math';

import 'package:bodychart_heatmap/bodychart_heatmap.dart';
import 'package:contribution_heatmap/contribution_heatmap.dart';
import 'package:fl_heatmap/fl_heatmap.dart';
import 'package:flutter/material.dart';

import '../widget/default_scaffold.dart';

class HeatmapScreen extends StatefulWidget {
  const HeatmapScreen({super.key});

  @override
  State<HeatmapScreen> createState() => _HeatmapScreenState();
}

class _HeatmapScreenState extends State<HeatmapScreen> {
  // contribution_heatmap 데이터
  late List<ContributionEntry> _contributionEntries;

  // fl_heatmap 데이터
  late HeatmapData _flHeatmapData;
  HeatmapItem? _selectedFlHeatmapItem;

  // bodychart_heatmap 데이터
  final Map<String, int> _bodyHeatmapData = {
    "chest": 8,
    "back": 6,
    "arm": 10,
    "leg": 5,
    "butt": 7,
    "shoulder": 4,
    "neck": 2,
    "abs": 9,
  };

  final Set<String> _selectedBodyParts = {"chest", "arm", "abs", "leg"};

  @override
  void initState() {
    super.initState();
    _initContributionData();
    _initFlHeatmapData();
  }

  // contribution_heatmap 데이터 초기화
  void _initContributionData() {
    final random = Random();
    final now = DateTime.now();
    _contributionEntries = [];

    // 최근 365일 데이터 생성
    for (int i = 0; i < 365; i++) {
      final date = now.subtract(Duration(days: i));
      final count = random.nextInt(15); // 0~14
      if (count > 0) {
        _contributionEntries.add(ContributionEntry(date, count));
      }
    }
  }

  // fl_heatmap 데이터 초기화
  void _initFlHeatmapData() {
    const rows = ['2025', '2024', '2023', '2022'];
    const columns = [
      '1월',
      '2월',
      '3월',
      '4월',
      '5월',
      '6월',
      '7월',
      '8월',
      '9월',
      '10월',
      '11월',
      '12월'
    ];

    final random = Random();
    const String unit = '건';

    _flHeatmapData = HeatmapData(
      rows: rows,
      columns: columns,
      items: [
        for (int row = 0; row < rows.length; row++)
          for (int col = 0; col < columns.length; col++)
            HeatmapItem(
              value: random.nextDouble() * 100,
              unit: unit,
              xAxisLabel: columns[col],
              yAxisLabel: rows[row],
            ),
      ],
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(ThemeData theme, String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('히트맵 시각화'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목
            Text(
              '히트맵 (Heatmap)',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '데이터를 색상으로 시각화하는 3가지 방법',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // 1. contribution_heatmap (GitHub 스타일)
            _buildSectionHeader(theme, '1. GitHub 스타일 기여도 차트'),
            const SizedBox(height: 8),
            _buildInfoCard(
              theme,
              '깃허브 contribution 차트 - 날짜별 활동 추적',
            ),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📊 최근 1년 활동 기록',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ContributionHeatmap(
                          entries: _contributionEntries,
                          cellSize: 12,
                          onCellTap: (date, value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${date.year}-${date.month}-${date.day}: $value건',
                                ),
                                duration: const Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '💡 활용: 습관 추적, 운동 기록, 공부 시간',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 2. fl_heatmap (데이터 테이블)
            _buildSectionHeader(theme, '2. 데이터 매트릭스 히트맵'),
            const SizedBox(height: 8),
            _buildInfoCard(
              theme,
              '행×열 데이터 시각화 - 년도별/월별 비교',
            ),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '📈 년도별 월간 통계',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        if (_selectedFlHeatmapItem != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '${_selectedFlHeatmapItem!.yAxisLabel} ${_selectedFlHeatmapItem!.xAxisLabel}: ${_selectedFlHeatmapItem!.value.toStringAsFixed(0)}${_selectedFlHeatmapItem!.unit}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),
                    Heatmap(
                      heatmapData: _flHeatmapData,
                      onItemSelectedListener: (item) {
                        setState(() {
                          _selectedFlHeatmapItem = item;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '💡 활용: 판매 데이터, 트래픽 분석, 전력 소비',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 3. bodychart_heatmap (신체 부위)
            _buildSectionHeader(theme, '3. 신체 부위 히트맵'),
            const SizedBox(height: 8),
            _buildInfoCard(
              theme,
              '인체 부위별 강도 시각화 - 피트니스/재활 앱용',
            ),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💪 운동 부위별 강도',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // BodyHeatmap
                          Column(
                            children: [
                              Text(
                                '강도 표시',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              BodyHeatmap(
                                selectedParts: _bodyHeatmapData,
                                baseColor: Colors.red,
                                width: 140,
                                showLegend: true,
                                intensityLevels: 3,
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          // BodyChart
                          Column(
                            children: [
                              Text(
                                '선택 부위',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              BodyChart(
                                selectedParts: _selectedBodyParts,
                                selectedColor: Colors.green,
                                viewType: BodyViewType.both,
                                width: 140,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '💡 활용: 운동 기록, 재활 치료, 통증 추적',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 비교표
            _buildSectionHeader(theme, '패키지 비교'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  _buildComparisonRow(
                    theme,
                    '📦 패키지',
                    ['contribution_heatmap', 'fl_heatmap', 'bodychart_heatmap'],
                  ),
                  _buildComparisonRow(
                    theme,
                    '🎯 용도',
                    ['활동 추적 (달력)', '데이터 분석 (테이블)', '신체 부위 (인체)'],
                  ),
                  _buildComparisonRow(
                    theme,
                    '📱 활용',
                    ['습관/운동 앱', '통계/분석 앱', '피트니스/의료 앱'],
                  ),
                  _buildComparisonRow(
                    theme,
                    '🎨 스타일',
                    ['GitHub 기여도', 'Excel 히트맵', '인체 다이어그램'],
                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 사용된 패키지
            _buildSectionHeader(theme, '사용된 패키지'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
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
                        '💡 패키지 목록',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  _buildPackageItem(
                      theme, 'contribution_heatmap', 'GitHub 스타일 기여도 차트'),
                  _buildPackageItem(theme, 'fl_heatmap', '데이터 매트릭스 히트맵'),
                  _buildPackageItem(
                      theme, 'bodychart_heatmap', '신체 부위 히트맵'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonRow(
      ThemeData theme,
      String label,
      List<String> values, {
        bool isLast = false,
      }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: values.map((value) {
                    return Expanded(
                      child: Text(
                        value,
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
      ],
    );
  }

  Widget _buildPackageItem(ThemeData theme, String name, String description) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            name,
            style: theme.textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}