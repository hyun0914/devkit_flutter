import 'package:flutter/material.dart';

import '../widget/default_scaffold.dart';

// 1. Sealed Classes + Pattern Matching (API 상태)
sealed class ApiState {}

class Loading extends ApiState {}

class Success extends ApiState {
  final List<String> data;
  Success(this.data);
}

class Error extends ApiState {
  final String message;
  Error(this.message);
}

class Dart3Screen extends StatefulWidget {
  const Dart3Screen({super.key});

  @override
  State<Dart3Screen> createState() => _Dart3ScreenState();
}

class _Dart3ScreenState extends State<Dart3Screen> {
  ApiState _apiState = Loading();

  @override
  void initState() {
    super.initState();
    _simulateApiCall();
  }

  // API 호출 시뮬레이션
  Future<void> _simulateApiCall() async {
    setState(() => _apiState = Loading());
    await Future.delayed(const Duration(seconds: 2));

    // 랜덤으로 성공/실패
    final random = DateTime.now().second % 3;
    setState(() {
      if (random == 0) {
        _apiState = Success(['Apple', 'Banana', 'Orange']);
      } else if (random == 1) {
        _apiState = Success([]);
      } else {
        _apiState = Error('네트워크 오류가 발생했습니다');
      }
    });
  }

  // 2. Records (여러 값 반환)
  (String, int, bool) getUserInfo() {
    return ('Alice', 25, true);
  }

  // Named Records
  ({String name, int age, String email}) getUserProfile() {
    return (name: 'Bob', age: 30, email: 'bob@example.com');
  }

  // 3. List/Map Pattern Matching
  String analyzeList(List<int> numbers) {
    return switch (numbers) {
      [] => '빈 리스트',
      [var first] => '단일 항목: $first',
      [var first, var second] => '두 항목: $first, $second',
      [var first, var second, var third] => '세 항목: $first, $second, $third',
      _ => '${numbers.length}개 항목',
    };
  }

