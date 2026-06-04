import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'example_list_screen.dart';
import 'oss_licenses/oss_licenses_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      // 다크모드 설정
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
      ),
      // 시스템 설정 따라가기
      themeMode: ThemeMode.system,
      home: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: const TextScaler.linear(1.0),
        ),
        child: const SelectHomeView(),
      ),
    );
  }
}

class SelectHomeView extends StatelessWidget {
  const SelectHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        onBackTwo();
      },
      child: Scaffold(
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '💡 뒤로가기 버튼을 두 번 누르면 앱이 종료됩니다',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        theme.colorScheme.primary.withValues(alpha: 0.08),
                        theme.colorScheme.surface,
                      ]
                    : [
                        theme.colorScheme.primaryContainer,
                        theme.colorScheme.surface,
                      ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 48),

                      // 헤더
                      _buildHeader(theme),
                      const SizedBox(height: 32),

                      // 통계 카드
                      _buildStatsCard(theme),
                      const SizedBox(height: 24),

                      // 카테고리 그리드
                      _buildCategoryGrid(context, theme),

                      const Spacer(),

                      // OSS 링크
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const OssLicensesPage(),
                              ),
                            );
                          },
                          child: Text(
                            '오픈소스 라이선스',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(ThemeData theme) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(20),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: _StatItem(
                icon: Icons.widgets_outlined,
                label: '총 예제',
                value: '${ExampleStats.totalExamples}',
                color: theme.colorScheme.primary,
              ),
            ),
            Expanded(
              child: _StatItem(
                icon: Icons.category_outlined,
                label: '카테고리',
                value: '${ExampleStats.totalCategories}',
                color: Colors.orange,
              ),
            ),
            Expanded(
              child: _StatItem(
                icon: Icons.extension_outlined,
                label: '패키지',
                value: '${ExampleStats.totalPackages}+',
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context, ThemeData theme) {
    final categories = [
      (Icons.apps_rounded, Categories.all, theme.colorScheme.primary),
      (Icons.widgets_outlined, Categories.basicWidget, theme.colorScheme.primary),
      (Icons.storage_outlined, Categories.dataProcessing, Colors.teal),
      (Icons.palette_outlined, Categories.uiPackage, Colors.purple),
      (Icons.cloud_outlined, Categories.network, Colors.blue),
      (Icons.image_outlined, Categories.imageFile, Colors.orange),
      (Icons.bolt_outlined, Categories.advanced, Colors.red),
      (Icons.layers_outlined, Categories.stateManagement, Colors.indigo),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '카테고리',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.1,
          children: categories.map((c) {
            return Material(
              color: c.$3.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ExampleListScreen(
                      initialCategory: c.$2 == Categories.all ? null : c.$2,
                    ),
                  ),
                ),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: c.$3.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 6,
                    children: [
                      Icon(c.$1, color: c.$3, size: 22),
                      Text(
                        c.$2,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.terminal_rounded,
                color: theme.colorScheme.onPrimary,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DevKit Flutter',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Flutter 개발자 도구',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Flutter 위젯 & 패키지 예제를 빠르게 참조하는 개인 레퍼런스 앱입니다.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }

}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

void showToast({
  required String msg,
}) {
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: Colors.green,
    toastLength: Toast.LENGTH_LONG,
    timeInSecForIosWeb: 1,
    gravity: ToastGravity.TOP,
  );
}


DateTime? backPressTime;
void onBackTwo() {
  DateTime now = DateTime.now();
  if (backPressTime == null ||
      now.difference(backPressTime!) > const Duration(seconds: 2)) {
    backPressTime = now;
    showToast(msg: '🔙 뒤로가기 버튼을 한 번 더 누르면 종료됩니다.');
  } else {
    SystemNavigator.pop();
  }
}
