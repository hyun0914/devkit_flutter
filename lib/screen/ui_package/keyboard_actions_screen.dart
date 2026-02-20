import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../widget/default_scaffold.dart';

class KeyboardActionsScreen extends StatefulWidget {
  const KeyboardActionsScreen({super.key});

  @override
  State<KeyboardActionsScreen> createState() => _KeyboardActionsScreenState();
}

class _KeyboardActionsScreenState extends State<KeyboardActionsScreen> {
  // FocusNode - 각 TextField마다 필요
  final FocusNode _focusName = FocusNode();
  final FocusNode _focusEmail = FocusNode();
  final FocusNode _focusPhone = FocusNode();
  final FocusNode _focusMemo = FocusNode();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();

  // KeyboardActionsConfig 설정
  KeyboardActionsConfig _buildKeyboardActionsConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS, // iOS만 적용
      keyboardBarColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      nextFocus: true, // 다음 필드로 이동 버튼
      actions: [
        KeyboardActionsItem(
          focusNode: _focusName,
          toolbarButtons: [(node) => _buildDoneButton(node)],
        ),
        KeyboardActionsItem(
          focusNode: _focusEmail,
          toolbarButtons: [(node) => _buildDoneButton(node)],
        ),
        KeyboardActionsItem(
          focusNode: _focusPhone,
          toolbarButtons: [(node) => _buildDoneButton(node)],
        ),
        KeyboardActionsItem(
          focusNode: _focusMemo,
          toolbarButtons: [(node) => _buildDoneButton(node)],
        ),
      ],
    );
  }

  // 닫기 버튼
  Widget _buildDoneButton(FocusNode node) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => node.unfocus(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          '닫기',
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusName.dispose();
    _focusEmail.dispose();
    _focusPhone.dispose();
    _focusMemo.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('KeyboardActions'),
      ),
      // KeyboardActions로 감싸기
      body: KeyboardActions(
        config: _buildKeyboardActionsConfig(context),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              'KeyboardActions 예제',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'iOS 키보드에는 닫기 버튼이 없어요\nKeyboardActions로 툴바를 추가할 수 있습니다',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // iOS vs Android 비교
            _buildInfoCard(theme),

            const SizedBox(height: 24),

            // 입력 폼
            _buildSectionHeader(theme, '기본 사용'),
            const SizedBox(height: 12),

            _buildTextField(
              theme: theme,
              label: '이름',
              hint: '이름을 입력하세요',
              icon: Icons.person_outline,
              controller: _nameController,
              focusNode: _focusName,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),

            _buildTextField(
              theme: theme,
              label: '이메일',
              hint: 'example@email.com',
              icon: Icons.email_outlined,
              controller: _emailController,
              focusNode: _focusEmail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),

            _buildTextField(
              theme: theme,
              label: '전화번호',
              hint: '010-0000-0000',
              icon: Icons.phone_outlined,
              controller: _phoneController,
              focusNode: _focusPhone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),

            _buildTextField(
              theme: theme,
              label: '메모',
              hint: '메모를 입력하세요',
              icon: Icons.notes_outlined,
              controller: _memoController,
              focusNode: _focusMemo,
              maxLines: 4,
              textInputAction: TextInputAction.done,
            ),

            const SizedBox(height: 24),

            // 사용 방법
            _buildSectionHeader(theme, '사용 방법'),
            const SizedBox(height: 12),
            _buildCodeCard(theme),

            const SizedBox(height: 24),

            // 제출 버튼
            FilledButton.icon(
              onPressed: () {
                FocusScope.of(context).unfocus();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '이름: ${_nameController.text} / '
                          '이메일: ${_emailController.text}',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.check),
              label: const Text('제출'),
            ),

            const SizedBox(height: 40),
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

  // 텍스트 필드
  Widget _buildTextField({
    required ThemeData theme,
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    required FocusNode focusNode,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor:
        theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
    );
  }

  // iOS vs Android 비교 카드
  Widget _buildInfoCard(ThemeData theme) {
    return Container(
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
              Icon(
                Icons.info_outline,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '왜 필요한가요?',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildPlatformCard(
                  theme: theme,
                  icon: Icons.phone_iphone,
                  platform: 'iOS',
                  description: '키보드 닫기 버튼 없음\n→ 툴바 추가 필요!',
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPlatformCard(
                  theme: theme,
                  icon: Icons.phone_android,
                  platform: 'Android',
                  description: '뒤로가기로\n키보드 닫기 가능',
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          Text(
            'KeyboardActionsPlatform.IOS 설정 시\niOS에서만 툴바가 표시됩니다',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  // 플랫폼 카드
  Widget _buildPlatformCard({
    required ThemeData theme,
    required IconData icon,
    required String platform,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        spacing: 8,
        children: [
          Icon(icon, color: color, size: 28),
          Text(
            platform,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // 코드 설명 카드
  Widget _buildCodeCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
        theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          _buildCodeStep(
            theme: theme,
            step: '1',
            title: 'FocusNode 생성',
            code: 'final FocusNode _focusNode = FocusNode();',
          ),
          _buildCodeStep(
            theme: theme,
            step: '2',
            title: 'KeyboardActions로 감싸기',
            code: 'KeyboardActions(\n  config: config,\n  child: ListView(...),\n)',
          ),
          _buildCodeStep(
            theme: theme,
            step: '3',
            title: 'TextField에 FocusNode 연결',
            code: 'TextField(\n  focusNode: _focusNode,\n)',
          ),
          _buildCodeStep(
            theme: theme,
            step: '4',
            title: 'Config에 FocusNode 등록',
            code: 'KeyboardActionsItem(\n  focusNode: _focusNode,\n  toolbarButtons: [...],\n)',
          ),
        ],
      ),
    );
  }

  // 코드 스텝
  Widget _buildCodeStep({
    required ThemeData theme,
    required String step,
    required String title,
    required String code,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              step,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  code,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}