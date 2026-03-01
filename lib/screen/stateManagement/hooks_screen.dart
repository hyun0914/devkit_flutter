import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../widget/default_scaffold.dart';

class HooksScreen extends HookWidget {
  const HooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 1. useState - 카운터
    final counter = useState(0);

    // 2. useEffect - 자동 타이머
    final seconds = useState(0);
    final isTimerRunning = useState(false);

    useEffect(() {
      if (!isTimerRunning.value) return null;

      final timer = Stream.periodic(
        const Duration(seconds: 1),
            (count) => count,
      ).listen((_) {
        seconds.value++;
      });

      return timer.cancel;
    }, [isTimerRunning.value]);

    // 3. useMemoized - 계산 캐싱
    final numberInput = useState(10);
    final sum = useMemoized(
          () {
        // 1부터 numberInput까지의 합계 계산 (무거운 연산 시뮬레이션)
        int result = 0;
        for (int i = 1; i <= numberInput.value; i++) {
          result += i;
        }
        return result;
      },
      [numberInput.value],
    );

    // 4. useTextEditingController
    final textController = useTextEditingController();
    final textLength = useState(0);

    useEffect(() {
      void listener() {
        textLength.value = textController.text.length;
      }

      textController.addListener(listener);
      return () => textController.removeListener(listener);
    }, [textController]);

    // 5. useAnimationController
    final animationController = useAnimationController(
      duration: const Duration(seconds: 2),
    );

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('Flutter Hooks'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              'Flutter Hooks',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '상태 관리 및 생명주기를 간단하게',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // 1. useState
            _buildSectionHeader(theme, '1. useState (상태 관리)'),
            const SizedBox(height: 12),
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
                children: [
                  Text(
                    '${counter.value}',
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => counter.value++,
                          icon: const Icon(Icons.add),
                          label: const Text('+1'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton.tonalIcon(
                          onPressed: () => counter.value--,
                          icon: const Icon(Icons.remove),
                          label: const Text('-1'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => counter.value = 0,
                          icon: const Icon(Icons.refresh),
                          label: const Text('리셋'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoBox(
                    theme: theme,
                    text: 'StatefulWidget 없이 상태 관리',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 2. useEffect
            _buildSectionHeader(theme, '2. useEffect (생명주기)'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.timer,
                        size: 32,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${seconds.value}초',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            isTimerRunning.value = true;
                          },
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('시작'),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton.tonalIcon(
                          onPressed: () {
                            isTimerRunning.value = false;
                          },
                          icon: const Icon(Icons.pause),
                          label: const Text('정지'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            isTimerRunning.value = false;
                            seconds.value = 0;
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('리셋'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoBox(
                    theme: theme,
                    text: 'initState, dispose 역할 수행',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 3. useMemoized
            _buildSectionHeader(theme, '3. useMemoized (메모이제이션)'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.tertiary.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '입력 숫자',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${numberInput.value}',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward, size: 32),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '합계 (1~N)',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$sum',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.tertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => numberInput.value += 5,
                          icon: const Icon(Icons.add),
                          label: const Text('+5'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton.tonalIcon(
                          onPressed: () {
                            if (numberInput.value > 5) {
                              numberInput.value -= 5;
                            }
                          },
                          icon: const Icon(Icons.remove),
                          label: const Text('-5'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoBox(
                    theme: theme,
                    text: '값이 변경될 때만 재계산 (성능 최적화)',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 4. useTextEditingController
            _buildSectionHeader(theme, '4. useTextEditingController'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.error.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      labelText: '텍스트 입력',
                      hintText: '무엇이든 입력하세요...',
                      border: const OutlineInputBorder(),
                      suffixIcon: textController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => textController.clear(),
                      )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.text_fields,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '입력 길이: ${textLength.value}자',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoBox(
                    theme: theme,
                    text: 'TextEditingController 자동 관리 (dispose 불필요)',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 5. useAnimationController
            _buildSectionHeader(theme, '5. useAnimationController'),
            const SizedBox(height: 12),
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
                children: [
                  RotationTransition(
                    turns: animationController,
                    child: Icon(
                      Icons.refresh,
                      size: 64,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            animationController.repeat();
                          },
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('시작'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton.tonalIcon(
                          onPressed: () {
                            animationController.stop();
                          },
                          icon: const Icon(Icons.pause),
                          label: const Text('정지'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            animationController.reset();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('리셋'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoBox(
                    theme: theme,
                    text: 'AnimationController 자동 관리 (dispose 불필요)',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 사용된 패키지
            _buildSectionHeader(theme, '사용된 패키지'),
            const SizedBox(height: 12),
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
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.extension,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: theme.textTheme.bodySmall,
                            children: [
                              const TextSpan(
                                text: 'flutter_hooks',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              TextSpan(
                                text: ' - React Hooks 스타일 상태 관리',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Hooks 장점
            _buildSectionHeader(theme, 'Hooks 장점'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAdvantageItem(
                    theme: theme,
                    icon: Icons.code,
                    text: 'StatefulWidget 불필요',
                  ),
                  const SizedBox(height: 8),
                  _buildAdvantageItem(
                    theme: theme,
                    icon: Icons.cleaning_services,
                    text: '자동 dispose (메모리 누수 방지)',
                  ),
                  const SizedBox(height: 8),
                  _buildAdvantageItem(
                    theme: theme,
                    icon: Icons.layers,
                    text: '로직 재사용 가능',
                  ),
                  const SizedBox(height: 8),
                  _buildAdvantageItem(
                    theme: theme,
                    icon: Icons.speed,
                    text: '간결한 코드',
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

  // 정보 박스
  Widget _buildInfoBox({
    required ThemeData theme,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
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
      ),
    );
  }

  // 장점 아이템
  Widget _buildAdvantageItem({
    required ThemeData theme,
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}