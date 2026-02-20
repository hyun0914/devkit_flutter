import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';

import '../widget/default_scaffold.dart';

class TextWidgetScreen extends StatelessWidget {
  const TextWidgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('Text 위젯'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 섹션: 텍스트 높이
          _buildSection(
            theme: theme,
            title: '텍스트 높이 (Line Height)',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildExampleCard(
                  theme: theme,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      Text(
                        'height: 1.0 (기본)',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.0,
                        ),
                      ),
                      Text(
                        'height: 1.5 (넓은 간격)\n여러 줄일 때 차이가 명확합니다.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.5,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        'height: 2.0 (매우 넓음)\n줄 간격이 아주 넓어집니다.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 2.0,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                _buildCodeHint(
                  theme: theme,
                  code: 'height: 1.5  // Line height % Text Size',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 섹션: 텍스트 오버플로우
          _buildSection(
            theme: theme,
            title: '텍스트 오버플로우',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildExampleCard(
                  theme: theme,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      // Ellipsis 예제
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 4,
                          children: [
                            Text(
                              'Ellipsis (...)',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const Text(
                              '제목테스트123456789101112131415',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),

                      // Fade 예제
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 4,
                          children: [
                            Text(
                              'Fade (서서히 사라짐)',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const Text(
                              '제목테스트123456789101112131415',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              softWrap: false,
                            ),
                          ],
                        ),
                      ),

                      // Clip 예제
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 4,
                          children: [
                            Text(
                              'Clip (잘라냄)',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const Text(
                              '제목테스트123456789101112131415',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                _buildCodeHint(
                  theme: theme,
                  code: 'overflow: TextOverflow.ellipsis\nmaxLines: 1',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 섹션: RichText (부분 스타일)
          _buildSection(
            theme: theme,
            title: 'RichText - 부분별 스타일 적용',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildExampleCard(
                  theme: theme,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      // RichText 방식
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          Text(
                            '① RichText 위젯',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: theme.textTheme.bodyLarge,
                              children: const [
                                TextSpan(
                                  text: '텍스트 ',
                                  style: TextStyle(color: Colors.brown),
                                ),
                                TextSpan(
                                  text: '텍스트10 ',
                                  style: TextStyle(
                                    color: Colors.indigo,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: '각각 스타일 적용',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const Divider(),

                      // Text.rich 방식
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          Text(
                            '② Text.rich 위젯',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              style: theme.textTheme.bodyLarge,
                              children: const [
                                TextSpan(
                                  text: '텍스트 ',
                                  style: TextStyle(color: Colors.brown),
                                ),
                                TextSpan(
                                  text: '텍스트10 ',
                                  style: TextStyle(
                                    color: Colors.indigo,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: '각각 스타일 적용',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const Divider(),

                      // EasyRichText 방식
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          Text(
                            '③ EasyRichText 패키지 (추천)',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          EasyRichText(
                            '텍스트 텍스트10 각각 스타일 적용',
                            defaultStyle: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.brown,
                            ),
                            patternList: const [
                              EasyRichTextPattern(
                                targetString: '텍스트10',
                                style: TextStyle(
                                  color: Colors.indigo,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              EasyRichTextPattern(
                                targetString: '각각 스타일 적용',
                                style: TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                _buildCodeHint(
                  theme: theme,
                  code: 'Text.rich(TextSpan(children: [...]))',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 도움말 카드
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
              spacing: 8,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '💡 참고',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  '• RichText: 복잡한 텍스트 스타일에 사용\n'
                  '• EasyRichText: 패턴 기반으로 더 간단하게 사용\n'
                  '• overflow: 텍스트가 넘칠 때 처리 방법 지정',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 섹션 헤더
  Widget _buildSection({
    required ThemeData theme,
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  // 예제 카드
  Widget _buildExampleCard({
    required ThemeData theme,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: child,
    );
  }

  // 코드 힌트
  Widget _buildCodeHint({
    required ThemeData theme,
    required String code,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.code,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              code,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
