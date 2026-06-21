import 'package:flutter/material.dart';

class ScaffoldScreen extends StatefulWidget {
  const ScaffoldScreen({super.key});

  @override
  State<ScaffoldScreen> createState() => _ScaffoldScreenState();
}

class _ScaffoldScreenState extends State<ScaffoldScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  // BottomNavigationBar 데모
  int _navIndex = 0;
  BottomNavigationBarType _navType = BottomNavigationBarType.fixed;
  bool _showActiveIcon = true;
  bool _showLabels = true;
  bool _removeElevation = false;
  bool _removeAnimation = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Scaffold & Drawer'),
        leadingWidth: 96,
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.of(context).pop(),
              tooltip: '뒤로가기',
            ),
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              tooltip: '좌측 Drawer',
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
            tooltip: '우측 Drawer',
          ),
        ],
      ),
      // 좌측 Drawer
      drawer: _buildLeftDrawer(theme),
      // 우측 Drawer
      endDrawer: _buildRightDrawer(theme),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 16,
            children: [
              // 헤더
              Text(
                'Scaffold 컴포넌트',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Drawer, AppBar, BottomNavigationBar 등을 확인해보세요',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 8),

              // Drawer 버튼들
              _buildExampleCard(
                theme: theme,
                title: 'Drawer 열기',
                icon: Icons.menu_open,
                description: '좌측에서 슬라이드되는 메뉴',
                color: theme.colorScheme.primary,
                onTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),

              _buildExampleCard(
                theme: theme,
                title: 'End Drawer 열기',
                icon: Icons.settings,
                description: '우측에서 슬라이드되는 설정',
                color: theme.colorScheme.secondary,
                onTap: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
              ),

              // Drawer 상태 확인
              _buildExampleCard(
                theme: theme,
                title: 'Drawer 상태 확인',
                icon: Icons.info_outline,
                description: 'Drawer가 열려있는지 확인',
                color: theme.colorScheme.tertiary,
                onTap: () {
                  final isDrawerOpen =
                      _scaffoldKey.currentState?.isDrawerOpen ?? false;
                  final isEndDrawerOpen =
                      _scaffoldKey.currentState?.isEndDrawerOpen ?? false;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '좌측 Drawer: ${isDrawerOpen ? "열림" : "닫힘"}\n'
                        '우측 Drawer: ${isEndDrawerOpen ? "열림" : "닫힘"}',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // 정보 섹션
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
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
                          Icons.lightbulb_outline,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Scaffold 주요 속성',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    _buildInfoItem(
                      theme: theme,
                      text: 'drawer: 좌측 Drawer',
                    ),
                    _buildInfoItem(
                      theme: theme,
                      text: 'endDrawer: 우측 Drawer',
                    ),
                    _buildInfoItem(
                      theme: theme,
                      text: 'appBar: 상단 AppBar',
                    ),
                    _buildInfoItem(
                      theme: theme,
                      text: 'bottomNavigationBar: 하단 네비게이션',
                    ),
                    _buildInfoItem(
                      theme: theme,
                      text: 'floatingActionButton: FAB',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Builder 예제
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.code,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Builder 사용 예제',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Builder를 사용하면 GlobalKey 없이도\nScaffold.of(context)로 접근할 수 있습니다',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Builder(
                      builder: (context) {
                        return FilledButton.tonal(
                          onPressed: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                          child: const Text('Builder로 Drawer 열기'),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // BottomNavigationBar 데모
              _buildBottomNavDemo(theme),

              // SafeArea 상세
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
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
                          Icons.phone_android,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'SafeArea 파라미터',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Notch, 상태바, 홈 인디케이터와 겹치지 않도록 자동 패딩 적용',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    _buildSafeAreaItem(theme, 'top: true (기본)', '상태바·노치 영역 회피'),
                    _buildSafeAreaItem(theme, 'bottom: true (기본)', '홈 인디케이터 영역 회피'),
                    _buildSafeAreaItem(theme, 'left / right: true (기본)', '사이드 노치 대응'),
                    _buildSafeAreaItem(theme, 'top: false', '상단 패딩 제거 — AppBar 아래 배치 시 사용'),
                    _buildSafeAreaItem(theme, 'minimum: EdgeInsets.all(8)', '최소 패딩 보장'),
                    const Divider(height: 1),
                    Text(
                      '💡 AppBar가 있으면 top: false 권장\n'
                      '   하단 FAB·BottomBar는 bottom: false 후 직접 패딩',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('FloatingActionButton 클릭!'),
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: '확인',
                onPressed: () {},
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('FAB'),
      ),
      bottomNavigationBar: _buildBottomNav(theme),
    );
  }

  Widget _buildBottomNav(ThemeData theme) {
    final isShifting = _navType == BottomNavigationBarType.shifting;

    final items = [
      BottomNavigationBarItem(
        icon: const Icon(Icons.home_outlined),
        activeIcon: _showActiveIcon ? const Icon(Icons.home) : null,
        label: '홈',
        backgroundColor:
            isShifting ? theme.colorScheme.primaryContainer : null,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.search_outlined),
        activeIcon: _showActiveIcon ? const Icon(Icons.search) : null,
        label: '검색',
        backgroundColor:
            isShifting ? theme.colorScheme.secondaryContainer : null,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.favorite_outline),
        activeIcon: _showActiveIcon ? const Icon(Icons.favorite) : null,
        label: '즐겨찾기',
        backgroundColor:
            isShifting ? theme.colorScheme.tertiaryContainer : null,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.person_outline),
        activeIcon: _showActiveIcon ? const Icon(Icons.person) : null,
        label: '프로필',
        backgroundColor:
            isShifting ? theme.colorScheme.surfaceContainerHighest : null,
      ),
    ];

    final nav = BottomNavigationBar(
      currentIndex: _navIndex,
      onTap: (i) => setState(() => _navIndex = i),
      type: _navType,
      elevation: _removeElevation ? 0 : 8,
      showSelectedLabels: _showLabels,
      showUnselectedLabels: _showLabels,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: theme.colorScheme.onSurfaceVariant,
      items: items,
    );

    if (_removeAnimation) {
      return Theme(
        data: theme.copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: nav,
      );
    }
    return nav;
  }

  // 좌측 Drawer
  Widget _buildLeftDrawer(ThemeData theme) {
    return Drawer(
      child: Column(
        children: [
          // Drawer 헤더
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primaryContainer,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: theme.colorScheme.surface,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '메뉴',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '좌측 Drawer',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),

          // 메뉴 아이템들
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  theme: theme,
                  icon: Icons.home,
                  title: '홈',
                  isSelected: _selectedIndex == 0,
                  onTap: () {
                    setState(() => _selectedIndex = 0);
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  theme: theme,
                  icon: Icons.person,
                  title: '프로필',
                  isSelected: _selectedIndex == 1,
                  onTap: () {
                    setState(() => _selectedIndex = 1);
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  theme: theme,
                  icon: Icons.favorite,
                  title: '즐겨찾기',
                  isSelected: _selectedIndex == 2,
                  onTap: () {
                    setState(() => _selectedIndex = 2);
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  theme: theme,
                  icon: Icons.notifications,
                  title: '알림',
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '3',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onError,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  isSelected: _selectedIndex == 3,
                  onTap: () {
                    setState(() => _selectedIndex = 3);
                    Navigator.pop(context);
                  },
                ),
                const Divider(height: 1),
                _buildDrawerItem(
                  theme: theme,
                  icon: Icons.settings,
                  title: '설정',
                  isSelected: _selectedIndex == 4,
                  onTap: () {
                    setState(() => _selectedIndex = 4);
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  theme: theme,
                  icon: Icons.help_outline,
                  title: '도움말',
                  isSelected: _selectedIndex == 5,
                  onTap: () {
                    setState(() => _selectedIndex = 5);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),

          // Drawer 하단
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Version 1.0.0',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // 우측 Drawer (설정)
  Widget _buildRightDrawer(ThemeData theme) {
    return Drawer(
      child: Column(
        children: [
          // 설정 헤더
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.settings,
                    size: 48,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '설정',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '앱 환경설정',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 설정 아이템들
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSettingItem(
                  theme: theme,
                  icon: Icons.dark_mode,
                  title: '다크 모드',
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(height: 8),
                _buildSettingItem(
                  theme: theme,
                  icon: Icons.notifications_active,
                  title: '알림 설정',
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(height: 8),
                _buildSettingItem(
                  theme: theme,
                  icon: Icons.language,
                  title: '언어',
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
                const SizedBox(height: 8),
                _buildSettingItem(
                  theme: theme,
                  icon: Icons.security,
                  title: '보안',
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 예제 카드
  Widget _buildExampleCard({
    required ThemeData theme,
    required String title,
    required IconData icon,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(16),
      color: theme.colorScheme.surface,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Drawer 아이템
  Widget _buildDrawerItem({
    required ThemeData theme,
    required IconData icon,
    required String title,
    Widget? trailing,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? theme.colorScheme.primary : null,
        ),
      ),
      trailing: trailing,
      selected: isSelected,
      selectedTileColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onTap: onTap,
    );
  }

  // 설정 아이템
  Widget _buildSettingItem({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyLarge,
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildSafeAreaItem(ThemeData theme, String param, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              children: [
                TextSpan(
                  text: '$param  ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: desc),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // BottomNavigationBar 데모 섹션
  Widget _buildBottomNavDemo(ThemeData theme) {
    final isShifting = _navType == BottomNavigationBarType.shifting;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.secondary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 0,
        children: [
          // 헤더
          Row(
            children: [
              Icon(Icons.tab, color: theme.colorScheme.secondary, size: 24),
              const SizedBox(width: 12),
              Text(
                'BottomNavigationBar',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '하단의 실제 바에 즉시 반영됩니다',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),

          // Type 토글
          _buildNavSwitchTile(
            theme: theme,
            title: 'Shifting 타입',
            subtitle: 'fixed: 고정 크기  /  shifting: 선택 탭 올라오는 애니메이션',
            value: isShifting,
            onChanged: (v) => setState(() => _navType = v
                ? BottomNavigationBarType.shifting
                : BottomNavigationBarType.fixed),
          ),

          // shifting 경고
          if (isShifting)
            Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
              ),
              child: Row(
                spacing: 8,
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Colors.orange, size: 16),
                  Expanded(
                    child: Text(
                      'shifting 타입: selectedItemColor 미설정 시 아이콘이 흰색으로 안 보일 수 있음',
                      style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.orange.shade800),
                    ),
                  ),
                ],
              ),
            ),

          // activeIcon 토글
          _buildNavSwitchTile(
            theme: theme,
            title: 'activeIcon 사용',
            subtitle: '선택 시 다른 아이콘 표시 (outlined → filled)',
            value: _showActiveIcon,
            onChanged: (v) => setState(() => _showActiveIcon = v),
          ),

          // 레이블 토글
          _buildNavSwitchTile(
            theme: theme,
            title: '레이블 표시',
            subtitle: 'showSelectedLabels / showUnselectedLabels',
            value: _showLabels,
            onChanged: (v) => setState(() => _showLabels = v),
          ),

          // elevation 토글
          _buildNavSwitchTile(
            theme: theme,
            title: 'elevation 제거',
            subtitle: '기본값 8  →  0으로 설정 시 그림자 제거',
            value: _removeElevation,
            onChanged: (v) => setState(() => _removeElevation = v),
          ),

          // 애니메이션 제거 토글
          _buildNavSwitchTile(
            theme: theme,
            title: '탭 애니메이션(ripple) 제거',
            subtitle: 'Theme(splashColor / highlightColor: transparent)',
            value: _removeAnimation,
            onChanged: (v) => setState(() => _removeAnimation = v),
          ),

          const SizedBox(height: 8),

          // 비교표
          Table(
            border: TableBorder.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(8),
            ),
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1.5),
              2: FlexColumnWidth(1.5),
            },
            children: [
              _buildTableRow(theme, ['속성', 'fixed', 'shifting'],
                  isHeader: true),
              _buildTableRow(
                  theme, ['backgroundColor', 'Bar 전체', '아이템별 설정']),
              _buildTableRow(
                  theme, ['기본 아이템 수', '3개 이하', '4개 이상']),
              _buildTableRow(
                  theme, ['탭 크기', '균등 고정', '선택 탭 확대']),
            ],
          ),

          const SizedBox(height: 12),

          // 참고 노트
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '💡 bottomNavigationBar에 TabBar도 사용 가능\n'
              '   SVG 아이콘: activeIcon에 SvgPicture 위젯 사용\n'
              '   아이콘 크기 변화 방지: selectedFontSize == unselectedFontSize',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavSwitchTile({
    required ThemeData theme,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title, style: theme.textTheme.bodyMedium),
      subtitle: Text(subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant)),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }

  TableRow _buildTableRow(ThemeData theme, List<String> cells,
      {bool isHeader = false}) {
    return TableRow(
      decoration: isHeader
          ? BoxDecoration(
              color:
                  theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
            )
          : null,
      children: cells
          .map(
            (c) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text(
                c,
                style: isHeader
                    ? theme.textTheme.labelSmall
                        ?.copyWith(fontWeight: FontWeight.bold)
                    : theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
          )
          .toList(),
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
          size: 18,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
