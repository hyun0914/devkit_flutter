import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../widget/default_scaffold.dart';

class EasyLocalizationScreen extends StatefulWidget {
  const EasyLocalizationScreen({super.key});

  @override
  State<EasyLocalizationScreen> createState() => _EasyLocalizationScreenState();
}

class _EasyLocalizationScreenState extends State<EasyLocalizationScreen> {
  int _appleCount = 0;
  int _messageCount = 0;
  bool _isMale = true;
  final String _userName = 'Flutter';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentLocale = context.locale;
    final isKorean = currentLocale.languageCode == 'ko';

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('EasyLocalization'),
        actions: [
          // 언어 전환 버튼
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: () {
                context.setLocale(
                  isKorean
                      ? const Locale('en')
                      : const Locale('ko'),
                );
              },
              icon: const Icon(Icons.language),
              label: Text(isKorean ? 'EN' : '한국어'),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 헤더
          Text(
            'EasyLocalization 예제',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'basic.description'.tr(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 16),

          // 현재 언어 표시 카드
          _buildCurrentLocaleCard(theme, currentLocale),

          const SizedBox(height: 24),

          // ── 1. 기본 번역 ──
          _buildSectionHeader(theme, 'basic.title'.tr()),
          const SizedBox(height: 12),

          _buildExampleCard(
            theme: theme,
            title: 'basic.simple'.tr(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                _buildTranslationRow(
                  theme: theme,
                  key: 'greeting',
                  value: 'greeting'.tr(),
                ),
                _buildTranslationRow(
                  theme: theme,
                  key: 'language',
                  value: 'language'.tr(),
                ),
                _buildTranslationRow(
                  theme: theme,
                  key: 'change_language',
                  value: 'change_language'.tr(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          _buildExampleCard(
            theme: theme,
            title: 'basic.with_args'.tr(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                _buildTranslationRow(
                  theme: theme,
                  key: 'welcome',
                  value: 'welcome'.tr(namedArgs: {'name': _userName}),
                ),
                _buildTranslationRow(
                  theme: theme,
                  key: 'current_language',
                  value: 'current_language'.tr(
                      namedArgs: {'lang': isKorean ? '한국어' : 'English'}),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── 2. 복수형 ──
          _buildSectionHeader(theme, 'plural.title'.tr()),
          const SizedBox(height: 12),

          _buildExampleCard(
            theme: theme,
            title: 'plural.title'.tr(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                // 사과 카운터
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'plural.apple'.plural(_appleCount,
                            namedArgs: {'count': '$_appleCount'}),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildCounter(
                      theme: theme,
                      count: _appleCount,
                      onDecrement: () =>
                          setState(() => _appleCount = (_appleCount - 1).clamp(0, 99)),
                      onIncrement: () =>
                          setState(() => _appleCount = (_appleCount + 1).clamp(0, 99)),
                    ),
                  ],
                ),
                const Divider(),
                // 메시지 카운터
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'plural.message'.plural(_messageCount),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildCounter(
                      theme: theme,
                      count: _messageCount,
                      onDecrement: () =>
                          setState(() => _messageCount = (_messageCount - 1).clamp(0, 99)),
                      onIncrement: () =>
                          setState(() => _messageCount = (_messageCount + 1).clamp(0, 99)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── 3. 성별 처리 ──
          _buildSectionHeader(theme, 'gender.title'.tr()),
          const SizedBox(height: 12),

          _buildExampleCard(
            theme: theme,
            title: 'gender.title'.tr(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Text(
                  'gender.greeting'.tr(
                      gender: _isMale ? 'male' : 'female',
                      args: [_userName]),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text(isKorean ? '남성' : 'Male'),
                      selected: _isMale,
                      onSelected: (_) => setState(() => _isMale = true),
                    ),
                    ChoiceChip(
                      label: Text(isKorean ? '여성' : 'Female'),
                      selected: !_isMale,
                      onSelected: (_) => setState(() => _isMale = false),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── 4. 패키지 정보 ──
          _buildSectionHeader(theme, 'info.title'.tr()),
          const SizedBox(height: 12),
          _buildInfoCard(theme),

          const SizedBox(height: 16),

          // ── 5. 고급 사용법 ──
          _buildAdvancedInfo(theme),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // 현재 언어 카드
  Widget _buildCurrentLocaleCard(ThemeData theme, Locale locale) {
    final isKorean = locale.languageCode == 'ko';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Text(
            isKorean ? '🇰🇷' : '🇺🇸',
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'current_language'.tr(
                      namedArgs: {'lang': isKorean ? '한국어' : 'English'}),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  'locale: ${locale.languageCode}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
          FilledButton.tonal(
            onPressed: () {
              context.setLocale(
                isKorean ? const Locale('en') : const Locale('ko'),
              );
            },
            child: Text(isKorean ? 'EN' : '한국어'),
          ),
        ],
      ),
    );
  }

  // 번역 행
  Widget _buildTranslationRow({
    required ThemeData theme,
    required String key,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            key,
            style: theme.textTheme.labelSmall?.copyWith(
              fontFamily: 'monospace',
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // 카운터 위젯
  Widget _buildCounter({
    required ThemeData theme,
    required int count,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filledTonal(
          onPressed: onDecrement,
          icon: const Icon(Icons.remove),
          iconSize: 18,
        ),
        SizedBox(
          width: 36,
          child: Text(
            '$count',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton.filledTonal(
          onPressed: onIncrement,
          icon: const Icon(Icons.add),
          iconSize: 18,
        ),
      ],
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
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          child,
        ],
      ),
    );
  }

  // 정보 카드
  Widget _buildInfoCard(ThemeData theme) {
    return Container(
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
        spacing: 10,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline,
                  color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                '💡 ${'info.title'.tr()}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          _buildInfoItem(theme, Icons.info_outline, 'info.version'.tr()),
          _buildInfoItem(theme, Icons.translate, 'info.supported'.tr()),
          _buildInfoItem(theme, Icons.save_outlined, 'info.storage'.tr()),
        ],
      ),
    );
  }

  Widget _buildInfoItem(ThemeData theme, IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.primary),
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

  // 고급 사용법 카드
  Widget _buildAdvancedInfo(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3),
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
              Icon(Icons.code, color: theme.colorScheme.tertiary, size: 20),
              const SizedBox(width: 8),
              Text(
                '🚀 고급 사용법',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          _buildCodeExample(
            theme: theme,
            title: '1. Extension 방식 (기본, 추천)',
            code: "'hello'.tr()\n'welcome'.tr(namedArgs: {'name': 'User'})",
          ),
          _buildCodeExample(
            theme: theme,
            title: '2. 함수 방식',
            code: "tr('hello')\ntr('welcome', namedArgs: {'name': 'User'})",
          ),
          _buildCodeExample(
            theme: theme,
            title: '3. 코드 생성 방식 (타입 안전)',
            code: "LocaleKeys.hello.tr()\nLocaleKeys.welcome.tr()\n\n// 사용 전 명령어 실행 필요:\nflutter pub run easy_localization:generate",
          ),
          const Divider(),
          _buildCodeExample(
            theme: theme,
            title: '번역 누락 체크 (audit)',
            code: "// Ko에 있는데 En에 없는 키 찾기\nflutter pub run easy_localization:audit",
          ),
        ],
      ),
    );
  }

  Widget _buildCodeExample({
    required ThemeData theme,
    required String title,
    required String code,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          title,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            code,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              height: 1.5,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}