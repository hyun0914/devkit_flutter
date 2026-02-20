import 'package:flutter/material.dart';

import '../widget/default_scaffold.dart';

class ListWheelScrollViewScreen extends StatefulWidget {
  const ListWheelScrollViewScreen({super.key});

  @override
  State<ListWheelScrollViewScreen> createState() => _ListWheelScrollViewScreenState();
}

class _ListWheelScrollViewScreenState
    extends State<ListWheelScrollViewScreen> {
  bool _useMagnifier = false;
  double _magnification = 1.2;
  double _diameterRatio = 2.0;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('ListWheelScrollView'),
      ),
      body: Column(
        children: [
          // 설명 영역
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  '3D 회전 휠 스크롤',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '아래로 스크롤하여 회전 효과를 확인하세요',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // ListWheelScrollView
          Expanded(
            child: ListWheelScrollView(
              itemExtent: 100,
              useMagnifier: _useMagnifier,
              magnification: _magnification,
              diameterRatio: _diameterRatio,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: List.generate(
                30,
                    (index) {
                  final isSelected = index == _selectedIndex;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isSelected
                            ? [
                          theme.colorScheme.primary,
                          theme.colorScheme.primaryContainer,
                        ]
                            : [
                          theme.colorScheme.surfaceContainerHighest,
                          theme.colorScheme.surfaceContainerHighest,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withValues(alpha: 0.2),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 8,
                        children: [
                          Icon(
                            isSelected ? Icons.check_circle : Icons.circle_outlined,
                            color: isSelected
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurfaceVariant,
                            size: 32,
                          ),
                          Text(
                            '아이템 $index',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // 컨트롤 패널
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  // 선택된 아이템 표시
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '선택된 아이템: $_selectedIndex',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 확대 효과 토글
                  SwitchListTile(
                    title: const Text('확대 효과 (Magnifier)'),
                    subtitle: const Text('중앙 아이템 확대'),
                    value: _useMagnifier,
                    onChanged: (value) {
                      setState(() {
                        _useMagnifier = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),

                  // 확대 비율
                  if (_useMagnifier) ...[
                    Text(
                      '확대 비율: ${_magnification.toStringAsFixed(1)}x',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Slider(
                      value: _magnification,
                      min: 1.0,
                      max: 2.0,
                      divisions: 10,
                      label: '${_magnification.toStringAsFixed(1)}x',
                      onChanged: (value) {
                        setState(() {
                          _magnification = value;
                        });
                      },
                    ),
                  ],

                  // 휠 직경
                  Text(
                    '휠 직경 비율: ${_diameterRatio.toStringAsFixed(1)}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Slider(
                    value: _diameterRatio,
                    min: 1.0,
                    max: 5.0,
                    divisions: 40,
                    label: _diameterRatio.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() {
                        _diameterRatio = value;
                      });
                    },
                  ),

                  // 설명
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '💡 Tip',
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '• diameterRatio가 작을수록 더 둥글게\n'
                              '• magnification으로 선택된 아이템 강조\n'
                              '• iOS의 Picker와 유사한 효과',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}