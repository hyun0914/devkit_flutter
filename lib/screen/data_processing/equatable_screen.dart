import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../widget/default_scaffold.dart';

class EquatableScreen extends StatelessWidget {
  const EquatableScreen({super.key});

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
                height: 1.5,
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
        title: const Text('데이터 비교'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              'Equatable 사용법',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '객체 비교를 쉽게 만드는 패키지',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // Equatable란?
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
                        'Equatable이란?',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '• 객체의 값 비교를 쉽게 만드는 패키지\n'
                        '• == 연산자와 hashCode 자동 생성\n'
                        '• props에 비교할 속성 지정',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Equatable 사용
            _buildSectionHeader(theme, 'Equatable 사용'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'props에 모든 속성 포함',
              description: '모든 필드 값이 같아야 동일 객체',
              code: '@override\nList<Object?> get props => [title, author];',
              child: FilledButton(
                onPressed: () {
                  const book1 = Book(
                    title: '플러터',
                    author: '구글',
                    detail: '플러터 코딩',
                  );
                  const book2 = Book(
                    title: '플러터',
                    author: '구글',
                    detail: '플러터 코딩',
                  );
                  const book3 = Book(
                    title: '플러터',
                    author: 'Google',
                    detail: '플러터 코딩',
                  );

                  _showResult(
                    context,
                    'Book (모든 속성 비교)',
                    'book1: ${book1.toString()}\n'
                        'book2: ${book2.toString()}\n'
                        'book3: ${book3.toString()}\n\n'
                        'book1 == book2: ${book1 == book2} ✓\n'
                        'book1 == book3: ${book1 == book3} ✗\n\n'
                        '※ author가 다르므로 false',
                  );
                },
                child: const Text('실행'),
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'props가 빈 리스트',
              description: '모든 객체가 동일한 것으로 간주',
              code: '@override\nList<Object?> get props => [];',
              child: FilledButton(
                onPressed: () {
                  const book1 = EmptyPropsBook(
                    title: '플러터',
                    author: '구글',
                  );
                  const book2 = EmptyPropsBook(
                    title: '다트',
                    author: 'Google',
                  );

                  _showResult(
                    context,
                    'EmptyPropsBook (빈 props)',
                    'book1: ${book1.toString()}\n'
                        'book2: ${book2.toString()}\n\n'
                        'book1 == book2: ${book1 == book2} ✓\n\n'
                        '※ props가 비어있으면 항상 true',
                  );
                },
                child: const Text('실행'),
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'props에 일부 속성만 포함',
              description: '지정된 속성만 비교',
              code: '@override\nList<Object?> get props => [title];',
              child: FilledButton(
                onPressed: () {
                  const book1 = TitleOnlyBook(
                    title: '플러터',
                    author: '구글',
                    price: 10000,
                  );
                  const book2 = TitleOnlyBook(
                    title: '플러터',
                    author: 'Google',
                    price: 15000,
                  );
                  const book3 = TitleOnlyBook(
                    title: '다트',
                    author: '구글',
                    price: 10000,
                  );

                  _showResult(
                    context,
                    'TitleOnlyBook (title만 비교)',
                    'book1: ${book1.toString()}\n'
                        'book2: ${book2.toString()}\n'
                        'book3: ${book3.toString()}\n\n'
                        'book1 == book2: ${book1 == book2} ✓\n'
                        'book1 == book3: ${book1 == book3} ✗\n\n'
                        '※ author, price는 무시됨',
                  );
                },
                child: const Text('실행'),
              ),
            ),

            const SizedBox(height: 24),

            // Equatable 없이
            _buildSectionHeader(theme, 'Equatable 없이 비교 (4단계)'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '❌ 1단계: 아무것도 없는 클래스',
              description: '비교 불가능 (항상 false)',
              code: 'class SimpleBook {\n  final String title;\n}',
              child: FilledButton(
                onPressed: () {
                  const book1 = SimpleBook(title: '플러터', author: '구글');
                  const book2 = SimpleBook(title: '플러터', author: '구글');

                  _showResult(
                    context,
                    '❌ SimpleBook (비교 불가)',
                    'book1: ${book1.toString()}\n'
                        'book2: ${book2.toString()}\n\n'
                        'book1 == book2: ${book1 == book2} ✗\n\n'
                        '※ 내용이 같아도 다른 인스턴스라 false',
                  );
                },
                child: const Text('실행'),
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '⚠️ 2단계: == 연산자만 오버라이드',
              description: 'hashCode 없어서 경고 발생',
              code: '@override\nbool operator ==(Object other) {...}\n// hashCode 없음!',
              child: FilledButton(
                onPressed: () {
                  const book1 = IncompleteBook(title: '플러터', author: '구글');
                  const book2 = IncompleteBook(title: '플러터', author: '구글');

                  _showResult(
                    context,
                    '⚠️ IncompleteBook (불완전)',
                    'book1: ${book1.toString()}\n'
                        'book2: ${book2.toString()}\n\n'
                        'book1 == book2: ${book1 == book2} ✓\n\n'
                        '※ 비교는 되지만 hashCode 없어서\n'
                        'Set, Map에서 문제 발생 가능',
                  );
                },
                child: const Text('실행'),
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '✅ 3단계: == + hashCode 모두 구현',
              description: '완전한 수동 구현',
              code: '@override\nbool operator ==(Object other) {...}\n\n@override\nint get hashCode => title.hashCode ^ author.hashCode;',
              child: FilledButton(
                onPressed: () {
                  const book1 = CompleteBook(title: '플러터', author: '구글');
                  const book2 = CompleteBook(title: '플러터', author: '구글');

                  _showResult(
                    context,
                    '✅ CompleteBook (완전 구현)',
                    'book1: ${book1.toString()}\n'
                        'book2: ${book2.toString()}\n\n'
                        'book1 == book2: ${book1 == book2} ✓\n'
                        'hashCode: ${book1.hashCode}\n\n'
                        '※ == 와 hashCode 모두 구현\n'
                        '하지만 코드가 많고 복잡함',
                  );
                },
                child: const Text('실행'),
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '🎯 4단계: Equatable 사용',
              description: 'props만 지정하면 자동!',
              code: 'class Book extends Equatable {\n  @override\n  List<Object?> get props => [title, author];\n}',
              child: FilledButton(
                onPressed: () {
                  const book1 = Book(
                    title: '플러터',
                    author: '구글',
                    detail: '플러터 코딩',
                  );
                  const book2 = Book(
                    title: '플러터',
                    author: '구글',
                    detail: '플러터 코딩',
                  );

                  _showResult(
                    context,
                    '🎯 Book (Equatable)',
                    'book1: ${book1.toString()}\n'
                        'book2: ${book2.toString()}\n\n'
                        'book1 == book2: ${book1 == book2} ✓\n'
                        'hashCode: ${book1.hashCode}\n\n'
                        '※ props만 지정하면 끝!\n'
                        '== 와 hashCode 자동 생성',
                  );
                },
                child: const Text('실행'),
              ),
            ),

            const SizedBox(height: 24),

            // 비교표
            _buildSectionHeader(theme, '4단계 비교표'),
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
                    '📊 단계별 비교',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildComparisonRow(
                    theme: theme,
                    step: '1단계',
                    hasEquals: false,
                    hasHashCode: false,
                    canCompare: false,
                    code: '없음',
                  ),
                  _buildComparisonRow(
                    theme: theme,
                    step: '2단계',
                    hasEquals: true,
                    hasHashCode: false,
                    canCompare: true,
                    code: '== 만',
                    warning: 'Set/Map 문제',
                  ),
                  _buildComparisonRow(
                    theme: theme,
                    step: '3단계',
                    hasEquals: true,
                    hasHashCode: true,
                    canCompare: true,
                    code: '== + hashCode',
                    warning: '코드 복잡',
                  ),
                  _buildComparisonRow(
                    theme: theme,
                    step: '4단계',
                    hasEquals: true,
                    hasHashCode: true,
                    canCompare: true,
                    code: 'Equatable',
                    isRecommended: true,
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
                    '3단계 vs 4단계 코드 비교',
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12,
                      children: [
                        Text(
                          '❌ 3단계 (수동 구현)',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        Text(
                          'class Book {\n'
                              '  final String title;\n'
                              '  final String author;\n\n'
                              '  @override\n'
                              '  bool operator ==(Object other) {\n'
                              '    if (identical(this, other)) return true;\n'
                              '    return other is Book &&\n'
                              '        other.title == title &&\n'
                              '        other.author == author;\n'
                              '  }\n\n'
                              '  @override\n'
                              '  int get hashCode => \n'
                              '      title.hashCode ^ author.hashCode;\n'
                              '}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                            height: 1.5,
                          ),
                        ),
                        const Divider(),
                        Text(
                          '✅ 4단계 (Equatable)',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          'class Book extends Equatable {\n'
                              '  final String title;\n'
                              '  final String author;\n\n'
                              '  const Book({\n'
                              '    required this.title,\n'
                              '    required this.author,\n'
                              '  });\n\n'
                              '  @override\n'
                              '  List<Object?> get props => [\n'
                              '    title,\n'
                              '    author,\n'
                              '  ];\n'
                              '}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 장단점
            _buildSectionHeader(theme, 'Equatable 장단점'),
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
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '장점',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      _buildInfoItem(theme: theme, text: '간단한 코드', icon: Icons.check),
                      _buildInfoItem(theme: theme, text: '== 연산자 자동 생성', icon: Icons.check),
                      _buildInfoItem(theme: theme, text: 'hashCode 자동 생성', icon: Icons.check),
                      _buildInfoItem(theme: theme, text: 'toString() 자동 생성', icon: Icons.check),
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
                            Icons.warning,
                            color: Colors.orange,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '단점',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      _buildInfoItem(theme: theme, text: '외부 패키지 의존성', icon: Icons.info),
                      _buildInfoItem(theme: theme, text: 'props 수동 관리 필요', icon: Icons.info),
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
                    text: 'BLoC 패턴의 State 클래스에 유용',
                    icon: Icons.check_circle,
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'props에 모든 필드를 포함하는 것이 일반적',
                    icon: Icons.check_circle,
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'const 생성자 사용 권장',
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

  // 비교표 행
  Widget _buildComparisonRow({
    required ThemeData theme,
    required String step,
    required bool hasEquals,
    required bool hasHashCode,
    required bool canCompare,
    required String code,
    String? warning,
    bool isRecommended = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isRecommended
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: isRecommended
            ? Border.all(
          color: theme.colorScheme.primary,
          width: 2,
        )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            children: [
              Text(
                step,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isRecommended ? theme.colorScheme.primary : null,
                ),
              ),
              const Spacer(),
              if (isRecommended)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '권장',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  code,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                hasEquals ? Icons.check : Icons.close,
                size: 16,
                color: hasEquals ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 4),
              Icon(
                hasHashCode ? Icons.check : Icons.close,
                size: 16,
                color: hasHashCode ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 4),
              Icon(
                canCompare ? Icons.check : Icons.close,
                size: 16,
                color: canCompare ? Colors.green : Colors.red,
              ),
            ],
          ),
          if (warning != null)
            Row(
              children: [
                Icon(
                  Icons.warning,
                  size: 14,
                  color: Colors.orange,
                ),
                const SizedBox(width: 4),
                Text(
                  warning,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
        ],
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
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                color: theme.colorScheme.primary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 4),
          child,
        ],
      ),
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

// 1단계: SimpleBook (아무것도 없음)
class SimpleBook {
  final String title;
  final String author;

  const SimpleBook({
    required this.title,
    required this.author,
  });

  @override
  String toString() => 'SimpleBook($title, $author)';
}

// 2단계: IncompleteBook (== 만 있음)
class IncompleteBook {
  final String title;
  final String author;

  const IncompleteBook({
    required this.title,
    required this.author,
  });

  // 의도적으로 hashCode를 생략했습니다 (교육 목적)
  // == 만 구현하면 왜 안 되는지 보여주기 위한 예제입니다.
  // 실무에서는 반드시 hashCode도 함께 오버라이드하세요
  // ignore: must_override_hash_code
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IncompleteBook &&
        other.title == title &&
        other.author == author;
  }

  // hashCode가 없어서 경고가 발생합니다 (2단계의 문제점)

  @override
  String toString() => 'IncompleteBook($title, $author)';
}

// 3단계: CompleteBook (== + hashCode 모두 있음)
class CompleteBook {
  final String title;
  final String author;

  const CompleteBook({
    required this.title,
    required this.author,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CompleteBook &&
        other.title == title &&
        other.author == author;
  }

  @override
  int get hashCode => title.hashCode ^ author.hashCode;

  @override
  String toString() => 'CompleteBook($title, $author)';
}

// 4단계: Book (Equatable 사용)
class Book extends Equatable {
  final String title;
  final String author;
  final String detail;

  const Book({
    required this.title,
    required this.author,
    required this.detail,
  });

  @override
  List<Object?> get props => [title, author, detail];

  @override
  String toString() => 'Book($title, $author)';
}

// EmptyPropsBook 클래스 (props가 빈 리스트)
class EmptyPropsBook extends Equatable {
  final String title;
  final String author;

  const EmptyPropsBook({
    required this.title,
    required this.author,
  });

  @override
  List<Object?> get props => [];

  @override
  String toString() => 'Book($title, $author)';
}

// TitleOnlyBook 클래스 (title만 비교)
class TitleOnlyBook extends Equatable {
  final String title;
  final String author;
  final int price;

  const TitleOnlyBook({
    required this.title,
    required this.author,
    required this.price,
  });

  @override
  List<Object?> get props => [title];

  @override
  String toString() => 'Book($title, $author, $price원)';
}