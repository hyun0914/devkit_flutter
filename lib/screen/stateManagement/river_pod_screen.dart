import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widget/default_scaffold.dart';

// Counter Provider
final counterProvider = NotifierProvider<CounterNotifier, int>(CounterNotifier.new);

class CounterNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
}

class RiverPodScreen extends ConsumerWidget {
  const RiverPodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final count = ref.watch(counterProvider);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('RiverPod'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 설명
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'StateProvider + ConsumerWidget',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 48),

            // 카운터 표시
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$count',
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 48),

            // 버튼들
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 감소
                  FilledButton.icon(
                    onPressed: () {
                      ref.read(counterProvider.notifier).decrement();
                    },
                    icon: const Icon(Icons.remove),
                    label: const Text('-'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(100, 56),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // 증가
                  FilledButton.icon(
                    onPressed: () {
                      ref.read(counterProvider.notifier).increment();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('+'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(100, 56),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 리셋
            OutlinedButton.icon(
              onPressed: () {
                ref.read(counterProvider.notifier).reset();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reset'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(216, 48),
              ),
            ),

            const SizedBox(height: 48),

            // 코드 설명
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.code,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '사용법',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '1. NotifierProvider 생성\n'
                    '2. ConsumerWidget 상속\n'
                    '3. ref.watch()로 값 구독\n'
                    '4. ref.read().notifier로 메서드 호출',
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
    );
  }
}