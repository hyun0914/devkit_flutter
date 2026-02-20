import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../widget/default_scaffold.dart';

class ListMapRelatedScreen extends StatelessWidget {
  const ListMapRelatedScreen({super.key});

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
        title: const Text('List & Map'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              'List & Map 처리',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '컬렉션 데이터 다루기',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // List 기본
            _buildSectionHeader(theme, 'List 기본'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'List 기본 속성',
              description: 'length, isEmpty, contains 등',
              code: 'list.length / list.contains()',
              child: FilledButton(
                onPressed: () {
                  final list = ['A', 'B', 'C', 1, 2];

                  _showResult(
                    context,
                    'List 기본',
                    'list: $list\n'
                        'length: ${list.length}\n'
                        'isEmpty: ${list.isEmpty}\n'
                        'isNotEmpty: ${list.isNotEmpty}\n'
                        'first: ${list.first}\n'
                        'last: ${list.last}\n'
                        'contains("B"): ${list.contains('B')}\n'
                        'indexOf(1): ${list.indexOf(1)}\n'
                        'reversed: ${list.reversed.toList()}',
                  );
                },
                child: const Text('실행'),
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'List 최대/최소값',
              description: 'reduce() 또는 sort() 사용',
              code: 'list.reduce((a, b) => a > b ? a : b)',
              child: FilledButton(
                onPressed: () {
                  final listInt = [44, 2, 777, 9, 123];

                  final min = listInt.reduce((a, b) => a < b ? a : b);
                  final max = listInt.reduce((a, b) => a > b ? a : b);

                  final sorted = [...listInt]..sort();

                  _showResult(
                    context,
                    'List 최대/최소',
                    'list: $listInt\n\n'
                        '[reduce 사용]\n'
                        'min: $min\n'
                        'max: $max\n\n'
                        '[sort 사용]\n'
                        'sorted: $sorted\n'
                        'min: ${sorted.first}\n'
                        'max: ${sorted.last}',
                  );
                },
                child: const Text('실행'),
              ),
            ),

            const SizedBox(height: 24),

            // List 연산
            _buildSectionHeader(theme, 'List 연산'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'List 합치기',
              description: 'Spread 연산자 (...) 사용',
              code: '[...list1, ...list2]',
              child: FilledButton(
                onPressed: () {
                  final list1 = [1, 2, 3];
                  final list2 = [4, 5, 6];
                  final combined = [...list1, ...list2];
                  final withZero = [0, ...list1];

                  _showResult(
                    context,
                    'List 합치기',
                    'list1: $list1\n'
                        'list2: $list2\n'
                        'combined: $combined\n'
                        'withZero: $withZero',
                  );
                },
                child: const Text('실행'),
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'List 복사',
              description: 'List.from() 또는 [...list] 사용',
              code: 'List.from(original)',
              child: FilledButton(
                onPressed: () {
                  final original = [111, 222, 333, 444];
                  final copy1 = List.from(original);
                  final copy2 = [...original];

                  copy1.removeWhere((value) => value == 333);

                  _showResult(
                    context,
                    'List 복사',
                    'original: $original\n'
                        'copy1 (수정됨): $copy1\n'
                        'copy2: $copy2\n\n'
                        '※ 복사본 수정해도 원본 유지',
                  );
                },
                child: const Text('실행'),
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'List 비교',
              description: 'listEquals() 사용 (foundation)',
              code: 'listEquals(list1, list2)',
              child: FilledButton(
                onPressed: () {
                  final list1 = ['A', 'B', 'C'];
                  final list2 = ['A', 'B', 'C'];
                  final list3 = ['A', 'B', 'D'];

                  _showResult(
                    context,
                    'List 비교',
                    'list1: $list1\n'
                        'list2: $list2\n'
                        'list3: $list3\n\n'
                        'list1 == list2: ${listEquals(list1, list2)}\n'
                        'list1 == list3: ${listEquals(list1, list3)}\n\n'
                        '※ import "package:flutter/foundation.dart"',
                  );
                },
                child: const Text('실행'),
              ),
            ),

            const SizedBox(height: 24),

            // List 고급
            _buildSectionHeader(theme, 'List 고급'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'List<Map> 처리',
              description: 'map(), where(), toList() 조합',
              code: 'list.map((e) => e["key"]).toList()',
              child: FilledButton(
                onPressed: () {
                  final testList = [
                    {'name': '사과', 'price': 1000},
                    {'name': '바나나', 'price': 1500},
                    {'name': '딸기', 'price': 3000},
                  ];

                  final names = testList.map((e) => e['name']).toList();
                  final expensive = testList.where((e) => (e['price']! as int) >= 2000).toList();

                  _showResult(
                    context,
                    'List<Map> 처리',
                    'original: $testList\n\n'
                        'names: $names\n\n'
                        'expensive (2000원 이상):\n$expensive',
                  );
                },
                child: const Text('실행'),
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'List<Map> 정렬',
              description: 'sort() + compareTo() 사용',
              code: 'list.sort((a, b) => a["key"].compareTo(b["key"]))',
              child: FilledButton(
                onPressed: () {
                  final listMap = [
                    {'name': '홍길동', 'score': 85},
                    {'name': '김철수', 'score': 95},
                    {'name': '이영희', 'score': 70},
                  ];

                  final ascending = [...listMap]..sort((a, b) => (a['score']! as int).compareTo(b['score']! as int));
                  final descending = [...listMap]..sort((a, b) => (b['score']! as int).compareTo(a['score']! as int));

                  _showResult(
                    context,
                    'List<Map> 정렬',
                    '[오름차순]\n$ascending\n\n'
                        '[내림차순]\n$descending',
                  );
                },
                child: const Text('실행'),
              ),
            ),

            const SizedBox(height: 24),

            // Map 기본
            _buildSectionHeader(theme, 'Map 기본'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'Map 기본 속성',
              description: 'keys, values, entries 등',
              code: 'map.keys / map.values',
              child: FilledButton(
                onPressed: () {
                  final map = {'name': '홍길동', 'age': 30, 'city': '서울'};

                  _showResult(
                    context,
                    'Map 기본',
                    'map: $map\n'
                        'length: ${map.length}\n'
                        'isEmpty: ${map.isEmpty}\n'
                        'keys: ${map.keys}\n'
                        'values: ${map.values}\n'
                        'entries: ${map.entries}\n\n'
                        'containsKey("name"): ${map.containsKey('name')}\n'
                        'containsValue(30): ${map.containsValue(30)}',
                  );
                },
                child: const Text('실행'),
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'Map 추가/삭제',
              description: 'addAll(), remove(), clear()',
              code: 'map.addAll({key: value})',
              child: FilledButton(
                onPressed: () {
                  final map = {'a': 1, 'b': 2};
                  final step1 = Map.from(map);

                  step1.addAll({'c': 3});
                  final step2 = Map.from(step1);

                  step2.remove('a');

                  _showResult(
                    context,
                    'Map 추가/삭제',
                    '초기: $map\n'
                        'addAll({"c": 3}): $step1\n'
                        'remove("a"): $step2',
                  );
                },
                child: const Text('실행'),
              ),
            ),

            const SizedBox(height: 24),

            // Map 고급
            _buildSectionHeader(theme, 'Map 고급'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'Map 정렬',
              description: 'entries를 정렬 후 다시 Map으로',
              code: 'Map.fromEntries(entries..sort())',
              child: FilledButton(
                onPressed: () {
                  final map = {5: 'e', 1: 'a', 3: 'c', 4: 'd', 2: 'b'};

                  final ascending = Map.fromEntries(
                      map.entries.toList()..sort((a, b) => a.key.compareTo(b.key))
                  );

                  final descending = Map.fromEntries(
                      map.entries.toList()..sort((a, b) => b.key.compareTo(a.key))
                  );

                  _showResult(
                    context,
                    'Map 정렬',
                    '원본: $map\n\n'
                        '[Key 오름차순]\n$ascending\n\n'
                        '[Key 내림차순]\n$descending',
                  );
                },
                child: const Text('실행'),
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'Map<int, List> 생성',
              description: 'Map에 빈 List 초기화',
              code: 'map.addAll({i: []})',
              child: FilledButton(
                onPressed: () {
                  final Map<int, List<String>> map = {};

                  for (int i = 0; i < 3; i++) {
                    map[i] = [];
                  }

                  map[0]!.add('A');
                  map[1]!.addAll(['B', 'C']);
                  map[2]!.addAll(['D', 'E', 'F']);

                  _showResult(
                    context,
                    'Map<int, List>',
                    '결과: $map\n\n'
                        'map[0]: ${map[0]}\n'
                        'map[1]: ${map[1]}\n'
                        'map[2]: ${map[2]}',
                  );
                },
                child: const Text('실행'),
              ),
            ),

            const SizedBox(height: 24),

            // 유용한 메서드
            _buildSectionHeader(theme, '유용한 메서드'),
            const SizedBox(height: 12),
            _buildMethodCard(
              theme: theme,
              method: 'map()',
              description: 'List 요소 변환',
              example: '[1,2,3].map((e) => e*2) → [2,4,6]',
            ),
            const SizedBox(height: 8),
            _buildMethodCard(
              theme: theme,
              method: 'where()',
              description: 'List 필터링',
              example: '[1,2,3,4].where((e) => e>2) → [3,4]',
            ),
            const SizedBox(height: 8),
            _buildMethodCard(
              theme: theme,
              method: 'reduce()',
              description: 'List 하나로 합치기',
              example: '[1,2,3].reduce((a,b) => a+b) → 6',
            ),
            const SizedBox(height: 8),
            _buildMethodCard(
              theme: theme,
              method: 'any() / every()',
              description: '조건 만족 여부',
              example: '[1,2,3].any((e) => e>2) → true',
            ),
            const SizedBox(height: 8),
            _buildMethodCard(
              theme: theme,
              method: 'join()',
              description: 'List를 String으로',
              example: '["A","B"].join(",") → "A,B"',
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
                        '💡 주의사항',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'List는 순서가 있고, Map은 key-value 쌍',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'sort()는 원본을 수정, [...list]..sort()는 복사본',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'map()은 변환, where()는 필터링',
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