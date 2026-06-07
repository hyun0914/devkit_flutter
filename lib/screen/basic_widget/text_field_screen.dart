import 'dart:async';

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

  // 입력 트리거 비교용
  final _debounceController = TextEditingController();
  Timer? _debounceTimer;
  String _debounceResult = '';

  final _submitController = TextEditingController();
  String _submitResult = '';

  final _blurController = TextEditingController();
  final FocusNode _blurFocus = FocusNode();
  String _blurResult = '';

  @override
  void initState() {
    super.initState();
    // 포커스를 잃는 순간을 감지하려면 onEditingComplete가 아닌 FocusNode 리스너가 필요하다
    _blurFocus.addListener(() {
      if (!_blurFocus.hasFocus && _blurController.text.isNotEmpty) {
        setState(() {
          _blurResult = '포커스 해제 → "${_blurController.text}" 실행';
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _emailFocus.dispose();
    _debounceTimer?.cancel();
    _debounceController.dispose();
    _submitController.dispose();
    _blurController.dispose();
    _blurFocus.dispose();
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

              // 입력 트리거 비교
              _buildSectionHeader(theme, Icons.compare_arrows, '입력 트리거 비교'),
              const SizedBox(height: 4),
              Text(
                '같은 "검색 실행"이라도 언제 트리거하느냐에 따라 사용자 경험과 서버 부하가 달라집니다',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              _buildExampleCard(
                theme: theme,
                title: '① 디바운스 (Timer) — 타이핑이 멈추면 실행',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    TextField(
                      controller: _debounceController,
                      decoration: InputDecoration(
                        hintText: '입력 후 500ms 동안 멈추면 자동 실행',
                        prefixIcon: const Icon(Icons.timer_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        _debounceTimer?.cancel();
                        _debounceTimer = Timer(const Duration(milliseconds: 500), () {
                          setState(() {
                            _debounceResult = '500ms 대기 후 실행 → "$value"';
                          });
                        });
                      },
                    ),
                    if (_debounceResult.isNotEmpty)
                      Text(
                        _debounceResult,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildExampleCard(
                theme: theme,
                title: '② 완료 버튼 (onSubmitted) — 키보드 완료를 누르면 실행',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    TextField(
                      controller: _submitController,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: '입력 후 키보드의 완료(검색) 버튼을 눌러보세요',
                        prefixIcon: const Icon(Icons.keyboard_return),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onSubmitted: (value) {
                        setState(() {
                          _submitResult = '완료 버튼 클릭 → "$value" 실행';
                        });
                      },
                    ),
                    if (_submitResult.isNotEmpty)
                      Text(
                        _submitResult,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildExampleCard(
                theme: theme,
                title: '③ 포커스 해제 (FocusNode) — 다른 곳을 탭하면 실행',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    TextField(
                      controller: _blurController,
                      focusNode: _blurFocus,
                      decoration: InputDecoration(
                        hintText: '입력 후 다른 영역을 탭해 포커스를 해제해보세요',
                        prefixIcon: const Icon(Icons.center_focus_weak),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    if (_blurResult.isNotEmpty)
                      Text(
                        _blurResult,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
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
                          Icons.compare_arrows,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '비교',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '• 디바운스: 입력마다 호출되는 자동완성/실시간 검색에 적합 (서버 부하 ↓)\n'
                      '• onSubmitted: 사용자가 명확히 "검색" 의도를 표현했을 때만 실행하고 싶을 때\n'
                      '• FocusNode(포커스 해제): 입력을 마치고 다른 작업으로 넘어가는 시점에 저장/검증할 때\n'
                      '   ※ onEditingComplete는 키보드 완료 액션 시 호출되어 onSubmitted와 유사하며,\n'
                      '     "포커스 손실" 자체를 감지하려면 FocusNode 리스너(hasFocus)가 필요합니다',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
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
