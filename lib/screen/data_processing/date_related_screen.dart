import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../widget/default_scaffold.dart';

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

  void _showResult(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text(title),
          content: Container(
            constraints: const BoxConstraints(maxHeight: 400),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  content,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
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
            _buildSectionHeader(theme, '기본 날짜 연산'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '날짜 더하기/빼기',
              description: 'add() / subtract() 사용',
              code: 'today.add(Duration(days: 7))',
              child: FilledButton(
                onPressed: () {
                  final yesterday = _today.subtract(const Duration(days: 1));
                  final tomorrow = _today.add(const Duration(days: 1));
                  final nextWeek = _today.add(const Duration(days: 7));

                  _showResult(
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
            _buildExampleCard(
              theme: theme,
              title: '날짜 차이 계산',
              description: 'difference() 사용',
              code: 'date1.difference(date2)',
              child: FilledButton(
                onPressed: () {
                  final targetDate = DateTime(2024, 12, 31);
                  final diff = targetDate.difference(_today);

                  _showResult(
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
            _buildExampleCard(
              theme: theme,
              title: '날짜 비교',
              description: 'compareTo() 사용 (-1, 0, 1)',
              code: 'date1.compareTo(date2)',
              child: FilledButton(
                onPressed: () {
                  final pastDate = _today.subtract(const Duration(days: 10));
                  final futureDate = _today.add(const Duration(days: 10));

                  final result1 = _today.compareTo(pastDate);
                  final result2 = _today.compareTo(futureDate);

                  _showResult(
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
            _buildSectionHeader(theme, '날짜 포맷팅'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'DateFormat 사용',
              description: 'intl 패키지 사용',
              code: "DateFormat('yyyy-MM-dd').format(date)",
              child: FilledButton(
                onPressed: () {
                  _showResult(
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
            _buildExampleCard(
              theme: theme,
              title: '시간 제외하고 날짜만',
              description: '3가지 방법',
              code: 'DateTime(year, month, day)',
              child: FilledButton(
                onPressed: () {
                  final method1 = DateTime(_today.year, _today.month, _today.day);
                  final method2 = _today.toIso8601String().split('T')[0];
                  final method3 = DateFormat('yyyy-MM-dd').format(_today);

                  _showResult(
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
            _buildSectionHeader(theme, '특수 날짜 계산'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
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

                  _showResult(
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
            _buildExampleCard(
              theme: theme,
              title: '이번 달 첫날/마지막날',
              description: 'DateTime 생성자 활용',
              code: 'DateTime(year, month + 1, 0)',
              child: FilledButton(
                onPressed: () {
                  final firstDay = DateTime(_today.year, _today.month, 1);
                  final lastDay = DateTime(_today.year, _today.month + 1, 0);

                  _showResult(
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
            _buildExampleCard(
              theme: theme,
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

                  _showResult(
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
            _buildSectionHeader(theme, '문자열 ↔ DateTime 변환'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
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

                  _showResult(
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
            _buildSectionHeader(theme, '유용한 DateTime 속성'),
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
                        '💡 주요 패키지',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'intl: 날짜 포맷팅 (DateFormat)',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'DateTime: Dart 기본 클래스',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'Duration: 시간 간격 표현',
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
    required String code,
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              code,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 4),
          child,
        ],
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