import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ios_utsname_ext/extension.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widget/default_scaffold.dart';

class AppDeviceInfoScreen extends StatefulWidget {
  const AppDeviceInfoScreen({super.key});

  @override
  State<AppDeviceInfoScreen> createState() => _AppDeviceInfoScreenState();
}

class _AppDeviceInfoScreenState extends State<AppDeviceInfoScreen> {
  PackageInfo? _packageInfo;
  String? _deviceModel;
  String? _osVersion;
  BatteryState? _batteryState;
  int? _batteryLevel;

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    try {
      // 패키지 정보
      final packageInfo = await PackageInfo.fromPlatform();

      setState(() {
        _packageInfo = packageInfo;
      });
    } catch (e) {
      debugPrint('패키지 정보 로드 오류: $e');
    }

    // 디바이스 정보
    try {
      String? deviceModel;
      String? osVersion;

      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        deviceModel = androidInfo.model;
        osVersion = 'Android ${androidInfo.version.release}';
      } else if (Platform.isIOS) {
        final iosInfo = await DeviceInfoPlugin().iosInfo;
        deviceModel = iosInfo.utsname.machine.iOSProductName;
        osVersion = 'iOS ${iosInfo.systemVersion}';
      }

      setState(() {
        _deviceModel = deviceModel;
        _osVersion = osVersion;
      });
    } catch (e) {
      debugPrint('디바이스 정보 로드 오류: $e');
    }

    // 배터리 정보 (Web 제외)
    if (!kIsWeb) {
      try {
        final battery = Battery();

        // 배터리 레벨
        try {
          final batteryLevel = await battery.batteryLevel;
          setState(() {
            _batteryLevel = batteryLevel;
          });
        } catch (e) {
          debugPrint('배터리 레벨 로드 오류 (Simulator일 수 있음): $e');
          setState(() {
            _batteryLevel = -1; // -1은 사용 불가 표시
          });
        }

        // 배터리 상태 리스닝
        battery.onBatteryStateChanged.listen((state) {
          if (mounted) {
            setState(() {
              _batteryState = state;
            });
          }
        });
      } catch (e) {
        debugPrint('배터리 정보 로드 오류: $e');
      }
    }
  }

  String _getPlatformName() {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    return 'Unknown';
  }

  IconData _getPlatformIcon() {
    if (kIsWeb) return Icons.language;
    if (Platform.isAndroid) return Icons.android;
    if (Platform.isIOS) return Icons.apple;
    return Icons.devices;
  }

  String _getBatteryStateText(BatteryState? state) {
    switch (state) {
      case BatteryState.full:
        return '완전 충전됨';
      case BatteryState.charging:
        return '충전 중';
      case BatteryState.connectedNotCharging:
        return '연결됨 (충전 안 됨)';
      case BatteryState.discharging:
        return '방전 중';
      case BatteryState.unknown:
      case null:
        return '알 수 없음';
    }
  }

  Color _getBatteryColor(int? level) {
    if (level == null || level == -1) return Colors.grey;
    if (level > 80) return Colors.green;
    if (level > 20) return Colors.orange;
    return Colors.red;
  }

  IconData _getBatteryIcon(BatteryState? state, int? level) {
    if (state == BatteryState.charging) {
      return Icons.battery_charging_full;
    }
    if (level == null || level == -1) return Icons.battery_unknown;
    if (level > 90) return Icons.battery_full;
    if (level > 80) return Icons.battery_6_bar;
    if (level > 60) return Icons.battery_5_bar;
    if (level > 50) return Icons.battery_4_bar;
    if (level > 30) return Icons.battery_3_bar;
    if (level > 20) return Icons.battery_2_bar;
    if (level > 10) return Icons.battery_1_bar;
    return Icons.battery_0_bar;
  }

  String _getOrientationText(Orientation orientation) {
    return orientation == Orientation.portrait ? '세로 (Portrait)' : '가로 (Landscape)';
  }

  Future<void> _openSettings() async {
    if (Platform.isAndroid) {
      const intent = AndroidIntent(
        action: 'action_application_details_settings',
        data: 'package:dev.devkit.flutter.devkit_flutter',
      );
      await intent.launch();
    } else if (Platform.isIOS) {
      const url = 'app-settings:';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final orientation = MediaQuery.of(context).orientation;
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('앱 & 기기 정보'),
        actions: [
          if (!kIsWeb)
            IconButton(
              onPressed: _openSettings,
              icon: const Icon(Icons.settings),
              tooltip: '앱 설정',
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              '앱 및 기기 정보',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '실시간 시스템 정보',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // 1. 앱 정보
            _buildSectionHeader(theme, '앱 정보'),
            const SizedBox(height: 12),
            if (_packageInfo != null)
              _buildInfoCard(
                theme: theme,
                color: theme.colorScheme.primaryContainer,
                children: [
                  _buildInfoRow(
                    theme: theme,
                    icon: Icons.apps,
                    label: '앱 이름',
                    value: _packageInfo!.appName,
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    theme: theme,
                    icon: Icons.tag,
                    label: '버전',
                    value: _packageInfo!.version,
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    theme: theme,
                    icon: Icons.numbers,
                    label: '빌드 번호',
                    value: _packageInfo!.buildNumber,
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    theme: theme,
                    icon: Icons.qr_code,
                    label: '패키지 이름',
                    value: _packageInfo!.packageName,
                  ),
                ],
              )
            else
              _buildLoadingCard(theme),

            const SizedBox(height: 24),

            // 2. 디바이스 정보
            _buildSectionHeader(theme, '디바이스 정보'),
            const SizedBox(height: 12),
            _buildInfoCard(
              theme: theme,
              color: theme.colorScheme.secondaryContainer,
              children: [
                _buildInfoRow(
                  theme: theme,
                  icon: _getPlatformIcon(),
                  label: '플랫폼',
                  value: _getPlatformName(),
                ),
                if (_deviceModel != null) ...[
                  const Divider(height: 24),
                  _buildInfoRow(
                    theme: theme,
                    icon: Icons.phone_android,
                    label: '기기 모델',
                    value: _deviceModel!,
                  ),
                ],
                if (_osVersion != null) ...[
                  const Divider(height: 24),
                  _buildInfoRow(
                    theme: theme,
                    icon: Icons.system_update,
                    label: 'OS 버전',
                    value: _osVersion!,
                  ),
                ],
              ],
            ),

            const SizedBox(height: 24),

            // 3. 배터리 정보
            if (!kIsWeb) ...[
              _buildSectionHeader(theme, '배터리 정보'),
              const SizedBox(height: 12),
              _buildInfoCard(
                theme: theme,
                color: theme.colorScheme.tertiaryContainer,
                children: [
                  _buildInfoRow(
                    theme: theme,
                    icon: _getBatteryIcon(_batteryState, _batteryLevel),
                    iconColor: _getBatteryColor(_batteryLevel),
                    label: '배터리 레벨',
                    value: _batteryLevel == null
                        ? '로딩 중...'
                        : _batteryLevel == -1
                        ? '사용 불가 (Simulator)'
                        : '$_batteryLevel%',
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    theme: theme,
                    icon: Icons.battery_charging_full,
                    label: '충전 상태',
                    value: _getBatteryStateText(_batteryState),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],

            // 4. 화면 정보
            _buildSectionHeader(theme, '화면 정보'),
            const SizedBox(height: 12),
            _buildInfoCard(
              theme: theme,
              color: theme.colorScheme.errorContainer,
              children: [
                _buildInfoRow(
                  theme: theme,
                  icon: Icons.aspect_ratio,
                  label: '화면 크기',
                  value: '${size.width.toStringAsFixed(1)} x ${size.height.toStringAsFixed(1)}',
                ),
                const Divider(height: 24),
                _buildInfoRow(
                  theme: theme,
                  icon: Icons.grid_4x4,
                  label: '픽셀 비율',
                  value: '${pixelRatio.toStringAsFixed(2)}x',
                ),
                const Divider(height: 24),
                _buildInfoRow(
                  theme: theme,
                  icon: Icons.screen_rotation,
                  label: '화면 방향',
                  value: _getOrientationText(orientation),
                ),
                const Divider(height: 24),
                _buildInfoRow(
                  theme: theme,
                  icon: Icons.space_bar,
                  label: 'Safe Area (상단)',
                  value: '${padding.top.toStringAsFixed(1)} px',
                ),
                const Divider(height: 24),
                _buildInfoRow(
                  theme: theme,
                  icon: Icons.space_bar,
                  label: 'Safe Area (하단)',
                  value: '${padding.bottom.toStringAsFixed(1)} px',
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 사용된 패키지
            _buildSectionHeader(theme, '사용된 패키지'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  _buildPackageItem(
                    theme: theme,
                    name: 'package_info_plus',
                    description: '앱 정보',
                  ),
                  const SizedBox(height: 8),
                  _buildPackageItem(
                    theme: theme,
                    name: 'device_info_plus',
                    description: '디바이스 정보',
                  ),
                  const SizedBox(height: 8),
                  _buildPackageItem(
                    theme: theme,
                    name: 'battery_plus',
                    description: '배터리 정보',
                  ),
                  if (Platform.isAndroid) ...[
                    const SizedBox(height: 8),
                    _buildPackageItem(
                      theme: theme,
                      name: 'android_intent_plus',
                      description: 'Android 인텐트',
                    ),
                  ],
                  if (Platform.isIOS) ...[
                    const SizedBox(height: 8),
                    _buildPackageItem(
                      theme: theme,
                      name: 'ios_utsname_ext',
                      description: 'iOS 기기명',
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 섹션 헤더
  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  // 정보 카드
  Widget _buildInfoCard({
    required ThemeData theme,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  // 정보 행
  Widget _buildInfoRow({
    required ThemeData theme,
    required IconData icon,
    required String label,
    required String value,
    Color? iconColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: iconColor ?? theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 로딩 카드
  Widget _buildLoadingCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // 패키지 아이템
  Widget _buildPackageItem({
    required ThemeData theme,
    required String name,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.extension,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodySmall,
                children: [
                  TextSpan(
                    text: name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                  TextSpan(
                    text: ' - $description',
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}