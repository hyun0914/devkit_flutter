import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/default_scaffold.dart';

// Counter Provider
class CounterProvider extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    _count--;
    notifyListeners();
  }

  void reset() {
    _count = 0;
    notifyListeners();
  }
}

class ProviderScreen extends StatelessWidget {
  const ProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CounterProvider(),
      child: const _ProviderContent(),
    );
  }
}

class _ProviderContent extends StatelessWidget {
  const _ProviderContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('Provider'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 설명
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'ChangeNotifierProvider + Consumer',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 48),

            // 카운터 표시
            Consumer<CounterProvider>(
              builder: (context, counter, child) {
                return Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${counter.count}',
                      style: theme.textTheme.displayLarge?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
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
                      context.read<CounterProvider>().decrement();
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
                      context.read<CounterProvider>().increment();
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
                context.read<CounterProvider>().reset();
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
                    '1. ChangeNotifier 상속\n'
                        '2. ChangeNotifierProvider로 감싸기\n'
                        '3. Consumer로 UI 업데이트\n'
                        '4. context.read()로 메서드 호출',
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