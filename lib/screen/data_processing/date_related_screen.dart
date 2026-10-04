import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../widget/example_widgets.dart';

class DateRelatedScreen extends StatefulWidget {
  const DateRelatedScreen({super.key});

  @override
  State<DateRelatedScreen> createState() => _DateRelatedScreenState();
}

class _DateRelatedScreenState extends State<DateRelatedScreen> {
  final DateTime _today = DateTime.now();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('날짜 처리'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              '날짜 처리 방법',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '현재 날짜, 비교, 포맷팅 등',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 16),

            // 현재 날짜 표시
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primaryContainer,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                spacing: 8,
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: theme.colorScheme.onPrimary,
                    size: 32,
                  ),
                  Text(
                    DateFormat('yyyy년 MM월 dd일 (E)', 'ko_KR').format(_today),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('HH:mm:ss').format(_today),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 기본 날짜 연산
            const SectionHeader('기본 날짜 연산'),
            const SizedBox(height: 12),
            ExampleCard(
              title: '날짜 더하기/빼기',
              description: 'add() / subtract() 사용',
              code: 'today.add(Duration(days: 7))',
              child: FilledButton(
                onPressed: () {
                  final yesterday = _today.subtract(const Duration(days: 1));
                  final tomorrow = _today.add(const Duration(days: 1));
                  final nextWeek = _today.add(const Duration(days: 7));

                  showResultDialog(
                    context,
                    '날짜 연산',
                    '어제: ${DateFormat('yyyy-MM-dd').format(yesterday)}\n'
                        '오늘: ${DateFormat('yyyy-MM-dd').format(_today)}\n'
                        '내일: ${DateFormat('yyyy-MM-dd').format(tomorrow)}\n'
                        '다음 주: ${DateFormat('yyyy-MM-dd').format(nextWeek)}',
                  );
                },
                child: const Text('실행'),
              ),
            ),
            const SizedBox(height: 12),
            ExampleCard(
              title: '날짜 차이 계산',
              description: 'difference() 사용',
              code: 'date1.difference(date2)',
              child: FilledButton(
                onPressed: () {
                  final targetDate = DateTime(2024, 12, 31);
                  final diff = targetDate.difference(_today);

                  showResultDialog(
                    context,
                    '날짜 차이',
                    '목표: ${DateFormat('yyyy-MM-dd').format(targetDate)}\n'
                        '현재: ${DateFormat('yyyy-MM-dd').format(_today)}\n\n'
                        '차이: ${diff.inDays}일\n'
                        '또는: ${diff.inHours}시간\n'
                        '또는: ${diff.inMinutes}분',
                  );
                },
                child: const Text('실행'),
              ),
            ),
            const SizedBox(height: 12),
            ExampleCard(
              title: '날짜 비교',
              description: 'compareTo() 사용 (-1, 0, 1)',
              code: 'date1.compareTo(date2)',
              child: FilledButton(
                onPressed: () {
                  final pastDate = _today.subtract(const Duration(days: 10));
                  final futureDate = _today.add(const Duration(days: 10));

                  final result1 = _today.compareTo(pastDate);
                  final result2 = _today.compareTo(futureDate);

                  showResultDialog(
                    context,
                    '날짜 비교',
                    '과거 날짜와 비교: $result1 (양수 = 미래)\n'
                        '미래 날짜와 비교: $result2 (음수 = 과거)\n\n'
                        'compareTo 반환값:\n'
                        '• -1: 과거\n'
                        '• 0: 동일\n'
                        '• 1: 미래',
                  );
                },
                child: const Text('실행'),
              ),
            ),

            const SizedBox(height: 24),

            // 날짜 포맷팅
            const SectionHeader('날짜 포맷팅'),
            const SizedBox(height: 12),
            ExampleCard(
              title: 'DateFormat 사용',
              description: 'intl 패키지 사용',
              code: "DateFormat('yyyy-MM-dd').format(date)",
              child: FilledButton(
                onPressed: () {
                  showResultDialog(
                    context,
                    '날짜 포맷팅',
                    "yyyy-MM-dd: ${DateFormat('yyyy-MM-dd').format(_today)}\n"
                        "yyyy.MM.dd: ${DateFormat('yyyy.MM.dd').format(_today)}\n"
                        "yy/MM/dd: ${DateFormat('yy/MM/dd').format(_today)}\n"
                        "yyyy년 M월 d일: ${DateFormat('yyyy년 M월 d일').format(_today)}\n"
                        "EEEE: ${DateFormat('EEEE', 'ko_KR').format(_today)}\n"
                        "E: ${DateFormat('E', 'ko_KR').format(_today)}\n"
                        "HH:mm:ss: ${DateFormat('HH:mm:ss').format(_today)}",
                  );
                },
                child: const Text('다양한 포맷 보기'),
              ),
            ),
            const SizedBox(height: 12),
            ExampleCard(
              title: '시간 제외하고 날짜만',
              description: '3가지 방법',
              code: 'DateTime(year, month, day)',
              child: FilledButton(
                onPressed: () {
                  final method1 = DateTime(_today.year, _today.month, _today.day);
                  final method2 = _today.toIso8601String().split('T')[0];
                  final method3 = DateFormat('yyyy-MM-dd').format(_today);

                  showResultDialog(
                    context,
                    '시간 제외',
                    '방법 1 (DateTime): $method1\n'
                        '방법 2 (ISO split): $method2\n'
                        '방법 3 (DateFormat): $method3',
                  );
                },
                child: const Text('실행'),
              ),
            ),

            const SizedBox(height: 24),

            // 특수 날짜 계산
            const SectionHeader('특수 날짜 계산'),
            const SizedBox(height: 12),
            ExampleCard(
              title: '이번 주 월~일 날짜',
              description: 'weekday 속성 활용',
              code: 'today.weekday (1=월 ~ 7=일)',
              child: FilledButton(
                onPressed: () {
                  final monday = _today.subtract(Duration(days: _today.weekday - 1));
                  final sunday = _today.add(Duration(days: 7 - _today.weekday));

                  final weekDates = <String>[];
                  for (int i = 0; i < 7; i++) {
                    final date = monday.add(Duration(days: i));
                    final dayName = DateFormat('E', 'ko_KR').format(date);
                    weekDates.add('${DateFormat('MM/dd').format(date)} ($dayName)');
                  }

                  showResultDialog(
                    context,
                    '이번 주',
                    '월요일: ${DateFormat('yyyy-MM-dd').format(monday)}\n'
                        '일요일: ${DateFormat('yyyy-MM-dd').format(sunday)}\n\n'
                        '${weekDates.join('\n')}',
                  );
                },
                child: const Text('실행'),
              ),
            ),
            const SizedBox(height: 12),
            ExampleCard(
              title: '이번 달 첫날/마지막날',
              description: 'DateTime 생성자 활용',
              code: 'DateTime(year, month + 1, 0)',
              child: FilledButton(
                onPressed: () {
                  final firstDay = DateTime(_today.year, _today.month, 1);
                  final lastDay = DateTime(_today.year, _today.month + 1, 0);

                  showResultDialog(
                    context,
                    '이번 달',
                    '첫날: ${DateFormat('yyyy-MM-dd (E)', 'ko_KR').format(firstDay)}\n'
                        '마지막날: ${DateFormat('yyyy-MM-dd (E)', 'ko_KR').format(lastDay)}\n'
                        '총 일수: ${lastDay.day}일',
                  );
                },
                child: const Text('실행'),
              ),
            ),
            const SizedBox(height: 12),
            ExampleCard(
              title: 'D-Day 계산',
              description: '목표 날짜까지 남은 일수',
              code: 'target.difference(today).inDays',
              child: FilledButton(
                onPressed: () {
                  final targetDate = DateTime(2025, 1, 1);
                  final diff = targetDate.difference(_today);

                  String dDay;
                  if (diff.inDays > 0) {
                    dDay = 'D-${diff.inDays}';
                  } else if (diff.inDays < 0) {
                    dDay = 'D+${-diff.inDays}';
                  } else {
                    dDay = 'D-Day';
                  }

                  showResultDialog(
                    context,
                    'D-Day',
                    '목표: ${DateFormat('yyyy-MM-dd').format(targetDate)}\n'
                        '현재: ${DateFormat('yyyy-MM-dd').format(_today)}\n\n'
                        '$dDay\n'
                        '(${diff.inDays}일 ${diff.inDays > 0 ? '남음' : '지남'})',
                  );
                },
                child: const Text('실행'),
              ),
            ),

            const SizedBox(height: 24),

            // 문자열 변환
            const SectionHeader('문자열 ↔ DateTime 변환'),
            const SizedBox(height: 12),
            ExampleCard(
              title: 'String → DateTime',
              description: 'DateTime.parse() 사용',
              code: "DateTime.parse('2024-12-25')",
              child: FilledButton(
                onPressed: () {
                  final dateStr1 = '2024-12-25';
                  final dateStr2 = '2024.12.25';

                  final parsed1 = DateTime.parse(dateStr1);
                  final parsed2 = DateTime.parse(
                    dateStr2.replaceAll(RegExp(r'\D'), ''),
                  );

                  showResultDialog(
                    context,
                    '문자열 → DateTime',
                    '입력 1: "$dateStr1"\n'
                        '결과 1: $parsed1\n\n'
                        '입력 2: "$dateStr2"\n'
                        '정규식 처리: "${dateStr2.replaceAll(RegExp(r'\D'), '')}"\n'
                        '결과 2: $parsed2',
                  );
                },
                child: const Text('실행'),
              ),
            ),

            const SizedBox(height: 24),

            // 유용한 속성
            const SectionHeader('유용한 DateTime 속성'),
            const SizedBox(height: 12),
            _buildMethodCard(
              theme: theme,
              property: 'year / month / day',
              description: '연/월/일 추출',
              example: 'today.year → ${_today.year}',
            ),
            const SizedBox(height: 8),
            _buildMethodCard(
              theme: theme,
              property: 'hour / minute / second',
              description: '시/분/초 추출',
              example: 'today.hour → ${_today.hour}',
            ),
            const SizedBox(height: 8),
            _buildMethodCard(
              theme: theme,
              property: 'weekday',
              description: '요일 (1=월 ~ 7=일)',
              example: 'today.weekday → ${_today.weekday}',
            ),
            const SizedBox(height: 8),
            _buildMethodCard(
              theme: theme,
              property: 'millisecondsSinceEpoch',
              description: 'Unix timestamp',
              example: 'today.millisecondsSinceEpoch',
            ),
            const SizedBox(height: 8),
            _buildMethodCard(
              theme: theme,
              property: 'isAfter() / isBefore()',
              description: '날짜 비교 (boolean)',
              example: 'today.isAfter(yesterday) → true',
            ),

            const SizedBox(height: 24),

            // 정보 카드
            InfoBox(
              icon: Icons.info_outline,
              title: '💡 주요 패키지',
              children: [
                const InfoItem('intl: 날짜 포맷팅 (DateFormat)'),
                const InfoItem('DateTime: Dart 기본 클래스'),
                const InfoItem('Duration: 시간 간격 표현'),
              ],
            ),
          ],
        ),
      ),
    );
  }



  // 메서드 카드
  Widget _buildMethodCard({
    required ThemeData theme,
    required String property,
    required String description,
    required String example,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              property,
              style: theme.textTheme.labelMedium?.copyWith(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  example,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}