import 'dart:ui' as ui;

import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

import '../widget/default_scaffold.dart';

class DottedBorderScreen extends StatelessWidget {
  const DottedBorderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('Dotted Border & Line'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 헤더
          Text(
            'Dotted Border & Line 예제',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '점선 테두리와 점선을 3가지 방법으로 비교합니다',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 24),

          // 비교 카드
          _buildComparisonCard(theme),

          const SizedBox(height: 24),

          // ── 1. 기본 위젯 (CustomPaint) ──
          _buildSectionHeader(theme, '1. 기본 위젯 (CustomPaint)'),
          const SizedBox(height: 4),
          Text(
            '패키지 없이 직접 구현 - 코드가 복잡하지만 의존성 없음',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),

          // CustomPaint - 점선 테두리
          _buildExampleCard(
            theme: theme,
            title: '점선 테두리 (Rect)',
            child: CustomPaint(
              painter: _DashedBorderPainter(
                color: theme.colorScheme.primary,
                strokeWidth: 2,
                dashWidth: 8,
                dashSpace: 4,
                radius: 8,
              ),
              child: Container(
                width: double.infinity,
                height: 80,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                child: const Text('CustomPaint 점선 테두리'),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // CustomPaint - 점선
          _buildExampleCard(
            theme: theme,
            title: '점선 (Line)',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                const Text('수평 점선'),
                CustomPaint(
                  painter: _DashedLinePainter(
                    color: theme.colorScheme.primary,
                    strokeWidth: 2,
                    dashWidth: 8,
                    dashSpace: 4,
                  ),
                  child: const SizedBox(width: double.infinity, height: 2),
                ),
                const Text('수직 점선'),
                SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      CustomPaint(
                        painter: _DashedLinePainter(
                          color: theme.colorScheme.primary,
                          strokeWidth: 2,
                          dashWidth: 8,
                          dashSpace: 4,
                          isVertical: true,
                        ),
                        child: const SizedBox(width: 2, height: 60),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── 2. dotted_border 패키지 ──
          _buildSectionHeader(theme, '2. dotted_border 패키지'),
          const SizedBox(height: 4),
          Text(
            '위젯 테두리에 특화 - 간단한 코드로 다양한 형태 구현',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),

          // Rect
          _buildExampleCard(
            theme: theme,
            title: 'Rect (직사각형)',
            child: Center(
              child: DottedBorder(
                options: RectDottedBorderOptions(
                  color: theme.colorScheme.primary,
                  strokeWidth: 2,
                  dashPattern: const [8, 4],
                  padding: const EdgeInsets.all(12),
                ),
                child: const Text('Rect 점선 테두리'),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // RoundedRect
          _buildExampleCard(
            theme: theme,
            title: 'RoundedRect (둥근 직사각형)',
            child: Center(
              child: DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  color: theme.colorScheme.secondary,
                  strokeWidth: 2,
                  dashPattern: const [8, 4],
                  radius: const Radius.circular(16),
                  padding: const EdgeInsets.all(12),
                ),
                child: const Text('RoundedRect 점선 테두리'),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Circular
          _buildExampleCard(
            theme: theme,
            title: 'Circular (원형)',
            child: Center(
              child: DottedBorder(
                options: CircularDottedBorderOptions(
                  color: theme.colorScheme.tertiary,
                  strokeWidth: 2,
                  dashPattern: const [6, 4],
                  padding: const EdgeInsets.all(16),
                ),
                child: const SizedBox(
                  width: 80,
                  height: 80,
                  child: Icon(Icons.add_photo_alternate_outlined, size: 40),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 실제 활용 - 파일 업로드 영역
          _buildExampleCard(
            theme: theme,
            title: '실제 활용 - 파일 업로드 영역',
            child: DottedBorder(
              options: RoundedRectDottedBorderOptions(
                color: theme.colorScheme.primary,
                strokeWidth: 2,
                dashPattern: const [10, 6],
                radius: const Radius.circular(12),
                padding: const EdgeInsets.all(0),
              ),
              child: Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 40,
                      color: theme.colorScheme.primary,
                    ),
                    Text(
                      '파일을 드래그하거나 클릭하세요',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'PNG, JPG, PDF 최대 10MB',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ── 3. dotted_line 패키지 ──
          _buildSectionHeader(theme, '3. dotted_line 패키지'),
          const SizedBox(height: 4),
          Text(
            '선(Line) 그리기에 특화 - 수평/수직 점선을 쉽게 구현',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),

          // 기본 사용
          _buildExampleCard(
            theme: theme,
            title: '기본 수평 점선',
            child: const DottedLine(),
          ),
          const SizedBox(height: 12),

          // 커스텀 점선
          _buildExampleCard(
            theme: theme,
            title: '커스텀 점선',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                // 대시 패턴
                const Text('긴 대시'),
                DottedLine(
                  dashLength: 16,
                  dashGapLength: 8,
                  lineThickness: 2,
                  dashColor: theme.colorScheme.primary,
                ),
                const Text('짧은 점선'),
                DottedLine(
                  dashLength: 3,
                  dashGapLength: 3,
                  lineThickness: 2,
                  dashRadius: 2,
                  dashColor: theme.colorScheme.secondary,
                ),
                const Text('두꺼운 점선'),
                DottedLine(
                  dashLength: 8,
                  dashGapLength: 6,
                  lineThickness: 4,
                  dashColor: theme.colorScheme.tertiary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 수직 점선
          _buildExampleCard(
            theme: theme,
            title: '수직 점선',
            child: SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DottedLine(
                    direction: Axis.vertical,
                    dashColor: theme.colorScheme.primary,
                    lineThickness: 2,
                    dashLength: 6,
                  ),
                  DottedLine(
                    direction: Axis.vertical,
                    dashColor: theme.colorScheme.secondary,
                    lineThickness: 2,
                    dashLength: 3,
                    dashGapLength: 3,
                    dashRadius: 2,
                  ),
                  DottedLine(
                    direction: Axis.vertical,
                    dashColor: theme.colorScheme.tertiary,
                    lineThickness: 4,
                    dashLength: 8,
                    dashGapLength: 6,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 실제 활용 - 타임라인
          _buildExampleCard(
            theme: theme,
            title: '실제 활용 - 타임라인',
            child: Column(
              children: [
                _buildTimelineItem(
                  theme: theme,
                  icon: Icons.check_circle,
                  color: theme.colorScheme.primary,
                  title: '주문 완료',
                  subtitle: '2024.01.15 10:00',
                  isLast: false,
                ),
                _buildTimelineItem(
                  theme: theme,
                  icon: Icons.local_shipping_outlined,
                  color: theme.colorScheme.secondary,
                  title: '배송 중',
                  subtitle: '2024.01.16 14:30',
                  isLast: false,
                ),
                _buildTimelineItem(
                  theme: theme,
                  icon: Icons.home_outlined,
                  color: theme.colorScheme.onSurfaceVariant,
                  title: '배송 완료 예정',
                  subtitle: '2024.01.17',
                  isLast: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 정리 카드
          _buildSummaryCard(theme),

          const SizedBox(height: 24),
        ],
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
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  // 예제 카드 래퍼
  Widget _buildExampleCard({
    required ThemeData theme,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
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
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          child,
        ],
      ),
    );
  }

  // 비교 카드
  Widget _buildComparisonCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Row(
            children: [
              Icon(Icons.compare_arrows, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                '언제 무엇을 쓸까?',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          _buildComparisonRow(
            theme: theme,
            icon: Icons.code,
            method: 'CustomPaint',
            useCase: '의존성 없이 완전한 커스터마이징이 필요할 때',
          ),
          _buildComparisonRow(
            theme: theme,
            icon: Icons.border_style,
            method: 'dotted_border',
            useCase: '위젯에 점선 테두리를 간단히 추가할 때',
          ),
          _buildComparisonRow(
            theme: theme,
            icon: Icons.horizontal_rule,
            method: 'dotted_line',
            useCase: '구분선, 타임라인 등 점선이 필요할 때',
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonRow({
    required ThemeData theme,
    required IconData icon,
    required String method,
    required String useCase,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.bodySmall,
              children: [
                TextSpan(
                  text: '$method: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                TextSpan(
                  text: useCase,
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 타임라인 아이템
  Widget _buildTimelineItem({
    required ThemeData theme,
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              if (!isLast)
                SizedBox(
                  height: 40,
                  child: CustomPaint(
                    painter: _DashedLinePainter(
                      color: theme.colorScheme.outline,
                      strokeWidth: 1.5,
                      dashWidth: 4,
                      dashSpace: 3,
                      isVertical: true,
                    ),
                    size: const Size(2, 40),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 정리 카드
  Widget _buildSummaryCard(ThemeData theme) {
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
              Icon(Icons.lightbulb_outline, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                '💡 핵심 정리',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          _buildSummaryItem(theme, Icons.check, 'dotted_border ^3.1.0 - options 파라미터로 BorderType 선택'),
          _buildSummaryItem(theme, Icons.check, 'dotted_line ^3.2.3 - direction으로 수평/수직 전환'),
          _buildSummaryItem(theme, Icons.check, 'CustomPaint - 패키지 없이 구현, 코드 복잡도 높음'),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(ThemeData theme, IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.primary),
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

// ── CustomPaint Painters ──

// 점선 테두리 Painter
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double radius;

  _DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.dashWidth = 8,
    this.dashSpace = 4,
    this.radius = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );

    _drawDashedPath(canvas, paint, path);
  }

  void _drawDashedPath(Canvas canvas, Paint paint, Path path) {
    final ui.PathMetrics pathMetrics = path.computeMetrics();
    for (final ui.PathMetric metric in pathMetrics) {
      double distance = 0;
      bool draw = true;
      while (distance < metric.length) {
        final len = draw ? dashWidth : dashSpace;
        if (draw) {
          canvas.drawPath(
            metric.extractPath(distance, distance + len),
            paint,
          );
        }
        distance += len;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color ||
          oldDelegate.strokeWidth != strokeWidth ||
          oldDelegate.dashWidth != dashWidth ||
          oldDelegate.dashSpace != dashSpace;
}

// 점선 Painter
class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final bool isVertical;

  _DashedLinePainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.dashWidth = 8,
    this.dashSpace = 4,
    this.isVertical = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double start = 0;
    final total = isVertical ? size.height : size.width;

    while (start < total) {
      if (isVertical) {
        canvas.drawLine(
          Offset(0, start),
          Offset(0, (start + dashWidth).clamp(0, total)),
          paint,
        );
      } else {
        canvas.drawLine(
          Offset(start, 0),
          Offset((start + dashWidth).clamp(0, total), 0),
          paint,
        );
      }
      start += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) =>
      oldDelegate.color != color ||
          oldDelegate.isVertical != isVertical;
}