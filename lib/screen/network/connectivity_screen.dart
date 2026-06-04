import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../widget/default_scaffold.dart';

class ConnectivityScreen extends StatefulWidget {
  const ConnectivityScreen({super.key});

  @override
  State<ConnectivityScreen> createState() => _ConnectivityScreenState();
}

class _ConnectivityScreenState extends State<ConnectivityScreen> {
  List<ConnectivityResult> _currentStatus = [];
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  final List<_ConnectivityLog> _logs = [];

  @override
  void initState() {
    super.initState();
    _checkOnce();
    _startListening();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _checkOnce() async {
    final result = await Connectivity().checkConnectivity();
    if (!mounted) return;
    setState(() {
      _currentStatus = result;
    });
  }

  void _startListening() {
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      if (!mounted) return;
      setState(() {
        _currentStatus = result;
        _logs.insert(
          0,
          _ConnectivityLog(
            status: result,
            time: DateTime.now(),
          ),
        );
        if (_logs.length > 20) _logs.removeLast();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('네트워크 연결 상태'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              '네트워크 연결 상태',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'connectivity_plus 패키지로 연결 상태를 확인·감지합니다',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            _buildSectionHeader(theme, '현재 상태'),
            const SizedBox(height: 12),
            _buildStatusCard(theme),

            const SizedBox(height: 24),

            _buildSectionHeader(theme, '실시간 감지 로그'),
            const SizedBox(height: 4),
            Text(
              '연결 상태가 변경될 때마다 기록됩니다',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            _buildLogSection(theme),

            const SizedBox(height: 24),
            _buildInfoCard(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(ThemeData theme) {
    final info = _getStatusInfo(_currentStatus);

    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: info.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(info.icon, color: info.color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info.label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: info.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    info.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: _checkOnce,
              icon: const Icon(Icons.refresh_rounded),
              tooltip: '새로고침',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogSection(ThemeData theme) {
    if (_logs.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Center(
          child: Text(
            '연결 상태 변경 시 여기에 기록됩니다',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _logs.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
        itemBuilder: (_, i) {
          final log = _logs[i];
          final info = _getStatusInfo(log.status);
          return ListTile(
            leading: Icon(info.icon, color: info.color, size: 20),
            title: Text(
              info.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              _formatTime(log.time),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          );
        },
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

  Widget _buildInfoCard(ThemeData theme) {
    return Container(
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
              Icon(Icons.info_outline, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                '💡 connectivity_plus 속성',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            '• checkConnectivity(): 현재 상태 1회 확인\n'
            '• onConnectivityChanged: 상태 변경 스트림\n'
            '• ConnectivityResult.wifi / mobile / none\n'
            '• 복수 결과 반환 가능 (List<ConnectivityResult>)\n'
            '• StreamSubscription은 dispose()에서 cancel() 필수',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  _StatusInfo _getStatusInfo(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.wifi)) {
      return _StatusInfo(
        icon: Icons.wifi_rounded,
        label: 'WiFi 연결 중',
        description: '무선 네트워크에 연결되어 있습니다',
        color: Colors.green,
      );
    } else if (result.contains(ConnectivityResult.mobile)) {
      return _StatusInfo(
        icon: Icons.signal_cellular_alt_rounded,
        label: '모바일 데이터 사용 중',
        description: '셀룰러 네트워크에 연결되어 있습니다',
        color: Colors.blue,
      );
    } else if (result.contains(ConnectivityResult.ethernet)) {
      return _StatusInfo(
        icon: Icons.cable_rounded,
        label: '이더넷 연결 중',
        description: '유선 네트워크에 연결되어 있습니다',
        color: Colors.teal,
      );
    } else {
      return _StatusInfo(
        icon: Icons.wifi_off_rounded,
        label: '연결 없음',
        description: '네트워크 연결을 확인하세요',
        color: Colors.red,
      );
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:'
        '${time.second.toString().padLeft(2, '0')}';
  }
}

class _StatusInfo {
  final IconData icon;
  final String label;
  final String description;
  final Color color;

  const _StatusInfo({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
  });
}

class _ConnectivityLog {
  final List<ConnectivityResult> status;
  final DateTime time;

  const _ConnectivityLog({required this.status, required this.time});
}
