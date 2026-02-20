import 'package:flutter/material.dart';

import '../widget/default_scaffold.dart';

class ValueListenableBuilderScreen extends StatefulWidget {
  const ValueListenableBuilderScreen({super.key});

  @override
  State<ValueListenableBuilderScreen> createState() => _ValueListenableBuilderScreenState();
}

class _ValueListenableBuilderScreenState extends State<ValueListenableBuilderScreen> {
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  final ValueNotifier<String> _text = ValueNotifier<String>('Hello');
  final ValueNotifier<Color> _color = ValueNotifier<Color>(Colors.blue);
  final ValueNotifier<bool> _isLiked = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _counter.dispose();
    _text.dispose();
    _color.dispose();
    _isLiked.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('ValueListenableBuilder'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              'ValueListenableBuilder',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'setState 없이 위젯만 다시 빌드',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 16),

            // 설명 카드
            Container(
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
                spacing: 8,
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
                        'ValueListenableBuilder란?',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '• setState()보다 효율적인 상태 관리\n'
                        '• 해당 위젯만 다시 빌드 (성능 향상)\n'
                        '• ValueNotifier와 함께 사용',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 예제 1: 카운터
            _buildSectionHeader(theme, '예제 1: 카운터'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                spacing: 16,
                children: [
                  ValueListenableBuilder<int>(
                    valueListenable: _counter,
                    builder: (context, value, child) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
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
                              Icons.pin_outlined,
                              color: theme.colorScheme.onPrimary,
                              size: 40,
                            ),
                            Text(
                              '$value',
                              style: theme.textTheme.displayLarge?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '카운트',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Row(
                    spacing: 12,
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _counter.value++,
                          icon: const Icon(Icons.add),
                          label: const Text('+1'),
                        ),
                      ),
                      Expanded(
                        child: FilledButton.tonal(
                          onPressed: () => _counter.value = 0,
                          child: const Text('초기화'),
                        ),
                      ),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _counter.value--,
                          icon: const Icon(Icons.remove),
                          label: const Text('-1'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 예제 2: 텍스트 변경
            _buildSectionHeader(theme, '예제 2: 텍스트 변경'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                spacing: 16,
                children: [
                  ValueListenableBuilder<String>(
                    valueListenable: _text,
                    builder: (context, value, child) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          value,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSecondaryContainer,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton.tonal(
                        onPressed: () => _text.value = 'Hello',
                        child: const Text('Hello'),
                      ),
                      FilledButton.tonal(
                        onPressed: () => _text.value = 'Flutter',
                        child: const Text('Flutter'),
                      ),
                      FilledButton.tonal(
                        onPressed: () => _text.value = 'Dart',
                        child: const Text('Dart'),
                      ),
                      FilledButton.tonal(
                        onPressed: () => _text.value = '안녕하세요',
                        child: const Text('안녕하세요'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 예제 3: 색상 변경
            _buildSectionHeader(theme, '예제 3: 색상 변경'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                spacing: 16,
                children: [
                  ValueListenableBuilder<Color>(
                    valueListenable: _color,
                    builder: (context, value, child) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          color: value,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.palette,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      );
                    },
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _ColorButton(
                        color: Colors.blue,
                        onPressed: () => _color.value = Colors.blue,
                      ),
                      _ColorButton(
                        color: Colors.red,
                        onPressed: () => _color.value = Colors.red,
                      ),
                      _ColorButton(
                        color: Colors.green,
                        onPressed: () => _color.value = Colors.green,
                      ),
                      _ColorButton(
                        color: Colors.orange,
                        onPressed: () => _color.value = Colors.orange,
                      ),
                      _ColorButton(
                        color: Colors.purple,
                        onPressed: () => _color.value = Colors.purple,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 예제 4: 좋아요 버튼
            _buildSectionHeader(theme, '예제 4: 좋아요 버튼'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Center(
                child: ValueListenableBuilder<bool>(
                  valueListenable: _isLiked,
                  builder: (context, value, child) {
                    return IconButton(
                      onPressed: () => _isLiked.value = !_isLiked.value,
                      icon: Icon(
                        value ? Icons.favorite : Icons.favorite_border,
                        color: value ? Colors.red : null,
                        size: 48,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 코드 예제
            _buildSectionHeader(theme, '코드 예제'),
            const SizedBox(height: 12),
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
                  Text(
                    '사용 방법',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '// 1. ValueNotifier 선언\n'
                          'final ValueNotifier<int> counter = \n'
                          '    ValueNotifier<int>(0);\n\n'
                          '// 2. ValueListenableBuilder 사용\n'
                          'ValueListenableBuilder<int>(\n'
                          '  valueListenable: counter,\n'
                          '  builder: (context, value, child) {\n'
                          '    return Text("\$value");\n'
                          '  },\n'
                          ')\n\n'
                          '// 3. 값 변경\n'
                          'counter.value++;\n\n'
                          '// 4. dispose 필수!\n'
                          '@override\n'
                          'void dispose() {\n'
                          '  counter.dispose();\n'
                          '  super.dispose();\n'
                          '}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 비교: setState vs ValueListenableBuilder
            _buildSectionHeader(theme, 'setState vs ValueListenableBuilder'),
            const SizedBox(height: 12),
            Container(
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
                spacing: 16,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.close,
                            color: Colors.orange,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'setState()',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      _buildInfoItem(theme: theme, text: '전체 위젯 트리 다시 빌드', icon: Icons.info),
                      _buildInfoItem(theme: theme, text: '성능 저하 가능성', icon: Icons.info),
                    ],
                  ),
                  const Divider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'ValueListenableBuilder',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      _buildInfoItem(theme: theme, text: '해당 위젯만 다시 빌드', icon: Icons.check),
                      _buildInfoItem(theme: theme, text: '성능 최적화', icon: Icons.check),
                      _buildInfoItem(theme: theme, text: '코드 가독성 향상', icon: Icons.check),
                    ],
                  ),
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
                        Icons.lightbulb_outline,
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
                    text: 'dispose()에서 ValueNotifier 해제 필수',
                    icon: Icons.check_circle,
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: '단순 상태 관리에 적합',
                    icon: Icons.check_circle,
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: '복잡한 상태는 Provider, Bloc 사용',
                    icon: Icons.check_circle,
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

  // 정보 아이템
  Widget _buildInfoItem({
    required ThemeData theme,
    required String text,
    IconData icon = Icons.check_circle,
  }) {
    return Row(
      children: [
        Icon(
          icon,
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

// 색상 버튼 위젯
class _ColorButton extends StatelessWidget {
  final Color color;
  final VoidCallback onPressed;

  const _ColorButton({
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}