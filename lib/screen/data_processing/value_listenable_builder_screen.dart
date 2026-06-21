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
  // child 파라미터 데모용
  final ValueNotifier<int> _childCounter = ValueNotifier<int>(0);
  // 동일 값 재할당 데모용
  final ValueNotifier<int> _sameValue = ValueNotifier<int>(5);
  int _sameValueBuildCount = 0;

  @override
  void dispose() {
    _counter.dispose();
    _text.dispose();
    _color.dispose();
    _isLiked.dispose();
    _childCounter.dispose();
    _sameValue.dispose();
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

            // 예제 5: child 파라미터 최적화
            _buildSectionHeader(theme, '예제 5: child 파라미터 최적화'),
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
                spacing: 12,
                children: [
                  Text(
                    'child에 전달된 위젯은 값이 바뀌어도 rebuild되지 않습니다.',
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant),
                  ),
                  ValueListenableBuilder<int>(
                    valueListenable: _childCounter,
                    // child: 정적 위젯 → 값 변경과 무관하게 한 번만 build
                    child: Column(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 36),
                        const SizedBox(height: 4),
                        Text('정적 위젯 (child)',
                            style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.amber.shade700)),
                      ],
                    ),
                    builder: (context, value, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 24,
                        children: [
                          // child는 rebuild 없이 그대로 전달됨
                          child!,
                          Column(
                            children: [
                              Text(
                                '$value',
                                style: theme.textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              Text('카운터 (builder rebuild)',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                      color:
                                          theme.colorScheme.onSurfaceVariant)),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  FilledButton.icon(
                    onPressed: () => _childCounter.value++,
                    icon: const Icon(Icons.add),
                    label: const Text('+1 (child 위젯은 rebuild 안 됨)'),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'ValueListenableBuilder(\n'
                      '  child: const ExpensiveWidget(), // 한 번만 build\n'
                      '  builder: (context, value, child) {\n'
                      '    return Row(children: [child!, Text("\$value")]);\n'
                      '  },\n'
                      ')',
                      style: theme.textTheme.labelSmall?.copyWith(
                          fontFamily: 'monospace', height: 1.6),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 예제 6: 동일 값 재할당 → 리스너 미호출
            _buildSectionHeader(theme, '예제 6: 동일 값 재할당 → 리스너 미호출'),
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
                spacing: 12,
                children: [
                  Text(
                    '== 연산자로 이전 값과 비교 → 동일하면 리스너 미호출',
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant),
                  ),
                  ValueListenableBuilder<int>(
                    valueListenable: _sameValue,
                    builder: (context, value, child) {
                      _sameValueBuildCount++;
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.tertiaryContainer
                              .withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          spacing: 4,
                          children: [
                            Text('현재 값: $value',
                                style: theme.textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                            Text('builder 호출 횟수: $_sameValueBuildCount',
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color:
                                        theme.colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      );
                    },
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // 같은 값 재할당 → == true → 리스너 미호출
                            _sameValue.value = 5;
                          },
                          child: const Text('value = 5\n(같은 값, 미호출)',
                              textAlign: TextAlign.center),
                        ),
                      ),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            // 다른 값 → 리스너 호출
                            _sameValue.value =
                                _sameValue.value == 5 ? 99 : 5;
                          },
                          child: const Text('value = 다른 값\n(리스너 호출)',
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 참조형 타입 주의 카드
            _buildSectionHeader(theme, '⚠️ 참조형 타입 주의 (List / Map)'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: Colors.orange, size: 20),
                      Text('List / Map은 참조가 같으면 == 동일 판단',
                          style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade800)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Colors.red.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      '// ❌ 내부 값만 변경 → 참조 동일 → 리스너 미호출\n'
                      'final n = ValueNotifier<List<int>>([1, 2, 3]);\n'
                      'n.value.add(4); // UI 업데이트 안 됨!',
                      style: theme.textTheme.labelSmall?.copyWith(
                          fontFamily: 'monospace',
                          color: Colors.red.shade700,
                          height: 1.6),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Colors.green.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      '// ✅ 새 List 할당 → 참조 다름 → 리스너 호출\n'
                      'n.value = [...n.value, 4]; // UI 업데이트됨\n\n'
                      '// ✅ 복잡한 참조형은 ChangeNotifier 사용 권장',
                      style: theme.textTheme.labelSmall?.copyWith(
                          fontFamily: 'monospace',
                          color: Colors.green.shade700,
                          height: 1.6),
                    ),
                  ),
                ],
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

            // 비교: setState vs ValueNotifier
            _buildSectionHeader(theme, 'setState vs ValueNotifier 비교'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3)),
              ),
              child: Table(
                border: TableBorder.symmetric(
                  inside: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2)),
                ),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1.5),
                  2: FlexColumnWidth(1.5),
                },
                children: [
                  _buildTableRow(
                    theme,
                    ['항목', 'setState', 'ValueNotifier'],
                    isHeader: true,
                  ),
                  _buildTableRow(
                      theme, ['rebuild 범위', 'StatefulWidget\n전체', 'VLB 내부만']),
                  _buildTableRow(
                      theme, ['외부 패키지', '불필요', '불필요']),
                  _buildTableRow(
                      theme, ['복잡한 상태', '부적합', '부적합\n(단일 값 전용)']),
                  _buildTableRow(
                      theme, ['참조형(List/Map)', '변경 감지', '감지 안 됨\n(새 객체 필요)']),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 언제 쓸까
            _buildSectionHeader(theme, '언제 쓸까?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2)),
              ),
              child: Column(
                spacing: 8,
                children: [
                  _buildWhenItem(theme, Icons.check_circle,
                      '상태가 단일 값 (int, bool, String 등 불변 타입)'),
                  _buildWhenItem(theme, Icons.check_circle,
                      'BLoC / Riverpod 같은 패키지가 부담스러운 간단한 화면'),
                  _buildWhenItem(theme, Icons.check_circle,
                      'setState로 인한 전체 rebuild를 줄이고 싶을 때'),
                  _buildWhenItem(theme, Icons.check_circle,
                      '복잡한 비즈니스 로직 없이 UI 반응만 필요한 경우'),
                  const Divider(height: 16),
                  _buildWhenItem(theme, Icons.cancel,
                      'List/Map 등 참조형 타입 → ChangeNotifier 사용 권장',
                      isWarning: true),
                  _buildWhenItem(theme, Icons.cancel,
                      '여러 값이 함께 변하는 복잡한 상태 → Provider / Riverpod 권장',
                      isWarning: true),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 팁 카드
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
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
                      Icon(Icons.lightbulb_outline,
                          color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Text('💡 핵심 요약',
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  _buildInfoItem(
                      theme: theme,
                      text: 'dispose()에서 ValueNotifier 해제 필수',
                      icon: Icons.check_circle),
                  _buildInfoItem(
                      theme: theme,
                      text: '동일 값 재할당 시 리스너 미호출 (== 비교)',
                      icon: Icons.check_circle),
                  _buildInfoItem(
                      theme: theme,
                      text: 'child 파라미터로 정적 위젯 rebuild 방지',
                      icon: Icons.check_circle),
                  _buildInfoItem(
                      theme: theme,
                      text: 'ChangeNotifier를 상속한 구현체',
                      icon: Icons.check_circle),
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

  TableRow _buildTableRow(ThemeData theme, List<String> cells,
      {bool isHeader = false}) {
    return TableRow(
      decoration: isHeader
          ? BoxDecoration(
              color: theme.colorScheme.primaryContainer
                  .withValues(alpha: 0.4),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
            )
          : null,
      children: cells
          .map(
            (c) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Text(
                c,
                style: isHeader
                    ? theme.textTheme.labelSmall
                        ?.copyWith(fontWeight: FontWeight.bold)
                    : theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildWhenItem(ThemeData theme, IconData icon, String text,
      {bool isWarning = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Icon(icon,
            size: 16,
            color: isWarning ? Colors.orange : Colors.green),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isWarning
                  ? Colors.orange.shade800
                  : theme.colorScheme.onSurfaceVariant,
            ),
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