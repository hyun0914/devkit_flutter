import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../widget/default_scaffold.dart';

class SensorsScreen extends StatefulWidget {
  const SensorsScreen({super.key});

  @override
  State<SensorsScreen> createState() => _SensorsScreenState();
}

class _SensorsScreenState extends State<SensorsScreen> {
  // 센서 데이터
  AccelerometerEvent? _accelerometerEvent;
  GyroscopeEvent? _gyroscopeEvent;
  MagnetometerEvent? _magnetometerEvent;

  // 구독
  final List<StreamSubscription<dynamic>> _streamSubscriptions = [];

  // 기울기 각도 (시각화용)
  double _tiltX = 0;
  double _tiltY = 0;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    _streamSubscriptions.add(
      accelerometerEventStream().listen(
            (AccelerometerEvent event) {
          setState(() {
            _accelerometerEvent = event;
            // 기울기 계산 (가속도계 데이터 기반)
            _tiltX = event.x.clamp(-10.0, 10.0) / 10.0;
            _tiltY = event.y.clamp(-10.0, 10.0) / 10.0;
          });
        },
        onError: (error) {
          // 센서가 없는 경우 처리
          debugPrint('Accelerometer error: $error');
        },
        cancelOnError: true,
      ),
    );

    _streamSubscriptions.add(
      gyroscopeEventStream().listen(
            (GyroscopeEvent event) {
          setState(() {
            _gyroscopeEvent = event;
          });
        },
        onError: (error) {
          debugPrint('Gyroscope error: $error');
        },
        cancelOnError: true,
      ),
    );

    _streamSubscriptions.add(
      magnetometerEventStream().listen(
            (MagnetometerEvent event) {
          setState(() {
            _magnetometerEvent = event;
          });
        },
        onError: (error) {
          debugPrint('Magnetometer error: $error');
        },
        cancelOnError: true,
      ),
    );
  }

  @override
  void dispose() {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  // 나침반 각도 계산
  double _getCompassHeading() {
    if (_magnetometerEvent == null) return 0;
    final x = _magnetometerEvent!.x;
    final y = _magnetometerEvent!.y;
    double heading = math.atan2(y, x) * (180 / math.pi);
    if (heading < 0) heading += 360;
    return heading;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('디바이스 센서'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              '센서 데이터 모니터링',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '실제 기기에서 폰을 움직여보세요',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // 경고 카드
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
                    '• 에뮬레이터에서는 센서가 작동하지 않습니다\n'
                        '• 실제 기기(iOS/Android)에서 테스트하세요\n'
                        '• 일부 저사양 기기는 센서가 없을 수 있습니다',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.orange.shade800,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 기울기 시각화
            _buildTiltVisualizer(theme),

            const SizedBox(height: 24),

            // 가속도계 (Accelerometer)
            _buildSectionHeader(theme, Icons.trending_up, 'Accelerometer (가속도계)'),
            const SizedBox(height: 8),
            Text(
              '중력을 포함한 기기의 가속도 (m/s²)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            _buildSensorCard(
              theme: theme,
              x: _accelerometerEvent?.x ?? 0,
              y: _accelerometerEvent?.y ?? 0,
              z: _accelerometerEvent?.z ?? 0,
              color: Colors.blue,
            ),

            const SizedBox(height: 24),

            // 자이로스코프 (Gyroscope)
            _buildSectionHeader(theme, Icons.rotate_90_degrees_ccw, 'Gyroscope (자이로스코프)'),
            const SizedBox(height: 8),
            Text(
              '기기의 회전 속도 (rad/s)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            _buildSensorCard(
              theme: theme,
              x: _gyroscopeEvent?.x ?? 0,
              y: _gyroscopeEvent?.y ?? 0,
              z: _gyroscopeEvent?.z ?? 0,
              color: Colors.green,
            ),

            const SizedBox(height: 24),

            // 자기계 (Magnetometer) + 나침반
            _buildSectionHeader(theme, Icons.explore, 'Magnetometer (자기계)'),
            const SizedBox(height: 8),
            Text(
              '주변 자기장 (μT) • 나침반 기능',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Expanded(
                  child: _buildSensorCard(
                    theme: theme,
                    x: _magnetometerEvent?.x ?? 0,
                    y: _magnetometerEvent?.y ?? 0,
                    z: _magnetometerEvent?.z ?? 0,
                    color: Colors.purple,
                  ),
                ),
                _buildCompass(theme),
              ],
            ),

            const SizedBox(height: 24),

            // 활용 예시
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
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
                      Icon(Icons.lightbulb_outline, color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '💡 활용 예시',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  _buildUseCaseItem(theme, Icons.videogame_asset, '게임 컨트롤 (기울여서 조작)'),
                  _buildUseCaseItem(theme, Icons.fitness_center, '만보기 / 운동 추적'),
                  _buildUseCaseItem(theme, Icons.explore, '나침반 앱'),
                  _buildUseCaseItem(theme, Icons.vibration, '흔들기 감지 (Shake detection)'),
                  _buildUseCaseItem(theme, Icons.view_in_ar, 'AR/VR 앱'),
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

  Widget _buildSensorCard({
    required ThemeData theme,
    required double x,
    required double y,
    required double z,
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
      child: Column(
        spacing: 8,
        children: [
          _buildAxisRow(theme, 'X', x, color),
          _buildAxisRow(theme, 'Y', y, color),
          _buildAxisRow(theme, 'Z', z, color),
        ],
      ),
    );
  }

  Widget _buildAxisRow(ThemeData theme, String axis, double value, Color color) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            axis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 24,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              FractionallySizedBox(
                widthFactor: (value.abs() / 20).clamp(0.0, 1.0),
                child: Container(
                  height: 24,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 60,
          child: Text(
            value.toStringAsFixed(2),
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildTiltVisualizer(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            '기울기 시각화',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            width: 150,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 배경 원
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.surface,
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                ),
                // 중심선
                Container(
                  width: 1,
                  height: 150,
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
                Container(
                  width: 150,
                  height: 1,
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
                // 기울기 표시 점
                Transform.translate(
                  offset: Offset(_tiltX * 60, _tiltY * 60),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primary,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha: 0.4),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '폰을 기울여보세요',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompass(ThemeData theme) {
    final heading = _getCompassHeading();
    return Container(
      width: 120,
      height: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 2,
        children: [
          Text(
            '나침반',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(
            width: 60,
            height: 60,
            child: Transform.rotate(
              angle: -heading * math.pi / 180,
              child: Icon(
                Icons.navigation,
                size: 48,
                color: theme.colorScheme.error,
              ),
            ),
          ),
          Text(
            '${heading.toStringAsFixed(0)}°',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              color: theme.colorScheme.primary,
            ),
          ),
          Text(
            _getDirection(heading),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _getDirection(double heading) {
    if (heading < 22.5 || heading >= 337.5) return 'N 북';
    if (heading < 67.5) return 'NE 북동';
    if (heading < 112.5) return 'E 동';
    if (heading < 157.5) return 'SE 남동';
    if (heading < 202.5) return 'S 남';
    if (heading < 247.5) return 'SW 남서';
    if (heading < 292.5) return 'W 서';
    return 'NW 북서';
  }

  Widget _buildUseCaseItem(ThemeData theme, IconData icon, String text) {
    return Row(
      spacing: 12,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary.withValues(alpha: 0.7)),
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
}