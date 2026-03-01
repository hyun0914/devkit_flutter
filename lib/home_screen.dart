import 'package:connectivity_plus/connectivity_plus.dart';
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
      themeMode: ThemeMode.system, // 시스템 설정 따라가기
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
        body: SafeArea(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                  theme.colorScheme.surface,
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 상단 타이틀 영역
                      _buildHeader(theme),
                      const SizedBox(height: 32),

                      // 통계 카드
                      _buildStatsCard(theme),
                      const SizedBox(height: 24),

                      // 메뉴 섹션 타이틀
                      Text(
                        '주요 기능',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 메뉴 버튼들
                      _HomeButton(
                        icon: Icons.apps_rounded,
                        label: '예제 앱 화면 열기',
                        description: '64개 위젯 & 패키지 샘플',
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primaryContainer,
                            theme.colorScheme.primary.withValues(alpha: 0.3),
                          ],
                        ),
                        onPressed: () async {
                          await Future.delayed(
                            const Duration(milliseconds: 300),
                          );
                          if (context.mounted) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ExampleListScreen(),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      _HomeButton(
                        icon: Icons.wifi_tethering_rounded,
                        label: '네트워크 상태 체크',
                        description: 'WiFi / 모바일 데이터 확인',
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.withValues(alpha: 0.2),
                            Colors.blue.withValues(alpha: 0.1),
                          ],
                        ),
                        onPressed: cheekConnectivity,
                      ),
                      const SizedBox(height: 12),
                      _HomeButton(
                        icon: Icons.description_outlined,
                        label: '오픈소스 라이선스',
                        description: '사용 중인 패키지 목록',
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.withValues(alpha: 0.2),
                            Colors.orange.withValues(alpha: 0.1),
                          ],
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const OssLicensesPage(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 32),

                      // 하단 안내 텍스트
                      Center(
                        child: Text(
                          '💡 뒤로가기 버튼을 두 번 누르면 앱이 종료됩니다',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
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
          '실무에서 바로 활용 가능한 위젯 & 패키지 예제를 한 곳에서 확인하세요.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard(ThemeData theme) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(20),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '프로젝트 통계',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    icon: Icons.widgets_outlined,
                    label: '총 예제',
                    value: '64+',
                    color: theme.colorScheme.primary,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    icon: Icons.category_outlined,
                    label: '카테고리',
                    value: '7',
                    color: Colors.orange,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    icon: Icons.extension_outlined,
                    label: '패키지',
                    value: '105+',
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 통계 아이템 위젯
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

// 홈 화면용 공통 버튼 위젯
class _HomeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final Gradient gradient;
  final VoidCallback onPressed;

  const _HomeButton({
    required this.icon,
    required this.label,
    required this.description,
    required this.gradient,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
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
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
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

void cheekConnectivity() async {
  final List<ConnectivityResult> connectivityResult =
  await (Connectivity().checkConnectivity());

  if (connectivityResult.contains(ConnectivityResult.wifi)) {
    showToast(msg: '📶 WiFi 사용 중입니다.');
  } else if (connectivityResult.contains(ConnectivityResult.mobile)) {
    showToast(msg: '📱 모바일 데이터 사용 중입니다.');
  } else if (connectivityResult.contains(ConnectivityResult.none)) {
    showToast(msg: '❌ 네트워크 연결을 확인하세요.');
  }
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