import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widget/default_scaffold.dart';

class AppLifeCycleScreen extends StatefulWidget {
  const AppLifeCycleScreen({super.key});

  @override
  State<AppLifeCycleScreen> createState() => _AppLifeCycleScreenState();
}

class _AppLifeCycleScreenState extends State<AppLifeCycleScreen> with WidgetsBindingObserver {
  AppLifecycleState? _currentState;
  final List<_StateLog> _stateHistory = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // 초기 상태 설정
    _currentState = WidgetsBinding.instance.lifecycleState;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    setState(() {
      _currentState = state;
      _stateHistory.insert(
        0,
        _StateLog(
          state: state,
          timestamp: DateTime.now(),
        ),
      );
      // 최대 20개까지만 유지
      if (_stateHistory.length > 20) {
        _stateHistory.removeLast();
      }
    });
  }

  String _getStateKoreanName(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        return '재개됨 (Resumed)';
      case AppLifecycleState.inactive:
        return '비활성화 (Inactive)';
      case AppLifecycleState.paused:
        return '일시정지 (Paused)';
      case AppLifecycleState.detached:
        return '분리됨 (Detached)';
      case AppLifecycleState.hidden:
        return '숨겨짐 (Hidden)';
    }
  }

  String _getStateDescription(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        return '앱이 화면에 표시되고 사용자 입력을 받을 수 있는 상태';
      case AppLifecycleState.inactive:
        return '앱이 비활성 상태 (전화 통화, 알림 등)';
      case AppLifecycleState.paused:
        return '앱이 백그라운드 상태 (홈 버튼, 다른 앱으로 전환)';
      case AppLifecycleState.detached:
        return '플러터 엔진은 실행 중이나 뷰가 분리된 상태';
      case AppLifecycleState.hidden:
        return '앱이 숨겨진 상태 (iOS에서 주로 발생)';
    }
  }

  Color _getStateColor(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        return Colors.green;
      case AppLifecycleState.inactive:
        return Colors.orange;
      case AppLifecycleState.paused:
        return Colors.blue;
      case AppLifecycleState.detached:
        return Colors.red;
      case AppLifecycleState.hidden:
        return Colors.grey;
    }
  }

  IconData _getStateIcon(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        return Icons.play_circle;
      case AppLifecycleState.inactive:
        return Icons.pause_circle;
      case AppLifecycleState.paused:
        return Icons.stop_circle;
      case AppLifecycleState.detached:
        return Icons.cancel;
      case AppLifecycleState.hidden:
        return Icons.visibility_off;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('앱 라이프사이클'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              '앱 라이프사이클',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '앱 상태 변화 모니터링',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // 현재 상태
            _buildSectionHeader(theme, '현재 상태'),
            const SizedBox(height: 12),
            if (_currentState != null)
              _buildCurrentStateCard(theme, _currentState!)
            else
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '상태를 기다리는 중...',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // 상태 설명
            _buildSectionHeader(theme, '상태 설명'),
            const SizedBox(height: 12),
            _buildStateDescriptions(theme),

            const SizedBox(height: 24),

            // 상태 변경 히스토리
            _buildSectionHeader(theme, '상태 변경 히스토리'),
            const SizedBox(height: 12),
            if (_stateHistory.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.history,
                        size: 48,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '아직 상태 변경이 없습니다',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '홈 버튼을 누르거나 앱을 전환해보세요',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
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
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.history,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '총 ${_stateHistory.length}개의 변경',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _stateHistory.length,
                      separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final log = _stateHistory[index];
                        return _buildHistoryItem(theme, log);
                      },
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // 사용된 개념
            _buildSectionHeader(theme, '사용된 개념'),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildConceptItem(
                    theme: theme,
                    title: 'WidgetsBindingObserver',
                    description: '위젯 생명주기 이벤트를 감지하는 믹스인',
                  ),
                  const SizedBox(height: 12),
                  _buildConceptItem(
                    theme: theme,
                    title: 'didChangeAppLifecycleState',
                    description: '앱 라이프사이클 상태 변경 시 호출되는 콜백',
                  ),
                  const SizedBox(height: 12),
                  _buildConceptItem(
                    theme: theme,
                    title: 'AppLifecycleState',
                    description: '5가지 앱 상태 (resumed, inactive, paused, detached, hidden)',
                  ),
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

  // 현재 상태 카드
  Widget _buildCurrentStateCard(ThemeData theme, AppLifecycleState state) {
    final color = _getStateColor(state);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(
            _getStateIcon(state),
            size: 64,
            color: color,
          ),
          const SizedBox(height: 16),
          Text(
            _getStateKoreanName(state),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _getStateDescription(state),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // 상태 설명 카드
  Widget _buildStateDescriptions(ThemeData theme) {
    return Container(
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
        children: AppLifecycleState.values.map((state) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getStateColor(state).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getStateIcon(state),
                    size: 20,
                    color: _getStateColor(state),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getStateKoreanName(state),
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getStateDescription(state),
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
        }).toList(),
      ),
    );
  }

  // 히스토리 아이템
  Widget _buildHistoryItem(ThemeData theme, _StateLog log) {
    final timeFormat = DateFormat('HH:mm:ss');

    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getStateColor(log.state),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            _getStateIcon(log.state),
            size: 20,
            color: _getStateColor(log.state),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _getStateKoreanName(log.state),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            timeFormat.format(log.timestamp),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  // 개념 아이템
  Widget _buildConceptItem({
    required ThemeData theme,
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
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
    );
  }
}

// 상태 로그 모델
class _StateLog {
  final AppLifecycleState state;
  final DateTime timestamp;

  _StateLog({
    required this.state,
    required this.timestamp,
  });
}