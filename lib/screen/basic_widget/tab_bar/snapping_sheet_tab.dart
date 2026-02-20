import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class SnappingSheetTab extends StatefulWidget {
  const SnappingSheetTab({super.key});

  @override
  State<SnappingSheetTab> createState() => _SnappingSheetTabState();
}

class _SnappingSheetTabState extends State<SnappingSheetTab> {
  final SnappingSheetController _snappingController =
      SnappingSheetController();
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SnappingSheet(
      controller: _snappingController,
      lockOverflowDrag: false,
      grabbingHeight: 60,
      grabbing: _buildGrabbingHeader(theme),
      onSnapCompleted: (positionData, snappingPosition) {
        setState(() {
          _isOpen = snappingPosition.grabbingContentOffset ==
              GrabbingContentOffset.bottom;
        });
        debugPrint(_isOpen ? 'Sheet 열림' : 'Sheet 닫힘');
      },
      sheetBelow: SnappingSheetContent(
        draggable: true,
        child: _buildSheetContent(theme),
      ),
      snappingPositions: [
        _closePosition,
        _halfOpenPosition,
        _openPosition,
      ],
      child: _buildMainContent(theme),
    );
  }

  // 메인 콘텐츠
  Widget _buildMainContent(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.surface,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SnappingSheet 예제',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '하단 시트를 드래그하거나 버튼으로 조작할 수 있습니다',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),

              // 컨트롤 버튼들
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: _buildControlButton(
                      theme: theme,
                      icon: Icons.close_fullscreen,
                      label: '닫기',
                      color: theme.colorScheme.error,
                      onPressed: () {
                        _snappingController.snapToPosition(_closePosition);
                      },
                    ),
                  ),
                  Expanded(
                    child: _buildControlButton(
                      theme: theme,
                      icon: Icons.horizontal_rule,
                      label: '반',
                      color: theme.colorScheme.secondary,
                      onPressed: () {
                        _snappingController
                            .snapToPosition(_halfOpenPosition);
                      },
                    ),
                  ),
                  Expanded(
                    child: _buildControlButton(
                      theme: theme,
                      icon: Icons.open_in_full,
                      label: '전체',
                      color: theme.colorScheme.primary,
                      onPressed: () {
                        _snappingController.snapToPosition(_openPosition);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 정보 카드
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
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
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '기능 설명',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    _buildInfoItem(
                      theme: theme,
                      icon: Icons.touch_app,
                      text: '드래그하여 높이 조절',
                    ),
                    _buildInfoItem(
                      theme: theme,
                      icon: Icons.swap_vert,
                      text: '3단계 스냅 포지션',
                    ),
                    _buildInfoItem(
                      theme: theme,
                      icon: Icons.animation,
                      text: '부드러운 애니메이션',
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // 상태 표시
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: _isOpen
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isOpen ? Icons.check_circle : Icons.circle_outlined,
                        size: 20,
                        color: _isOpen
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isOpen ? 'Sheet 열림' : 'Sheet 닫힘',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _isOpen
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 80), // SnappingSheet를 위한 여유 공간
            ],
          ),
        ),
      ),
    );
  }

  // 그래빙 헤더 (드래그 영역)
  Widget _buildGrabbingHeader(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          // 드래그 핸들
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          // 헤더 텍스트
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.swipe_up,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '위로 드래그하여 열기',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Sheet 콘텐츠
  Widget _buildSheetContent(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surface,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 타이틀
          Text(
            'SnappingSheet 콘텐츠',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '이 영역은 스크롤 가능합니다',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // 예제 리스트
          ...List.generate(10, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
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
                            '아이템 ${index + 1}',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'SnappingSheet 콘텐츠 예제',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 40),

          // 닫기 버튼
          FilledButton.icon(
            onPressed: () {
              _snappingController.snapToPosition(_closePosition);
            },
            icon: const Icon(Icons.close),
            label: const Text('Sheet 닫기'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  // 컨트롤 버튼
  Widget _buildControlButton({
    required ThemeData theme,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return FilledButton.tonal(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: color.withValues(alpha: 0.15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Icon(icon, size: 24, color: color),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // 정보 아이템
  Widget _buildInfoItem({
    required ThemeData theme,
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 12),
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

  // 스냅 포지션들
  static const SnappingPosition _closePosition = SnappingPosition.factor(
    positionFactor: 0.0,
    snappingCurve: Curves.easeOutCubic,
    snappingDuration: Duration(milliseconds: 400),
    grabbingContentOffset: GrabbingContentOffset.top,
  );

  static const SnappingPosition _halfOpenPosition = SnappingPosition.factor(
    positionFactor: 0.5,
    snappingCurve: Curves.easeOutCubic,
    snappingDuration: Duration(milliseconds: 400),
    grabbingContentOffset: GrabbingContentOffset.bottom,
  );

  static const SnappingPosition _openPosition = SnappingPosition.factor(
    positionFactor: 1.0,
    snappingCurve: Curves.easeOutCubic,
    snappingDuration: Duration(milliseconds: 400),
    grabbingContentOffset: GrabbingContentOffset.bottom,
  );
}
