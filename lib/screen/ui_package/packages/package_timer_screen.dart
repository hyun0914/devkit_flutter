import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../widget/example_widgets.dart';

class PackageTimerScreen extends StatelessWidget {
  const PackageTimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final targetTime = DateTime.now().add(
      const Duration(
        days: 5,
        hours: 14,
        minutes: 27,
        seconds: 34,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('타이머 & 카운트다운'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              '타이머 & 카운트다운',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '다양한 카운트다운 타이머',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // TimerCountdown
            const SectionHeader('TimerCountdown'),
            const SizedBox(height: 12),
            ExampleCard(
              title: '일/시/분/초',
              description: 'days:hours:minutes:seconds',
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: TimerCountdown(
                    format: CountDownTimerFormat.daysHoursMinutesSeconds,
                    endTime: targetTime,
                    onEnd: () {
                      debugPrint('Timer finished');
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ExampleCard(
              title: '일/시/분 (설명 제거)',
              description: 'days:hours:minutes without labels',
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: TimerCountdown(
                    format: CountDownTimerFormat.daysHoursMinutes,
                    enableDescriptions: false,
                    endTime: targetTime,
                    onEnd: () {
                      debugPrint('Timer finished');
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ExampleCard(
              title: '시간만 표시',
              description: 'hours only with descriptions',
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: TimerCountdown(
                    format: CountDownTimerFormat.hoursOnly,
                    enableDescriptions: true,
                    endTime: targetTime,
                    onEnd: () {
                      debugPrint('Timer finished');
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // SlideCountdown
            const SectionHeader('SlideCountdown'),
            const SizedBox(height: 12),
            ExampleCard(
              title: '슬라이드 카운트다운',
              description: '기본 스타일',
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: const Center(
                  child: SlideCountdown(
                    duration: Duration(days: 2, hours: 5, minutes: 30),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ExampleCard(
              title: '분리된 스타일',
              description: '각 숫자가 개별 박스',
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: const Center(
                  child: SlideCountdownSeparated(
                    duration: Duration(days: 2, hours: 5, minutes: 30),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ExampleCard(
              title: '제목 포함 + 위로 슬라이드',
              description: 'separatorType: title, slideDirection: up',
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: const Center(
                  child: SlideCountdown(
                    duration: Duration(days: 2, hours: 5, minutes: 30),
                    separatorType: SeparatorType.title,
                    slideDirection: SlideDirection.up,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ExampleCard(
              title: '카운트 업 (증가)',
              description: 'countUp: true',
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.2),
                      theme.colorScheme.secondary.withValues(alpha: 0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: SlideCountdown(
                    duration: Duration(hours: 1, minutes: 30),
                    countUp: true,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 포맷 비교표
            const SectionHeader('TimerCountdown 포맷'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            '포맷',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '표시',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildFormatRow(theme, 'daysHoursMinutesSeconds', 'D:H:M:S'),
                  _buildFormatRow(theme, 'daysHoursMinutes', 'D:H:M'),
                  _buildFormatRow(theme, 'daysHours', 'D:H'),
                  _buildFormatRow(theme, 'daysOnly', 'D'),
                  _buildFormatRow(theme, 'hoursMinutesSeconds', 'H:M:S'),
                  _buildFormatRow(theme, 'hoursMinutes', 'H:M'),
                  _buildFormatRow(theme, 'hoursOnly', 'H'),
                  _buildFormatRow(theme, 'minutesSeconds', 'M:S'),
                  _buildFormatRow(theme, 'minutesOnly', 'M'),
                  _buildFormatRow(theme, 'secondsOnly', 'S'),
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
                        '💡 사용 팁',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const InfoItem('TimerCountdown: 다양한 포맷 지원'),
                  const InfoItem('SlideCountdown: 애니메이션 효과'),
                  const InfoItem('onEnd: 타이머 종료 콜백'),
                  const InfoItem('countUp: 증가 카운터로 변경 가능'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  // 포맷 행
  Widget _buildFormatRow(ThemeData theme, String format, String display) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              format,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              display,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

}