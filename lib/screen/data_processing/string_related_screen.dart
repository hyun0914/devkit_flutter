import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

import '../widget/example_widgets.dart';

class StringRelatedScreen extends StatelessWidget {
  const StringRelatedScreen({super.key});

  void _showResult(BuildContext context, String title, String before, String after) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Text(
                '변경 전:',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '"$before"',
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '변경 후:',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '"$after"',
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ],
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

  void _showSprintfResult(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: const Text('sprintf 결과'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              _buildSprintfItem(
                theme,
                '%s (문자열)',
                sprintf('%s', ['Hello']),
                "sprintf('%s', ['Hello'])",
              ),
              _buildSprintfItem(
                theme,
                '%d (정수)',
                sprintf('%d', [1004]),
                "sprintf('%d', [1004])",
              ),
              _buildSprintfItem(
                theme,
                '%.2f (소수)',
                sprintf('%.2f', [1004.1004]),
                "sprintf('%.2f', [1004.1004])",
              ),
              _buildSprintfItem(
                theme,
                '%x (16진수)',
                sprintf('%x', [255]),
                "sprintf('%x', [255])",
              ),
              _buildSprintfItem(
                theme,
                '%05d (0 패딩)',
                sprintf('%05d', [42]),
                "sprintf('%05d', [42])",
              ),
            ],
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

  Widget _buildSprintfItem(
      ThemeData theme,
      String label,
      String result,
      String code,
      ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          Text(
            code,
            style: theme.textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            '→ "$result"',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const str01 = '    Flutter에서 문자열의 공백을 제거하는 방법    ';
    const str02 = 'Flutter에서 문자열의 공백을 제거하는 방법';

    return Scaffold(
      appBar: AppBar(
        title: const Text('문자열 처리'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              '문자열 처리 방법',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '다양한 문자열 조작 및 포맷팅 기능',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // 공백 제거
            const SectionHeader('공백 제거'),
            const SizedBox(height: 12),
            ExampleCard(
              title: 'trim() - 앞뒤 공백 제거',
              description: '문자열 양쪽 끝의 공백만 제거',
              code: 'str.trim()',
              child: FilledButton(
                onPressed: () {
                  final trimmed = str01.trim();
                  _showResult(context, 'trim()', str01, trimmed);
                },
                child: const Text('실행'),
              ),
            ),
            const SizedBox(height: 12),
            ExampleCard(
              title: 'replaceAll() - 모든 공백 제거',
              description: '문자열 내 모든 공백 제거',
              code: "str.replaceAll(' ', '')",
              child: FilledButton(
                onPressed: () {
                  final replaced = str02.replaceAll(' ', '');
                  _showResult(context, 'replaceAll()', str02, replaced);
                },
                child: const Text('실행'),
              ),
            ),
            const SizedBox(height: 12),
            ExampleCard(
              title: 'RegExp - 정규식으로 공백 제거',
              description: '공백, 탭, 줄바꿈 모두 제거',
              code: r"str.replaceAll(RegExp(r'\s+'), '')",
              child: FilledButton(
                onPressed: () {
                  final replaced = str02.replaceAll(RegExp(r'\s+'), '');
                  _showResult(context, 'RegExp', str02, replaced);
                },
                child: const Text('실행'),
              ),
            ),

            const SizedBox(height: 24),

            // 문자열 포맷팅
            const SectionHeader('문자열 포맷팅'),
            const SizedBox(height: 12),
            ExampleCard(
              title: 'sprintf - C 스타일 포맷팅',
              description: '%s, %d, %f, %x 등 다양한 포맷 지원',
              code: "sprintf('%s %d', ['text', 123])",
              child: FilledButton(
                onPressed: () {
                  _showSprintfResult(context);
                },
                child: const Text('예제 보기'),
              ),
            ),
            const SizedBox(height: 12),
            ExampleCard(
              title: 'String Interpolation',
              description: 'Dart의 기본 문자열 보간',
              code: r"'Hello $name, age: $age'",
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Text(
                          '간단한 변수:',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          r"'이름: $name'",
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '표현식:',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          r"'합계: ${a + b}'",
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 기타 문자열 메서드
            const SectionHeader('기타 유용한 메서드'),
            const SizedBox(height: 12),
            MethodCard(
              method: 'toUpperCase()',
              description: '대문자로 변환',
              example: '"hello".toUpperCase() → "HELLO"',
            ),
            const SizedBox(height: 8),
            MethodCard(
              method: 'toLowerCase()',
              description: '소문자로 변환',
              example: '"HELLO".toLowerCase() → "hello"',
            ),
            const SizedBox(height: 8),
            MethodCard(
              method: 'split()',
              description: '문자열 분리',
              example: '"a,b,c".split(",") → ["a", "b", "c"]',
            ),
            const SizedBox(height: 8),
            MethodCard(
              method: 'substring()',
              description: '부분 문자열 추출',
              example: '"hello".substring(0, 3) → "hel"',
            ),
            const SizedBox(height: 8),
            MethodCard(
              method: 'contains()',
              description: '문자열 포함 여부',
              example: '"hello".contains("ll") → true',
            ),
            const SizedBox(height: 8),
            MethodCard(
              method: 'startsWith() / endsWith()',
              description: '시작/끝 문자열 확인',
              example: '"hello".startsWith("he") → true',
            ),

            const SizedBox(height: 24),

            // 정보 카드
            InfoBox(
              icon: Icons.info_outline,
              title: '💡 권장 사항',
              children: [
                const InfoItem('String Interpolation 우선 사용 (더 간결)'),
                const InfoItem('sprintf는 복잡한 포맷팅에만 사용'),
                const InfoItem('RegExp는 성능이 필요하면 재사용'),
              ],
            ),
          ],
        ),
      ),
    );
  }




}