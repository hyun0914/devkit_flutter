import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../widget/default_scaffold.dart';

class ListScrollCompareScreen extends StatefulWidget {
  const ListScrollCompareScreen({super.key});

  @override
  State<ListScrollCompareScreen> createState() => _ListScrollCompareScreenState();
}

class _ListScrollCompareScreenState extends State<ListScrollCompareScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // SuperSliverList 컨트롤러
  final ListController _listController = ListController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _jumpController = TextEditingController();
  final int _totalItems = 1000;
  int? _currentIndex;

  // ScrollablePositionedList 컨트롤러
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
  ItemPositionsListener.create();
  final TextEditingController _posJumpController = TextEditingController();
  int? _posCurrentIndex;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // SuperSliverList 초기 위치
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _jumpToIndex(44);
    });

    // SuperSliverList 스크롤 위치 추적
    _scrollController.addListener(_updateCurrentIndex);

    // ScrollablePositionedList 위치 추적
    _itemPositionsListener.itemPositions.addListener(() {
      final positions = _itemPositionsListener.itemPositions.value;
      if (positions.isNotEmpty) {
        final first = positions
            .where((p) => p.itemLeadingEdge >= 0)
            .fold<ItemPosition?>(
          null,
              (min, p) => min == null || p.itemLeadingEdge < min.itemLeadingEdge
              ? p
              : min,
        );
        if (first != null && first.index != _posCurrentIndex) {
          setState(() => _posCurrentIndex = first.index);
        }
      }
    });
  }

  void _updateCurrentIndex() {
    final position = _scrollController.position.pixels;
    const itemHeight = 72.0;
    final estimatedIndex = (position / itemHeight).round();
    if (estimatedIndex != _currentIndex) {
      setState(() {
        _currentIndex = estimatedIndex.clamp(0, _totalItems - 1);
      });
    }
  }

  void _jumpToIndex(int index, {double alignment = 0.0}) {
    if (index >= 0 && index < _totalItems) {
      _listController.jumpToItem(
        index: index,
        scrollController: _scrollController,
        alignment: alignment,
      );
      setState(() => _currentIndex = index);
    }
  }

  void _animateToIndex(int index, {double alignment = 0.0}) {
    if (index >= 0 && index < _totalItems) {
      _listController.animateToItem(
        index: index,
        scrollController: _scrollController,
        alignment: alignment,
        duration: (estimatedDistance) => const Duration(milliseconds: 500),
        curve: (estimatedDistance) => Curves.easeInOut,
      );
      setState(() => _currentIndex = index);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _listController.dispose();
    _scrollController.dispose();
    _jumpController.dispose();
    _posJumpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('리스트 스크롤 비교'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.flash_on), text: 'SuperSliverList'),
            Tab(icon: Icon(Icons.list_alt), text: 'PositionedList'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSuperSliverListTab(theme),
          _buildScrollablePositionedListTab(theme),
        ],
      ),
    );
  }

  // SuperSliverList 탭
  Widget _buildSuperSliverListTab(ThemeData theme) {
    return Column(
      children: [
        // 특징 카드
        _buildFeatureCard(
          theme: theme,
          title: 'SuperSliverList',
          color: theme.colorScheme.primary,
          icon: Icons.flash_on,
          features: [
            '대용량 리스트 성능 최적화',
            'Sliver 계열과 완벽 호환',
            'jumpToItem / animateToItem',
            'alignment로 위치 미세 조정',
          ],
        ),

        // 컨트롤 패널
        Container(
          padding: const EdgeInsets.all(12),
          color:
          theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          child: Column(
            spacing: 8,
            children: [
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () => _jumpToIndex(0),
                      child: const Text('처음'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () =>
                          _jumpToIndex((_currentIndex ?? 0) - 50),
                      child: const Text('↑ 50'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () =>
                          _jumpToIndex((_currentIndex ?? 0) + 50),
                      child: const Text('↓ 50'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () => _jumpToIndex(_totalItems - 1),
                      child: const Text('끝'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _jumpController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '인덱스 (0-${_totalItems - 1})',
                        border: const OutlineInputBorder(),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () {
                      final index = int.tryParse(_jumpController.text);
                      if (index != null) {
                        _jumpToIndex(index, alignment: 0.2);
                        _jumpController.clear();
                      }
                    },
                    icon: const Icon(Icons.fast_forward, size: 18),
                    label: const Text('점프'),
                  ),
                  const SizedBox(width: 4),
                  FilledButton.icon(
                    onPressed: () {
                      final index = int.tryParse(_jumpController.text);
                      if (index != null) {
                        _animateToIndex(index, alignment: 0.2);
                        _jumpController.clear();
                      }
                    },
                    icon: const Icon(Icons.play_arrow, size: 18),
                    label: const Text('이동'),
                  ),
                ],
              ),
              // 현재 위치
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '현재 위치: #${_currentIndex ?? 44}  •  총 $_totalItems개',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // SuperSliverList
        Expanded(
          child: SuperListView.builder(
            itemCount: _totalItems,
            listController: _listController,
            controller: _scrollController,
            itemBuilder: (context, index) {
              return _buildListItem(
                theme: theme,
                index: index,
                isHighlighted: index == 44,
                isCurrent: index == _currentIndex,
                highlightLabel: '초기 위치',
                subtitle: index == 44
                    ? '앱 시작 시 이 위치로 점프합니다'
                    : 'SuperSliverList로 빠른 점프',
              );
            },
          ),
        ),
      ],
    );
  }

  // ScrollablePositionedList 탭
  Widget _buildScrollablePositionedListTab(ThemeData theme) {
    return Column(
      children: [
        // 특징 카드
        _buildFeatureCard(
          theme: theme,
          title: 'ScrollablePositionedList',
          color: theme.colorScheme.secondary,
          icon: Icons.list_alt,
          features: [
            '특정 인덱스로 정확한 이동',
            'scrollTo / jumpTo 간단한 API',
            'offset 계산 불필요',
            'ItemPositionsListener로 위치 추적',
          ],
        ),

        // 컨트롤 패널
        Container(
          padding: const EdgeInsets.all(12),
          color:
          theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          child: Column(
            spacing: 8,
            children: [
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () =>
                          _itemScrollController.jumpTo(index: 0),
                      child: const Text('처음'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () => _itemScrollController.jumpTo(
                        index: ((_posCurrentIndex ?? 0) - 50)
                            .clamp(0, _totalItems - 1),
                      ),
                      child: const Text('↑ 50'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () => _itemScrollController.jumpTo(
                        index: ((_posCurrentIndex ?? 0) + 50)
                            .clamp(0, _totalItems - 1),
                      ),
                      child: const Text('↓ 50'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () => _itemScrollController.jumpTo(
                        index: _totalItems - 1,
                      ),
                      child: const Text('끝'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _posJumpController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '인덱스 (0-${_totalItems - 1})',
                        border: const OutlineInputBorder(),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () {
                      final index = int.tryParse(_posJumpController.text);
                      if (index != null &&
                          index >= 0 &&
                          index < _totalItems) {
                        _itemScrollController.jumpTo(index: index);
                        _posJumpController.clear();
                      }
                    },
                    icon: const Icon(Icons.fast_forward, size: 18),
                    label: const Text('점프'),
                  ),
                  const SizedBox(width: 4),
                  FilledButton.icon(
                    onPressed: () {
                      final index = int.tryParse(_posJumpController.text);
                      if (index != null &&
                          index >= 0 &&
                          index < _totalItems) {
                        _itemScrollController.scrollTo(
                          index: index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                        _posJumpController.clear();
                      }
                    },
                    icon: const Icon(Icons.play_arrow, size: 18),
                    label: const Text('이동'),
                  ),
                ],
              ),
              // 현재 위치
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '현재 위치: #${_posCurrentIndex ?? 0}  •  총 $_totalItems개',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ScrollablePositionedList
        Expanded(
          child: ScrollablePositionedList.builder(
            itemCount: _totalItems,
            itemScrollController: _itemScrollController,
            itemPositionsListener: _itemPositionsListener,
            itemBuilder: (context, index) {
              return _buildListItem(
                theme: theme,
                index: index,
                isHighlighted: index == 100,
                isCurrent: index == _posCurrentIndex,
                color: theme.colorScheme.secondary,
                highlightLabel: '타겟',
                subtitle: index == 100
                    ? '이 위치를 타겟으로 이동해보세요'
                    : 'PositionedList 아이템',
              );
            },
          ),
        ),
      ],
    );
  }

  // 특징 카드
  Widget _buildFeatureCard({
    required ThemeData theme,
    required String title,
    required Color color,
    required IconData icon,
    required List<String> features,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(color: color.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: features
                      .map(
                        (f) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        f,
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: color),
                      ),
                    ),
                  )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 리스트 아이템
  Widget _buildListItem({
    required ThemeData theme,
    required int index,
    required bool isHighlighted,
    required bool isCurrent,
    Color? color,
    required String highlightLabel,
    required String subtitle,
  }) {
    final activeColor = color ?? theme.colorScheme.primary;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isHighlighted
            ? activeColor.withValues(alpha: 0.15)
            : isCurrent
            ? theme.colorScheme.secondaryContainer.withValues(alpha: 0.3)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlighted
              ? activeColor
              : theme.colorScheme.outline.withValues(alpha: 0.2),
          width: isHighlighted ? 2 : 1,
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isHighlighted
                ? activeColor
                : theme.colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${index % 100}',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isHighlighted
                    ? Colors.white
                    : theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            Text(
              'Item $index',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight:
                isHighlighted ? FontWeight.bold : FontWeight.w600,
              ),
            ),
            if (isHighlighted) ...[
              const SizedBox(width: 8),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  highlightLabel,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing:
        isHighlighted ? Icon(Icons.star, color: activeColor) : null,
      ),
    );
  }
}