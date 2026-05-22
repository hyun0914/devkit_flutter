import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../widget/default_scaffold.dart';

// ── 무거운 연산 함수 (최상위 함수여야 Isolate에서 실행 가능) ──────
int _heavyComputation(int n) {
  int count = 0;
  for (int i = 2; i <= n; i++) {
    bool isPrime = true;
    for (int j = 2; j * j <= i; j++) {
      if (i % j == 0) {
        isPrime = false;
        break;
      }
    }
    if (isPrime) count++;
  }
  return count;
}

class IsolateScreen extends StatefulWidget {
  const IsolateScreen({super.key});

  @override
  State<IsolateScreen> createState() => _IsolateScreenState();
}

class _IsolateScreenState extends State<IsolateScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  bool _isRunning = false;
  String _result = '';
  Duration _elapsed = Duration.zero;

  static const int _targetN = 500000;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // 메인 스레드 — UI 블로킹
  Future<void> _runOnMainThread() async {
    setState(() {
      _isRunning = true;
      _result = '';
    });

    final stopwatch = Stopwatch()..start();
    final count = _heavyComputation(_targetN);
    stopwatch.stop();

    setState(() {
      _isRunning = false;
      _result = '$_targetN 이하 소수 개수: $count개';
      _elapsed = stopwatch.elapsed;
    });
  }

  // compute — Flutter 제공 헬퍼 (내부적으로 Isolate 사용)
  Future<void> _runWithCompute() async {
    setState(() {
      _isRunning = true;
      _result = '';
    });

    final stopwatch = Stopwatch()..start();
    final count = await compute(_heavyComputation, _targetN);
    stopwatch.stop();

    setState(() {
      _isRunning = false;
      _result = '$_targetN 이하 소수 개수: $count개';
      _elapsed = stopwatch.elapsed;
    });
  }

  // Isolate.run — Dart 2.19+ 간단한 방식
  Future<void> _runWithIsolateRun() async {
    setState(() {
      _isRunning = true;
      _result = '';
    });

    final stopwatch = Stopwatch()..start();
    final count = await Isolate.run(() => _heavyComputation(_targetN));
    stopwatch.stop();

    setState(() {
      _isRunning = false;
      _result = '$_targetN 이하 소수 개수: $count개';
      _elapsed = stopwatch.elapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(title: const Text('Isolate (백그라운드 처리)')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Isolate',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              '무거운 연산을 별도 스레드에서 실행해 UI 프리즈 방지',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),

            const SizedBox(height: 24),

            // 애니메이션 — UI 블로킹 여부 확인용
            _buildSectionHeader(theme, 'UI 상태 확인'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  RotationTransition(
                    turns: _animController,
                    child: Icon(Icons.refresh_rounded,
                        color: theme.colorScheme.primary, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      '이 아이콘이 멈추면 UI가 블로킹된 것입니다.\n메인 스레드로 실행 시 잠깐 멈춥니다.',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildSectionHeader(theme, '실행 방법 비교'),
            const SizedBox(height: 12),

            // 메인 스레드
            _buildRunButton(
              theme: theme,
              title: '메인 스레드로 실행',
              subtitle: 'UI 블로킹 발생 (아이콘 멈춤)',
              icon: Icons.warning_amber_rounded,
              color: Colors.orange,
              code: '_heavyComputation(n)',
              onPressed: _isRunning ? null : _runOnMainThread,
            ),
            const SizedBox(height: 8),

            // compute
            _buildRunButton(
              theme: theme,
              title: 'compute() 사용',
              subtitle: 'Flutter 제공 헬퍼, 간단한 단일 연산에 적합',
              icon: Icons.check_circle_rounded,
              color: Colors.blue,
              code: 'await compute(_heavyComputation, n)',
              onPressed: _isRunning ? null : _runWithCompute,
            ),
            const SizedBox(height: 8),

            // Isolate.run
            _buildRunButton(
              theme: theme,
              title: 'Isolate.run() 사용',
              subtitle: 'Dart 2.19+, 가장 간단한 Isolate 사용법',
              icon: Icons.check_circle_rounded,
              color: Colors.green,
              code: 'await Isolate.run(() => _heavyComputation(n))',
              onPressed: _isRunning ? null : _runWithIsolateRun,
            ),

            const SizedBox(height: 24),

            // 결과
            _buildSectionHeader(theme, '결과'),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _result.isNotEmpty
                    ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                    : theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _result.isNotEmpty
                      ? theme.colorScheme.primary.withValues(alpha: 0.3)
                      : theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: _isRunning
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _result.isEmpty
                      ? Text(
                          '위 버튼을 눌러 실행해보세요',
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_result,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                              '소요 시간: ${_elapsed.inMilliseconds}ms',
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
            ),

            const SizedBox(height: 24),

            // 코드 패턴
            _buildSectionHeader(theme, 'Isolate.spawn 패턴'),
            const SizedBox(height: 12),
            _buildCodeBlock(theme, '''// 양방향 통신이 필요할 때
final receivePort = ReceivePort();

await Isolate.spawn((sendPort) {
  // 별도 Isolate에서 실행
  final result = heavyWork();
  sendPort.send(result);
}, receivePort.sendPort);

final result = await receivePort.first;'''),
          ],
        ),
      ),
    );
  }

  Widget _buildRunButton({
    required ThemeData theme,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String code,
    required VoidCallback? onPressed,
  }) {
    return Opacity(
      opacity: onPressed == null ? 0.5 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: color, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(title,
                            style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      code,
                      style: theme.textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace', color: color),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCodeBlock(ThemeData theme, String code) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Text(
        code,
        style: theme.textTheme.bodySmall?.copyWith(
          fontFamily: 'monospace',
          height: 1.6,
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
}
