import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

import '../widget/default_scaffold.dart';

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

    return DefaultScaffold(
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
            _buildSectionHeader(theme, '공백 제거'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
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
            _buildExampleCard(
              theme: theme,
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
            _buildExampleCard(
              theme: theme,
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
            _buildSectionHeader(theme, '문자열 포맷팅'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
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
            _buildExampleCard(
              theme: theme,
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
            _buildSectionHeader(theme, '기타 유용한 메서드'),
            const SizedBox(height: 12),
            _buildMethodCard(
              theme: theme,
              method: 'toUpperCase()',
              description: '대문자로 변환',
              example: '"hello".toUpperCase() → "HELLO"',
            ),
            const SizedBox(height: 8),
            _buildMethodCard(
              theme: theme,
              method: 'toLowerCase()',
              description: '소문자로 변환',
              example: '"HELLO".toLowerCase() → "hello"',
            ),
            const SizedBox(height: 8),
            _buildMethodCard(
              theme: theme,
              method: 'split()',
              description: '문자열 분리',
              example: '"a,b,c".split(",") → ["a", "b", "c"]',
            ),
            const SizedBox(height: 8),
            _buildMethodCard(
              theme: theme,
              method: 'substring()',
              description: '부분 문자열 추출',
              example: '"hello".substring(0, 3) → "hel"',
            ),
            const SizedBox(height: 8),
            _buildMethodCard(
              theme: theme,
              method: 'contains()',
              description: '문자열 포함 여부',
              example: '"hello".contains("ll") → true',
            ),
            const SizedBox(height: 8),
            _buildMethodCard(
              theme: theme,
              method: 'startsWith() / endsWith()',
              description: '시작/끝 문자열 확인',
              example: '"hello".startsWith("he") → true',
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
                        '💡 권장 사항',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'String Interpolation 우선 사용 (더 간결)',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'sprintf는 복잡한 포맷팅에만 사용',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'RegExp는 성능이 필요하면 재사용',
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
    required String method,
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
              method,
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