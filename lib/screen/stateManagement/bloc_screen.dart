import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widget/default_scaffold.dart';

// Counter Cubit
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
  void reset() => emit(0);
}

class BlocScreen extends StatelessWidget {
  const BlocScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: const _BlocContent(),
    );
  }
}

class _BlocContent extends StatelessWidget {
  const _BlocContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('BLoC'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 설명
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Cubit + BlocBuilder',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 48),

            // 카운터 표시
            BlocBuilder<CounterCubit, int>(
              builder: (context, count) {
                return Container(
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
                      context.read<CounterCubit>().decrement();
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
                      context.read<CounterCubit>().increment();
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
                context.read<CounterCubit>().reset();
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
                    '1. Cubit 클래스 생성\n'
                        '2. BlocProvider로 감싸기\n'
                        '3. BlocBuilder로 UI 업데이트\n'
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