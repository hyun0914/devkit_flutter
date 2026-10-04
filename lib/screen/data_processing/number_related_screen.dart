import 'package:flutter/material.dart';
import 'dart:math';

import '../widget/example_widgets.dart';

class NumberRelatedScreen extends StatefulWidget {
  const NumberRelatedScreen({super.key});

  @override
  State<NumberRelatedScreen> createState() => _NumberRelatedScreenState();
}

class _NumberRelatedScreenState extends State<NumberRelatedScreen> {
  String _randomResult = '';
  int _randomNumber = 0;

  String _generateRandomString({int length = 6}) {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return String.fromCharCodes(
      Iterable.generate(
        length,
            (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  int _generateRandomNumber({int min = 1, int max = 100}) {
    final random = Random();
    return min + random.nextInt(max - min + 1);
  }

  void _showResult(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text(title),
          content: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              content,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontFamily: 'monospace',
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('숫자 처리'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              '숫자 처리 방법',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '랜덤 생성, 올림/내림, 반올림 등',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // 랜덤 생성
            const SectionHeader('랜덤 생성'),
            const SizedBox(height: 12),
            ExampleCard(
              title: '랜덤 문자열 생성',
              description: '영문 대소문자 + 숫자 조합',
              code: 'Random().nextInt()',
              child: Column(
                spacing: 12,
                children: [
                  if (_randomResult.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _randomResult,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  FilledButton.icon(
                    onPressed: () {
                      setState(() {
                        _randomResult = _generateRandomString();
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('새로 생성'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ExampleCard(
              title: '랜덤 숫자 생성',
              description: '1 ~ 100 범위의 랜덤 정수',
              code: 'Random().nextInt(100)',
              child: Column(
                spacing: 12,
                children: [
                  if (_randomNumber > 0)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$_randomNumber',
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSecondaryContainer,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  FilledButton.icon(
                    onPressed: () {
                      setState(() {
                        _randomNumber = _generateRandomNumber();
                      });
                    },
                    icon: const Icon(Icons.casino),
                    label: const Text('주사위 굴리기 (1~100)'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 절댓값
            const SectionHeader('절댓값 변환'),
            const SizedBox(height: 12),
            ExampleCard(
              title: 'abs() - 절댓값',
              description: '음수를 양수로 변환',
              code: 'number.abs()',
              child: FilledButton(
                onPressed: () {
                  const minusNumber = -10;
                  final absNumber = minusNumber.abs();
                  _showResult(
                    context,
                    'abs() 결과',
                    '원본: $minusNumber\n절댓값: $absNumber',
                  );
                },
                child: const Text('실행'),
              ),
            ),

            const SizedBox(height: 24),

            // 소수점 처리
            const SectionHeader('소수점 처리'),
            const SizedBox(height: 12),
            ExampleCard(
              title: 'ceil() - 올림',
              description: '소수점 이하를 올림',
              code: 'number.ceil()',
              child: Column(
                spacing: 8,
                children: [
                  _buildDecimalExample(theme, 4.1, (n) => n.ceil(), '5'),
                  _buildDecimalExample(theme, 4.9, (n) => n.ceil(), '5'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ExampleCard(
              title: 'floor() - 내림',
              description: '소수점 이하를 버림',
              code: 'number.floor()',
              child: Column(
                spacing: 8,
                children: [
                  _buildDecimalExample(theme, 4.1, (n) => n.floor(), '4'),
                  _buildDecimalExample(theme, 4.9, (n) => n.floor(), '4'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ExampleCard(
              title: 'round() - 반올림',
              description: '0.5 기준으로 반올림',
              code: 'number.round()',
              child: Column(
                spacing: 8,
                children: [
                  _buildDecimalExample(theme, 4.4, (n) => n.round(), '4'),
                  _buildDecimalExample(theme, 4.5, (n) => n.round(), '5'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ExampleCard(
              title: 'toStringAsFixed() - 소수점 고정',
              description: '소수점 자릿수 지정',
              code: 'number.toStringAsFixed(2)',
              child: Column(
                spacing: 8,
                children: [
                  _buildDecimalStringExample(theme, 4.9999, 0, '5'),
                  _buildDecimalStringExample(theme, 4.9999, 1, '5.0'),
                  _buildDecimalStringExample(theme, 4.9999, 2, '5.00'),
                  _buildDecimalStringExample(theme, 4.9999, 3, '5.000'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 기타 메서드
            const SectionHeader('기타 유용한 메서드'),
            const SizedBox(height: 12),
            MethodCard(
              method: 'clamp()',
              description: '범위 제한',
              example: '10.clamp(0, 5) → 5',
            ),
            const SizedBox(height: 8),
            MethodCard(
              method: 'toInt()',
              description: 'double → int 변환',
              example: '4.9.toInt() → 4',
            ),
            const SizedBox(height: 8),
            MethodCard(
              method: 'toDouble()',
              description: 'int → double 변환',
              example: '5.toDouble() → 5.0',
            ),
            const SizedBox(height: 8),
            MethodCard(
              method: 'isNaN / isInfinite',
              description: 'NaN / 무한대 체크',
              example: '(0/0).isNaN → true',
            ),
            const SizedBox(height: 8),
            MethodCard(
              method: 'isEven / isOdd',
              description: '짝수 / 홀수 확인',
              example: '4.isEven → true, 5.isOdd → true',
            ),

            const SizedBox(height: 24),

            // 정보 카드
            InfoBox(
              icon: Icons.info_outline,
              title: '💡 주의사항',
              children: [
                const InfoItem('ceil, floor, round는 정수(int) 반환'),
                const InfoItem('toStringAsFixed는 문자열(String) 반환'),
                const InfoItem('Random은 import "dart:math" 필요'),
              ],
            ),
          ],
        ),
      ),
    );
  }



  // 소수점 예제
  Widget _buildDecimalExample(
      ThemeData theme,
      double value,
      int Function(double) operation,
      String result,
      ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            '$value',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.arrow_forward, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            result,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  // 소수점 문자열 예제
  Widget _buildDecimalStringExample(
      ThemeData theme,
      double value,
      int fractionDigits,
      String result,
      ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            'toStringAsFixed($fractionDigits)',
            style: theme.textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Icon(Icons.arrow_forward, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            '"$result"',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }


}