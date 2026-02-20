import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../widget/default_scaffold.dart';

class WakelockScreen extends StatefulWidget {
  const WakelockScreen({super.key});

  @override
  State<WakelockScreen> createState() => _WakelockScreenState();
}

class _WakelockScreenState extends State<WakelockScreen> {
  bool _isWakelockEnabled = false;
  Timer? _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _checkWakelockStatus();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WakelockPlus.disable();
    super.dispose();
  }

  // Wakelock 상태 확인
  Future<void> _checkWakelockStatus() async {
    final enabled = await WakelockPlus.enabled;
    setState(() {
      _isWakelockEnabled = enabled;
    });
  }

  // Wakelock 활성화
  Future<void> _enableWakelock() async {
    await WakelockPlus.enable();
    await _checkWakelockStatus();
    _startTimer();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('화면이 꺼지지 않습니다'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Wakelock 비활성화
  Future<void> _disableWakelock() async {
    await WakelockPlus.disable();
    await _checkWakelockStatus();
    _stopTimer();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('화면 자동 꺼짐 활성화'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // 타이머 시작
  void _startTimer() {
    _seconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  // 타이머 중지
  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _seconds = 0;
    });
  }

  // 시간 포맷 (00:00:00)
  String _formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('화면 켜짐 유지'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              'Wakelock',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '화면 자동 꺼짐 방지',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // 상태 표시 카드
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isWakelockEnabled
                      ? [
                    Colors.green.withValues(alpha: 0.2),
                    Colors.green.withValues(alpha: 0.05),
                  ]
                      : [
                    theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    theme.colorScheme.surface,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isWakelockEnabled
                      ? Colors.green.withValues(alpha: 0.4)
                      : theme.colorScheme.outline.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  // 아이콘
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isWakelockEnabled
                          ? Colors.green.withValues(alpha: 0.2)
                          : theme.colorScheme.surfaceContainerHighest,
                    ),
                    child: Icon(
                      _isWakelockEnabled ? Icons.lightbulb : Icons.lightbulb_outline,
                      size: 48,
                      color: _isWakelockEnabled ? Colors.green : theme.colorScheme.outline,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 상태 텍스트
                  Text(
                    _isWakelockEnabled ? '화면 켜짐 유지 중' : '화면 자동 꺼짐',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _isWakelockEnabled ? Colors.green : theme.colorScheme.onSurface,
                    ),
                  ),

                  if (_isWakelockEnabled) ...[
                    const SizedBox(height: 8),
                    Text(
                      '화면이 자동으로 꺼지지 않습니다',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],

                  // 타이머
                  if (_isWakelockEnabled) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.green.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        spacing: 4,
                        children: [
                          Text(
                            '활성화 시간',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.green.shade700,
                            ),
                          ),
                          Text(
                            _formatTime(_seconds),
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                              color: Colors.green.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // 토글 버튼
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _isWakelockEnabled ? _disableWakelock : _enableWakelock,
                      icon: Icon(_isWakelockEnabled ? Icons.close : Icons.check, size: 20),
                      label: Text(
                        _isWakelockEnabled ? '비활성화' : '활성화',
                        style: const TextStyle(fontSize: 16),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: _isWakelockEnabled
                            ? theme.colorScheme.error
                            : Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 테스트 안내
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '테스트 방법',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '1. 기기 설정에서 화면 자동 꺼짐을 짧게 설정 (예: 15초)\n'
                        '2. "활성화" 버튼을 누른 후 기다리기\n'
                        '3. 설정한 시간이 지나도 화면이 안 꺼지는지 확인',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.blue.shade800,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 활용 예시
            _buildSectionHeader(theme, Icons.apps, '실무 활용 예시'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  _buildUseCaseItem(theme, Icons.play_circle, '동영상 재생 중'),
                  _buildUseCaseItem(theme, Icons.book, '전자책/뉴스 읽기'),
                  _buildUseCaseItem(theme, Icons.restaurant, '요리 레시피 보면서 요리'),
                  _buildUseCaseItem(theme, Icons.slideshow, '프레젠테이션/슬라이드쇼'),
                  _buildUseCaseItem(theme, Icons.navigation, '내비게이션 사용 중'),
                  _buildUseCaseItem(theme, Icons.volume_up, 'TTS (음성 읽기) 재생 중'),
                  _buildUseCaseItem(theme, Icons.sports_esports, '게임 플레이'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 주의사항
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '⚠️ 주의사항',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '• 배터리 소모가 증가할 수 있습니다\n'
                        '• 필요한 경우에만 활성화하세요\n'
                        '• 앱 전체가 아닌 특정 화면에서만 사용 권장\n'
                        '• main() 함수에서 전역 활성화는 피하세요',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.orange.shade800,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 코드 예제
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
                      Icon(Icons.code, color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '간단한 사용법',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        _buildCodeLine('// 활성화'),
                        _buildCodeLine('await WakelockPlus.enable();'),
                        const SizedBox(height: 8),
                        _buildCodeLine('// 비활성화'),
                        _buildCodeLine('await WakelockPlus.disable();'),
                        const SizedBox(height: 8),
                        _buildCodeLine('// 상태 확인'),
                        _buildCodeLine('bool enabled = await WakelockPlus.enabled;'),
                      ],
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

  Widget _buildSectionHeader(ThemeData theme, IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 24),
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

  Widget _buildUseCaseItem(ThemeData theme, IconData icon, String text) {
    return Row(
      spacing: 12,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary.withValues(alpha: 0.7)),
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

  Widget _buildCodeLine(String code) {
    return Text(
      code,
      style: const TextStyle(
        fontFamily: 'monospace',
        fontSize: 12,
        color: Colors.greenAccent,
        height: 1.5,
      ),
    );
  }
}