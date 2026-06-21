import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widget/default_scaffold.dart';

// ActivateIntent 방식 — 커스텀 Intent (ActivateIntent 상속)
class _SimActivateIntent extends ActivateIntent {
  const _SimActivateIntent(this.focusNode);
  final FocusNode focusNode;
}

// ActivateIntent 방식 — 커스텀 Action
class _SimActivateAction extends Action<_SimActivateIntent> {
  @override
  Object? invoke(_SimActivateIntent intent) {
    final ctx = intent.focusNode.context;
    if (ctx != null) {
      Actions.maybeInvoke(ctx, const ActivateIntent());
    }
    return null;
  }
}

class ButtonTriggerScreen extends StatefulWidget {
  const ButtonTriggerScreen({super.key});

  @override
  State<ButtonTriggerScreen> createState() => _ButtonTriggerScreenState();
}

class _ButtonTriggerScreenState extends State<ButtonTriggerScreen> {
  final GlobalKey _targetButtonKey = GlobalKey();
  final WidgetStatesController _statesController = WidgetStatesController();
  final FocusNode _activateFocusNode = FocusNode();

  int _clickCount = 0;
  String _lastTriggeredBy = '';
  String _pendingSource = '';

  @override
  void dispose() {
    _statesController.dispose();
    _activateFocusNode.dispose();
    super.dispose();
  }

