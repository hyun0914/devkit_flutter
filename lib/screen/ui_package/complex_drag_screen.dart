import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';

import '../widget/default_scaffold.dart';

class ComplexDragScreen extends StatefulWidget {
  const ComplexDragScreen({super.key});

  @override
  State<ComplexDragScreen> createState() => _ComplexDragScreenState();
}

class _ComplexDragScreenState extends State<ComplexDragScreen> {
  late List<_ListData> _listsData;

  @override
  void initState() {
    super.initState();
    _resetLists();
  }

  void _resetLists() {
    _listsData = [
      _ListData(
        title: '할 일 📝',
        color: Colors.red,
        items: ['디자인 검토', '기획서 작성', 'API 문서 읽기'],
      ),
      _ListData(
        title: '진행 중 🔥',
        color: Colors.orange,
        items: ['로그인 화면 개발', '데이터베이스 설계'],
      ),
      _ListData(
        title: '완료 ✅',
        color: Colors.green,
        items: ['프로젝트 초기화', '패키지 설치'],
      ),
    ];
  }

  List<DragAndDropList> _buildLists() {
    return _listsData.map((listData) {
      return DragAndDropList(
        header: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: listData.color.withValues(alpha: 0.15),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            border: Border.all(color: listData.color.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  listData.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: listData.color.withValues(alpha: 0.9),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: listData.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${listData.items.length}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: listData.color,
                  ),
                ),
              ),
            ],
          ),
        ),
        children: listData.items
            .map((item) => DragAndDropItem(
          child: _buildTaskCard(item, listData.color),
        ))
            .toList(),
        contentsWhenEmpty: Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            '여기로 드래그하세요',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }).toList();
  }

  Widget _buildTaskCard(String task, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.drag_indicator, color: Colors.grey.shade400, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              task,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('복잡한 드래그 & 드롭'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _resetLists();
              });
            },
            tooltip: '초기화',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.all(16),
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(
                    '작업 관리 보드 (Trello 스타일)',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '• 카드를 다른 컬럼으로 드래그하세요\n'
                        '• 컬럼 헤더를 길게 눌러 순서를 바꾸세요',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // 작업 관리 보드
            Expanded(
              child: DragAndDropLists(
                children: _buildLists(),
                onItemReorder: _onItemReorder,
                onListReorder: _onListReorder,
                listPadding: const EdgeInsets.all(8),
                listInnerDecoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                listWidth: 280,
                listDraggingWidth: 280,
                itemDivider: const Divider(height: 0, color: Colors.transparent),
                itemDecorationWhileDragging: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),

            // 하단 정보 카드
            Container(
              margin: const EdgeInsets.all(16),
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
                spacing: 8,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '💡 drag_and_drop_lists',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '• 리스트 간 아이템 이동 (Trello/Notion 스타일)\n'
                        '• 리스트 자체도 드래그 가능\n'
                        '• 빈 영역에 "여기로 드래그" 안내',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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

  void _onItemReorder(
      int oldItemIndex,
      int oldListIndex,
      int newItemIndex,
      int newListIndex,
      ) {
    setState(() {
      final movedItem = _listsData[oldListIndex].items.removeAt(oldItemIndex);
      _listsData[newListIndex].items.insert(newItemIndex, movedItem);
    });
  }

  void _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      final movedList = _listsData.removeAt(oldListIndex);
      _listsData.insert(newListIndex, movedList);
    });
  }
}

// 리스트 데이터 클래스
class _ListData {
  final String title;
  final Color color;
  final List<String> items;

  _ListData({
    required this.title,
    required this.color,
    required this.items,
  });
}