  String analyzeJson(Map<String, dynamic> json) {
    return switch (json) {
      {'name': String name, 'age': int age} => '$name님, $age세',
      {'error': String message} => '에러: $message',
      _ => '알 수 없는 형식',
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('Dart 3.x 신기능'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 헤더
          Text(
            'Dart 3.x 신기능 예제',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Sealed Classes, Records, Pattern Matching',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 24),

          // 1. Sealed Classes + Pattern Matching
          _buildSection(
            theme: theme,
            icon: Icons.category,
            title: '1. Sealed Classes + Pattern Matching',
            description: 'API 상태를 타입 안전하게 처리',
            child: Column(
              spacing: 16,
              children: [
                // API 상태 표시
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: _buildApiStateWidget(theme),
                ),

                // 재시도 버튼
                FilledButton.icon(
                  onPressed: _simulateApiCall,
                  icon: const Icon(Icons.refresh),
                  label: const Text('API 재호출'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),

                // 코드 예제
                _buildCodeExample(
                  theme: theme,
                  code: '''sealed class ApiState {}
class Loading extends ApiState {}
class Success extends ApiState {
  final List<String> data;
}
class Error extends ApiState {
  final String message;
}

// Pattern Matching
return switch (state) {
  Loading() => CircularProgressIndicator(),
  Success(data: final items) => ListView(...),
  Error(message: final msg) => Text(msg),
};''',
                ),

                _buildTip(
                  theme: theme,
                  text: '✅ 모든 케이스 처리 강제 (컴파일 에러)',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 2. Records
          _buildSection(
            theme: theme,
            icon: Icons.data_object,
            title: '2. Records (여러 값 반환)',
            description: '클래스 없이 여러 값을 묶어 반환',
            child: Column(
              spacing: 16,
              children: [
                // Positional Records
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Text(
                        'Positional Records',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          final (name, age, isActive) = getUserInfo();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
                            children: [
                              Text('이름: $name'),
                              Text('나이: $age'),
                              Text('활성: $isActive'),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Named Records
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Text(
                        'Named Records',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          final profile = getUserProfile();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
                            children: [
                              Text('이름: ${profile.name}'),
                              Text('나이: ${profile.age}'),
                              Text('이메일: ${profile.email}'),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // 코드 예제
                _buildCodeExample(
                  theme: theme,
                  code: '''// Positional Records
(String, int, bool) getUserInfo() {
  return ('Alice', 25, true);
}
final (name, age, isActive) = getUserInfo();

// Named Records
({String name, int age}) getUser() {
  return (name: 'Bob', age: 30);
}
final user = getUser();
print(user.name); // Bob''',
                ),

                _buildTip(
                  theme: theme,
                  text: '✅ 간단한 데이터는 클래스 대신 Records 사용',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 3. List/Map Pattern Matching
          _buildSection(
            theme: theme,
            icon: Icons.list_alt,
            title: '3. List/Map Pattern Matching',
            description: '컬렉션 구조를 패턴으로 매칭',
            child: Column(
              spacing: 16,
              children: [
                // List Pattern
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      Text(
                        'List Pattern',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildPatternExample(
                        theme,
                        '[]',
                        analyzeList([]),
                      ),
                      _buildPatternExample(
                        theme,
                        '[5]',
                        analyzeList([5]),
                      ),
                      _buildPatternExample(
                        theme,
                        '[1, 2]',
                        analyzeList([1, 2]),
                      ),
                      _buildPatternExample(
                        theme,
                        '[1, 2, 3]',
                        analyzeList([1, 2, 3]),
                      ),
                      _buildPatternExample(
                        theme,
                        '[1, 2, 3, 4, 5]',
                        analyzeList([1, 2, 3, 4, 5]),
                      ),
                    ],
                  ),
                ),

                // Map Pattern
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      Text(
                        'Map Pattern',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildPatternExample(
                        theme,
                        "{'name': 'Alice', 'age': 25}",
                        analyzeJson({'name': 'Alice', 'age': 25}),
                      ),
                      _buildPatternExample(
                        theme,
                        "{'error': 'Not found'}",
                        analyzeJson({'error': 'Not found'}),
                      ),
                      _buildPatternExample(
                        theme,
                        "{'unknown': 'data'}",
                        analyzeJson({'unknown': 'data'}),
                      ),
                    ],
                  ),
                ),

                // 코드 예제
                _buildCodeExample(
                  theme: theme,
                  code: '''// List Pattern
switch (list) {
  case []: print('빈 리스트');
  case [var x]: print('단일: \$x');
  case [var x, var y]: print('두 개: \$x, \$y');
  case _: print('여러 개');
}

// Map Pattern
switch (json) {
  case {'name': String n, 'age': int a}:
    print('\$n, \$a세');
  case {'error': String msg}:
    print('에러: \$msg');
}''',
                ),

                _buildTip(
                  theme: theme,
                  text: '✅ JSON 파싱, 리스트 검증에 유용',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 4. Guard Clauses
          _buildSection(
            theme: theme,
            icon: Icons.shield,
            title: '4. Guard Clauses (when)',
            description: '패턴에 조건 추가',
            child: Column(
              spacing: 16,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      _buildGuardExample(theme, 5, _categorizeNumber(5)),
                      _buildGuardExample(theme, 15, _categorizeNumber(15)),
                      _buildGuardExample(theme, 25, _categorizeNumber(25)),
                      _buildGuardExample(theme, 50, _categorizeNumber(50)),
                      _buildGuardExample(theme, 75, _categorizeNumber(75)),
                      _buildGuardExample(theme, 100, _categorizeNumber(100)),
                    ],
                  ),
                ),

                _buildCodeExample(
                  theme: theme,
                  code: '''String categorize(int n) {
  return switch (n) {
    < 10 => '한 자리',
    >= 10 && < 20 when n % 2 == 0 => '10대 짝수',
    >= 10 && < 20 => '10대 홀수',
    >= 20 && < 100 => '두 자리',
    _ => '큰 수',
  };
}''',
                ),

                _buildTip(
                  theme: theme,
                  text: '✅ when으로 추가 조건 검사 가능',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 5. if-case 문
          _buildSection(
            theme: theme,
            icon: Icons.fork_right,
            title: '5. if-case 문',
            description: 'if 조건에서 패턴 매칭',
            child: Column(
              spacing: 16,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      Text(
                        'Null 체크',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildIfCaseExample(
                        theme,
                        'value: 42',
                        _processNullable(42),
                      ),
                      _buildIfCaseExample(
                        theme,
                        'value: null',
                        _processNullable(null),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'JSON 검증',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildIfCaseExample(
                        theme,
                        "{'user': 'Alice', 'id': 1}",
                        _validateUser({'user': 'Alice', 'id': 1}),
                      ),
                      _buildIfCaseExample(
                        theme,
                        "{'error': 'Invalid'}",
                        _validateUser({'error': 'Invalid'}),
                      ),
                    ],
                  ),
                ),

                _buildCodeExample(
                  theme: theme,
                  code: '''// Null 체크
if (value case var x?) {
  print('값: \$x');
} else {
  print('null');
}

// JSON 검증
if (json case {'user': String name, 'id': int id}) {
  print('\$name (\$id)');
} else {
  print('잘못된 형식');
}''',
                ),

                _buildTip(
                  theme: theme,
                  text: '✅ 간단한 패턴은 if-case로 깔끔하게',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 요약
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
                      '💡 Dart 3.x 핵심 요약',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                _buildSummaryItem(
                  theme,
                  'Sealed Classes',
                  '타입 안전한 상태 관리',
                ),
                _buildSummaryItem(
                  theme,
                  'Records',
                  '간단한 데이터 묶음',
                ),
                _buildSummaryItem(
                  theme,
                  'Pattern Matching',
                  'List/Map 구조 검증',
                ),
                _buildSummaryItem(
                  theme,
                  'Guard Clauses',
                  '패턴 + 조건문',
                ),
                _buildSummaryItem(
                  theme,
                  'if-case',
                  '간단한 패턴 매칭',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // API 상태 위젯 (Pattern Matching 사용)
  Widget _buildApiStateWidget(ThemeData theme) {
    return switch (_apiState) {
      Loading() => const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 12),
          Text('로딩 중...'),
        ],
      ),
      Success(data: final items) when items.isEmpty => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 8),
          const Text('데이터가 없습니다'),
        ],
      ),
      Success(data: final items) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Text(
                '성공! (${items.length}개)',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Text('• $item'),
          )),
        ],
      ),
      Error(message: final msg) => Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 48),
          Text(
            msg,
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    };
  }

  // Guard Clause 예제
  String _categorizeNumber(int n) {
    return switch (n) {
      < 10 => '한 자리 수',
      >= 10 && < 20 when n % 2 == 0 => '10대 짝수',
      >= 10 && < 20 => '10대 홀수',
      >= 20 && < 100 => '두 자리 수',
      _ => '큰 수',
    };
  }

  // if-case: Null 처리
  String _processNullable(int? value) {
    if (value case var x?) {
      return '값: ${x * 2}';
    } else {
      return 'null 값';
    }
  }

  // if-case: JSON 검증
  String _validateUser(Map<String, dynamic> json) {
    if (json case {'user': String name, 'id': int id}) {
      return '사용자: $name (ID: $id)';
    } else {
      return '잘못된 형식';
    }
  }

  // UI 헬퍼들
  Widget _buildSection({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String description,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: theme.colorScheme.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 48),
                  child: Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildCodeExample({
    required ThemeData theme,
    required String code,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        code,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 11,
          height: 1.5,
          color: Colors.white70,
        ),
      ),
    );
  }

  Widget _buildTip({
    required ThemeData theme,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.tips_and_updates,
            size: 16,
            color: theme.colorScheme.tertiary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatternExample(ThemeData theme, String input, String result) {
    return Row(
      children: [
        Expanded(
          child: Text(
            input,
            style: theme.textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
            ),
          ),
        ),
        const SizedBox(width: 8),
        Icon(Icons.arrow_forward, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            result,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuardExample(ThemeData theme, int input, String result) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                '$input',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.arrow_forward, size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              result,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIfCaseExample(ThemeData theme, String input, String result) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
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
            input,
            style: theme.textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  result,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(ThemeData theme, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(left: 28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodySmall,
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}