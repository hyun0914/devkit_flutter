import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widget/default_scaffold.dart';

// 스크롤 발광 효과 제거
class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class BasicWidgetScreen extends StatefulWidget {
  const BasicWidgetScreen({super.key});

  @override
  State<BasicWidgetScreen> createState() => _BasicWidgetScreenState();
}

class _BasicWidgetScreenState extends State<BasicWidgetScreen>
    with TickerProviderStateMixin {
  // 상태 변수
  bool switchValue = true;
  double barValue = 280 * (40 / 100);
  int currentIndex = 0;
  List<String> strList = ['커피', '치킨', '햄버거', '피자', '파스타', '족발', '갈비찜'];
  String dropdownValue = '테스트1';
  String dropdownFormValue = '테스트항목1';
  String _overlayDropdownValue = '옵션 1';
  bool _isOverlayDropdownOpen = false;
  final LayerLink _dropdownLayerLink = LayerLink();
  OverlayEntry? _dropdownOverlay;
  bool ignorePointerEnabled = false;
  bool _absorbPointerEnabled = true;
  String _clipboardRead = '';
  String _hitBehaviorLog = '';
  int _chipSingleIndex = 0;
  final Set<int> _chipMultiSelected = {0, 2};

  // Keys
  final GlobalKey<TooltipState> tooltipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> tooltipKey2 = GlobalKey<TooltipState>();
  final GlobalKey appBarKey = GlobalKey();

  // Controllers
  late AnimationController progressController;
  late AnimationController shakeController;
  late Animation<Color?> colorTween;
  late Animation<double> shakeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Progress Indicator
    progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
      setState(() {});
    });
    colorTween = progressController.drive(
      ColorTween(begin: Colors.green, end: Colors.teal),
    );
    progressController.forward();

    // Shake Animation
    shakeController = AnimationController(
      duration: const Duration(milliseconds: 40),
      vsync: this,
    );
    shakeAnimation = Tween(begin: 0.0, end: 3.0).animate(shakeController);
    shakeController.repeat(reverse: true);
    Timer(const Duration(seconds: 1), () => shakeController.stop());
  }

  void showOverlayWidget(double? top) async {
    final overlayEntry = OverlayEntry(builder: (BuildContext context) {
      if (top == null) {
        return Align(
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Center(
              child: Text(
                'Overlay\n중앙',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }
      return Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Material(
          type: MaterialType.transparency,
          child: SafeArea(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Text(
                'Overlay 상단',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    });

    Overlay.of(context).insert(overlayEntry);
    await Future.delayed(const Duration(seconds: 1));
    overlayEntry.remove();
  }

  @override
  Widget build(BuildContext context) {
    var primaryScrollController = PrimaryScrollController.of(context);
    final theme = Theme.of(context);

    return DefaultScaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () => primaryScrollController.jumpTo(0),
        child: const Icon(Icons.arrow_upward),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        key: appBarKey,
        title: const Text('기본 위젯 모음'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _buildShakeIcon(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        elevation: 0.0,
        backgroundColor: theme.colorScheme.primary,
        selectedItemColor: theme.colorScheme.onPrimary,
        unselectedItemColor:
        theme.colorScheme.onPrimary.withValues(alpha: 0.6),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(bottom: 60),
          child: ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: ListView(
              controller: primaryScrollController,
              padding: const EdgeInsets.all(16),
              children: [
                // 헤더
                Text(
                  '기본 위젯 모음',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '자주 사용하는 Flutter 위젯',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 24),

                // 레이아웃 위젯
                _buildSection(
                  theme: theme,
                  icon: Icons.view_quilt,
                  title: '레이아웃 위젯',
                  children: [
                    _buildExampleItem(
                      theme: theme,
                      title: 'AspectRatio (비율 유지)',
                      child: AspectRatio(
                        aspectRatio: 4.4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            border: Border.all(
                                width: 2, color: theme.colorScheme.primary),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'AspectRatio: 4.4',
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildExampleItem(
                      theme: theme,
                      title: 'FractionallySizedBox (비율 크기)',
                      child: Container(
                        width: 200,
                        height: 100,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          border: Border.all(
                              width: 2, color: theme.colorScheme.outline),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: FractionallySizedBox(
                          widthFactor: 0.8,
                          heightFactor: 0.8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              border: Border.all(
                                  width: 2, color: theme.colorScheme.primary),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '80% 크기',
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildExampleItem(
                      theme: theme,
                      title: 'Stack & Positioned',
                      child: SizedBox(
                        height: 120,
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 100,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              height: 50,
                              child: Container(
                                margin:
                                const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    'Positioned 중앙',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onPrimary),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildExampleItem(
                      theme: theme,
                      title: 'Align (정렬 위치)',
                      child: SizedBox(
                        height: 100,
                        child: Row(
                          children: [
                            Expanded(child: _buildAlignBox(theme, Alignment.topLeft, 'topLeft')),
                            const SizedBox(width: 4),
                            Expanded(child: _buildAlignBox(theme, Alignment.center, 'center')),
                            const SizedBox(width: 4),
                            Expanded(child: _buildAlignBox(theme, Alignment.bottomRight, 'bottomRight')),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildExampleItem(
                      theme: theme,
                      title: 'Wrap (자동 줄바꿈 / spacing·runSpacing)',
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ['Flutter', 'Dart', 'Widget', 'Layout', 'Build', 'Design']
                            .map((label) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(label,
                                      style: theme.textTheme.labelMedium),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildExampleItem(
                      theme: theme,
                      title: 'ConstrainedBox (최소/최대 크기 제약)',
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: 180,
                            minHeight: 56,
                            maxHeight: 80,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: theme.colorScheme.primary, width: 2),
                            ),
                            child: Center(
                              child: Text(
                                'minWidth: 180  minHeight: 56',
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildExampleItem(
                      theme: theme,
                      title: 'IntrinsicWidth (가장 넓은 자식 기준 너비 통일)',
                      child: Center(
                        child: IntrinsicWidth(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer,
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(8)),
                                ),
                                child: Text('짧음',
                                    style: theme.textTheme.bodySmall),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                color: theme.colorScheme.secondaryContainer,
                                child: Text('조금 더 긴 텍스트',
                                    style: theme.textTheme.bodySmall),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.tertiaryContainer,
                                  borderRadius: const BorderRadius.vertical(
                                      bottom: Radius.circular(8)),
                                ),
                                child: Text('가장 긴 텍스트 예시입니다',
                                    style: theme.textTheme.bodySmall),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // UI 컴포넌트
                _buildSection(
                  theme: theme,
                  icon: Icons.widgets_outlined,
                  title: 'UI 컴포넌트',
                  children: [
                    _buildExampleItem(
                      theme: theme,
                      title: 'Switch (Material & Cupertino)',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Switch(
                                value: switchValue,
                                thumbColor:
                                WidgetStateProperty.resolveWith((states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return theme.colorScheme.primary;
                                  }
                                  return null;
                                }),
                                onChanged: (value) {
                                  setState(() {
                                    switchValue = value;
                                  });
                                },
                              ),
                              Text('Material',
                                  style: theme.textTheme.labelSmall),
                            ],
                          ),
                          Column(
                            children: [
                              Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                  activeTrackColor: theme.colorScheme.primary,
                                  value: switchValue,
                                  onChanged: (value) {
                                    setState(() {
                                      switchValue = value;
                                    });
                                  },
                                ),
                              ),
                              Text('Cupertino',
                                  style: theme.textTheme.labelSmall),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildExampleItem(
                      theme: theme,
                      title: 'Custom Progress Bar',
                      child: Column(
                        spacing: 8,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 10,
                                decoration: BoxDecoration(
                                  color:
                                  theme.colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              Container(
                                width: barValue,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ],
                          ),
                          Text('40% 진행',
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.primary)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildExampleItem(
                      theme: theme,
                      title: 'Chip & Wrap',
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(
                          strList.length,
                              (index) => Chip(
                            label: Text(strList[index]),
                            backgroundColor:
                            theme.colorScheme.secondaryContainer,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildExampleItem(
                      theme: theme,
                      title: 'ChoiceChip (단일 선택)',
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(
                          strList.length,
                          (index) => ChoiceChip(
                            label: Text(strList[index]),
                            selected: _chipSingleIndex == index,
                            onSelected: (_) =>
                                setState(() => _chipSingleIndex = index),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildExampleItem(
                      theme: theme,
                      title: 'ChoiceChip (복수 선택)',
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(
                          strList.length,
                          (index) => ChoiceChip(
                            label: Text(strList[index]),
                            selected: _chipMultiSelected.contains(index),
                            onSelected: (selected) => setState(() {
                              if (selected) {
                                _chipMultiSelected.add(index);
                              } else {
                                _chipMultiSelected.remove(index);
                              }
                            }),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildExampleItem(
                      theme: theme,
                      title: 'Tooltip',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () => tooltipKey.currentState
                                ?.ensureTooltipVisible(),
                            child: Tooltip(
                              key: tooltipKey,
                              message: 'Manual Tooltip',
                              triggerMode: TooltipTriggerMode.manual,
                              showDuration: const Duration(seconds: 1),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              textStyle: TextStyle(
                                  color: theme.colorScheme.onPrimary),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text('탭하세요'),
                              ),
                            ),
                          ),
                          Tooltip(
                            key: tooltipKey2,
                            message: 'Tap Tooltip',
                            preferBelow: false,
                            triggerMode: TooltipTriggerMode.tap,
                            showDuration: const Duration(seconds: 1),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: TextStyle(
                                color: theme.colorScheme.onSecondary),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text('탭 모드'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 시각 효과
                _buildSection(
                  theme: theme,
                  icon: Icons.palette_outlined,
                  title: '시각 효과',
                  children: [
                    _buildExampleItem(
                      theme: theme,
                      title: 'ClipRRect & ClipOval (이미지 모양)',
                      child: Column(
                        spacing: 12,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                spacing: 4,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      width: 80,
                                      height: 60,
                                      color: theme.colorScheme.primaryContainer,
                                      child: Icon(Icons.image,
                                          size: 32,
                                          color: theme.colorScheme.primary),
                                    ),
                                  ),
                                  Text('circular(12)',
                                      style: theme.textTheme.labelSmall),
                                ],
                              ),
                              Column(
                                spacing: 4,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      color: theme.colorScheme.tertiaryContainer,
                                      child: Icon(Icons.image,
                                          size: 32,
                                          color: theme.colorScheme.tertiary),
                                    ),
                                  ),
                                  Text('원형 (size/2)',
                                      style: theme.textTheme.labelSmall),
                                ],
                              ),
                              Column(
                                spacing: 4,
                                children: [
                                  ClipOval(
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      color:
                                          theme.colorScheme.secondaryContainer,
                                      child: Icon(Icons.person,
                                          size: 32,
                                          color: theme.colorScheme.secondary),
                                    ),
                                  ),
                                  Text('ClipOval',
                                      style: theme.textTheme.labelSmall),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '✓ 반드시 클리핑할 위젯 바로 위에 감싸야 함\n'
                              '⚠ ClipRRect가 child보다 크면 예상치 못한 위치에 클리핑됨',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildExampleItem(
                      theme: theme,
                      title: 'Gradient (그라데이션)',
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    theme.colorScheme.primary,
                                    theme.colorScheme.secondary,
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Linear',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: RadialGradient(
                                  colors: [
                                    theme.colorScheme.tertiary,
                                    theme.colorScheme.tertiaryContainer,
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Radial',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.colorScheme.onTertiary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildExampleItem(
                      theme: theme,
                      title: 'Gradient Text — foreground vs ShaderMask',
                      child: Column(
                        spacing: 14,
                        children: [
                          // 방법 1: TextStyle.foreground (고정 Rect)
                          Column(
                            spacing: 4,
                            children: [
                              Text(
                                '방법 1: TextStyle.foreground',
                                style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant),
                              ),
                              Text(
                                'Gradient Text',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()
                                    ..shader = LinearGradient(
                                      colors: [
                                        theme.colorScheme.primary,
                                        theme.colorScheme.tertiary,
                                      ],
                                    ).createShader(
                                        const Rect.fromLTWH(0, 0, 200, 40)),
                                ),
                              ),
                              Text(
                                '⚠ Rect 고정값 → 위젯 크기 변화 시 그라디언트 위치 어긋남',
                                style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.error),
                              ),
                            ],
                          ),
                          const Divider(),
                          // 방법 2: ShaderMask (권장)
                          Column(
                            spacing: 4,
                            children: [
                              Text(
                                '방법 2: ShaderMask (권장)',
                                style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant),
                              ),
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    theme.colorScheme.primary,
                                    theme.colorScheme.secondary,
                                  ],
                                ).createShader(Rect.fromLTWH(
                                    0, 0, bounds.width, bounds.height)),
                                child: const Text(
                                  'Gradient Text',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '✓ bounds 자동 대응 / child color는 Colors.white 필수',
                                style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.primary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildExampleItem(
                      theme: theme,
                      title: 'BoxShadow (그림자)',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.primary
                                      .withValues(alpha: 0.3),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Shadow',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildExampleItem(
                      theme: theme,
                      title: 'Material Shape',
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildShapeCard(
                            theme,
                            'Rounded',
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          _buildShapeCard(
                            theme,
                            'Stadium',
                            const StadiumBorder(),
                          ),
                          _buildShapeCard(
                            theme,
                            'Circle',
                            const CircleBorder(),
                          ),
                          _buildShapeCard(
                            theme,
                            'Continuous',
                            ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(24)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 인터랙션
                _buildSection(
                  theme: theme,
                  icon: Icons.touch_app_outlined,
                  title: '인터랙션',
                  children: [
                    // IgnorePointer vs AbsorbPointer
                    _buildExampleItem(
                      theme: theme,
                      title: 'IgnorePointer vs AbsorbPointer',
                      child: Column(
                        spacing: 12,
                        children: [
                          // 단순 비활성화 비교
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  spacing: 6,
                                  children: [
                                    Text('IgnorePointer',
                                        style: theme.textTheme.labelMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold)),
                                    IgnorePointer(
                                      ignoring: ignorePointerEnabled,
                                      child: FilledButton(
                                        onPressed: () =>
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content:
                                                        Text('IgnorePointer: 클릭!'))),
                                        child: const Text('버튼'),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('ignoring:',
                                            style:
                                                theme.textTheme.labelSmall),
                                        Switch(
                                          value: ignorePointerEnabled,
                                          onChanged: (v) => setState(
                                              () => ignorePointerEnabled = v),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  spacing: 6,
                                  children: [
                                    Text('AbsorbPointer',
                                        style: theme.textTheme.labelMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold)),
                                    AbsorbPointer(
                                      absorbing: _absorbPointerEnabled,
                                      child: FilledButton(
                                        onPressed: () =>
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'AbsorbPointer: 클릭!'))),
                                        child: const Text('버튼'),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('absorbing:',
                                            style:
                                                theme.textTheme.labelSmall),
                                        Switch(
                                          value: _absorbPointerEnabled,
                                          onChanged: (v) => setState(
                                              () =>
                                                  _absorbPointerEnabled = v),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          // Stack 차이 비교
                          Text(
                            'Stack에서 핵심 차이 — 빨간 영역 탭',
                            style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  spacing: 4,
                                  children: [
                                    SizedBox(
                                      height: 72,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Positioned.fill(
                                            child: ElevatedButton(
                                              onPressed: () =>
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              '하단 버튼 클릭 O'))),
                                              child: const Text('하단'),
                                            ),
                                          ),
                                          IgnorePointer(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                              color: Colors.red
                                                  .withValues(alpha: 0.75),
                                              child: const Text('상단\n(투명)',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text('이벤트 → 하단 전달 O',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                                color: Colors.green[700])),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  spacing: 4,
                                  children: [
                                    SizedBox(
                                      height: 72,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Positioned.fill(
                                            child: ElevatedButton(
                                              onPressed: () =>
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              '하단 버튼 클릭 O (AbsorbPointer 꺼짐)'))),
                                              child: const Text('하단'),
                                            ),
                                          ),
                                          AbsorbPointer(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                              color: Colors.red
                                                  .withValues(alpha: 0.75),
                                              child: const Text('상단\n(흡수)',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text('이벤트 → 하단 차단 X',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                                color: theme
                                                    .colorScheme.error)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '단순 버튼 비활성화 → 둘 다 OK\n'
                              'Stack 하단도 클릭 필요 → IgnorePointer\n'
                              'Stack 하단까지 막아야 → AbsorbPointer',
                              style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Clipboard
                    _buildExampleItem(
                      theme: theme,
                      title: 'Clipboard',
                      child: Column(
                        spacing: 10,
                        children: [
                          Row(
                            spacing: 8,
                            children: [
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed: () async {
                                    await Clipboard.setData(
                                        const ClipboardData(
                                            text: 'Flutter Clipboard 예제'));
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('복사 완료!'),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor:
                                            theme.colorScheme.primary,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.copy, size: 16),
                                  label: const Text('setData'),
                                ),
                              ),
                              Expanded(
                                child: FilledButton.tonal(
                                  onPressed: () async {
                                    final data = await Clipboard.getData(
                                        Clipboard.kTextPlain);
                                    setState(() {
                                      _clipboardRead =
                                          data?.text ?? '(비어있음)';
                                    });
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.paste, size: 16),
                                      SizedBox(width: 6),
                                      Text('getData'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_clipboardRead.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.assignment,
                                      size: 14,
                                      color: theme.colorScheme.primary),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      '읽기: $_clipboardRead',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          // SelectableText
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: theme.colorScheme.outline
                                      .withValues(alpha: 0.3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 4,
                              children: [
                                Text('SelectableText — 길게 눌러 선택 복사',
                                    style: theme.textTheme.labelSmall
                                        ?.copyWith(
                                            color: theme
                                                .colorScheme.onSurfaceVariant)),
                                SelectableText(
                                  'Long press → 드래그 선택 → 복사 가능한 텍스트입니다.',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '⚠ getData → null 체크 필수 (data?.text)\n'
                            '⚠ 복사 후 반드시 SnackBar 등 피드백 제공',
                            style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // GestureDetector HitTestBehavior
                    _buildExampleItem(
                      theme: theme,
                      title: 'GestureDetector HitTestBehavior',
                      child: Column(
                        spacing: 12,
                        children: [
                          Text(
                            '두 박스 사이 빈 공간 탭 — 어떤 behavior가 감지할까?',
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant),
                          ),
                          Row(
                            children: [
                              _buildHitBehaviorDemo(
                                theme: theme,
                                label: 'deferToChild\n(기본)',
                                behavior: HitTestBehavior.deferToChild,
                                note: '빈 공간 → 미감지',
                                noteColor: theme.colorScheme.error,
                                onHit: () => setState(() =>
                                    _hitBehaviorLog = 'deferToChild 탭됨'),
                              ),
                              _buildHitBehaviorDemo(
                                theme: theme,
                                label: 'opaque',
                                behavior: HitTestBehavior.opaque,
                                note: '전체 감지\n(뒤 차단)',
                                noteColor: Colors.green[700]!,
                                onHit: () => setState(
                                    () => _hitBehaviorLog = 'opaque 탭됨'),
                              ),
                              _buildHitBehaviorDemo(
                                theme: theme,
                                label: 'translucent',
                                behavior: HitTestBehavior.translucent,
                                note: '전체 감지\n(뒤 전달)',
                                noteColor: Colors.green[700]!,
                                onHit: () => setState(() =>
                                    _hitBehaviorLog = 'translucent 탭됨'),
                              ),
                            ],
                          ),
                          if (_hitBehaviorLog.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(_hitBehaviorLog,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold)),
                            ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'deferToChild: 자식 영역만 (기본값)\n'
                              'opaque: 전체 수신, 뒤 차단\n'
                              'translucent: 전체 수신, 뒤에도 전달\n'
                              '빈 공간 탭 → Container(color: transparent)로 해결도 가능',
                              style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 기타 위젯
                _buildSection(
                  theme: theme,
                  icon: Icons.extension_outlined,
                  title: '기타 위젯',
                  children: [
                    _buildExampleItem(
                      theme: theme,
                      title: 'ExpansionTile',
                      child: Column(
                        spacing: 8,
                        children: [
                          // 기본: divider 제거 + shape 적용
                          Theme(
                            data: theme.copyWith(
                                dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              tilePadding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              childrenPadding:
                                  const EdgeInsets.fromLTRB(16, 0, 16, 12),
                              collapsedBackgroundColor:
                                  theme.colorScheme.surfaceContainerHighest,
                              backgroundColor: theme.colorScheme.surface,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              collapsedShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              title: const Text('기본 (shape + divider 제거)'),
                              children: const [Text('내용')],
                            ),
                          ),
                          // trailing 아이콘 제거
                          Theme(
                            data: theme.copyWith(
                                dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              trailing: const SizedBox.shrink(),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              collapsedShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              title: const Text('trailing 아이콘 제거'),
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text('내용'),
                                ),
                              ],
                            ),
                          ),
                          // 아이콘 왼쪽 배치
                          Theme(
                            data: theme.copyWith(
                                dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              controlAffinity:
                                  ListTileControlAffinity.leading,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              collapsedShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              title: const Text('아이콘 왼쪽 (leading)'),
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text('내용'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildExampleItem(
                      theme: theme,
                      title: 'Divider (구분선)',
                      child: Column(
                        spacing: 16,
                        children: [
                          Divider(thickness: 2, color: theme.colorScheme.outline),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              Container(
                                width: 2,
                                height: 60,
                                margin:
                                const EdgeInsets.symmetric(horizontal: 8),
                                color: theme.colorScheme.outline,
                              ),
                              Expanded(
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.secondaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildExampleItem(
                      theme: theme,
                      title: 'ProgressIndicator',
                      child: _buildProgressIndicator(theme),
                    ),
                    const SizedBox(height: 12),
                    _buildExampleItem(
                      theme: theme,
                      title: 'Dropdown',
                      child: _buildDropdownExample(theme),
                    ),
                    const SizedBox(height: 12),
                    _buildExampleItem(
                      theme: theme,
                      title: 'Overlay Widget',
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (appBarKey.currentContext != null) {
                                  RenderBox renderBox = appBarKey
                                      .currentContext!
                                      .findRenderObject() as RenderBox;
                                  Offset offset =
                                  renderBox.localToGlobal(Offset.zero);
                                  showOverlayWidget(offset.dy + 56);
                                }
                              },
                              icon: const Icon(Icons.layers),
                              label: const Text('상단'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => showOverlayWidget(null),
                              icon: const Icon(Icons.center_focus_strong),
                              label: const Text('중앙'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Shake Icon (AppBar용)
  Widget _buildShakeIcon() {
    return AnimatedBuilder(
      animation: shakeAnimation,
      builder: (context, child) {
        double x = 0;
        if (shakeAnimation.value != 3.0) {
          x = shakeAnimation.value - 1.5;
        }
        return Transform.translate(
          offset: Offset(x, 0),
          child: const Icon(Icons.access_alarms),
        );
      },
    );
  }

  // Progress Indicator
  Widget _buildProgressIndicator(ThemeData theme) {
    return Column(
      spacing: 16,
      children: [
        // 무한 vs 고정 진행률
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              spacing: 8,
              children: [
                const CircularProgressIndicator(),
                Text('무한 (null)', style: theme.textTheme.labelSmall),
              ],
            ),
            Column(
              spacing: 8,
              children: [
                CircularProgressIndicator(
                  value: progressController.value,
                  valueColor: colorTween,
                ),
                Text(
                  '${(progressController.value * 100).toInt()}%',
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
            Column(
              spacing: 8,
              children: [
                CircularProgressIndicator(
                  value: 0.7,
                  strokeWidth: 4,
                  backgroundColor:
                      theme.colorScheme.surfaceContainerHighest,
                ),
                Text('backgroundColor', style: theme.textTheme.labelSmall),
              ],
            ),
          ],
        ),
        // strokeWidth 비교 (Circular)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              spacing: 8,
              children: [
                const CircularProgressIndicator(value: 0.6, strokeWidth: 2),
                Text('strokeWidth: 2', style: theme.textTheme.labelSmall),
              ],
            ),
            Column(
              spacing: 8,
              children: [
                const CircularProgressIndicator(value: 0.6, strokeWidth: 6),
                Text('strokeWidth: 6', style: theme.textTheme.labelSmall),
              ],
            ),
            Column(
              spacing: 8,
              children: [
                const CircularProgressIndicator(value: 0.6, strokeWidth: 12),
                Text('strokeWidth: 12', style: theme.textTheme.labelSmall),
              ],
            ),
          ],
        ),
        // Linear: minHeight 비교 (strokeWidth 아님)
        Column(
          spacing: 8,
          children: [
            const LinearProgressIndicator(),
            Text('Linear 무한', style: theme.textTheme.labelSmall),
            LinearProgressIndicator(
              value: progressController.value,
              valueColor: colorTween,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),
            Text('고정 진행률 + backgroundColor',
                style: theme.textTheme.labelSmall),
            LinearProgressIndicator(
              value: 0.6,
              minHeight: 12,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),
            Text('minHeight: 12  ← strokeWidth 아님',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
      ],
    );
  }

  // Dropdown Example
  Widget _buildDropdownExample(ThemeData theme) {
    final dropdownList = ['테스트1', '테스트2', '테스트3', '테스트4', '테스트5'];
    final dropdownFormList = ['테스트항목1', '테스트항목2', '테스트항목3', '테스트항목4'];
    const overlayOptions = ['옵션 1', '옵션 2', '옵션 3', '옵션 4'];

    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 방법 1 (권장): InputDecorator + DropdownButtonHideUnderline ──
        Text('방법 1 (권장): InputDecorator',
            style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant)),
        InputDecorator(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            isDense: true,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: dropdownValue,
              isExpanded: true,
              isDense: true,
              items: dropdownList
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
              onChanged: (v) => setState(() => dropdownValue = v!),
            ),
          ),
        ),

        // ── 방법 2: Container + BoxDecoration ──
        Text('방법 2: Container 래핑',
            style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: dropdownValue,
            isExpanded: true,
            underline: const SizedBox(),
            items: dropdownList
                .map((value) => DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
            onChanged: (value) => setState(() => dropdownValue = value!),
          ),
        ),

        // ── DropdownButtonFormField ──
        Text('DropdownButtonFormField',
            style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant)),
        DropdownButtonFormField<String>(
          initialValue: dropdownFormValue,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: dropdownFormList
              .map((item) =>
                  DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: (value) => setState(() => dropdownFormValue = value!),
        ),

        // ── OverlayEntry 커스텀 Dropdown ──
        Text('OverlayEntry 커스텀 Dropdown',
            style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant)),
        CompositedTransformTarget(
          link: _dropdownLayerLink,
          child: GestureDetector(
            onTap: () => _isOverlayDropdownOpen
                ? _closeOverlayDropdown()
                : _openOverlayDropdown(context, overlayOptions, theme),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isOverlayDropdownOpen
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                  width: _isOverlayDropdownOpen ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(_overlayDropdownValue,
                        style: theme.textTheme.bodyMedium),
                  ),
                  Icon(
                    _isOverlayDropdownOpen
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '버튼 위치 고정 • LayerLink → CompositedTransformTarget/Follower\n'
            'Overlay.of(context).insert(entry) → entry.remove()',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }

  void _openOverlayDropdown(
      BuildContext context, List<String> options, ThemeData theme) {
    _dropdownOverlay = OverlayEntry(
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _closeOverlayDropdown,
          child: Stack(
            children: [
              CompositedTransformFollower(
                link: _dropdownLayerLink,
                showWhenUnlinked: false,
                offset: const Offset(0, 44),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: options
                          .map(
                            (opt) => InkWell(
                              onTap: () {
                                setState(() => _overlayDropdownValue = opt);
                                _closeOverlayDropdown();
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: opt == _overlayDropdownValue
                                      ? theme.colorScheme.primaryContainer
                                          .withValues(alpha: 0.5)
                                      : null,
                                ),
                                child: Text(opt,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: opt == _overlayDropdownValue
                                          ? theme.colorScheme.primary
                                          : null,
                                      fontWeight: opt == _overlayDropdownValue
                                          ? FontWeight.bold
                                          : null,
                                    )),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    Overlay.of(context).insert(_dropdownOverlay!);
    setState(() => _isOverlayDropdownOpen = true);
  }

  void _closeOverlayDropdown() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
    if (mounted) setState(() => _isOverlayDropdownOpen = false);
  }

  // 섹션 빌더
  Widget _buildSection({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: theme.colorScheme.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(
              height: 1,
              thickness: 1,
              color: theme.colorScheme.outline.withValues(alpha: 0.2)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  // 예제 아이템
  Widget _buildExampleItem({
    required ThemeData theme,
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildAlignBox(ThemeData theme, Alignment alignment, String label) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Align(
        alignment: alignment,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              label.replaceAll('Right', 'R').replaceAll('Left', 'L'),
              style: const TextStyle(color: Colors.white, fontSize: 8),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShapeCard(ThemeData theme, String label, ShapeBorder shape) {
    return Material(
      shape: shape,
      color: theme.colorScheme.primaryContainer,
      child: SizedBox(
        width: 80,
        height: 48,
        child: Center(
          child: Text(label, style: theme.textTheme.labelSmall),
        ),
      ),
    );
  }

  Widget _buildHitBehaviorDemo({
    required ThemeData theme,
    required String label,
    required HitTestBehavior behavior,
    required String note,
    required Color noteColor,
    required VoidCallback onHit,
  }) {
    return Expanded(
      child: Column(
        spacing: 4,
        children: [
          Text(label,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          GestureDetector(
            behavior: behavior,
            onTap: onHit,
            child: Container(
              height: 64,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 20,
                    height: 40,
                    color: theme.colorScheme.primary,
                  ),
                  Container(
                    width: 20,
                    height: 40,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
          Text(note,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: noteColor)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    progressController.dispose();
    shakeController.dispose();
    _dropdownOverlay?.remove();
    super.dispose();
  }
}