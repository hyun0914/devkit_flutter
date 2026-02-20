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
  bool ignorePointerEnabled = false;

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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 100,
                              height: 70,
                              color: theme.colorScheme.primaryContainer,
                              child: Icon(
                                Icons.image,
                                size: 40,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          ClipOval(
                            child: Container(
                              width: 70,
                              height: 70,
                              color: theme.colorScheme.secondaryContainer,
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: theme.colorScheme.secondary,
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
                      title: 'ShaderMask (Gradient 텍스트)',
                      child: Center(
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.secondary,
                            ],
                          ).createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          ),
                          child: const Text(
                            'Gradient Text',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
                  ],
                ),

                const SizedBox(height: 24),

                // 인터랙션
                _buildSection(
                  theme: theme,
                  icon: Icons.touch_app_outlined,
                  title: '인터랙션',
                  children: [
                    _buildExampleItem(
                      theme: theme,
                      title: 'IgnorePointer',
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        spacing: 12,
                        children: [
                          Text('Ignoring: $ignorePointerEnabled'),
                          IgnorePointer(
                            ignoring: ignorePointerEnabled,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(24.0),
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('버튼 클릭됨!')),
                                );
                              },
                              child: const Text('클릭'),
                            ),
                          ),
                          FilledButton(
                            onPressed: () {
                              setState(() {
                                ignorePointerEnabled = !ignorePointerEnabled;
                              });
                            },
                            child: Text(
                              ignorePointerEnabled
                                  ? 'Set ignoring to false'
                                  : 'Set ignoring to true',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildExampleItem(
                      theme: theme,
                      title: 'AbsorbPointer',
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          SizedBox(
                            width: 100.0,
                            height: 100.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.greenAccent,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('초록 버튼 클릭!')),
                                );
                              },
                              child: const Text('뒤'),
                            ),
                          ),
                          SizedBox(
                            width: 160.0,
                            height: 30.0,
                            child: AbsorbPointer(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () {},
                                child: const Text('앞 (흡수)'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildExampleItem(
                      theme: theme,
                      title: 'Clipboard (복사)',
                      child: GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                              const ClipboardData(text: '텍스트 복사 완료!'));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('텍스트가 복사되었습니다'),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: theme.colorScheme.primary,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.copy,
                                  color: theme.colorScheme.primary),
                              const SizedBox(width: 8),
                              Text(
                                '탭하여 복사하기',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                      child: Theme(
                        data: theme.copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          initiallyExpanded: false,
                          tilePadding: const EdgeInsets.all(16),
                          childrenPadding:
                          const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          collapsedBackgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                          backgroundColor: theme.colorScheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: const Text('펼쳐서 내용 보기'),
                          children: const [
                            Text('ExpansionTile 내용이 여기에 표시됩니다.'),
                          ],
                        ),
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        spacing: 10,
        children: [
          Text(
            '${(progressController.value * 100).toInt()}%',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          CircularProgressIndicator(
            strokeWidth: 4,
            value: progressController.value,
            valueColor: colorTween,
          ),
          LinearProgressIndicator(
            value: progressController.value,
            valueColor: colorTween,
          ),
        ],
      ),
    );
  }

  // Dropdown Example
  Widget _buildDropdownExample(ThemeData theme) {
    final dropdownList = ['테스트1', '테스트2', '테스트3', '테스트4', '테스트5'];
    final dropdownFormList = ['테스트항목1', '테스트항목2', '테스트항목3', '테스트항목4'];

    return Column(
      spacing: 12,
      children: [
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
            onChanged: (value) {
              setState(() {
                dropdownValue = value!;
              });
            },
          ),
        ),
        DropdownButtonFormField<String>(
          value: dropdownFormValue,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: dropdownFormList
              .map((item) => DropdownMenuItem(
            value: item,
            child: Text(item),
          ))
              .toList(),
          onChanged: (value) {
            setState(() {
              dropdownFormValue = value!;
            });
          },
        ),
      ],
    );
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

  @override
  void dispose() {
    progressController.dispose();
    shakeController.dispose();
    super.dispose();
  }
}