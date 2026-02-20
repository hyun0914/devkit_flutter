import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../widget/default_scaffold.dart';

class ButtonTriggerScreen extends StatefulWidget {
  const ButtonTriggerScreen({super.key});

  @override
  State<ButtonTriggerScreen> createState() => _ButtonTriggerScreenState();
}

class _ButtonTriggerScreenState extends State<ButtonTriggerScreen> {
  final GlobalKey _targetButtonKey = GlobalKey();
  final WidgetStatesController _statesController = WidgetStatesController();
  int _clickCount = 0;
  String _lastTriggeredBy = '';

  @override
  void dispose() {
    _statesController.dispose();
    super.dispose();
  }

  void _onTargetButtonPressed() {
    setState(() {
      _clickCount++;
      _lastTriggeredBy = '직접 클릭';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('타겟 버튼 클릭됨 ($_clickCount번째)'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _triggerByPointerEvent() {
    final renderBox =
    _targetButtonKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final centerX = position.dx + (renderBox.size.width / 2);
    final centerY = position.dy + (renderBox.size.height / 2);

    // 버튼 눌림 시뮬레이션
    GestureBinding.instance.handlePointerEvent(
      PointerDownEvent(position: Offset(centerX, centerY)),
    );

    // 버튼 떼기 시뮬레이션
    Future.delayed(const Duration(milliseconds: 100), () {
      GestureBinding.instance.handlePointerEvent(
        PointerUpEvent(position: Offset(centerX, centerY)),
      );
    });

    setState(() {
      _lastTriggeredBy = 'PointerEvent';
    });
  }

  void _triggerByStateController() async {
    // 눌림 효과만 표시 (onPressed는 호출되지 않음)
    _statesController.update(WidgetState.pressed, true);
    await Future.delayed(const Duration(milliseconds: 200));
    _statesController.update(WidgetState.pressed, false);

    if (!mounted) return;

    setState(() {
      _lastTriggeredBy = 'StateController (시각적 효과만)';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('StateController: 시각적 효과만 적용됨'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('Button Trigger'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              'Button Trigger 예제',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '다른 버튼으로 버튼을 제어하는 방법',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 32),

            // 타겟 버튼
            Center(
              child: Column(
                spacing: 16,
                children: [
                  Text(
                    '🎯 타겟 버튼',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: FilledButton.icon(
                      key: _targetButtonKey,
                      statesController: _statesController,
                      onPressed: _onTargetButtonPressed,
                      icon: const Icon(Icons.touch_app, size: 28),
                      label: const Text(
                        '타겟 버튼',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  if (_clickCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '클릭 횟수: $_clickCount번',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ),
                  if (_lastTriggeredBy.isNotEmpty)
                    Text(
                      '마지막 트리거: $_lastTriggeredBy',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // 제어 버튼들
            Text(
              '🎮 제어 버튼',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // 방법 1: PointerEvent
            _buildControlCard(
              theme: theme,
              title: '방법 1: PointerEvent',
              description: '터치 이벤트를 직접 시뮬레이션\n→ onPressed 콜백 실행됨',
              icon: Icons.touch_app,
              color: theme.colorScheme.primary,
              buttonLabel: 'PointerEvent로 트리거',
              onPressed: _triggerByPointerEvent,
            ),

            const SizedBox(height: 16),

            // 방법 2: StateController
            _buildControlCard(
              theme: theme,
              title: '방법 2: StateController',
              description: '버튼 상태만 변경 (시각적 효과만)\n→ onPressed 콜백 실행 안됨',
              icon: Icons.palette,
              color: theme.colorScheme.secondary,
              buttonLabel: 'StateController로 트리거',
              onPressed: _triggerByStateController,
            ),

            const SizedBox(height: 32),

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
                        '💡 차이점',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  _buildInfoItem(
                    theme: theme,
                    icon: Icons.check_circle,
                    text: 'PointerEvent: 실제 터치 시뮬레이션 → onPressed 호출',
                    color: Colors.green,
                  ),
                  _buildInfoItem(
                    theme: theme,
                    icon: Icons.visibility,
                    text: 'StateController: 시각적 효과만 → onPressed 미호출',
                    color: Colors.orange,
                  ),
                  const Divider(),
                  Text(
                    '실제 사용 예시:',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '• PointerEvent: 자동화 테스트, 튜토리얼\n'
                        '• StateController: 로딩 상태 표시',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 리셋 버튼
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _clickCount = 0;
                  _lastTriggeredBy = '';
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('카운터 리셋'),
            ),
          ],
        ),
      ),
    );
  }

  // 제어 카드
  Widget _buildControlCard({
    required ThemeData theme,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required String buttonLabel,
    required VoidCallback onPressed,
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
        spacing: 12,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
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
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonal(
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: color.withValues(alpha: 0.15),
                foregroundColor: color,
              ),
              child: Text(buttonLabel),
            ),
          ),
        ],
      ),
    );
  }

  // 정보 아이템
  Widget _buildInfoItem({
    required ThemeData theme,
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: color),
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