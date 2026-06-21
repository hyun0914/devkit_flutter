import 'package:flutter/material.dart';
import 'package:animated_reorderable/animated_reorderable.dart';
import 'package:animated_reorderable_list/animated_reorderable_list.dart';

import '../widget/default_scaffold.dart';

class DragReorderScreen extends StatefulWidget {
  const DragReorderScreen({super.key});

  @override
  State<DragReorderScreen> createState() => _DragReorderScreenState();
}

class _DragReorderScreenState extends State<DragReorderScreen> {
  int _modeIndex = 0; // 0: animated_reorderable_list, 1: ReorderableListView, 2: animated_reorderable
  List<User> _list = [];
  Color? _dragTargetColor;
  bool _customHandles = false;

  final _animatedReorderableKey = GlobalKey<AnimatedReorderableState>();

  @override
  void initState() {
    super.initState();
    _list = List.generate(8, (index) => User(id: index));
  }

  void _switchMode(int index) {
    setState(() => _modeIndex = index);
  }

  ({String title, String description, Color Function(ThemeData) color, IconData icon}) get _currentMode {
    return switch (_modeIndex) {
      0 => (
      title: '📦 animated_reorderable_list',
      description: '애니메이션 효과 • 길게 눌러서 드래그',
      color: (ThemeData t) => t.colorScheme.primaryContainer,
      icon: Icons.animation,
      ),
      1 => (
      title: '📋 ReorderableListView (내장)',
      description: '기본 재정렬 • 드래그 핸들로 이동',
      color: (ThemeData t) => t.colorScheme.secondaryContainer,
      icon: Icons.reorder,
      ),
      _ => (
      title: '🔄 animated_reorderable',
      description: '래퍼 방식 • keyGetter로 키 관리 • GridView 지원',
      color: (ThemeData t) => t.colorScheme.tertiaryContainer,
      icon: Icons.swap_vert,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mode = _currentMode;

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('Drag & Reorder'),
      ),
      body: Column(
        children: [
          // 모드 표시 헤더
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: mode.color(theme).withValues(alpha: 0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Row(
                  children: [
                    Icon(mode.icon, color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      mode.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  mode.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // 모드 전환 탭 (SegmentedButton)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(
                  value: 0,
                  label: Text('패키지1'),
                  icon: Icon(Icons.animation, size: 16),
                ),
                ButtonSegment(
                  value: 1,
                  label: Text('내장'),
                  icon: Icon(Icons.reorder, size: 16),
                ),
                ButtonSegment(
                  value: 2,
                  label: Text('패키지2'),
                  icon: Icon(Icons.swap_vert, size: 16),
                ),
              ],
              selected: {_modeIndex},
              onSelectionChanged: (val) => _switchMode(val.first),
              style: const ButtonStyle(
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),

          // Draggable 데모 섹션
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Text(
                  'Draggable 데모',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Draggable (즉시)
                    Column(
                      spacing: 6,
                      children: [
                        Draggable<Color>(
                          data: Colors.green,
                          feedback: Material(
                            elevation: 8,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(Icons.touch_app,
                                  color: Colors.white, size: 48),
                            ),
                          ),
                          childWhenDragging: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: theme.colorScheme.outline, width: 2),
                            ),
                            child: Icon(Icons.touch_app,
                                color: theme.colorScheme.outline, size: 28),
                          ),
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.touch_app,
                                color: Colors.white, size: 28),
                          ),
                        ),
                        Text('Draggable\n(즉시 드래그)',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.labelSmall),
                      ],
                    ),

                    // LongPressDraggable (길게 누름)
                    Column(
                      spacing: 6,
                      children: [
                        LongPressDraggable<Color>(
                          data: Colors.orange,
                          feedback: Material(
                            elevation: 8,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(Icons.pan_tool,
                                  color: Colors.white, size: 48),
                            ),
                          ),
                          childWhenDragging: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: theme.colorScheme.outline, width: 2),
                            ),
                            child: Icon(Icons.pan_tool,
                                color: theme.colorScheme.outline, size: 28),
                          ),
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.pan_tool,
                                color: Colors.white, size: 28),
                          ),
                        ),
                        Text('LongPressDraggable\n(길게 눌러 드래그)',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.labelSmall),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Icon(Icons.arrow_forward,
                          color: theme.colorScheme.primary),
                    ),

                    // DragTarget (공유)
                    Column(
                      spacing: 6,
                      children: [
                        DragTarget<Color>(
                          onWillAcceptWithDetails: (details) => true,
                          onAcceptWithDetails: (details) {
                            setState(() => _dragTargetColor = details.data);
                          },
                          onLeave: (data) {
                            setState(() => _dragTargetColor = null);
                          },
                          builder: (context, candidateData, rejectedData) {
                            return Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: _dragTargetColor ??
                                    theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: candidateData.isNotEmpty
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.outline,
                                  width: candidateData.isNotEmpty ? 3 : 2,
                                ),
                              ),
                              child: Icon(
                                _dragTargetColor != null
                                    ? Icons.check_circle
                                    : Icons.inbox,
                                color: _dragTargetColor != null
                                    ? Colors.white
                                    : theme.colorScheme.onSurfaceVariant,
                                size: 28,
                              ),
                            );
                          },
                        ),
                        Text('DragTarget\n(공유)',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.labelSmall),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 16),

          // 리스트 섹션 헤더
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Icon(Icons.list, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Reorderable 리스트',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_list.length}개 항목',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 리스트
          Expanded(
            child: switch (_modeIndex) {
              0 => _buildAnimatedReorderableList(theme),
              1 => _buildReorderableListView(theme),
              _ => _buildAnimatedReorderable(theme),
            },
          ),
        ],
      ),
    );
  }

  // ── 1. animated_reorderable_list ──
  Widget _buildAnimatedReorderableList(ThemeData theme) {
    return AnimatedReorderableListView(
      items: _list,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final user = _list[index];
        return _ItemTile(
          key: ValueKey(user.id),
          id: user.id,
          color: theme.colorScheme.primaryContainer,
          textColor: theme.colorScheme.onPrimaryContainer,
          icon: Icons.drag_indicator,
        );
      },
      enterTransition: [SlideInDown()],
      exitTransition: [SlideInUp()],
      insertDuration: const Duration(milliseconds: 300),
      removeDuration: const Duration(milliseconds: 300),
      dragStartDelay: const Duration(milliseconds: 200),
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) newIndex -= 1;
          final User user = _list.removeAt(oldIndex);
          _list.insert(newIndex, user);
        });
      },
      isSameItem: (a, b) => a.id == b.id,
    );
  }

  // ── 2. ReorderableListView (내장) ──
  Widget _buildReorderableListView(ThemeData theme) {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('buildDefaultDragHandles: false'),
          subtitle: const Text('기본 핸들 숨김 → ReorderableDragStartListener 사용'),
          value: _customHandles,
          onChanged: (v) => setState(() => _customHandles = v),
          dense: true,
        ),
        Expanded(
          child: ReorderableListView.builder(
            buildDefaultDragHandles: !_customHandles,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _list.length,
            itemBuilder: (context, index) {
              final user = _list[index];
              if (_customHandles) {
                return ReorderableDragStartListener(
                  key: ValueKey(user.id),
                  index: index,
                  child: _ItemTile(
                    id: user.id,
                    color: theme.colorScheme.secondaryContainer,
                    textColor: theme.colorScheme.onSecondaryContainer,
                    icon: Icons.drag_handle,
                  ),
                );
              }
              return _ItemTile(
                key: ValueKey(user.id),
                id: user.id,
                color: theme.colorScheme.secondaryContainer,
                textColor: theme.colorScheme.onSecondaryContainer,
                icon: Icons.drag_handle,
              );
            },
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex) newIndex -= 1;
                final User user = _list.removeAt(oldIndex);
                _list.insert(newIndex, user);
              });
            },
          ),
        ),
      ],
    );
  }

  // ── 3. animated_reorderable ──
  Widget _buildAnimatedReorderable(ThemeData theme) {
    return AnimatedReorderable.list(
      key: _animatedReorderableKey,
      keyGetter: (index) => ValueKey(_list[index].id),
      onReorder: (permutations) {
        setState(() => permutations.apply(_list));
      },
      listView: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _list.length,
        itemBuilder: (context, index) {
          final user = _list[index];
          return _ItemTile(
            key: ValueKey(user.id),
            id: user.id,
            color: theme.colorScheme.tertiaryContainer,
            textColor: theme.colorScheme.onTertiaryContainer,
            icon: Icons.drag_indicator,
          );
        },
      ),
    );
  }
}

// ── 데이터 모델 ──
class User {
  final int id;
  User({required this.id});
}

// ── 아이템 타일 ──
class _ItemTile extends StatelessWidget {
  final int id;
  final Color color;
  final Color textColor;
  final IconData icon;

  const _ItemTile({
    super.key,
    required this.id,
    required this.color,
    required this.textColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 64,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: textColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$id',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Item $id',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
          Icon(icon, color: textColor.withValues(alpha: 0.7), size: 24),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}