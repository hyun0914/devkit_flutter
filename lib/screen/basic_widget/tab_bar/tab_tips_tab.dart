import 'package:flutter/material.dart';

class TabTipsTab extends StatefulWidget {
  const TabTipsTab({super.key});

  @override
  State<TabTipsTab> createState() => _TabTipsTabState();
}

class _TabTipsTabState extends State<TabTipsTab>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _scrollTabController;
  final _scrollItems = ['음식', '패션', '전자기기', '여행', '스포츠', '뷰티', '도서', '홈'];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollTabController =
        TabController(length: _scrollItems.length, vsync: this);
  }

  @override
  void dispose() {
    _scrollTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      key: const PageStorageKey('tab_tips_tab'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // isScrollable
          _buildSectionHeader(theme, 'isScrollable: true'),
          const SizedBox(height: 6),
          Text(
            '탭이 많을 때 가로 스크롤 — tabAlignment: start 함께 사용',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                TabBar(
                  controller: _scrollTabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  dividerHeight: 0,
                  tabs: _scrollItems.map((e) => Tab(text: e)).toList(),
                ),
                SizedBox(
                  height: 48,
                  child: TabBarView(
                    controller: _scrollTabController,
                    children: _scrollItems
                        .map((e) => Center(
                              child: Text('$e 화면',
                                  style: theme.textTheme.bodyMedium),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // labelPadding
          _buildSectionHeader(theme, 'labelPadding 비교'),
          const SizedBox(height: 6),
          Text(
            'kTabLabelPadding 기본값 = EdgeInsets.symmetric(horizontal: 16)',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          Column(
            spacing: 8,
            children: [
              _buildLabelPaddingDemo(theme, 'horizontal: 4 (좁게)',
                  const EdgeInsets.symmetric(horizontal: 4)),
              _buildLabelPaddingDemo(theme, 'horizontal: 16 (기본)',
                  const EdgeInsets.symmetric(horizontal: 16)),
              _buildLabelPaddingDemo(theme, 'horizontal: 32 (넓게)',
                  const EdgeInsets.symmetric(horizontal: 32)),
            ],
          ),

          const SizedBox(height: 24),

          // physics
          _buildSectionHeader(theme, 'TabBarView physics'),
          const SizedBox(height: 6),
          Text(
            '내부에 가로 스크롤 위젯이 있어 충돌할 때 NeverScrollable 사용',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          Column(
            spacing: 6,
            children: [
              _buildPhysicsRow(theme, 'NeverScrollableScrollPhysics()',
                  '스와이프 비활성화 → 탭 클릭만 동작'),
              _buildPhysicsRow(
                  theme, 'BouncingScrollPhysics()', '끝에서 바운스 (iOS 스타일)'),
              _buildPhysicsRow(
                  theme, 'ClampingScrollPhysics()', 'Android 기본 동작'),
              _buildPhysicsRow(
                  theme, 'null', 'ScrollBehavior 플랫폼 기본값 따름'),
            ],
          ),

          const SizedBox(height: 24),

          // AutomaticKeepAlive
          _buildSectionHeader(theme, '리렌더링 방지'),
          const SizedBox(height: 12),
          Column(
            spacing: 8,
            children: [
              _buildStepCard(
                theme,
                step: '1단계',
                title: 'PageStorageKey("unique_key")',
                desc: '스크롤 위치만 보존 — 탭 전환 시 리렌더링은 여전히 발생',
              ),
              _buildStepCard(
                theme,
                step: '2단계',
                title: 'AutomaticKeepAliveClientMixin',
                desc:
                    'wantKeepAlive: true 설정\nsuper.build(context) 반드시 호출\nStatefulWidget으로 탭 콘텐츠 분리 필요',
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: theme.colorScheme.error, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '모든 탭에 무조건 적용 금지 → 메모리 낭비\n렌더링 비용 높은 탭에만 선택적으로 적용',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
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

  Widget _buildLabelPaddingDemo(
      ThemeData theme, String label, EdgeInsets padding) {
    return DefaultTabController(
      length: 3,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
              child: Text(label,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ),
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelPadding: padding,
              dividerHeight: 0,
              tabs: const [Tab(text: '탭 A'), Tab(text: '탭 B'), Tab(text: '탭 C')],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhysicsRow(ThemeData theme, String name, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 5),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
              color: theme.colorScheme.primary, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: theme.textTheme.labelMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              Text(desc,
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepCard(ThemeData theme,
      {required String step, required String title, required String desc}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(step,
                style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(title,
                    style: theme.textTheme.labelMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                Text(desc,
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
