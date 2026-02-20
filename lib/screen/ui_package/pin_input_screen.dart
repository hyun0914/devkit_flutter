import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../widget/default_scaffold.dart';

class PinInputScreen extends StatefulWidget {
  const PinInputScreen({super.key});

  @override
  State<PinInputScreen> createState() => _PinInputScreenScreenState();
}

class _PinInputScreenScreenState extends State<PinInputScreen> {
  final _pinController1 = TextEditingController();
  final _pinController2 = TextEditingController();
  final _pinController3 = TextEditingController();
  final _pinController4 = TextEditingController();

  @override
  void dispose() {
    _pinController1.dispose();
    _pinController2.dispose();
    _pinController3.dispose();
    _pinController4.dispose();
    super.dispose();
  }

  void _showResult(BuildContext context, String pin) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('입력 완료'),
        content: Text('PIN: $pin'),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('PIN 입력 (PinPut)'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              'PIN 입력 위젯',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '다양한 스타일의 PIN 입력',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // 기본 스타일
            _buildSectionHeader(theme, 'Material 3 스타일'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '기본 스타일',
              description: 'Material 3 디자인',
              child: Center(
                child: Pinput(
                  controller: _pinController1,
                  length: 4,
                  defaultPinTheme: PinTheme(
                    width: 56,
                    height: 56,
                    textStyle: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: 56,
                    height: 56,
                    textStyle: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  submittedPinTheme: PinTheme(
                    width: 56,
                    height: 56,
                    textStyle: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  onCompleted: (pin) {
                    _showResult(context, pin);
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 동그란 스타일
            _buildExampleCard(
              theme: theme,
              title: '원형 스타일',
              description: '둥근 모양의 PIN 입력',
              child: Center(
                child: Pinput(
                  controller: _pinController2,
                  length: 6,
                  defaultPinTheme: PinTheme(
                    width: 48,
                    height: 48,
                    textStyle: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.outline,
                        width: 2,
                      ),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: 48,
                    height: 48,
                    textStyle: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.secondary,
                        width: 2,
                      ),
                    ),
                  ),
                  submittedPinTheme: PinTheme(
                    width: 48,
                    height: 48,
                    textStyle: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  onCompleted: (pin) {
                    _showResult(context, pin);
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 하단 밑줄 스타일
            _buildExampleCard(
              theme: theme,
              title: '밑줄 스타일',
              description: '하단 라인만 표시',
              child: Center(
                child: Pinput(
                  controller: _pinController3,
                  length: 4,
                  defaultPinTheme: PinTheme(
                    width: 56,
                    height: 56,
                    textStyle: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: theme.colorScheme.outline,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: 56,
                    height: 56,
                    textStyle: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.tertiary,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: theme.colorScheme.tertiary,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                  submittedPinTheme: PinTheme(
                    width: 56,
                    height: 56,
                    textStyle: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.tertiary,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: theme.colorScheme.tertiary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  onCompleted: (pin) {
                    _showResult(context, pin);
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 비밀번호 스타일
            _buildExampleCard(
              theme: theme,
              title: '비밀번호 모드',
              description: '입력한 숫자 숨김 (●●●●)',
              child: Center(
                child: Pinput(
                  controller: _pinController4,
                  length: 4,
                  obscureText: true,
                  obscuringCharacter: '●',
                  defaultPinTheme: PinTheme(
                    width: 56,
                    height: 56,
                    textStyle: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: 56,
                    height: 56,
                    textStyle: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.error,
                        width: 2,
                      ),
                    ),
                  ),
                  submittedPinTheme: PinTheme(
                    width: 56,
                    height: 56,
                    textStyle: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                  onCompleted: (pin) {
                    _showResult(context, pin);
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 비교표
            _buildSectionHeader(theme, '스타일 비교'),
            const SizedBox(height: 12),
            Container(
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
                spacing: 12,
                children: [
                  _buildComparisonRow(theme, '기본', '사각형 박스', '인증번호'),
                  const Divider(height: 1),
                  _buildComparisonRow(theme, '원형', '동그란 모양', 'OTP'),
                  const Divider(height: 1),
                  _buildComparisonRow(theme, '밑줄', '하단 라인', '간단한 입력'),
                  const Divider(height: 1),
                  _buildComparisonRow(theme, '비밀번호', '숫자 숨김', '보안 PIN'),
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
                    text: 'defaultPinTheme: 기본 상태',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'focusedPinTheme: 포커스된 상태',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'submittedPinTheme: 입력 완료 상태',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'onCompleted: 입력 완료 시 호출',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'obscureText: 비밀번호 모드',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 초기화 버튼
            FilledButton.icon(
              onPressed: () {
                setState(() {
                  _pinController1.clear();
                  _pinController2.clear();
                  _pinController3.clear();
                  _pinController4.clear();
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('모두 초기화'),
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
        spacing: 12,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
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
            ],
          ),
          child,
        ],
      ),
    );
  }

  // 비교 행
  Widget _buildComparisonRow(
      ThemeData theme,
      String style,
      String shape,
      String usage,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              style,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              shape,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Text(
            usage,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
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