import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:d_chart/d_chart.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart' as geekyants;

import '../../widget/default_scaffold.dart';

class PackageChartScreen extends StatefulWidget {
  const PackageChartScreen({super.key});

  @override
  State<PackageChartScreen> createState() => _PackageChartScreenState();
}

class _PackageChartScreenState extends State<PackageChartScreen> {
  double _gaugeValue = 30;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('차트 & 게이지'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              '차트 & 게이지',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '데이터 시각화 위젯',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // DChart - Pie Chart
            _buildSectionHeader(theme, 'DChart - Pie Chart'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '파이 차트',
              description: '원형 차트',
              child: AspectRatio(
                aspectRatio: 1.4,
                child: DChartPieO(
                  data: [
                    OrdinalData(
                      domain: '판매',
                      measure: 70,
                      color: const Color(0xFF119F6F),
                    ),
                    OrdinalData(
                      domain: '기본',
                      measure: 20,
                      color: const Color(0xFFF75A5D),
                    ),
                    OrdinalData(
                      domain: '구매',
                      measure: 10,
                      color: const Color(0xFFF0F0F0),
                    ),
                  ],
                  configRenderPie: const ConfigRenderPie(
                    arcWidth: 20,
                    arcLength: 7 / 5 * 3.14,
                    startAngle: 4 / 5 * 3.14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '도넛 차트',
              description: '중앙이 빈 파이 차트',
              child: AspectRatio(
                aspectRatio: 1.4,
                child: DChartPieO(
                  data: [
                    OrdinalData(
                      domain: 'A',
                      measure: 40,
                      color: theme.colorScheme.primary,
                    ),
                    OrdinalData(
                      domain: 'B',
                      measure: 30,
                      color: theme.colorScheme.secondary,
                    ),
                    OrdinalData(
                      domain: 'C',
                      measure: 20,
                      color: theme.colorScheme.tertiary,
                    ),
                    OrdinalData(
                      domain: 'D',
                      measure: 10,
                      color: Colors.grey,
                    ),
                  ],
                  configRenderPie: const ConfigRenderPie(
                    arcWidth: 30,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // DChart - Bar Chart
            _buildSectionHeader(theme, 'DChart - Single Bar'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '단일 바 차트',
              description: '프로그레스 바',
              child: Column(
                spacing: 16,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8,
                          children: [
                            Text(
                              '판매 (80%)',
                              style: theme.textTheme.labelMedium,
                            ),
                            const SizedBox(
                              height: 10,
                              child: DChartSingleBar(
                                radius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                foregroundColor: Color(0xFF119F6F),
                                backgroundColor: Color(0xFFDBDBDB),
                                value: 80,
                                max: 100,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8,
                          children: [
                            Text(
                              '반품 (20%)',
                              style: theme.textTheme.labelMedium,
                            ),
                            const SizedBox(
                              height: 10,
                              child: DChartSingleBar(
                                radius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                foregroundColor: Color(0xFFF75A5D),
                                backgroundColor: Color(0xFFDBDBDB),
                                value: 20,
                                max: 100,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '양방향 바 차트',
              description: '좌우 반전 효과',
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 10,
                      child: Transform.rotate(
                        angle: 180 * math.pi / 180,
                        child: const DChartSingleBar(
                          radius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          foregroundColor: Color(0xFF119F6F),
                          backgroundColor: Color(0xFFDBDBDB),
                          value: 80,
                          max: 100,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 10,
                      child: const DChartSingleBar(
                        radius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        foregroundColor: Color(0xFFF75A5D),
                        backgroundColor: Color(0xFFDBDBDB),
                        value: 20,
                        max: 100,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Gauge Indicator
            _buildSectionHeader(theme, 'Gauge Indicator'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '애니메이션 게이지',
              description: '값 조절 가능',
              child: Column(
                spacing: 16,
                children: [
                  AnimatedRadialGauge(
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInBack,
                    radius: 100,
                    value: _gaugeValue,
                    builder: (context, child, value) {
                      return RadialGaugeLabel(
                        value: value,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                    axis: GaugeAxis(
                      min: 0,
                      max: 100,
                      degrees: 180,
                      style: GaugeAxisStyle(
                        thickness: 15,
                        background: Colors.grey.shade300,
                        segmentSpacing: 2,
                      ),
                      pointer: const GaugePointer.triangle(
                        borderRadius: 2,
                        width: 20,
                        height: 20,
                        color: Color(0xFF193663),
                      ),
                      progressBar: GaugeProgressBar.rounded(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  Slider(
                    value: _gaugeValue,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: _gaugeValue.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _gaugeValue = value;
                      });
                    },
                  ),
                  Text(
                    '값: ${_gaugeValue.round()}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '원형 게이지',
              description: '360도 게이지',
              child: Center(
                child: AnimatedRadialGauge(
                  duration: const Duration(seconds: 1),
                  radius: 100,
                  value: 75,
                  builder: (context, child, value) {
                    return RadialGaugeLabel(
                      value: value,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    );
                  },
                  axis: GaugeAxis(
                    min: 0,
                    max: 100,
                    degrees: 360,
                    style: GaugeAxisStyle(
                      thickness: 20,
                      background: theme.colorScheme.surfaceContainerHighest,
                      segmentSpacing: 4,
                    ),
                    pointer: const GaugePointer.circle(
                      radius: 12,
                      color: Colors.transparent,
                    ),
                    progressBar: GaugeProgressBar.rounded(
                      gradient: GaugeAxisGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Geekyants Gauges
            _buildSectionHeader(theme, 'Geekyants Gauges'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '다양한 게이지',
              description: 'Linear & Radial Gauge',
              child: Column(
                spacing: 16,
                children: [
                  geekyants.LinearGauge(
                    rulers: geekyants.RulerStyle(
                      primaryRulerColor: theme.colorScheme.primary,
                      secondaryRulerColor: theme.colorScheme.secondary,
                      textStyle: TextStyle(
                        color: theme.colorScheme.onSurface,
                      ),
                      rulerPosition: geekyants.RulerPosition.bottom,
                    ),
                  ),
                  geekyants.RadialGauge(
                    track: geekyants.RadialTrack(
                      start: 0,
                      end: 100,
                      color: theme.colorScheme.surfaceContainerHighest,
                      trackStyle: geekyants.TrackStyle(
                        primaryRulersHeight: 8,
                        secondaryRulersHeight: 5,
                        primaryRulerColor: theme.colorScheme.outline,
                        secondaryRulerColor:
                        theme.colorScheme.outline.withValues(alpha: 0.5),
                      ),
                    ),
                    needlePointer: [
                      geekyants.NeedlePointer(
                        value: 30,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Transform 예제
            _buildSectionHeader(theme, 'Transform (회전/반전)'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '좌우 반전',
              description: 'Matrix4.rotationY(π)',
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      color: Colors.yellow,
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey,
                      child: const Center(
                        child: Text(
                          '반전',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '상하 반전',
              description: 'Matrix4.rotationX(π)',
              child: Center(
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationX(math.pi),
                  child: Container(
                    width: 100,
                    height: 60,
                    color: Colors.yellow,
                    child: const Center(
                      child: Text(
                        '반전',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 정보 카드
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
                        '💡 사용 팁',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'DChart: 간단한 차트 (Pie, Bar)',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'Gauge Indicator: 애니메이션 게이지',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'Geekyants Gauges: Linear & Radial',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'Transform: 위젯 회전/반전',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'import "dart:math" as math 필요',
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