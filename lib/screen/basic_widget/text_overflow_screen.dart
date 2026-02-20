import 'package:flutter/material.dart';

import '../widget/default_scaffold.dart';

class TextOverflowScreen extends StatelessWidget {
  const TextOverflowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('텍스트 Overflow'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              '텍스트 Overflow 처리',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '긴 텍스트를 제한된 공간에 표시하는 방법',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // 1. Clip
            _buildExampleCard(
              theme: theme,
              title: 'TextOverflow.clip',
              description: '넘치는 텍스트를 잘라냄 (보이지 않음)',
              icon: Icons.content_cut,
              color: Colors.red,
              child: const Text(
                '12345678910 가나다라마바사아자차카타파하 12345678910 가나다라마바사아자차카타파하 12345678910 가나다라마바사아자차카타파하',
                style: TextStyle(fontSize: 16, overflow: TextOverflow.clip),
              ),
            ),

            const SizedBox(height: 16),

            // 2. Fade
            _buildExampleCard(
              theme: theme,
              title: 'TextOverflow.fade',
              description: '넘치는 텍스트를 점진적으로 투명하게',
              icon: Icons.gradient,
              color: Colors.orange,
              child: const Text(
                '12345678910 가나다라마바사아자차카타파하 12345678910 가나다라마바사아자차카타파하 12345678910 가나다라마바사아자차카타파하',
                style: TextStyle(fontSize: 16, overflow: TextOverflow.fade),
                softWrap: false,
              ),
            ),

            const SizedBox(height: 16),

            // 3. Ellipsis (추천)
            _buildExampleCard(
              theme: theme,
              title: 'TextOverflow.ellipsis ⭐',
              description: '넘치는 텍스트를 ... 으로 표시 (가장 많이 사용)',
              icon: Icons.more_horiz,
              color: Colors.green,
              child: const Text(
                '12345678910 가나다라마바사아자차카타파하 12345678910 가나다라마바사아자차카타파하 12345678910 가나다라마바사아자차카타파하',
                style: TextStyle(fontSize: 16, overflow: TextOverflow.ellipsis),
                maxLines: 3,
              ),
            ),

            const SizedBox(height: 16),

            // 4. Visible
            _buildExampleCard(
              theme: theme,
              title: 'TextOverflow.visible',
              description: '넘치는 텍스트가 영역을 벗어나 표시됨',
              icon: Icons.visibility,
              color: Colors.blue,
              child: const Text(
                '12345678910 가나다라마바사아자차카타파하 12345678910 가나다라마바사아자차카타파하 12345678910 가나다라마바사아자차카타파하',
                style: TextStyle(fontSize: 16, overflow: TextOverflow.visible),
              ),
            ),

            const SizedBox(height: 24),

            // maxLines 비교
            _buildSectionHeader(theme, 'maxLines 활용'),
            const SizedBox(height: 12),

            _buildExampleCard(
              theme: theme,
              title: 'maxLines: 1',
              description: '한 줄로 제한',
              icon: Icons.looks_one,
              color: theme.colorScheme.primary,
              child: const Text(
                '12345678910 가나다라마바사아자차카타파하 12345678910 가나다라마바사아자차카타파하',
                style: TextStyle(fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 12),

            _buildExampleCard(
              theme: theme,
              title: 'maxLines: 2',
              description: '두 줄로 제한',
              icon: Icons.looks_two,
              color: theme.colorScheme.secondary,
              child: const Text(
                '12345678910 가나다라마바사아자차카타파하 12345678910 가나다라마바사아자차카타파하',
                style: TextStyle(fontSize: 16),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 12),

            _buildExampleCard(
              theme: theme,
              title: 'maxLines: 3',
              description: '세 줄로 제한',
              icon: Icons.looks_3,
              color: theme.colorScheme.tertiary,
              child: const Text(
                '12345678910 가나다라마바사아자차카타파하 12345678910 가나다라마바사아자차카타파하',
                style: TextStyle(fontSize: 16),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 24),

            // 비교 표
            _buildSectionHeader(theme, '비교표'),
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
                  // 헤더
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
                          flex: 2,
                          child: Text(
                            'Overflow',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            '설명',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildTableRow(theme, 'clip', '잘라냄'),
                  _buildTableRow(theme, 'fade', '페이드 아웃'),
                  _buildTableRow(theme, 'ellipsis', '... 표시 ⭐'),
                  _buildTableRow(theme, 'visible', '영역 벗어남'),
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
                  _buildInfoItem(
                    theme: theme,
                    text: 'ellipsis가 가장 많이 사용됨',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'fade는 softWrap: false와 함께 사용',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'maxLines로 줄 수 제한 가능',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'visible은 디버깅 용도로 유용',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildExampleCard({
    required ThemeData theme,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 콘텐츠
          Container(
            width: double.infinity,
            height: 88,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(ThemeData theme, String overflow, String description) {
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
            flex: 2,
            child: Text(
              overflow,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              description,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

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