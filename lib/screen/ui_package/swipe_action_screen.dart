import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../widget/default_scaffold.dart';

class SwipeActionScreen extends StatefulWidget {
  const SwipeActionScreen({super.key});

  @override
  State<SwipeActionScreen> createState() => _SwipeActionScreenState();
}

class _SwipeActionScreenState extends State<SwipeActionScreen> {
  final List<String> _items = List.generate(8, (index) => '아이템 ${index + 1}');

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
    _showSnackBar(context, '삭제되었습니다');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('Slidable'),
      ),
      body: Column(
        children: [
          // 헤더
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  '스와이프 액션',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '좌우로 스와이프하여 액션 버튼을 확인하세요',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // 리스트
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ScrollMotion (기본)
                _buildSectionHeader(theme, 'ScrollMotion (기본)'),
                const SizedBox(height: 8),
                _buildSlidableItem(
                  context: context,
                  theme: theme,
                  index: 0,
                  title: 'ScrollMotion',
                  subtitle: '기본 스크롤 모션',
                  motion: const ScrollMotion(),
                ),

                const SizedBox(height: 16),

                // DrawerMotion
                _buildSectionHeader(theme, 'DrawerMotion'),
                const SizedBox(height: 8),
                _buildSlidableItem(
                  context: context,
                  theme: theme,
                  index: 1,
                  title: 'DrawerMotion',
                  subtitle: '서랍처럼 열림',
                  motion: const DrawerMotion(),
                ),

                const SizedBox(height: 16),

                // BehindMotion
                _buildSectionHeader(theme, 'BehindMotion'),
                const SizedBox(height: 8),
                _buildSlidableItem(
                  context: context,
                  theme: theme,
                  index: 2,
                  title: 'BehindMotion',
                  subtitle: '뒤에서 나타남',
                  motion: const BehindMotion(),
                ),

                const SizedBox(height: 16),

                // StretchMotion
                _buildSectionHeader(theme, 'StretchMotion'),
                const SizedBox(height: 8),
                _buildSlidableItem(
                  context: context,
                  theme: theme,
                  index: 3,
                  title: 'StretchMotion',
                  subtitle: '늘어나는 효과',
                  motion: const StretchMotion(),
                ),

                const SizedBox(height: 16),

                // 삭제 가능 (Dismissible)
                _buildSectionHeader(theme, 'Dismissible (삭제 가능)'),
                const SizedBox(height: 8),
                ..._items.map((item) {
                  final index = _items.indexOf(item);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildDismissibleItem(
                      context: context,
                      theme: theme,
                      index: index,
                      title: item,
                    ),
                  );
                }),

                const SizedBox(height: 16),

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
                            '💡 사용 팁',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      _buildInfoItem(
                        theme: theme,
                        text: 'startActionPane: 좌측에서 스와이프',
                      ),
                      _buildInfoItem(
                        theme: theme,
                        text: 'endActionPane: 우측에서 스와이프',
                      ),
                      _buildInfoItem(
                        theme: theme,
                        text: 'motion: 애니메이션 스타일',
                      ),
                      _buildInfoItem(
                        theme: theme,
                        text: 'dismissible: 끝까지 밀면 삭제',
                      ),
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

  // 섹션 헤더
  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 20,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  // Slidable 아이템
  Widget _buildSlidableItem({
    required BuildContext context,
    required ThemeData theme,
    required int index,
    required String title,
    required String subtitle,
    required Widget motion,
  }) {
    return Slidable(
      key: ValueKey(index),
      startActionPane: ActionPane(
        motion: motion,
        children: [
          SlidableAction(
            onPressed: (_) => _showSnackBar(context, '공유'),
            backgroundColor: theme.colorScheme.tertiary,
            foregroundColor: theme.colorScheme.onTertiary,
            icon: Icons.share,
            label: '공유',
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(12),
            ),
          ),
          SlidableAction(
            onPressed: (_) => _showSnackBar(context, '수정'),
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: theme.colorScheme.onSecondary,
            icon: Icons.edit,
            label: '수정',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: motion,
        children: [
          SlidableAction(
            onPressed: (_) => _showSnackBar(context, '보관'),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: '보관',
          ),
          SlidableAction(
            onPressed: (_) => _showSnackBar(context, '삭제'),
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
            icon: Icons.delete,
            label: '삭제',
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(12),
            ),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: CircleAvatar(
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          trailing: Icon(
            Icons.drag_handle,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  // 삭제 가능한 아이템
  Widget _buildDismissibleItem({
    required BuildContext context,
    required ThemeData theme,
    required int index,
    required String title,
  }) {
    return Slidable(
      key: ValueKey('dismissible_$index'),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () => _deleteItem(index),
          confirmDismiss: () async {
            return await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('삭제 확인'),
                content: Text('$title을(를) 삭제하시겠습니까?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('취소'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('삭제'),
                  ),
                ],
              ),
            ) ?? false;
          },
        ),
        children: [
          SlidableAction(
            onPressed: (_) {},
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
            icon: Icons.delete,
            label: '삭제',
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(12),
            ),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Icon(
            Icons.label,
            color: theme.colorScheme.primary,
          ),
          title: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            '좌측으로 밀어서 삭제',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          trailing: Icon(
            Icons.chevron_left,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  // 정보 아이템
  Widget _buildInfoItem({
    required ThemeData theme,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          Icons.check_circle,
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