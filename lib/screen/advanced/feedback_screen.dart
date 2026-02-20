import 'package:flutter/material.dart';
import 'package:feedback/feedback.dart';

import '../widget/default_scaffold.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 헤더
          Text(
            'Feedback 예제',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '화면을 직접 그리고 텍스트로 피드백을 보낼 수 있어요',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 16),

          // 소개 카드
          _buildIntroCard(theme),

          const SizedBox(height: 24),

          // ── 기본 사용 ──
          _buildSectionHeader(theme, '기본 사용'),
          const SizedBox(height: 12),

          _buildExampleCard(
            theme: theme,
            title: '피드백 열기',
            description: 'BetterFeedback.of(context).show()로 피드백 UI를 열어요.\n'
                '사용자가 화면에 직접 그림을 그리고 텍스트를 입력한 뒤 제출하면 콜백이 호출돼요.',
            child: FilledButton.icon(
              onPressed: () => _showBasicFeedback(context),
              icon: const Icon(Icons.feedback_outlined),
              label: const Text('피드백 열기'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ── 커스텀 폼 ──
          _buildSectionHeader(theme, '커스텀 폼'),
          const SizedBox(height: 12),

          _buildExampleCard(
            theme: theme,
            title: '추가 입력 필드',
            description: 'feedbackBuilder로 피드백 UI 하단에 커스텀 위젯을 추가할 수 있어요.\n'
                '이메일, 카테고리 선택 등 추가 정보를 받을 수 있어요.',
            child: FilledButton.icon(
              onPressed: () => _showCustomFeedback(context),
              icon: const Icon(Icons.edit_note),
              label: const Text('커스텀 폼 피드백 열기'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ── 활용 방법 ──
          _buildSectionHeader(theme, '활용 방법'),
          const SizedBox(height: 12),

          _buildUseCaseCard(theme),

          const SizedBox(height: 24),

          // ── 정보 카드 ──
          _buildInfoCard(theme),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // 기본 피드백
  void _showBasicFeedback(BuildContext context) {
    BetterFeedback.of(context).show((UserFeedback feedback) {
      _handleFeedback(context, feedback);
    });
  }

  // 커스텀 폼 피드백
  void _showCustomFeedback(BuildContext context) {
    BetterFeedback.of(context).show((UserFeedback feedback) {
      _handleFeedback(context, feedback);
    });
  }

  // 피드백 처리
  void _handleFeedback(BuildContext context, UserFeedback feedback) {
    final extra = feedback.extra;
    final category = extra?['category'] as String? ?? '일반';
    final email = extra?['email'] as String? ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('피드백 수신 완료'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            _buildResultRow('메시지', feedback.text),
            if (email.isNotEmpty) _buildResultRow('이메일', email),
            _buildResultRow('카테고리', category),
            _buildResultRow('스크린샷', '${feedback.screenshot.lengthInBytes ~/ 1024}KB'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  // 소개 카드
  Widget _buildIntroCard(ThemeData theme) {
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
        spacing: 10,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'feedback 패키지란?',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          _buildIntroItem(theme, Icons.draw_outlined,
              '사용자가 현재 화면에 직접 그림을 그려 문제 위치를 표시'),
          _buildIntroItem(theme, Icons.text_fields,
              '텍스트로 추가 설명 입력'),
          _buildIntroItem(theme, Icons.screenshot_outlined,
              '스크린샷 + 텍스트를 콜백으로 전달'),
          _buildIntroItem(theme, Icons.send_outlined,
              '서버 전송, 이메일, Firebase 등 다양한 방법으로 활용'),
        ],
      ),
    );
  }

  Widget _buildIntroItem(ThemeData theme, IconData icon, String text) {
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

  // 활용 방법 카드
  Widget _buildUseCaseCard(ThemeData theme) {
    final useCases = [
      ('서버 업로드', Icons.cloud_upload_outlined, 'MultipartRequest로 스크린샷 + 텍스트 전송'),
      ('이메일 전송', Icons.email_outlined, 'flutter_email_sender와 함께 사용'),
      ('Firebase', Icons.storage_outlined, 'Cloud Storage에 이미지 저장'),
      ('Sentry', Icons.bug_report_outlined, 'feedback_sentry 플러그인 사용'),
    ];

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
          for (final (title, icon, desc) in useCases)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 18, color: theme.colorScheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        desc,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                '💡 핵심 정리',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          _buildIntroItem(theme, Icons.check, 'feedback: ^3.2.0'),
          _buildIntroItem(theme, Icons.check, 'BetterFeedback로 앱 최상단 감싸기'),
          _buildIntroItem(theme, Icons.check, 'BetterFeedback.of(context).show()로 피드백 UI 열기'),
          _buildIntroItem(theme, Icons.check, 'UserFeedback.screenshot으로 스크린샷(Uint8List) 접근'),
          _buildIntroItem(theme, Icons.warning_amber_outlined,
              'Platform View (WebView, Google Maps) 스크린샷 불가'),
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
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
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
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }
}

// ── 커스텀 피드백 폼 ──
class _CustomFeedbackForm extends StatefulWidget {
  final OnSubmit onSubmit;
  final ScrollController? scrollController;

  const _CustomFeedbackForm({
    required this.onSubmit,
    this.scrollController,
  });

  @override
  State<_CustomFeedbackForm> createState() => _CustomFeedbackFormState();
}

class _CustomFeedbackFormState extends State<_CustomFeedbackForm> {
  final _feedbackController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedCategory = '버그 신고';

  final _categories = ['버그 신고', '기능 제안', '디자인 개선', '기타'];

  @override
  void dispose() {
    _feedbackController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      controller: widget.scrollController,
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          '피드백 보내기',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // 카테고리
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          decoration: InputDecoration(
            labelText: '카테고리',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            isDense: true,
          ),
          items: _categories
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
          onChanged: (val) => setState(() => _selectedCategory = val!),
        ),
        const SizedBox(height: 12),

        // 이메일
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: '이메일 (선택)',
            hintText: 'email@example.com',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            isDense: true,
          ),
        ),
        const SizedBox(height: 12),

        // 메시지
        TextField(
          controller: _feedbackController,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: '피드백 내용',
            hintText: '문제나 의견을 입력해주세요',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 제출 버튼
        FilledButton.icon(
          onPressed: () {
            widget.onSubmit(
              _feedbackController.text,
              extras: {
                'email': _emailController.text,
                'category': _selectedCategory,
              },
            );
          },
          icon: const Icon(Icons.send),
          label: const Text('피드백 제출'),
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
      ],
    );
  }
}