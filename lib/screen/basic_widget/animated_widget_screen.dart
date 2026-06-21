import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../widget/default_scaffold.dart';

class AnimatedWidgetScreen extends StatefulWidget {
  const AnimatedWidgetScreen({super.key});

  @override
  State<AnimatedWidgetScreen> createState() => _AnimatedWidgetScreenState();
}

class _AnimatedWidgetScreenState extends State<AnimatedWidgetScreen>
    with TickerProviderStateMixin {
  bool _selected = false;
  int _count = 0;
  double _opacity = 1.0;
  double _padding = 0.0;
  double _iconSize = 24.0;
  bool _slideSelected = false;
  bool _flipY = false;
  bool _flipX = false;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('Animated 위젯'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              'Animated 위젯',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '다양한 애니메이션 효과를 확인해보세요',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // AnimatedContainer
            _buildSectionHeader(theme, '크기 & 색상'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'AnimatedContainer',
              description: '크기, 색상, 정렬이 부드럽게 변화',
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selected = !_selected;
                  });
                },
                child: Center(
                  child: AnimatedContainer(
                    width: _selected ? 200.0 : 100.0,
                    height: _selected ? 100.0 : 200.0,
                    decoration: BoxDecoration(
                      color: _selected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(_selected ? 50 : 10),
                    ),
                    alignment:
                        _selected ? Alignment.center : Alignment.topCenter,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                    child: Icon(
                      Icons.touch_app,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // AnimatedSize
            _buildExampleCard(
              theme: theme,
              title: 'AnimatedSize',
              description: '크기 변화에 자동으로 애니메이션 적용',
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selected = !_selected;
                  });
                },
                child: Center(
                  child: Container(
                    color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      child: FlutterLogo(
                        size: _selected ? 150.0 : 80.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 투명도 & 간격
            _buildSectionHeader(theme, '투명도 & 간격'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'AnimatedOpacity',
              description: '투명도가 부드럽게 변화',
              child: Column(
                spacing: 12,
                children: [
                  Center(
                    child: AnimatedOpacity(
                      opacity: _opacity,
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.visibility,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: () {
                      setState(() {
                        _opacity = _opacity == 0 ? 1.0 : 0.0;
                      });
                    },
                    child: Text(_opacity == 0 ? '보이기' : '숨기기'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _buildExampleCard(
              theme: theme,
              title: 'AnimatedPadding',
              description: '패딩이 부드럽게 변화',
              child: Column(
                spacing: 12,
                children: [
                  Container(
                    width: double.infinity,
                    height: 120,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: AnimatedPadding(
                      padding: EdgeInsets.all(_padding),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Padding: ${_padding.toInt()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: () {
                      setState(() {
                        _padding = _padding == 0.0 ? 40.0 : 0.0;
                      });
                    },
                    child: Text(_padding == 0 ? '패딩 추가' : '패딩 제거'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 전환 효과
            _buildSectionHeader(theme, '전환 효과'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'AnimatedSwitcher',
              description: '위젯 전환 시 페이드 효과',
              child: Column(
                spacing: 12,
                children: [
                  Container(
                    height: 80,
                    alignment: Alignment.center,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },
                      child: Text(
                        '$_count',
                        key: ValueKey<int>(_count),
                        style: theme.textTheme.displayLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () {
                      setState(() {
                        _count++;
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('카운트 증가'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _buildExampleCard(
              theme: theme,
              title: 'AnimatedCrossFade',
              description: '두 위젯 간 크로스페이드 전환',
              child: Column(
                spacing: 12,
                children: [
                  Center(
                    child: AnimatedCrossFade(
                      firstChild: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: const Icon(
                          Icons.circle,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                      secondChild: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.square,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                      crossFadeState: _selected
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 500),
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: () {
                      setState(() {
                        _selected = !_selected;
                      });
                    },
                    child: Text(_selected ? '네모로 변경' : '동그라미로 변경'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 고급 효과
            _buildSectionHeader(theme, '고급 효과'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'AnimatedPhysicalModel',
              description: '그림자와 elevation 애니메이션',
              child: Column(
                spacing: 12,
                children: [
                  Center(
                    child: AnimatedPhysicalModel(
                      shape: BoxShape.rectangle,
                      borderRadius:
                          _selected ? BorderRadius.circular(50) : BorderRadius.zero,
                      elevation: _selected ? 20.0 : 2.0,
                      color: _selected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.secondary,
                      shadowColor: _selected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.secondary,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      child: const SizedBox(
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: () {
                      setState(() {
                        _selected = !_selected;
                      });
                    },
                    child: const Text('그림자 변경'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _buildExampleCard(
              theme: theme,
              title: 'TweenAnimationBuilder',
              description: '사용자 정의 애니메이션',
              child: Column(
                spacing: 12,
                children: [
                  Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: _iconSize),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.elasticOut,
                      builder: (context, size, child) {
                        return Icon(
                          Icons.favorite,
                          size: size,
                          color: theme.colorScheme.error,
                        );
                      },
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: () {
                      setState(() {
                        _iconSize = _iconSize == 24.0 ? 80.0 : 24.0;
                      });
                    },
                    child: Text(_iconSize == 24 ? '크게' : '작게'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 슬라이드 & 변형
            _buildSectionHeader(theme, '슬라이드 & 변형'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'AnimatedContainer + Matrix4 슬라이드',
              description: 'transform: Matrix4.translationValues(x, 0, 0)',
              child: Column(
                spacing: 12,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                    transform: Matrix4.translationValues(
                      _slideSelected ? 80.0 : 0.0,
                      0,
                      0,
                    ),
                    child: Container(
                      width: 80,
                      height: 60,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_forward, color: Colors.white),
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: () =>
                        setState(() => _slideSelected = !_slideSelected),
                    child: Text(_slideSelected ? '← 원위치' : '슬라이드 →'),
                  ),
                  Text(
                    '⚠ null인 속성은 애니메이션 안 됨 / child 위젯은 애니메이션 대상 아님',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _buildExampleCard(
              theme: theme,
              title: 'Transform — 위젯 반전',
              description:
                  'Matrix4.rotationY/X(math.pi) + alignment: Alignment.center',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    spacing: 8,
                    children: [
                      Transform(
                        alignment: Alignment.center,
                        transform:
                            Matrix4.rotationY(_flipY ? math.pi : 0),
                        child: Container(
                          width: 80,
                          height: 70,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.thumb_up,
                              color: theme.colorScheme.primary, size: 32),
                        ),
                      ),
                      FilledButton.tonal(
                        onPressed: () =>
                            setState(() => _flipY = !_flipY),
                        child: const Text('좌우 반전'),
                      ),
                      Text('rotationY(pi)',
                          style: theme.textTheme.labelSmall),
                    ],
                  ),
                  Column(
                    spacing: 8,
                    children: [
                      Transform(
                        alignment: Alignment.center,
                        transform:
                            Matrix4.rotationX(_flipX ? math.pi : 0),
                        child: Container(
                          width: 80,
                          height: 70,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.thumb_up,
                              color: theme.colorScheme.secondary, size: 32),
                        ),
                      ),
                      FilledButton.tonal(
                        onPressed: () =>
                            setState(() => _flipX = !_flipX),
                        child: const Text('상하 반전'),
                      ),
                      Text('rotationX(pi)',
                          style: theme.textTheme.labelSmall),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Shimmer
            _buildSectionHeader(theme, '로딩 효과'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'Shimmer (스켈레톤 로딩)',
              description: 'shimmer: ^3.0.0 — 데이터 로드 전 플레이스홀더 UI',
              child: Shimmer.fromColors(
                baseColor: theme.colorScheme.surfaceContainerHighest,
                highlightColor: theme.colorScheme.surface,
                child: Column(
                  spacing: 12,
                  children: List.generate(
                    3,
                    (i) => Row(
                      spacing: 12,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 6,
                            children: [
                              Container(
                                height: 14,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              Container(
                                height: 12,
                                width: 140,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Wave Indicator
            _buildSectionHeader(theme, '커스텀 그리기'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'Wave Indicator (CustomPainter + sin)',
              description:
                  'AnimationController.repeat() → AnimatedBuilder → CustomPaint',
              child: Column(
                spacing: 16,
                children: [
                  AnimatedBuilder(
                    animation: _waveController,
                    builder: (context, _) => Column(
                      spacing: 8,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: CustomPaint(
                            painter: _WavePainter(
                              progress: _waveController.value,
                              color: theme.colorScheme.primary,
                              amplitude: 12,
                              frequency: 2,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: CustomPaint(
                            painter: _WavePainter(
                              progress: _waveController.value,
                              color: theme.colorScheme.secondary,
                              amplitude: 20,
                              frequency: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'amplitude(높이) · frequency(주기) 조절로 다양한 파동\n'
                      'shouldRepaint → true 반환 필수',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
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
                        '💡 Animated 위젯 종류',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'AnimatedContainer: 가장 범용적',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'AnimatedOpacity: 페이드 효과',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'AnimatedSwitcher: 위젯 교체',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'TweenAnimationBuilder: 커스텀 애니메이션',
                  ),
                  const Divider(),
                  Text(
                    '모든 Animated 위젯은 duration과 curve를 지정할 수 있습니다.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 리셋 버튼
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _selected = false;
                  _count = 0;
                  _opacity = 1.0;
                  _padding = 0.0;
                  _iconSize = 24.0;
                  _slideSelected = false;
                  _flipY = false;
                  _flipX = false;
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('모두 리셋'),
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

  // 예제 카드
  Widget _buildExampleCard({
    required ThemeData theme,
    required String title,
    required String description,
    required Widget child,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
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
}

class _WavePainter extends CustomPainter {
  final double progress;
  final Color color;
  final double amplitude;
  final double frequency;

  const _WavePainter({
    required this.progress,
    required this.color,
    required this.amplitude,
    required this.frequency,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height / 2);
    for (double x = 0; x <= size.width; x++) {
      final y = size.height / 2 +
          amplitude *
              math.sin(
                (x / size.width * 2 * math.pi * frequency) +
                    (progress * 2 * math.pi),
              );
      path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
