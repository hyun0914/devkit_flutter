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

  final TextEditingController searchController = TextEditingController();

  late final TabController _tabController;
  final Map<String, ScrollController> _scrollControllers = {};

  GlobalKey tutorialKey = GlobalKey();
  GlobalKey tutorialKey2 = GlobalKey();
  GlobalKey tutorialKey3 = GlobalKey();

  String searchQuery = '';
  Set<String> favoriteItems = {};

  static const List<String> _categories = [
    Categories.all,
    Categories.favorites,
    Categories.basicWidget,
    Categories.dataProcessing,
    Categories.uiPackage,
    Categories.network,
    Categories.imageFile,
    Categories.advanced,
    Categories.stateManagement,
  ];

  late final List<ExampleItem> allExamples;

  @override
  void initState() {
    super.initState();
    allExamples = ExampleData.items;
    _loadFavorites();
    _tabController = TabController(length: _categories.length, vsync: this);
    for (final cat in _categories) {
      _scrollControllers[cat] = ScrollController();
    }
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteItems = prefs.getStringList('favorites')?.toSet() ?? {};
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
    });
    await prefs.setStringList('favorites', favoriteItems.toList());
  }

  List<ExampleItem> _getFilteredItems(String category) {
    return allExamples.where((example) {
      final matchesSearch =
          example.title.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory = category == Categories.all ||
          (category == Categories.favorites
              ? favoriteItems.contains(example.title)
              : example.category == category);
      return matchesSearch && matchesCategory;
    }).toList();
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
          align: ContentAlign.top,
          padding: const EdgeInsets.fromLTRB(160, 0, 0, 10),
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
          align: ContentAlign.bottom,
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('탭을 눌러 카테고리를 전환할 수 있습니다',
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ],
        ),
      ],
      colorShadow: Colors.grey.shade200,
      onClickTarget: (target) => debugPrint('onClickTarget $target'),
      onClickTargetWithTapPosition: (target, tapDetails) =>
          debugPrint('onClickTargetWithTapPosition\n$target\n$tapDetails'),
      onClickOverlay: (target) => debugPrint('onClickOverlay $target'),
      onSkip: () {
        debugPrint('onSkip');
        return true;
      },
      onFinish: () => debugPrint('onFinish'),
    ).show(context: context);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
                  setState(() => searchQuery = '');
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
        setState(() => searchQuery = '');
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

    return FloatingDraggableWidget(
      floatingWidgetWidth: 48,
      floatingWidgetHeight: 48,
      dx: screenSize.width - 64,
      dy: screenSize.height - 160,
      floatingWidget: FloatingActionButton.small(
        key: tutorialKey,
        backgroundColor: theme.colorScheme.primaryContainer,
        onPressed: () {
          final cat = _categories[_tabController.index];
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
            key: tutorialKey3,
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: _categories.map((cat) {
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
        ),
        body: Column(
          children: [
            Padding(
              key: tutorialKey2,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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
                            setState(() => searchQuery = '');
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
                onChanged: (value) => setState(() => searchQuery = value),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _categories.map((cat) {
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