  void _onTargetButtonPressed() {
    setState(() {
      _clickCount++;
      _lastTriggeredBy =
          _pendingSource.isEmpty ? '직접 클릭' : _pendingSource;
      _pendingSource = '';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('타겟 버튼 $_clickCount번째 — $_lastTriggeredBy'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // 방법 1: ActivateIntent — 리플 + onPressed 모두 실행 (권장)
  void _triggerByActivateIntent() {
    _pendingSource = 'ActivateIntent (리플 + onPressed)';
    Actions.maybeInvoke(context, _SimActivateIntent(_activateFocusNode));
  }

  // 방법 2: PointerEvent — 실제 터치 이벤트 시뮬레이션
  void _triggerByPointerEvent() {
    _pendingSource = 'PointerEvent';
    final renderBox =
        _targetButtonKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final centerX = position.dx + (renderBox.size.width / 2);
    final centerY = position.dy + (renderBox.size.height / 2);

    GestureBinding.instance.handlePointerEvent(
      PointerDownEvent(position: Offset(centerX, centerY)),
    );
    Future.delayed(const Duration(milliseconds: 100), () {
      GestureBinding.instance.handlePointerEvent(
        PointerUpEvent(position: Offset(centerX, centerY)),
      );
    });
  }

  // 방법 3: StateController — 시각적 pressed 상태만 토글
  void _triggerByStateController() async {
    _statesController.update(WidgetState.pressed, true);
    await Future.delayed(const Duration(milliseconds: 200));
    _statesController.update(WidgetState.pressed, false);

    if (!mounted) return;
    setState(() => _lastTriggeredBy = 'StateController (시각적 효과만)');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('StateController: pressed 색상 변화만 적용됨'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(title: const Text('Button Trigger')),
      body: SafeArea(
        // Shortcuts → Actions가 ListView 상위에 위치해야 트리거 버튼에서도 invoke 가능
        child: Shortcuts(
          shortcuts: {
            SingleActivator(LogicalKeyboardKey.keyT):
                _SimActivateIntent(_activateFocusNode),
          },
          child: Actions(
            actions: {_SimActivateIntent: _SimActivateAction()},
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Button Trigger 예제',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '코드에서 버튼 동작을 시뮬레이션하는 방법 3가지',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),

                const SizedBox(height: 32),

                // 타겟 버튼 — Focus로 감싸서 FocusNode 연결
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
                          color: theme.colorScheme.primaryContainer
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                        child: Focus(
                          focusNode: _activateFocusNode,
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
                                  horizontal: 32, vertical: 16),
                            ),
                          ),
                        ),
                      ),
                      if (_clickCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
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

                Text(
                  '🎮 제어 버튼',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // 방법 1
                _buildControlCard(
                  theme: theme,
                  badge: '권장',
                  title: '방법 1: ActivateIntent',
                  description:
                      'Shortcuts → Actions → Focus(focusNode) → 버튼 구조\n'
                      '→ 리플 애니메이션 + onPressed 콜백 모두 실행',
                  icon: Icons.bolt,
                  color: theme.colorScheme.primary,
                  buttonLabel: 'ActivateIntent로 트리거',
                  onPressed: _triggerByActivateIntent,
                ),

                const SizedBox(height: 16),

                // 방법 2
                _buildControlCard(
                  theme: theme,
                  title: '방법 2: PointerEvent',
                  description:
                      'GestureBinding으로 터치 이벤트 직접 주입\n'
                      '→ onPressed 실행, 리플은 플랫폼에 따라 상이',
                  icon: Icons.touch_app,
                  color: theme.colorScheme.secondary,
                  buttonLabel: 'PointerEvent로 트리거',
                  onPressed: _triggerByPointerEvent,
                ),

                const SizedBox(height: 16),

                // 방법 3
                _buildControlCard(
                  theme: theme,
                  title: '방법 3: StateController',
                  description:
                      'statesController.update(WidgetState.pressed, true/false)\n'
                      '→ pressed 색상 변화만, 리플·onPressed 미실행',
                  icon: Icons.palette,
                  color: theme.colorScheme.tertiary,
                  buttonLabel: 'StateController로 트리거',
                  onPressed: _triggerByStateController,
                ),

                const SizedBox(height: 32),

                // 비교표
                _buildComparisonTable(theme),

                const SizedBox(height: 16),

                // 주의사항
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color:
                            theme.colorScheme.outline.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: theme.colorScheme.primary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '💡 주의사항',
                            style: theme.textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      _buildInfoRow(
                        theme,
                        Icons.warning_amber,
                        'onTap/onPressed 직접 호출 시 로직은 실행되지만 리플·pressed 시각 효과 없음',
                        Colors.orange,
                      ),
                      _buildInfoRow(
                        theme,
                        Icons.account_tree_outlined,
                        'Shortcuts 위젯은 트리 상위에 위치할수록 적용 범위 넓어짐',
                        theme.colorScheme.primary,
                      ),
                      _buildInfoRow(
                        theme,
                        Icons.delete_outline,
                        'FocusNode는 dispose()에서 반드시 해제',
                        theme.colorScheme.primary,
                      ),
                      _buildInfoRow(
                        theme,
                        Icons.keyboard,
                        'T 키 입력으로 ActivateIntent 트리거 가능 (키보드 연결 시)',
                        Colors.teal,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                OutlinedButton.icon(
                  onPressed: () => setState(() {
                    _clickCount = 0;
                    _lastTriggeredBy = '';
                  }),
                  icon: const Icon(Icons.refresh),
                  label: const Text('카운터 리셋'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControlCard({
    required ThemeData theme,
    String? badge,
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
          color: badge != null
              ? color.withValues(alpha: 0.5)
              : theme.colorScheme.outline.withValues(alpha: 0.2),
          width: badge != null ? 1.5 : 1,
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
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              if (badge != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    badge,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: color,
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

  Widget _buildComparisonTable(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '📊 비교표',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(12)),
            child: Table(
              border: TableBorder.symmetric(
                inside: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2)),
              ),
              columnWidths: const {
                0: FlexColumnWidth(2.2),
                1: FlexColumnWidth(1.8),
                2: FlexColumnWidth(1.8),
                3: FlexColumnWidth(2.2),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest),
                  children: [
                    _buildCell(theme, '', isHeader: true),
                    _buildCell(theme, 'Activate\nIntent', isHeader: true),
                    _buildCell(theme, 'Pointer\nEvent', isHeader: true),
                    _buildCell(theme, 'States\nController', isHeader: true),
                  ],
                ),
                ...[
                  ('리플 애니메이션', '✅', '플랫폼별', '❌'),
                  ('onPressed 실행', '✅', '✅', '❌'),
                  ('구현 복잡도', '중간', '낮음', '낮음'),
                  ('권장 상황', '실제 탭과 동일', '자동화·테스트', '시각 피드백만'),
                ].map(
                  (row) => TableRow(
                    children: [
                      _buildCell(theme, row.$1),
                      _buildCell(theme, row.$2),
                      _buildCell(theme, row.$3),
                      _buildCell(theme, row.$4),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCell(ThemeData theme, String text, {bool isHeader = false}) {
    return Container(
      height: isHeader ? 48 : 40,
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            color: isHeader ? theme.colorScheme.onSurfaceVariant : null,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      ThemeData theme, IconData icon, String text, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
