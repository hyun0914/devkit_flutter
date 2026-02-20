import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widget/default_scaffold.dart';

class DioScreen extends StatelessWidget {
  const DioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('Dio (HTTP 통신)'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              'HTTP 통신 & 파일 다운로드',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Dio 패키지로 네트워크 요청',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // 다운로드 버튼
            _buildSectionHeader(theme, '파일 다운로드'),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => _dioDown(context),
              icon: const Icon(Icons.download),
              label: const Text('Dio 다운로드 테스트'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
              ),
            ),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'LEGO 이미지 다운로드 • 알림 표시 • 중복 파일명 자동 처리',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // HTTP 메서드 (Dio)
            _buildSectionHeader(theme, 'HTTP 메서드 (Dio)'),
            const SizedBox(height: 12),
            _buildMethodCard(
              theme: theme,
              method: 'GET',
              description: '데이터 조회',
              code: 'dio.get(url, queryParameters: params)',
              color: Colors.blue,
            ),
            const SizedBox(height: 8),
            _buildMethodCard(
              theme: theme,
              method: 'POST',
              description: '데이터 생성',
              code: 'dio.post(url, data: params)',
              color: Colors.green,
            ),
            const SizedBox(height: 8),
            _buildMethodCard(
              theme: theme,
              method: 'PUT',
              description: '데이터 수정',
              code: 'dio.put(url, data: params)',
              color: Colors.orange,
            ),
            const SizedBox(height: 8),
            _buildMethodCard(
              theme: theme,
              method: 'DELETE',
              description: '데이터 삭제',
              code: 'dio.delete(url, data: params)',
              color: Colors.red,
            ),

            const SizedBox(height: 24),

