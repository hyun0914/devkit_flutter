import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'example_data.dart';
import 'example_item.dart';
import 'screen/widget/default_scaffold.dart';
import 'screen/widget/example_list_tile.dart';

export 'example_item.dart';

class ExampleListScreen extends StatefulWidget {
  const ExampleListScreen({super.key});

  @override
  State<ExampleListScreen> createState() => _ExampleListScreenState();
}

class _ExampleListScreenState extends State<ExampleListScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  // 상단 탭: 전체 / 실무 / 재미용
  late TabController _topController;

  // 하단 탭: 카테고리 (동적)
  TabController? _catController;
  List<String> _cats = [];

  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  Set<String> favoriteItems = {};

  final GlobalKey tutorialKey = GlobalKey();
  final GlobalKey tutorialKey2 = GlobalKey();
  final GlobalKey tutorialKey3 = GlobalKey();

  final Map<String, ScrollController> _scrollControllers = {};

  late final List<ExampleItem> allExamples;

  static const _orderedCats = [
    Categories.basicWidget,
    Categories.dataProcessing,
    Categories.uiPackage,
    Categories.network,
    Categories.imageFile,
    Categories.advanced,
    Categories.stateManagement,
  ];

  @override
  void initState() {
    super.initState();
    allExamples = ExampleData.items;
    _topController = TabController(length: 3, vsync: this);
    _topController.addListener(_onTopChanged);
    _rebuildCats();
    _loadFavorites();
  }

  void _onTopChanged() {
    if (_topController.indexIsChanging) return;
    setState(() => _rebuildCats());
  }

  void _rebuildCats() {
    final newCats = _computeCats();

    String? currentCat;
    if (_catController != null && _cats.isNotEmpty) {
      final idx = _catController!.index.clamp(0, _cats.length - 1);
      currentCat = _cats[idx];
    }

    _catController?.dispose();
    _cats = newCats;

    for (final cat in _cats) {
      _scrollControllers.putIfAbsent(cat, () => ScrollController());
    }

    final newIdx = (currentCat != null && newCats.contains(currentCat))
        ? newCats.indexOf(currentCat)
        : 0;

    _catController = TabController(
      length: newCats.length,
      vsync: this,
      initialIndex: newIdx,
    );
  }

  List<String> _computeCats() {
    final topFiltered = _applyTopFilter(allExamples);
    final searchFiltered = searchQuery.isEmpty
        ? topFiltered
        : topFiltered
            .where((e) =>
                e.title.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();

    final usedCats = searchFiltered.map((e) => e.category).toSet();
    final result = <String>[Categories.all];

    if (favoriteItems.isNotEmpty &&
        searchFiltered.any((e) => favoriteItems.contains(e.title))) {
      result.add(Categories.favorites);
    }

    for (final cat in _orderedCats) {
      if (usedCats.contains(cat)) result.add(cat);
    }

    return result;
  }

  List<ExampleItem> _applyTopFilter(List<ExampleItem> items) {
    final idx = _topController.index;
    if (idx == 0) return items;
    return items.where((e) => idx == 1 ? e.isPractical : !e.isPractical).toList();
  }

  List<ExampleItem> _getFilteredItems(String category) {
    final topFiltered = _applyTopFilter(allExamples);
    return topFiltered.where((e) {
      final matchesSearch =
          e.title.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory = category == Categories.all
          ? true
          : category == Categories.favorites
              ? favoriteItems.contains(e.title)
              : e.category == category;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteItems = prefs.getStringList('favorites')?.toSet() ?? {};
      _rebuildCats();
    });
  }

  Future<void> _toggleFavorite(String title) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favoriteItems.contains(title)) {
        favoriteItems.remove(title);
      } else {
        favoriteItems.add(title);
      }
      _rebuildCats();
    });
    await prefs.setStringList('favorites', favoriteItems.toList());
  }

  Future<void> _handleTap(BuildContext context, ExampleItem example) async {
    if (example.title.contains('캐시 이미지')) {
      await FastCachedImageConfig.init(
        clearCacheAfter: const Duration(days: 15),
      );
    }
    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => example.screen),
      );
    }
  }

  TargetFocus _buildTargetFocus({
    required dynamic identify,
    required GlobalKey keyTarget,
    ShapeLightFocus? shape,
    double? paddingFocus,
    required ContentAlign align,
    required EdgeInsets padding,
    required CrossAxisAlignment crossAxisAlignment,
    required List<Widget> children,
  }) {
    return TargetFocus(
      identify: identify,
      keyTarget: keyTarget,
      shape: shape ?? ShapeLightFocus.RRect,
      color: Colors.black26,
      enableOverlayTab: true,
      focusAnimationDuration: const Duration(milliseconds: 400),
      unFocusAnimationDuration: const Duration(milliseconds: 400),
      paddingFocus: paddingFocus,
      contents: [
        TargetContent(
          align: align,
          padding: padding,
          builder: (context, controller) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: crossAxisAlignment,
            children: children,
          ),
        ),
      ],
    );
  }

  void _showTutorial() {
    TutorialCoachMark(
      targets: [
        _buildTargetFocus(
          identify: 'Target 1',
          keyTarget: tutorialKey,
          shape: ShapeLightFocus.Circle,
          paddingFocus: 1,
          align: ContentAlign.left,
          padding: const EdgeInsets.fromLTRB(160, 0, 0, 10),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('위/아래 스크롤 버튼',
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ],
        ),
        _buildTargetFocus(
          identify: 'Target 2',
          keyTarget: tutorialKey2,
          shape: ShapeLightFocus.RRect,
          paddingFocus: 1,
          align: ContentAlign.bottom,
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('검색 기능으로 예제를 빠르게 찾을 수 있습니다',
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ],
        ),
        _buildTargetFocus(
          identify: 'Target 3',
          keyTarget: tutorialKey3,
          shape: ShapeLightFocus.RRect,
          paddingFocus: 1,
          align: ContentAlign.top,
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('카테고리 탭으로 분류별로 볼 수 있습니다',
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ],
        ),
      ],
      colorShadow: Colors.grey.shade200,
      onSkip: () => true,
    ).show(context: context);
  }

  @override
  void dispose() {
    _topController.removeListener(_onTopChanged);
    _topController.dispose();
    _catController?.dispose();
    for (final ctrl in _scrollControllers.values) {
      ctrl.dispose();
    }
    searchController.dispose();
    super.dispose();
  }

  Widget _buildTabContent(
    BuildContext context,
    ThemeData theme,
    String category,
    List<ExampleItem> items,
    ScrollController ctrl,
  ) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category == Categories.favorites
                  ? Icons.star_border
                  : Icons.search_off,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              category == Categories.favorites && searchQuery.isEmpty
                  ? '즐겨찾기한 예제가 없습니다'
                  : '검색 결과가 없습니다',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (searchQuery.isNotEmpty) ...[
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () {
                  searchController.clear();
                  setState(() {
                    searchQuery = '';
                    _rebuildCats();
                  });
                },
                icon: const Icon(Icons.clear, size: 16),
                label: const Text('검색어 초기화'),
              ),
            ],
          ],
        ),
      );
    }

    final showCategory =
        category == Categories.all || category == Categories.favorites;

    return CustomMaterialIndicator(
      onRefresh: () async {
        searchController.clear();
        setState(() {
          searchQuery = '';
          _rebuildCats();
        });
      },
      indicatorBuilder: (context, controller) => const Icon(
        Icons.refresh,
        size: 30,
        color: Colors.green,
      ),
      child: ListView.separated(
        controller: ctrl,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: items.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          indent: 72,
          endIndent: 16,
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        itemBuilder: (context, index) {
          final example = items[index];
          return ExampleListTile(
            example: example,
            isFavorite: favoriteItems.contains(example.title),
            showCategory: showCategory,
            onTap: () => _handleTap(context, example),
            onFavoriteToggle: () => _toggleFavorite(example.title),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final catController = _catController;
    if (catController == null) return const SizedBox();

    return FloatingDraggableWidget(
      floatingWidgetWidth: 48,
      floatingWidgetHeight: 48,
      dx: screenSize.width - 64,
      dy: screenSize.height - 160,
      floatingWidget: FloatingActionButton.small(
        key: tutorialKey,
        backgroundColor: theme.colorScheme.primaryContainer,
        onPressed: () {
          if (_cats.isEmpty) return;
          final cat = _cats[catController.index];
          final ctrl = _scrollControllers[cat];
          if (ctrl == null || !ctrl.hasClients) return;
          final pos = ctrl.position;
          final isAtBottom = pos.pixels >= pos.maxScrollExtent - 10;
          ctrl.animateTo(
            isAtBottom ? pos.minScrollExtent : pos.maxScrollExtent,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
          );
        },
        child: const Icon(Icons.swap_vert),
      ),
      mainScreenWidget: DefaultScaffold(
        appBar: AppBar(
          title: const Text('위젯 & 패키지 샘플'),
          actions: [
            IconButton(
              onPressed: _showTutorial,
              icon: const Icon(Icons.help_outline),
              tooltip: '튜토리얼',
            ),
          ],
          bottom: TabBar(
            controller: _topController,
            tabs: const [
              Tab(text: '전체'),
              Tab(text: '실무'),
              Tab(text: '특수'),
            ],
          ),
        ),
        body: Column(
          children: [
            // 검색
            Padding(
              key: tutorialKey2,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: '예제 검색...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            setState(() {
                              searchQuery = '';
                              _rebuildCats();
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                ),
                onChanged: (value) => setState(() {
                  searchQuery = value;
                  _rebuildCats();
                }),
              ),
            ),

            // 하단 카테고리 탭 (동적)
            TabBar(
              key: tutorialKey3,
              controller: catController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: _cats.map((cat) {
                if (cat == Categories.favorites) {
                  return const Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_rounded, size: 14),
                        SizedBox(width: 4),
                        Text('즐겨찾기'),
                      ],
                    ),
                  );
                }
                return Tab(text: cat);
              }).toList(),
            ),

            // 콘텐츠
            Expanded(
              child: TabBarView(
                controller: catController,
                children: _cats.map((cat) {
                  final items = _getFilteredItems(cat);
                  final ctrl = _scrollControllers[cat]!;
                  return _buildTabContent(context, theme, cat, items, ctrl);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
