import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../widget/default_scaffold.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _permissionGranted = false;
  String _lastTappedPayload = '';

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: (response) {
        setState(() => _lastTappedPayload = response.payload ?? '없음');
      },
    );

    await _checkPermission();
  }

  Future<void> _checkPermission() async {
    bool granted = false;
    if (Platform.isIOS) {
      final status = await _plugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.checkPermissions();
      granted = status?.isAlertEnabled ?? false;
    } else if (Platform.isAndroid) {
      granted = await _plugin
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;
    }
    setState(() => _permissionGranted = granted);
  }

  Future<void> _requestPermission() async {
    bool granted = false;
    if (Platform.isIOS) {
      granted = await _plugin
              .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(alert: true, badge: true, sound: true) ??
          false;
    } else if (Platform.isAndroid) {
      granted = await _plugin
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
              ?.requestNotificationsPermission() ??
          false;
    }
    setState(() => _permissionGranted = granted);
  }

  NotificationDetails _details({
    String channelId = 'default',
    String channelName = '기본 알림',
    Importance importance = Importance.high,
    Priority priority = Priority.high,
    StyleInformation? styleInformation,
    bool showProgress = false,
    int maxProgress = 0,
    int progress = 0,
  }) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        importance: importance,
        priority: priority,
        styleInformation: styleInformation,
        showProgress: showProgress,
        maxProgress: maxProgress,
        progress: progress,
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }

  Future<void> _showBasicNotification() async {
    await _plugin.show(
      1,
      '기본 알림',
      '가장 단순한 형태의 로컬 알림입니다.',
      _details(channelId: 'basic', channelName: '기본 알림'),
      payload: 'basic',
    );
  }

  Future<void> _showBigTextNotification() async {
    await _plugin.show(
      2,
      '큰 텍스트 알림',
      '아래로 펼치면 전체 내용을 볼 수 있습니다.',
      _details(
        channelId: 'big_text',
        channelName: '큰 텍스트 알림',
        styleInformation: const BigTextStyleInformation(
          'BigTextStyleInformation을 사용하면 알림에 긴 내용을 담을 수 있습니다. '
          'Android에서 알림을 아래로 스와이프하면 이 전체 텍스트가 펼쳐집니다. '
          '실무에서 이메일 미리보기, 메시지 내용 표시 등에 활용합니다.',
          contentTitle: '큰 텍스트 알림',
          summaryText: 'flutter_local_notifications',
        ),
      ),
      payload: 'big_text',
    );
  }

  Future<void> _showProgressNotification() async {
    for (int i = 0; i <= 100; i += 20) {
      await _plugin.show(
        3,
        i < 100 ? '다운로드 중... $i%' : '다운로드 완료',
        i < 100 ? '잠시만 기다려주세요.' : '파일이 저장되었습니다.',
        _details(
          channelId: 'progress',
          channelName: '진행률 알림',
          importance: i < 100 ? Importance.low : Importance.high,
          priority: i < 100 ? Priority.low : Priority.high,
          showProgress: i < 100,
          maxProgress: 100,
          progress: i,
        ),
      );
      await Future.delayed(const Duration(milliseconds: 600));
    }
  }

  Future<void> _showPeriodicNotification() async {
    await _plugin.periodicallyShow(
      4,
      '반복 알림',
      '1분마다 표시되는 알림입니다.',
      RepeatInterval.everyMinute,
      _details(channelId: 'periodic', channelName: '반복 알림'),
      androidScheduleMode: AndroidScheduleMode.inexact,
      payload: 'periodic',
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('반복 알림 등록 완료 (1분마다)'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _cancelAll() async {
    await _plugin.cancelAll();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('모든 알림이 취소되었습니다'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(title: const Text('로컬 알림')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'flutter_local_notifications',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              '기기 로컬 알림 예제',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            _buildSectionHeader(theme, '알림 권한'),
            const SizedBox(height: 12),
            _buildPermissionCard(theme),

            const SizedBox(height: 24),

            _buildSectionHeader(theme, '알림 타입'),
            const SizedBox(height: 12),

            _buildNotificationButton(
              theme: theme,
              icon: Icons.notifications_rounded,
              title: '기본 알림',
              description: '제목 + 내용으로 구성된 단순 알림',
              color: Colors.blue,
              onPressed: _permissionGranted ? _showBasicNotification : null,
            ),
            const SizedBox(height: 8),
            _buildNotificationButton(
              theme: theme,
              icon: Icons.article_rounded,
              title: '큰 텍스트 알림',
              description: '펼치면 긴 내용을 보여주는 알림 (Android)',
              color: Colors.green,
              onPressed: _permissionGranted ? _showBigTextNotification : null,
            ),
            const SizedBox(height: 8),
            _buildNotificationButton(
              theme: theme,
              icon: Icons.downloading_rounded,
              title: '진행률 알림',
              description: '프로그레스 바가 표시되는 알림 (Android)',
              color: Colors.orange,
              onPressed: _permissionGranted ? _showProgressNotification : null,
            ),
            const SizedBox(height: 8),
            _buildNotificationButton(
              theme: theme,
              icon: Icons.repeat_rounded,
              title: '반복 알림',
              description: '1분마다 반복되는 알림 등록',
              color: Colors.purple,
              onPressed: _permissionGranted ? _showPeriodicNotification : null,
            ),

            const SizedBox(height: 24),

            _buildSectionHeader(theme, '알림 관리'),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _cancelAll,
              icon: const Icon(Icons.notifications_off_rounded),
              label: const Text('모든 알림 취소'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
            ),

            if (_lastTappedPayload.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildSectionHeader(theme, '알림 탭 감지'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.touch_app_rounded, color: theme.colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '마지막으로 탭한 알림 payload',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _lastTappedPayload,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionCard(ThemeData theme) {
    final granted = _permissionGranted;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: granted
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: granted
              ? Colors.green.withValues(alpha: 0.3)
              : Colors.red.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            granted ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: granted ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              granted ? '알림 권한 허용됨' : '알림 권한 없음',
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          if (!granted)
            TextButton(
              onPressed: _requestPermission,
              child: const Text('권한 요청'),
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationButton({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    final enabled = onPressed != null;
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.send_rounded, size: 16, color: enabled ? color : theme.colorScheme.outline),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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
}
