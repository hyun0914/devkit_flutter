import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../widget/default_scaffold.dart';
import '../widget/snack_bar_view.dart';
import '../widget/syncfusion_license_info.dart';

class DialogSheetScreen extends StatefulWidget {
  const DialogSheetScreen({super.key});

  @override
  State<DialogSheetScreen> createState() => _DialogSheetScreenState();
}

class _DialogSheetScreenState extends State<DialogSheetScreen> {
  final DateRangePickerController _dateController = DateRangePickerController();

  @override
  void initState() {
    super.initState();
    _dateController.view = DateRangePickerView.month;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('Dialog & Sheet'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              'Dialog & Sheet 예제',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '다양한 다이얼로그와 시트 스타일을 확인해보세요',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // Dialog 섹션
            _buildSectionHeader(theme, Icons.speaker_notes_outlined, 'Dialogs'),
            const SizedBox(height: 12),
            _buildExampleButton(
              theme: theme,
              title: 'AlertDialog',
              subtitle: '기본 알림 다이얼로그',
              icon: Icons.info_outline,
              color: theme.colorScheme.primary,
              onTap: () => _showAlertDialog(context),
            ),
            const SizedBox(height: 8),
            _buildExampleButton(
              theme: theme,
              title: 'showGeneralDialog',
              subtitle: '커스텀 애니메이션 다이얼로그',
              icon: Icons.animation,
              color: theme.colorScheme.secondary,
              onTap: () => _showGeneralDialog(context),
            ),

            const SizedBox(height: 24),

            // Date Picker 섹션
            _buildSectionHeader(theme, Icons.calendar_today_outlined, 'Date Pickers'),
            const SizedBox(height: 12),
            _buildExampleButton(
              theme: theme,
              title: 'Material DatePicker',
              subtitle: '기본 날짜 선택',
              icon: Icons.event,
              color: Colors.blue,
              onTap: () => _showMaterialDatePicker(context),
            ),
            const SizedBox(height: 8),
            _buildExampleButton(
              theme: theme,
              title: 'Syncfusion DatePicker',
              subtitle: '고급 달력 위젯',
              icon: Icons.date_range,
              color: Colors.purple,
              onTap: () => _showSyncfusionDatePicker(context),
            ),
            const SizedBox(height: 8),
            SyncfusionLicenseInfo(),
            const SizedBox(height: 8),
            _buildExampleButton(
              theme: theme,
              title: 'Cupertino DatePicker',
              subtitle: 'iOS 스타일 날짜 선택',
              icon: Icons.calendar_month,
              color: Colors.orange,
              onTap: () => _showCupertinoDatePicker(context),
            ),
            const SizedBox(height: 8),
            _buildExampleButton(
              theme: theme,
              title: 'Board DatePicker (날짜)',
              subtitle: '캘린더 + 피커 통합 • 날짜 선택',
              icon: Icons.calendar_view_month,
              color: Colors.teal,
              onTap: () => _showBoardDatePicker(context),
            ),
            const SizedBox(height: 8),
            _buildExampleButton(
              theme: theme,
              title: 'Board DateTimePicker (날짜+시간)',
              subtitle: '캘린더 + 피커 통합 • 날짜+시간 선택',
              icon: Icons.edit_calendar,
              color: Colors.cyan,
              onTap: () => _showBoardDateTimePicker(context),
            ),
            const SizedBox(height: 8),
            _buildExampleButton(
              theme: theme,
              title: 'Board DatePicker (기간 범위)',
              subtitle: '시작일 ~ 종료일 범위 선택',
              icon: Icons.date_range_outlined,
              color: Colors.indigo,
              onTap: () => _showBoardRangePicker(context),
            ),

            const SizedBox(height: 24),

            // Time Picker 섹션
            _buildSectionHeader(theme, Icons.access_time_outlined, 'Time Pickers'),
            const SizedBox(height: 12),
            _buildExampleButton(
              theme: theme,
              title: 'Material TimePicker',
              subtitle: '기본 시간 선택',
              icon: Icons.schedule,
              color: Colors.green,
              onTap: () => _showMaterialTimePicker(context),
            ),
            const SizedBox(height: 8),
            _buildExampleButton(
              theme: theme,
              title: 'Cupertino TimePicker',
              subtitle: 'iOS 스타일 시간 선택',
              icon: Icons.access_time,
              color: Colors.teal,
              onTap: () => _showCupertinoTimePicker(context),
            ),
            const SizedBox(height: 8),
            _buildExampleButton(
              theme: theme,
              title: 'Cupertino Timer',
              subtitle: '타이머 선택기',
              icon: Icons.timer,
              color: Colors.indigo,
              onTap: () => _showCupertinoTimer(context),
            ),
            const SizedBox(height: 8),
            _buildExampleButton(
              theme: theme,
              title: 'Board TimePicker',
              subtitle: '캘린더 + 피커 통합 • 시간 선택',
              icon: Icons.more_time,
              color: Colors.deepPurple,
              onTap: () => _showBoardTimePicker(context),
            ),

            const SizedBox(height: 24),

            // Action Sheet 섹션
            _buildSectionHeader(theme, Icons.list_alt, 'Action Sheets'),
            const SizedBox(height: 12),
            _buildExampleButton(
              theme: theme,
              title: 'Adaptive ActionSheet',
              subtitle: '플랫폼별 액션 시트',
              icon: Icons.more_vert,
              color: Colors.red,
              onTap: () => _showActionSheet(context),
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
                      Icon(Icons.info_outline, color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Text('💡 Tip', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Text(
                    '• AlertDialog: 간단한 확인/취소 다이얼로그\n'
                        '• showGeneralDialog: 커스텀 애니메이션 가능\n'
                        '• Cupertino: iOS 스타일 UI 제공\n'
                        '• Board DatePicker: 캘린더+피커 통합, 범위 선택 지원\n'
                        '• ActionSheet: 여러 옵션 선택에 적합',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.5,
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

  // ── 섹션 헤더 ──
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

  // ── 예제 버튼 ──
  Widget _buildExampleButton({
    required ThemeData theme,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      color: theme.colorScheme.surface,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                    Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: theme.colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }

  // ── AlertDialog ──
  Future<void> _showAlertDialog(BuildContext context) {
    final theme = Theme.of(context);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.info_outline, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              const Text('알림'),
            ],
          ),
          content: const Text('이것은 AlertDialog 예제입니다.\n확인 또는 취소를 선택하세요.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('확인되었습니다')));
              },
              child: const Text('확인'),
            ),
          ],
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        );
      },
    );
  }

