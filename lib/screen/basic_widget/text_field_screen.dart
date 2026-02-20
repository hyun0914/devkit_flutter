import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import '../widget/default_scaffold.dart';
import '../widget/snack_bar_view.dart';

class TextFieldScreen extends StatefulWidget {
  const TextFieldScreen({super.key});

  @override
  State<TextFieldScreen> createState() => _TextFieldScreenState();
}

class _TextFieldScreenState extends State<TextFieldScreen> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  final FocusNode _emailFocus = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return KeyboardDismissOnTap(
      child: DefaultScaffold(
        appBar: AppBar(
          title: const Text('TextField 예제'),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              // 헤더
              Text(
                'TextField & TextFormField',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '다양한 TextField 스타일과 기능을 확인해보세요',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 24),

              // 기본 TextField
              _buildSectionHeader(theme, Icons.edit_outlined, '기본 TextField'),
              const SizedBox(height: 12),
              _buildExampleCard(
                theme: theme,
                title: '기본 TextField',
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: '검색어를 입력하세요',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: () {
                  if (_searchController.text.trim().isEmpty) {
                    snackBarView(context: context, message: '검색어를 입력해주세요');
                  } else {
                    snackBarView(context: context, message: _searchController.text);
                  }
                },
                icon: const Icon(Icons.search),
                label: const Text('검색'),
              ),

              const SizedBox(height: 24),

              // 포맷팅
              _buildSectionHeader(theme, Icons.format_shapes, '입력 포맷팅'),
              const SizedBox(height: 12),
              _buildExampleCard(
                theme: theme,
                title: '전화번호 (000 0000 0000)',
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    MaskedInputFormatter("000 0000 0000"),
                  ],
                  decoration: InputDecoration(
                    hintText: '010 1234 5678',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildExampleCard(
                theme: theme,
                title: '대문자 자동 변환',
                child: TextField(
                  inputFormatters: [UpperCaseTextFormatter()],
                  decoration: InputDecoration(
                    hintText: '소문자 입력 시 대문자로 변환',
                    prefixIcon: const Icon(Icons.text_fields),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildExampleCard(
                theme: theme,
                title: '숫자만 입력',
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: '숫자만 입력 가능',
                    prefixIcon: const Icon(Icons.pin),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildExampleCard(
                theme: theme,
                title: '한글만 입력',
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]'),
                    ),
                  ],
                  decoration: InputDecoration(
                    hintText: '한글만 입력 가능',
                    prefixIcon: const Icon(Icons.language),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildExampleCard(
                theme: theme,
                title: '통화 포맷',
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    CurrencyTextInputFormatter.currency(
                      locale: 'ko',
                      decimalDigits: 0,
                      symbol: '₩',
                    ),
                  ],
                  decoration: InputDecoration(
                    hintText: '금액 입력',
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 유효성 검사
              _buildSectionHeader(theme, Icons.verified_outlined, '유효성 검사'),
              const SizedBox(height: 12),
              _buildExampleCard(
                theme: theme,
                title: '이메일 검증',
                child: Form(
                  key: _formKey,
                  child: Column(
                    spacing: 12,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocus,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: '이메일',
                          hintText: 'example@email.com',
                          helperText: '이메일 형식으로 입력해주세요',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '이메일을 입력해주세요';
                          }
                          final pattern = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          );
                          if (!pattern.hasMatch(value)) {
                            return '올바른 이메일 형식이 아닙니다';
                          }
                          return null;
                        },
                      ),
                      FilledButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('유효한 이메일입니다')),
                            );
                          }
                        },
                        child: const Text('검증하기'),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 특수 기능
              _buildSectionHeader(theme, Icons.tune, '특수 기능'),
              const SizedBox(height: 12),
              _buildExampleCard(
                theme: theme,
                title: '멀티라인 (5줄)',
                child: TextField(
                  maxLines: 5,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: '여러 줄 입력 가능',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildExampleCard(
                theme: theme,
                title: '최대 길이 제한 (10자)',
                child: TextField(
                  maxLength: 10,
                  decoration: InputDecoration(
                    hintText: '최대 10자까지 입력',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildExampleCard(
                theme: theme,
                title: '특정 문자 금지 (@)',
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp('[@]')),
                  ],
                  decoration: InputDecoration(
                    hintText: '@ 문자는 입력할 수 없습니다',
                    helperText: '@ 기호 입력 불가',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildExampleCard(
                theme: theme,
                title: '우측 정렬',
                child: TextField(
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '금액 입력 (우측 정렬)',
                    prefixText: '₩ ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 스타일링
              _buildSectionHeader(theme, Icons.palette_outlined, '스타일링'),
              const SizedBox(height: 12),
              _buildExampleCard(
                theme: theme,
                title: '커스텀 색상',
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                    hintText: '배경색 적용',
                    prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildExampleCard(
                theme: theme,
                title: '하단 라인만',
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Underline 스타일',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildExampleCard(
                theme: theme,
                title: 'Border 없음',
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Border 제거',
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    border: InputBorder.none,
                  ),
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
                          Icons.lightbulb_outline,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '💡 Tip',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '• inputFormatters: 입력 형식 지정\n'
                      '• validator: 유효성 검사\n'
                      '• maxLength: 최대 입력 길이\n'
                      '• keyboardType: 키보드 타입 지정\n'
                      '• onChanged: 입력값 변경 감지',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 포커스 제어 버튼
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                      },
                      icon: const Icon(Icons.keyboard_hide),
                      label: const Text('포커스 해제'),
                    ),
                  ),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _emailFocus.requestFocus();
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('이메일 포커스'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 섹션 헤더
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

  // 예제 카드
  Widget _buildExampleCard({
    required ThemeData theme,
    required String title,
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
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

// 대문자 변환 Formatter
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