            // HTTP 메서드 (http 패키지)
            _buildSectionHeader(theme, 'HTTP 메서드 (http 패키지)'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  _buildHttpExample(
                    theme: theme,
                    method: 'GET',
                    code: "import 'package:http/http.dart' as http;\n\n"
                        "final response = await http.get(\n"
                        "  Uri.parse('https://api.example.com/data'),\n"
                        ");",
                    color: Colors.blue,
                  ),
                  const Divider(),
                  _buildHttpExample(
                    theme: theme,
                    method: 'POST',
                    code: "final response = await http.post(\n"
                        "  Uri.parse('https://api.example.com/data'),\n"
                        "  headers: {'Content-Type': 'application/json'},\n"
                        "  body: jsonEncode({'key': 'value'}),\n"
                        ");",
                    color: Colors.green,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // HTTP vs Dio 비교
            _buildSectionHeader(theme, 'HTTP vs Dio 비교'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  // HTTP 패키지
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'http',
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '기본 HTTP 패키지',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      _buildComparisonItem(theme, '✅ 가볍고 간단'),
                      _buildComparisonItem(theme, '✅ 기본적인 HTTP 요청'),
                      _buildComparisonItem(theme, '❌ Interceptor 없음'),
                      _buildComparisonItem(theme, '❌ 진행률 추적 어려움'),
                    ],
                  ),
                  const Divider(),
                  // Dio 패키지
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'dio',
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '강력한 HTTP 클라이언트',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      _buildComparisonItem(theme, '✅ Interceptor (토큰 자동 추가)'),
                      _buildComparisonItem(theme, '✅ 파일 다운로드 진행률'),
                      _buildComparisonItem(theme, '✅ 요청 취소, 타임아웃'),
                      _buildComparisonItem(theme, '✅ FormData, 멀티파트'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 추천
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 20,
                    color: theme.colorScheme.tertiary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '실무 추천: 간단한 API는 http, 복잡한 요청은 dio',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Interceptor 예제
            _buildSectionHeader(theme, 'Interceptor (요청/응답 가로채기)'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Text(
                    'Header 추가 예제',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'dio.interceptors.add(\n'
                          '  InterceptorsWrapper(\n'
                          '    onRequest: (options, handler) {\n'
                          '      options.headers["Authorization"] =\n'
                          '        "Bearer \$token";\n'
                          '      return handler.next(options);\n'
                          '    },\n'
                          '  ),\n'
                          ');',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 정보 카드
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
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
                        Icons.info_outline,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '💡 사용 팁',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'Android 13+ 권한 자동 허용',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: '중복 파일명 자동 처리 (1), (2)...',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: '시뮬레이터: 앱 폴더에 저장 (경로 표시)',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: '실기기: Download 폴더 + 알림',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 다운로드 실행
  Future<void> _dioDown(BuildContext context) async {
    Dio dio = Dio();
    NotificationService notificationService = NotificationService();

    bool permissionReady = await _checkPermission();

    if (!permissionReady) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('저장소 권한이 필요합니다'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    String localPath = await _findLocalPath();
    await _prepareSaveDir(localPath: localPath);

    String filename = 'test.png';
    String filename2 = 'test.png';
    String downloadPath = '$localPath/$filename';
    String downloadUrl =
        'https://www.lego.com/cdn/cs/set/assets/blt742e8599eb5e8931/40649.png';

    // 중복 파일 체크
    bool checkFile = await File(downloadPath).exists();
    if (checkFile) {
      String filename1 = filename.replaceAll('.png', '');
      String filename21 = filename2.replaceAll('.png', '');
      for (int i = 1; i < 99; i++) {
        bool checkFile2 = await File('$localPath/$filename1($i).png').exists();
        if (!checkFile2) {
          filename2 = '$filename21($i).png';
          downloadPath = '$localPath/$filename1($i).png';
          break;
        }
      }
    }

    // 다운로드 실행
    final response = await dio.download(
      downloadUrl,
      downloadPath,
      onReceiveProgress: (count, total) {
        notificationService.createNotification(
          100,
          ((count / total) * 100).toInt(),
          0,
          localPath,
          filename2,
        );
      },
    );

    if (context.mounted && response.statusCode == 200) {
      // 시뮬레이터 체크
      final isSimulator = await _isSimulator();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isSimulator
                ? '다운로드 완료: $filename2\n📱 시뮬레이터: 앱 폴더에 저장됨'
                : '다운로드 완료: $filename2',
          ),
          behavior: SnackBarBehavior.floating,
          duration: isSimulator ? const Duration(seconds: 4) : const Duration(seconds: 2),
          action: isSimulator
              ? SnackBarAction(
            label: '경로 보기',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('📁 저장 경로'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      Text(
                        '시뮬레이터에서는 앱 샌드박스 폴더에 저장됩니다.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SelectableText(
                          downloadPath,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('닫기'),
                    ),
                  ],
                ),
              );
            },
          )
              : null,
        ),
      );
    }
  }

  // 시뮬레이터 감지
  Future<bool> _isSimulator() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      return androidInfo.isPhysicalDevice == false;
    } else if (Platform.isIOS) {
      final iosInfo = await DeviceInfoPlugin().iosInfo;
      return !iosInfo.isPhysicalDevice;
    }
    return false;
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

  // HTTP 메서드 카드
  Widget _buildMethodCard({
    required ThemeData theme,
    required String method,
    required String description,
    required String code,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              method,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  description,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  code,
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
  }

  // HTTP 패키지 예제
  Widget _buildHttpExample({
    required ThemeData theme,
    required String method,
    required String code,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                method,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            code,
            style: theme.textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
              height: 1.5,
            ),
          ),
        ),
      ],
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
          size: 16,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  // 비교 아이템
  Widget _buildComparisonItem(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  // 권한 체크
  Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        var status = await Permission.storage.status;
        if (status != PermissionStatus.granted) {
          final result = await Permission.storage.request();
          return result == PermissionStatus.granted;
        }
        return true;
      }
      return true;
    }
    return true;
  }

  // 경로 찾기
  Future<String> _findLocalPath() async {
    if (Platform.isAndroid) {
      return "/storage/emulated/0/Download";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return '${directory.path}${Platform.pathSeparator}Download';
    }
  }

  // 폴더 생성
  Future<void> _prepareSaveDir({required String localPath}) async {
    final savedDir = Directory(localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }
}

// NotificationService
int count2 = 0;

class NotificationService {
  static final NotificationService _notificationService =
  NotificationService._internal();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings _androidInitializationSettings =
  const AndroidInitializationSettings('ic_launcher');

  var iosDetails = const DarwinInitializationSettings(
    defaultPresentAlert: true,
    defaultPresentBadge: true,
    defaultPresentSound: true,
  );

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal() {
    init();
  }

  void init() async {
    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: _androidInitializationSettings,
      iOS: iosDetails,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> createNotification(
      int count, int i, int id, String downloadPath, String downloadName) async {
    String groupKey = '${count2++}';
    const String groupChannelId = 'downloadChannel';
    const String groupChannelName = 'downloadName';
    const String groupChannelDescription = '다운로드 후 알림';

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      groupChannelId,
      groupChannelName,
      channelDescription: groupChannelDescription,
      channelShowBadge: false,
      groupKey: groupKey,
      setAsGroupSummary: true,
      importance: Importance.max,
      priority: Priority.high,
      onlyAlertOnce: false,
      showProgress: true,
      maxProgress: count,
      progress: i,
    );

    var initializationSettingsIOS = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: initializationSettingsIOS,
    );

    if (i == 100) {
      await _flutterLocalNotificationsPlugin.show(
        id,
        downloadName,
        '다운로드가 완료되었습니다.',
        platformChannelSpecifics,
        payload: downloadPath,
      );
    }

    await _flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (payload) async {
        await OpenFile.open(payload.payload).then((value) {});
      },
    );
  }
}