  // ── showGeneralDialog ──
  void _showGeneralDialog(BuildContext context) {
    final theme = Theme.of(context);
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Barrier",
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
              .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              children: [
                Icon(Icons.animation, size: 64, color: theme.colorScheme.secondary),
                Text('showGeneralDialog', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                Text('위에서 아래로 슬라이드되는\n커스텀 애니메이션 다이얼로그', style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
                FilledButton(onPressed: () => Navigator.pop(context), child: const Text('닫기')),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Material DatePicker ──
  Future<void> _showMaterialDatePicker(BuildContext context) async {
    final date = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2023, 1, 1),
      lastDate: DateTime(date.year + 1, 12, 31),
    );
    if (picked != null && context.mounted) {
      final formatted = DateFormat('yyyy-MM-dd').format(picked);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('선택된 날짜: $formatted')));
    }
  }

  // ── Syncfusion DatePicker ──
  Future<void> _showSyncfusionDatePicker(BuildContext context) {
    final theme = Theme.of(context);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.all(16),
          content: SizedBox(
            width: 400,
            height: 400,
            child: SfDateRangePicker(
              controller: _dateController,
              view: DateRangePickerView.month,
              backgroundColor: theme.colorScheme.surface,
              showActionButtons: true,
              toggleDaySelection: true,
              allowViewNavigation: true,
              onSubmit: (value) {
                if (value == null) {
                  snackBarView(context: context, message: '날짜를 선택해주세요.');
                } else {
                  final formatted = DateFormat('yyyy-MM-dd').format(value as DateTime);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('선택된 날짜: $formatted')));
                }
              },
              onCancel: () => Navigator.pop(context),
            ),
          ),
        );
      },
    );
  }

  // ── Cupertino DatePicker ──
  void _showCupertinoDatePicker(BuildContext context) {
    DateTime selectedDate = DateTime.now();
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
                  Text('날짜 선택', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      final formatted = DateFormat('yyyy-MM-dd').format(selectedDate);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('선택된 날짜: $formatted')));
                    },
                    child: const Text('확인'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 250,
              child: CupertinoDatePicker(
                initialDateTime: DateTime.now(),
                minimumYear: 2023,
                maximumYear: DateTime.now().year + 1,
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime value) => selectedDate = value,
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Board DatePicker (날짜) ──
  Future<void> _showBoardDatePicker(BuildContext context) async {
    final result = await showBoardDateTimePicker(
      context: context,
      pickerType: DateTimePickerType.date,
      options: BoardDateTimeOptions(
        languages: const BoardPickerLanguages(locale: 'ko', today: '오늘', tomorrow: '내일', now: '지금'),
        boardTitle: '날짜 선택',
      ),
    );
    if (result != null && context.mounted) {
      final formatted = DateFormat('yyyy-MM-dd (E)', 'ko_KR').format(result);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('선택된 날짜: $formatted')));
    }
  }

  // ── Board DateTimePicker (날짜+시간) ──
  Future<void> _showBoardDateTimePicker(BuildContext context) async {
    final result = await showBoardDateTimePicker(
      context: context,
      pickerType: DateTimePickerType.datetime,
      options: BoardDateTimeOptions(
        languages: const BoardPickerLanguages(locale: 'ko', today: '오늘', tomorrow: '내일', now: '지금'),
        boardTitle: '날짜/시간 선택',
      ),
    );
    if (result != null && context.mounted) {
      final formatted = DateFormat('yyyy-MM-dd HH:mm').format(result);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('선택된 날짜+시간: $formatted')));
    }
  }

  // ── Board RangePicker (범위) ──
  Future<void> _showBoardRangePicker(BuildContext context) async {
    final result = await showBoardDateTimeMultiPicker(
      context: context,
      pickerType: DateTimePickerType.date,
      options: BoardDateTimeOptions(
        languages: const BoardPickerLanguages(locale: 'ko', today: '오늘', tomorrow: '내일', now: '지금'),
        boardTitle: '기간 선택',
      ),
    );
    if (result != null && context.mounted) {
      final start = DateFormat('yyyy-MM-dd').format(result.start);
      final end = DateFormat('yyyy-MM-dd').format(result.end);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('선택된 기간: $start ~ $end')));
    }
  }

  // ── Board TimePicker (시간) ──
  Future<void> _showBoardTimePicker(BuildContext context) async {
    final result = await showBoardDateTimePicker(
      context: context,
      pickerType: DateTimePickerType.time,
      options: BoardDateTimeOptions(
        languages: const BoardPickerLanguages(locale: 'ko', today: '오늘', tomorrow: '내일', now: '지금'),
        boardTitle: '시간 선택',
      ),
    );
    if (result != null && context.mounted) {
      final formatted = DateFormat('HH:mm').format(result);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('선택된 시간: $formatted')));
    }
  }

  // ── Material TimePicker ──
  Future<void> _showMaterialTimePicker(BuildContext context) async {
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('선택된 시간: ${picked.format(context)}')));
    }
  }

  // ── Cupertino TimePicker ──
  void _showCupertinoTimePicker(BuildContext context) {
    DateTime selectedTime = DateTime.now();
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
                  Text('시간 선택', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      final formatted = DateFormat('HH:mm').format(selectedTime);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('선택된 시간: $formatted')));
                    },
                    child: const Text('확인'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 250,
              child: CupertinoDatePicker(
                initialDateTime: selectedTime,
                mode: CupertinoDatePickerMode.time,
                use24hFormat: true,
                onDateTimeChanged: (DateTime value) => selectedTime = value,
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Cupertino Timer ──
  void _showCupertinoTimer(BuildContext context) {
    Duration selectedDuration = const Duration(hours: 0, minutes: 30);
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
                  Text('타이머 설정', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      final hours = selectedDuration.inHours;
                      final minutes = selectedDuration.inMinutes.remainder(60);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('선택된 시간: $hours시간 $minutes분')));
                    },
                    child: const Text('확인'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 250,
              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hm,
                initialTimerDuration: selectedDuration,
                onTimerDurationChanged: (Duration value) => selectedDuration = value,
              ),
            ),
          ],
        );
      },
    );
  }

  // ── ActionSheet ──
  void _showActionSheet(BuildContext context) {
    showAdaptiveActionSheet(
      context: context,
      title: const Text('작업 선택'),
      actions: <BottomSheetAction>[
        BottomSheetAction(
          title: Row(
            children: [
              Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              const Text('수정하기'),
            ],
          ),
          onPressed: (context) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('수정하기 선택됨')));
          },
        ),
        BottomSheetAction(
          title: Row(
            children: [
              Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
              const SizedBox(width: 12),
              const Text('삭제하기'),
            ],
          ),
          onPressed: (context) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('삭제하기 선택됨')));
          },
        ),
      ],
      cancelAction: CancelAction(title: const Text('취소')),
    );
  }
}