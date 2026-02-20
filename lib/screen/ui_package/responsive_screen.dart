import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sizer/sizer.dart';

import '../widget/default_scaffold.dart';

class ResponsiveScreen extends StatelessWidget {
  const ResponsiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sizer 래퍼: 이 화면 내에서만 sizer extension 사용 가능
    return Sizer(
      builder: (context, orientation, deviceType) {
        return _ResponsiveScreenContent();
      },
    );
  }
}

class _ResponsiveScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('반응형 레이아웃'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              '반응형 레이아웃 패키지',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '화면 크기에 따라 UI를 자동으로 적응시키는 방법',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 16),

            // 현재 화면 정보 카드
            _CurrentScreenInfo(),

            const SizedBox(height: 24),

            // responsive_builder 섹션
            _buildSectionHeader(theme, Icons.devices_outlined, 'responsive_builder', Colors.blue),
            const SizedBox(height: 4),
            Text(
              '디바이스 타입(mobile/tablet/desktop)에 따라 다른 위젯을 렌더링',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),

            // ResponsiveBuilder 예제
            _buildCodeCard(
              theme: theme,
              title: 'ResponsiveBuilder',
              code: 'ResponsiveBuilder(\n'
                  '  builder: (context, sizingInfo) {\n'
                  '    if (sizingInfo.isDesktop) return DesktopWidget();\n'
                  '    if (sizingInfo.isTablet) return TabletWidget();\n'
                  '    return MobileWidget();\n'
                  '  },\n'
                  ')',
              child: ResponsiveBuilder(
                builder: (context, sizingInfo) {
                  final deviceLabel = sizingInfo.isTablet
                      ? '태블릿 레이아웃'
                      : sizingInfo.isDesktop
                      ? '데스크탑 레이아웃'
                      : '모바일 레이아웃';
                  final deviceColor = sizingInfo.isTablet
                      ? Colors.blue
                      : sizingInfo.isDesktop
                      ? Colors.purple
                      : Colors.green;
                  final deviceIcon = sizingInfo.isTablet
                      ? Icons.tablet
                      : sizingInfo.isDesktop
                      ? Icons.desktop_windows
                      : Icons.phone_android;

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: deviceColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: deviceColor,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          deviceIcon,
                          color: deviceColor,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 2,
                            children: [
                              Text(
                                deviceLabel,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: deviceColor,
                                ),
                              ),
                              Text(
                                '화면 너비: ${sizingInfo.screenSize.width.toInt()}px',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                '디바이스: ${sizingInfo.deviceScreenType.toString().split('.').last}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // ScreenTypeLayout.builder 예제
            _buildCodeCard(
              theme: theme,
              title: 'ScreenTypeLayout.builder',
              code: 'ScreenTypeLayout.builder(\n'
                  '  mobile: (ctx) => MobileLayout(),\n'
                  '  tablet: (ctx) => TabletLayout(),\n'
                  '  desktop: (ctx) => DesktopLayout(),\n'
                  ')',
              child: ScreenTypeLayout.builder(
                mobile: (context) => _DeviceCard(
                  icon: Icons.phone_android,
                  label: 'Mobile Layout',
                  color: Colors.green,
                  description: '< 600px',
                ),
                tablet: (context) => _DeviceCard(
                  icon: Icons.tablet,
                  label: 'Tablet Layout',
                  color: Colors.blue,
                  description: '600px ~ 950px',
                ),
                desktop: (context) => _DeviceCard(
                  icon: Icons.desktop_windows,
                  label: 'Desktop Layout',
                  color: Colors.purple,
                  description: '> 950px',
                ),
              ),
            ),

            const SizedBox(height: 12),

            // OrientationLayoutBuilder 예제
            _buildCodeCard(
              theme: theme,
              title: 'OrientationLayoutBuilder',
              code: 'OrientationLayoutBuilder(\n'
                  '  portrait: (ctx) => PortraitWidget(),\n'
                  '  landscape: (ctx) => LandscapeWidget(),\n'
                  ')',
              child: OrientationLayoutBuilder(
                portrait: (context) => _OrientationCard(
                  icon: Icons.stay_current_portrait,
                  label: 'Portrait 세로 모드',
                  color: Colors.orange,
                ),
                landscape: (context) => _OrientationCard(
                  icon: Icons.stay_current_landscape,
                  label: 'Landscape 가로 모드',
                  color: Colors.teal,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // sizer 섹션
            _buildSectionHeader(theme, Icons.straighten_outlined, 'sizer', Colors.deepOrange),
            const SizedBox(height: 4),
            Text(
              '화면 크기 비율(%)로 위젯 크기/폰트를 지정 — .w .h .sp .dp extension 사용',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),

            // Sizer 크기 비교 예제
            _buildCodeCard(
              theme: theme,
              title: '비율 기반 너비 (.w)',
              code: 'Container(width: 80.w)  // 화면 너비의 80%\n'
                  'Container(width: 50.w)  // 화면 너비의 50%\n'
                  'Container(width: 30.w)  // 화면 너비의 30%',
              child: Column(
                spacing: 8,
                children: [
                  _SizerBar(label: '80.w', percent: 80, color: Colors.deepOrange),
                  _SizerBar(label: '50.w', percent: 50, color: Colors.orange),
                  _SizerBar(label: '30.w', percent: 30, color: Colors.amber),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 폰트 크기 예제
            _buildCodeCard(
              theme: theme,
              title: '반응형 폰트 (.sp / .dp)',
              code: 'Text(style: TextStyle(fontSize: 20.sp))\n'
                  'Text(style: TextStyle(fontSize: 16.sp))\n'
                  'Text(style: TextStyle(fontSize: 12.sp))',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6,
                children: [
                  Text('fontSize: 20.sp → 반응형 폰트', style: TextStyle(fontSize: 20.sp)),
                  Text('fontSize: 16.sp → 반응형 폰트', style: TextStyle(fontSize: 16.sp)),
                  Text('fontSize: 12.sp → 반응형 폰트', style: TextStyle(fontSize: 12.sp)),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 높이 예제
            _buildCodeCard(
              theme: theme,
              title: '비율 기반 높이 (.h)',
              code: 'SizedBox(height: 10.h)  // 화면 높이의 10%\n'
                  'SizedBox(height: 5.h)   // 화면 높이의 5%',
              child: Row(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _SizerHeightBox(label: '10.h', heightPercent: 10, color: Colors.deepOrange),
                  _SizerHeightBox(label: '7.h', heightPercent: 7, color: Colors.orange),
                  _SizerHeightBox(label: '5.h', heightPercent: 5, color: Colors.amber),
                  _SizerHeightBox(label: '3.h', heightPercent: 3, color: Colors.yellow),
                  Expanded(
                    child: Text(
                      '화면 높이의\n비율로 설정',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 비교 테이블
            _buildSectionHeader(theme, Icons.compare_arrows, '패키지 비교', theme.colorScheme.primary),
            const SizedBox(height: 12),
            _buildComparisonTable(theme),

            const SizedBox(height: 24),

            // 정보 카드
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Text('💡 언제 무엇을 쓸까?',
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Text(
                    '• responsive_builder: 모바일/태블릿/데스크탑 레이아웃을 완전히 다르게 구성할 때\n'
                        '• sizer: 기존 레이아웃 구조는 유지하면서 크기만 비율로 맞출 때\n'
                        '• 함께 사용: 레이아웃 분기는 responsive_builder, 크기 조절은 sizer',
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
    );
  }

  Widget _buildSectionHeader(ThemeData theme, IconData icon, String title, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildCodeCard({
    required ThemeData theme,
    required String title,
    required String code,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              code,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                color: theme.colorScheme.primary,
                height: 1.5,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildComparisonTable(ThemeData theme) {
    final rows = [
      ['기준', 'responsive_builder', 'sizer'],
      ['접근 방식', '위젯 분기', '비율 크기'],
      ['주요 API', 'ScreenTypeLayout\nResponsiveBuilder', '.w .h .sp .dp'],
      ['설정 필요', '불필요', 'Sizer() 래퍼'],
      ['적합한 상황', '레이아웃 완전히 다를 때', '크기만 조절할 때'],
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1.2),
          1: FlexColumnWidth(1.5),
          2: FlexColumnWidth(1.5),
        },
        children: rows.asMap().entries.map((entry) {
          final isHeader = entry.key == 0;
          final row = entry.value;
          return TableRow(
            decoration: BoxDecoration(
              color: isHeader
                  ? theme.colorScheme.primaryContainer.withValues(alpha: 0.5)
                  : entry.key.isEven
                  ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2)
                  : null,
            ),
            children: row.map((cell) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                  cell,
                  style: isHeader
                      ? theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)
                      : theme.textTheme.bodySmall?.copyWith(height: 1.4),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}

// 현재 화면 정보
class _CurrentScreenInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return ResponsiveBuilder(
      builder: (context, sizingInfo) {
        final deviceLabel = sizingInfo.isTablet
            ? '태블릿'
            : sizingInfo.isDesktop
            ? '데스크탑'
            : '모바일';
        final deviceColor = sizingInfo.isTablet
            ? Colors.blue
            : sizingInfo.isDesktop
            ? Colors.purple
            : Colors.green;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [deviceColor.withValues(alpha: 0.15), deviceColor.withValues(alpha: 0.05)],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: deviceColor.withValues(alpha: 0.4)),
          ),
          child: Row(
            spacing: 16,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: deviceColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  sizingInfo.isTablet
                      ? Icons.tablet
                      : sizingInfo.isDesktop
                      ? Icons.desktop_windows
                      : Icons.phone_android,
                  color: deviceColor,
                  size: 28,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      '현재: $deviceLabel',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: deviceColor,
                      ),
                    ),
                    Text(
                      '${size.width.toInt()} × ${size.height.toInt()} px',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 디바이스 타입 카드
class _DeviceCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final String description;

  const _DeviceCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        spacing: 12,
        children: [
          Icon(icon, color: color, size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              Text(label, style: theme.textTheme.titleSmall?.copyWith(color: color, fontWeight: FontWeight.bold)),
              Text(description, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ],
      ),
    );
  }
}

// 방향 카드
class _OrientationCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _OrientationCard({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        spacing: 12,
        children: [
          Icon(icon, color: color, size: 28),
          Text(label, style: theme.textTheme.titleSmall?.copyWith(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// Sizer 너비 바
class _SizerBar extends StatelessWidget {
  final String label;
  final double percent;
  final Color color;

  const _SizerBar({required this.label, required this.percent, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      spacing: 8,
      children: [
        SizedBox(
          width: 50,
          child: Text(label, style: theme.textTheme.labelSmall?.copyWith(fontFamily: 'monospace')),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 28,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percent / 100,
                child: Container(
                  height: 28,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$percent%',
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Sizer 높이 박스
class _SizerHeightBox extends StatelessWidget {
  final String label;
  final double heightPercent;
  final Color color;

  const _SizerHeightBox({required this.label, required this.heightPercent, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        Container(
          width: 40,
          height: heightPercent.h,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(fontFamily: 'monospace'),
        ),
      ],
    );
  }
}