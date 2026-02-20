import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:badges/badges.dart' as badges;
import 'package:focus_detector/focus_detector.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:gal/gal.dart';
import 'package:scroll_screenshot/scroll_screenshot.dart';

import '../../widget/default_scaffold.dart';

class PackageUtilityScreen extends StatefulWidget {
  const PackageUtilityScreen({super.key});

  @override
  State<PackageUtilityScreen> createState() => _PackageUtilityScreenState();
}

class _PackageUtilityScreenState extends State<PackageUtilityScreen> {
  int _badgeCount = 3;
  String _focusStatus = '대기 중...';
  String _visibilityStatus = '대기 중...';
  final GlobalKey _visibilityKey = GlobalKey();
  final GlobalKey _screenshotKey = GlobalKey();
  final GlobalKey _scrollScreenshotKey = GlobalKey();

  void _showToast(String message, {Color? backgroundColor}) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: backgroundColor ?? Colors.green,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
      fontSize: 16,
    );
  }

  // 화면 캡처 후 갤러리 저장
  Future<void> _takeScreenshot() async {
    // Web 체크
    if (kIsWeb) {
      _showToast('웹에서는 갤러리 저장을 지원하지 않습니다', backgroundColor: Colors.orange);
      return;
    }

    try {
      RenderRepaintBoundary boundary =
      _screenshotKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        await Gal.putImageBytes(byteData.buffer.asUint8List());
        if (mounted) {
          _showToast('갤러리에 저장되었습니다!', backgroundColor: Colors.green);
        }
      }
    } catch (e) {
      if (mounted) {
        _showToast('저장 실패 (시뮬레이터이거나 권한이 없을 수 있음)', backgroundColor: Colors.red);
      }
    }
  }

  // 스크롤 화면 캡처 후 갤러리 저장 (scroll_screenshot 패키지 사용)
  Future<void> _saveScrollScreenshot() async {
    // Web 체크
    if (kIsWeb) {
      _showToast('웹에서는 갤러리 저장을 지원하지 않습니다', backgroundColor: Colors.orange);
      return;
    }

    try {
      String? base64String = await ScrollScreenshot.captureAndSaveScreenshot(
        _scrollScreenshotKey,
      );
      if (base64String != null && mounted) {
        _showToast('스크롤 화면이 저장되었습니다!', backgroundColor: Colors.green);
      }
    } catch (e) {
      if (mounted) {
        _showToast('저장 실패 (시뮬레이터이거나 권한이 없을 수 있음)', backgroundColor: Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final priceFormat = NumberFormat('#,###');

    return FocusDetector(
      onFocusGained: () {
        setState(() {
          _focusStatus = '✅ Focus Gained';
        });
      },
      onFocusLost: () {
        setState(() {
          _focusStatus = '❌ Focus Lost';
        });
      },
      onVisibilityGained: () {
        debugPrint('Visibility Gained');
      },
      onVisibilityLost: () {
        debugPrint('Visibility Lost');
      },
      child: DefaultScaffold(
        appBar: AppBar(
          title: const Text('유틸리티'),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 헤더
              Text(
                '유틸리티',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '편리한 유틸리티 패키지',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 24),

              // NumberFormat
              _buildSectionHeader(theme, 'NumberFormat (intl)'),
              const SizedBox(height: 12),
              _buildExampleCard(
                theme: theme,
                title: '숫자 포맷팅',
                description: '천 단위 콤마',
                child: Column(
                  spacing: 12,
                  children: [
                    _buildFormatExample(
                      theme,
                      '1000',
                      priceFormat.format(1000),
                    ),
                    _buildFormatExample(
                      theme,
                      '1234567',
                      priceFormat.format(1234567),
                    ),
                    _buildFormatExample(
                      theme,
                      '999999999',
                      priceFormat.format(999999999),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildExampleCard(
                theme: theme,
                title: '통화 포맷',
                description: '원화 표시',
                child: Column(
                  spacing: 12,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.primaryContainer,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        spacing: 8,
                        children: [
                          Text(
                            '${priceFormat.format(50000)}원',
                            style: theme.textTheme.displaySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '가격',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Fluttertoast
              _buildSectionHeader(theme, 'Fluttertoast'),
              const SizedBox(height: 12),
              _buildExampleCard(
                theme: theme,
                title: '토스트 메시지',
                description: '짧은 알림 메시지',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.icon(
                      onPressed: () => _showToast('성공!', backgroundColor: Colors.green),
                      icon: const Icon(Icons.check),
                      label: const Text('성공'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () => _showToast('에러 발생!', backgroundColor: Colors.red),
                      icon: const Icon(Icons.error),
                      label: const Text('에러'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () => _showToast('경고!', backgroundColor: Colors.orange),
                      icon: const Icon(Icons.warning),
                      label: const Text('경고'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () => _showToast('정보', backgroundColor: Colors.blue),
                      icon: const Icon(Icons.info),
                      label: const Text('정보'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Badges
              _buildSectionHeader(theme, 'Badges'),
              const SizedBox(height: 12),
              _buildExampleCard(
                theme: theme,
                title: '배지',
                description: '알림 카운트 표시',
                child: Column(
                  spacing: 16,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        badges.Badge(
                          badgeContent: Text(
                            '$_badgeCount',
                            style: const TextStyle(color: Colors.white),
                          ),
                          badgeStyle: badges.BadgeStyle(
                            badgeColor: theme.colorScheme.error,
                          ),
                          child: Icon(
                            Icons.notifications,
                            size: 40,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        badges.Badge(
                          badgeContent: Text(
                            '${_badgeCount * 2}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          badgeStyle: const badges.BadgeStyle(
                            badgeColor: Colors.red,
                          ),
                          child: Icon(
                            Icons.shopping_cart,
                            size: 40,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                        badges.Badge(
                          badgeContent: Text(
                            '${_badgeCount + 5}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          badgeStyle: const badges.BadgeStyle(
                            badgeColor: Colors.green,
                          ),
                          child: Icon(
                            Icons.email,
                            size: 40,
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilledButton.icon(
                          onPressed: () {
                            setState(() {
                              _badgeCount++;
                            });
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('증가'),
                        ),
                        FilledButton.icon(
                          onPressed: () {
                            setState(() {
                              if (_badgeCount > 0) _badgeCount--;
                            });
                          },
                          icon: const Icon(Icons.remove),
                          label: const Text('감소'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // FocusDetector
              _buildSectionHeader(theme, 'FocusDetector'),
              const SizedBox(height: 12),
              _buildExampleCard(
                theme: theme,
                title: '포커스 감지',
                description: '화면 포커스 상태',
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.visibility,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _focusStatus,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // VisibilityDetector
              _buildSectionHeader(theme, 'VisibilityDetector'),
              const SizedBox(height: 12),
              _buildExampleCard(
                theme: theme,
                title: '가시성 감지',
                description: '위젯이 화면에 보이는지 감지',
                child: Column(
                  spacing: 12,
                  children: [
                    Container(
                      height: 100,
                      color: theme.colorScheme.surfaceContainerHighest,
                    ),
                    VisibilityDetector(
                      key: _visibilityKey,
                      onVisibilityChanged: (info) {
                        setState(() {
                          if (info.visibleFraction == 1.0) {
                            _visibilityStatus = '✅ 완전히 보임';
                          } else if (info.visibleFraction > 0) {
                            _visibilityStatus = '⚠️ 부분적으로 보임 (${(info.visibleFraction * 100).toStringAsFixed(0)}%)';
                          } else {
                            _visibilityStatus = '❌ 안 보임';
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.secondary,
                              theme.colorScheme.secondaryContainer,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          spacing: 8,
                          children: [
                            Icon(
                              Icons.remove_red_eye,
                              size: 40,
                              color: Colors.white,
                            ),
                            Text(
                              _visibilityStatus,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '스크롤해서 테스트',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 100,
                      color: theme.colorScheme.surfaceContainerHighest,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Screenshot
              _buildSectionHeader(theme, 'Screenshot (Gal)'),
              const SizedBox(height: 12),
              _buildExampleCard(
                theme: theme,
                title: '화면 캡처',
                description: '현재 화면 갤러리 저장',
                child: Column(
                  spacing: 12,
                  children: [
                    RepaintBoundary(
                      key: _screenshotKey,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.secondary,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          spacing: 12,
                          children: [
                            const Icon(
                              Icons.camera_alt,
                              size: 48,
                              color: Colors.white,
                            ),
                            Text(
                              '이 영역이 캡처됩니다',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              DateTime.now().toString().substring(0, 19),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: _takeScreenshot,
                      icon: const Icon(Icons.save),
                      label: const Text('갤러리에 저장'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildExampleCard(
                theme: theme,
                title: '스크롤 화면 캡처',
                description: '긴 콘텐츠도 캡처 가능 (scroll_screenshot)',
                child: Column(
                  spacing: 12,
                  children: [
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SingleChildScrollView(
                        child: RepaintBoundary(
                          key: _scrollScreenshotKey,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 800,
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 15,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.all(8),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: index.isEven
                                            ? theme.colorScheme.primaryContainer
                                            : theme.colorScheme.secondaryContainer,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.image,
                                            color: index.isEven
                                                ? theme.colorScheme.onPrimaryContainer
                                                : theme.colorScheme.onSecondaryContainer,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            'Item ${index + 1}',
                                            style: theme.textTheme.bodyLarge?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '스크롤해서 전체 내용 확인 → 버튼으로 전체 캡처',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: _saveScrollScreenshot,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('전체 스크롤 화면 저장'),
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
                      text: 'NumberFormat: 천 단위 콤마, 통화',
                    ),
                    _buildInfoItem(
                      theme: theme,
                      text: 'Fluttertoast: 간단한 알림',
                    ),
                    _buildInfoItem(
                      theme: theme,
                      text: 'Badges: 알림 개수 표시',
                    ),
                    _buildInfoItem(
                      theme: theme,
                      text: 'FocusDetector: 화면 포커스 감지',
                    ),
                    _buildInfoItem(
                      theme: theme,
                      text: 'VisibilityDetector: 위젯 가시성 감지',
                    ),
                    _buildInfoItem(
                      theme: theme,
                      text: 'Screenshot: 화면 캡처 & 갤러리 저장',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 포맷 예제
  Widget _buildFormatExample(ThemeData theme, String input, String output) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              input,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontFamily: 'monospace',
              ),
            ),
          ),
          Icon(Icons.arrow_forward, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              output,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
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