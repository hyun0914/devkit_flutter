import 'package:flutter/material.dart';

import 'tab_bar/bottom_sheet_tab.dart';
import 'tab_bar/snapping_sheet_tab.dart';
import 'tab_bar/sliver_tab.dart';
import 'tab_bar/tab_tips_tab.dart';
import '../widget/default_scaffold.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _swipeEnabled = true;

  final List<TabData> _tabs = [
    TabData(
      title: 'BottomSheet',
      icon: Icons.vertical_align_bottom_outlined,
      selectedIcon: Icons.vertical_align_bottom,
    ),
    TabData(
      title: 'Snapping',
      icon: Icons.swap_vert_outlined,
      selectedIcon: Icons.swap_vert,
    ),
    TabData(
      title: 'Sliver',
      icon: Icons.view_list_outlined,
      selectedIcon: Icons.view_list,
    ),
    TabData(
      title: 'Tips',
      icon: Icons.tips_and_updates_outlined,
      selectedIcon: Icons.tips_and_updates,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('TabBar 예제'),
        elevation: 0,
        actions: [
          IconButton(
            tooltip: _swipeEnabled ? '스와이프 끄기' : '스와이프 켜기',
            icon: Icon(
              _swipeEnabled ? Icons.swipe : Icons.swipe_right_alt,
            ),
            onPressed: () => setState(() => _swipeEnabled = !_swipeEnabled),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelPadding: const EdgeInsets.symmetric(horizontal: 8),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 3,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(3),
                ),
              ),
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
              labelStyle: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.normal,
              ),
              tabs: _tabs.map((tab) {
                final index = _tabs.indexOf(tab);
                return AnimatedBuilder(
                  animation: _tabController,
                  builder: (context, child) {
                    final isSelected = _tabController.index == index;
                    return Tab(
                      height: 56,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isSelected ? tab.selectedIcon : tab.icon,
                            size: 22,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tab.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          physics: _swipeEnabled
              ? null
              : const NeverScrollableScrollPhysics(),
          children: const [
            BottomSheetTab(),
            SnappingSheetTab(),
            SliverTab(),
            TabTipsTab(),
          ],
        ),
      ),
    );
  }
}

// TabBar 데이터 모델
class TabData {
  final String title;
  final IconData icon;
  final IconData selectedIcon;

  TabData({
    required this.title,
    required this.icon,
    required this.selectedIcon,
  });
}