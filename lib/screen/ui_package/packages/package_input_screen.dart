import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:hold_down_button/hold_down_button.dart';
import 'package:wtf_rotary_dial/wtf_rotary_dial.dart';

import '../../widget/default_scaffold.dart';

class PackageInputScreen extends StatefulWidget {
  const PackageInputScreen({super.key});

  @override
  State<PackageInputScreen> createState() => _PackageInputScreenState();
}

class _PackageInputScreenState extends State<PackageInputScreen> {
  final GlobalKey<SignatureState> _signatureKey = GlobalKey<SignatureState>();
  double _sliderValue = 50;
  List<double> _rangeValues = [40, 60];
  double _rating = 3.0;
  String? _selectedDropdown;
  int _holdDownCount = 0;
  String _rotaryNumber = '';

  final List<String> _dropdownList = [
    '옵션 1',
    '옵션 2',
    '옵션 3',
    '옵션 4',
  ];

  void _clearSignature() {
    _signatureKey.currentState?.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('입력 위젯'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              '입력 위젯',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '다양한 사용자 입력 위젯',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // Signature
            _buildSectionHeader(theme, 'Signature'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '서명 패드',
              description: '손가락으로 그리기',
              child: Column(
                spacing: 12,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorScheme.outline,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Signature(
                        key: _signatureKey,
                        color: theme.colorScheme.primary,
                        strokeWidth: 4,
                      ),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: _clearSignature,
                    icon: const Icon(Icons.clear),
                    label: const Text('서명 지우기'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // FlutterSlider
            _buildSectionHeader(theme, 'FlutterSlider'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '단일 슬라이더',
              description: '0 ~ 100',
              child: Column(
                spacing: 12,
                children: [
                  FlutterSlider(
                    values: [_sliderValue],
                    max: 100,
                    min: 0,
                    handlerAnimation: const FlutterSliderHandlerAnimation(
                      curve: Curves.elasticOut,
                      duration: Duration(milliseconds: 500),
                    ),
                    trackBar: FlutterSliderTrackBar(
                      activeTrackBar: BoxDecoration(
                        color: theme.colorScheme.primary,
                      ),
                      inactiveTrackBar: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),
                    handler: FlutterSliderHandler(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.circle,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    onDragging: (handlerIndex, lowerValue, upperValue) {
                      setState(() {
                        _sliderValue = lowerValue;
                      });
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '값: ${_sliderValue.round()}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '범위 슬라이더',
              description: '최소/최대 값 선택',
              child: Column(
                spacing: 12,
                children: [
                  FlutterSlider(
                    values: _rangeValues,
                    rangeSlider: true,
                    max: 100,
                    min: 0,
                    trackBar: FlutterSliderTrackBar(
                      activeTrackBar: BoxDecoration(
                        color: theme.colorScheme.secondary,
                      ),
                      inactiveTrackBar: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),
                    onDragging: (handlerIndex, lowerValue, upperValue) {
                      setState(() {
                        _rangeValues = [lowerValue, upperValue];
                      });
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '범위: ${_rangeValues[0].round()} ~ ${_rangeValues[1].round()}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // RatingBar
            _buildSectionHeader(theme, 'RatingBar'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '별점 평가',
              description: '0.5 단위 평가 가능',
              child: Column(
                spacing: 16,
                children: [
                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: theme.colorScheme.primary,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$_rating / 5.0',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // DropdownButton2
            _buildSectionHeader(theme, 'DropdownButton2'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '드롭다운',
              description: '옵션 선택',
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField2<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  hint: const Text('옵션을 선택하세요'),
                  value: _selectedDropdown,
                  items: _dropdownList.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  selectedItemBuilder: (context) {
                    return _dropdownList.map((String item) {
                      return Text(
                        item,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  },
                  onChanged: (value) {
                    setState(() {
                      _selectedDropdown = value;
                    });
                  },
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // HoldDownButton
            _buildSectionHeader(theme, 'HoldDownButton'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '길게 누르기 버튼',
              description: '누르고 있으면 반복 실행',
              child: Column(
                spacing: 12,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '카운트: $_holdDownCount',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    spacing: 12,
                    children: [
                      Expanded(
                        child: HoldDownButton(
                          onHoldDown: () {
                            setState(() {
                              _holdDownCount++;
                            });
                          },
                          child: FilledButton.icon(
                            onPressed: () {
                              setState(() {
                                _holdDownCount++;
                              });
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('증가'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: HoldDownButton(
                          onHoldDown: () {
                            setState(() {
                              _holdDownCount--;
                            });
                          },
                          child: FilledButton.icon(
                            onPressed: () {
                              setState(() {
                                _holdDownCount--;
                              });
                            },
                            icon: const Icon(Icons.remove),
                            label: const Text('감소'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  FilledButton.tonal(
                    onPressed: () {
                      setState(() {
                        _holdDownCount = 0;
                      });
                    },
                    child: const Text('초기화'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // RotaryDial
            _buildSectionHeader(theme, 'RotaryDial'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '회전식 다이얼',
              description: '옛날 전화기 스타일',
              child: Column(
                spacing: 16,
                children: [
                  if (_rotaryNumber.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _rotaryNumber,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 250,
                    child: RotaryDial(
                      onDigitSelected: (int value) {
                        setState(() {
                          if (_rotaryNumber.length < 11) {
                            _rotaryNumber += value.toString();
                          }
                        });
                      },
                      rotaryDialThemeData: RotaryDialThemeData(
                        spinnerColor: Colors.white,
                        rotaryDialColor: theme.colorScheme.primary,
                        dialColor: theme.colorScheme.primaryContainer,
                        numberColor: theme.colorScheme.onPrimary,
                      ),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.decelerate,
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () {
                      setState(() {
                        _rotaryNumber = '';
                      });
                    },
                    icon: const Icon(Icons.clear),
                    label: const Text('지우기'),
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
                    text: 'Signature: 서명, 그림 그리기',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'FlutterSlider: 범위 선택 가능',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'RatingBar: 반쪽 별점 지원',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'HoldDownButton: 길게 누르기 감지',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'RotaryDial: 재미있는 UI',
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