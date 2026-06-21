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

  // 스크롤 팁 탭
  final ScrollController _tipScrollController = ScrollController();
  double _tipScrollOffset = 0;
  double _tipMaxExtent = 0;
  int _physicsIndex = 0; // 0=기본, 1=Clamping, 2=Bouncing
  bool _removeGlow = false;
  final List<GlobalKey> _tipItemKeys = List.generate(4, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // SuperSliverList 초기 위치 — addPostFrameCallback: initState에서 직접 jumpTo 불가
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _jumpToIndex(44);
    });

    // SuperSliverList 스크롤 위치 추적
    _scrollController.addListener(_updateCurrentIndex);

    // 스크롤 팁 탭 offset 추적
    _tipScrollController.addListener(() {
      if (_tipScrollController.hasClients) {
        setState(() {
          _tipScrollOffset = _tipScrollController.offset;
          _tipMaxExtent =
              _tipScrollController.position.maxScrollExtent;
        });
      }
    });

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
    _tipScrollController.dispose();
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
            Tab(icon: Icon(Icons.tips_and_updates), text: '스크롤 팁'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSuperSliverListTab(theme),
          _buildScrollablePositionedListTab(theme),
          _buildScrollTipsTab(theme),
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

  // ── 스크롤 팁 탭 ──
  Widget _buildScrollTipsTab(ThemeData theme) {
    final minExtent = _tipScrollController.hasClients
        ? _tipScrollController.position.minScrollExtent
        : 0.0;

    ScrollPhysics? physics = switch (_physicsIndex) {
      1 => const ClampingScrollPhysics(),
      2 => const BouncingScrollPhysics(),
      _ => null,
    };

    final keyColors = [Colors.red, Colors.orange, Colors.green, Colors.blue];
    final keyLabels = ['앵커 A', '앵커 B', '앵커 C', '앵커 D'];

    return Column(
      children: [
        // ScrollController 정보
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
          child: Column(
            spacing: 8,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildOffsetBadge(theme, 'offset',
                      _tipScrollOffset.toStringAsFixed(1), theme.colorScheme.primary),
                  _buildOffsetBadge(theme, 'minExtent',
                      minExtent.toStringAsFixed(1), Colors.green),
                  _buildOffsetBadge(theme, 'maxExtent',
                      _tipMaxExtent.toStringAsFixed(1), Colors.orange),
                ],
              ),
              Row(
                spacing: 6,
                children: [
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () => _tipScrollController.jumpTo(0),
                      child: const Text('처음'),
                    ),
                  ),
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () {
                        if (_tipScrollController.hasClients) {
                          _tipScrollController.animateTo(
                            _tipScrollController.position.maxScrollExtent / 2,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: const Text('중간 animateTo'),
                    ),
                  ),
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () {
                        if (_tipScrollController.hasClients) {
                          _tipScrollController
                              .jumpTo(_tipScrollController.position.maxScrollExtent);
                        }
                      },
                      child: const Text('끝'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // 설정 패널
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          child: Column(
            spacing: 6,
            children: [
              Row(
                children: [
                  Text('Physics: ', style: theme.textTheme.labelMedium),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SegmentedButton<int>(
                      segments: const [
                        ButtonSegment(value: 0, label: Text('기본')),
                        ButtonSegment(value: 1, label: Text('Clamping')),
                        ButtonSegment(value: 2, label: Text('Bouncing')),
                      ],
                      selected: {_physicsIndex},
                      onSelectionChanged: (v) =>
                          setState(() => _physicsIndex = v.first),
                      style: const ButtonStyle(
                          visualDensity: VisualDensity.compact),
                    ),
                  ),
                ],
              ),
              SwitchListTile(
                title: const Text('Overscroll Glow 제거'),
                subtitle: const Text(
                    '_NoGlowBehavior extends ScrollBehavior → buildOverscrollIndicator returns child'),
                value: _removeGlow,
                onChanged: (v) => setState(() => _removeGlow = v),
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),

        // 스크롤 가능한 본문
        Expanded(
          child: ScrollConfiguration(
            behavior: _removeGlow ? _NoGlowBehavior() : const MaterialScrollBehavior(),
            child: ListView(
              controller: _tipScrollController,
              physics: physics,
              padding: const EdgeInsets.all(16),
              children: [
                // ensureVisible 섹션
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.anchor,
                              size: 16, color: theme.colorScheme.tertiary),
                          const SizedBox(width: 6),
                          Text('Scrollable.ensureVisible',
                              style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Text(
                        'GlobalKey로 등록된 위젯을 뷰포트 안으로 스크롤합니다.',
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant),
                      ),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: List.generate(4, (i) {
                          return FilledButton(
                            onPressed: () {
                              final ctx = _tipItemKeys[i].currentContext;
                              if (ctx != null) {
                                Scrollable.ensureVisible(
                                  ctx,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                  alignment: 0.1,
                                );
                              }
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: keyColors[i],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              minimumSize: Size.zero,
                            ),
                            child: Text('→ ${keyLabels[i]}',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.white)),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 콘텐츠 아이템들 (앵커 포함)
                ..._buildTipListItems(theme, keyColors, keyLabels),

                const SizedBox(height: 16),

                // PrimaryScrollController 안내
                _buildInfoCard(
                  theme: theme,
                  icon: Icons.account_tree_outlined,
                  title: 'PrimaryScrollController',
                  body: 'ListView에 primary: true 설정 시 위젯 트리 상단 컨트롤러에 연결됩니다.\n'
                      'PrimaryScrollController.of(context).animateTo(0, ...) 로 앱바 탭에서 스크롤 탑 구현.',
                ),
                const SizedBox(height: 8),

                // addPostFrameCallback 안내
                _buildInfoCard(
                  theme: theme,
                  icon: Icons.schedule,
                  title: 'addPostFrameCallback',
                  body: 'initState에서 jumpTo / animateTo를 직접 호출하면 에러가 발생합니다.\n'
                      'WidgetsBinding.instance.addPostFrameCallback((_) { ... }) 으로 첫 프레임 이후 실행하세요.',
                  color: Colors.orange,
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTipListItems(
      ThemeData theme, List<Color> keyColors, List<String> keyLabels) {
    final items = <Widget>[];
    const totalItems = 20;
    const anchorPositions = [0, 6, 12, 18];

    for (int i = 0; i < totalItems; i++) {
      final anchorIdx = anchorPositions.indexOf(i);
      final isAnchor = anchorIdx != -1;

      items.add(
        Container(
          key: isAnchor ? _tipItemKeys[anchorIdx] : null,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isAnchor
                ? keyColors[anchorIdx].withValues(alpha: 0.15)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isAnchor
                  ? keyColors[anchorIdx]
                  : theme.colorScheme.outline.withValues(alpha: 0.2),
              width: isAnchor ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isAnchor
                      ? keyColors[anchorIdx]
                      : theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$i',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isAnchor
                          ? Colors.white
                          : theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isAnchor ? '${keyLabels[anchorIdx]} — GlobalKey 앵커' : 'Item $i',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isAnchor ? FontWeight.bold : null,
                    color: isAnchor ? keyColors[anchorIdx] : null,
                  ),
                ),
              ),
              if (isAnchor)
                Icon(Icons.anchor, color: keyColors[anchorIdx], size: 18),
            ],
          ),
        ),
      );
    }
    return items;
  }

  Widget _buildOffsetBadge(
      ThemeData theme, String label, String value, Color color) {
    return Column(
      spacing: 2,
      children: [
        Text(label,
            style: theme.textTheme.labelSmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: Text(
            value,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String body,
    Color? color,
  }) {
    final c = color ?? theme.colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: c.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: c),
              const SizedBox(width: 6),
              Text(title,
                  style: theme.textTheme.labelMedium
                      ?.copyWith(fontWeight: FontWeight.bold, color: c)),
            ],
          ),
          Text(body,
              style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant, height: 1.5)),
        ],
      ),
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

class _NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}