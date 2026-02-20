import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import '../widget/default_scaffold.dart';

class ReadMoreScreen extends StatelessWidget {
  const ReadMoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('ReadMore'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              'ReadMore 패키지',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '긴 텍스트를 접고 펼치기',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // Line 모드 (기본)
            _buildSectionHeader(theme, 'TrimMode.Line (줄 수 제한)'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '2줄로 제한',
              child: ReadMoreText(
                '플러터(Flutter)는 구글이 개발한 오픈 소스 모바일 애플리케이션 개발 프레임워크입니다. '
                    '하나의 코드베이스로 iOS와 Android 앱을 동시에 개발할 수 있으며, '
                    'Dart 언어를 사용합니다. 위젯 기반 아키텍처로 아름다운 UI를 빠르게 구현할 수 있습니다. '
                    'Hot Reload 기능으로 개발 속도가 빠르고, Material Design과 Cupertino 스타일을 모두 지원합니다.',
                trimMode: TrimMode.Line,
                trimLines: 2,
                colorClickableText: theme.colorScheme.primary,
                trimCollapsedText: '더보기',
                trimExpandedText: '닫기',
                moreStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                style: theme.textTheme.bodyMedium,
              ),
            ),

            const SizedBox(height: 16),

            _buildExampleCard(
              theme: theme,
              title: '3줄로 제한',
              child: ReadMoreText(
                'Material 3는 구글의 최신 디자인 시스템입니다. '
                    '동적 색상(Dynamic Color)을 지원하여 시스템 테마에 자동으로 적응합니다. '
                    '개선된 접근성과 일관성 있는 컴포넌트를 제공합니다. '
                    '텍스트 스타일, 색상 시스템, 형태(Shape)가 모두 업데이트되었습니다. '
                    'Material You라는 개인화된 디자인 철학을 기반으로 합니다.',
                trimMode: TrimMode.Line,
                trimLines: 3,
                colorClickableText: theme.colorScheme.secondary,
                trimCollapsedText: '펼치기 ▼',
                trimExpandedText: '접기 ▲',
                moreStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.secondary,
                ),
                style: theme.textTheme.bodyMedium,
              ),
            ),

            const SizedBox(height: 24),

            // Length 모드
            _buildSectionHeader(theme, 'TrimMode.Length (글자 수 제한)'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '100자로 제한',
              child: ReadMoreText(
                'Dart는 구글이 개발한 프로그래밍 언어로, 플러터 앱 개발에 사용됩니다. '
                    '객체지향 언어이며 강력한 타입 시스템을 가지고 있습니다. '
                    'null safety를 지원하여 안전한 코드를 작성할 수 있습니다.',
                trimMode: TrimMode.Length,
                trimLength: 100,
                colorClickableText: theme.colorScheme.tertiary,
                trimCollapsedText: '...더보기',
                trimExpandedText: ' 줄이기',
                moreStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.tertiary,
                ),
                style: theme.textTheme.bodyMedium,
              ),
            ),

            const SizedBox(height: 24),

            // 실제 사용 예제
            _buildSectionHeader(theme, '실제 사용 예제'),
            const SizedBox(height: 12),

            // 뉴스 카드
            _buildNewsCard(
              theme: theme,
              title: '플러터 3.0 출시 소식',
              date: '2024.02.14',
              content:
              '구글이 플러터 3.0을 정식 출시했습니다. '
                  '이번 버전에서는 Material 3 지원, 향상된 성능, '
                  '그리고 새로운 렌더링 엔진이 포함되었습니다. '
                  '특히 웹 성능이 크게 개선되었으며, '
                  '데스크톱 앱 개발도 안정화되었습니다. '
                  '개발자들은 더 빠르고 효율적인 앱 개발이 가능해졌습니다.',
            ),

            const SizedBox(height: 12),

            // 리뷰 카드
            _buildReviewCard(
              theme: theme,
              userName: '김개발',
              rating: 5,
              review:
              '플러터로 앱을 개발한 지 1년이 되었습니다. '
                  '정말 훌륭한 프레임워크입니다! '
                  'Hot Reload 기능 덕분에 개발 속도가 엄청 빨라졌고, '
                  'Material Design 위젯들이 너무 아름답습니다. '
                  '처음에는 Dart 언어가 낯설었지만 금방 익숙해졌습니다. '
                  'iOS와 Android를 동시에 개발할 수 있어서 개발 비용이 절반으로 줄었습니다.',
            ),

            const SizedBox(height: 24),

            // 설정표
            _buildSectionHeader(theme, '주요 설정'),
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
                  _buildSettingRow(
                    theme: theme,
                    name: 'trimMode',
                    description: 'Line (줄 수) / Length (글자 수)',
                  ),
                  const Divider(height: 1),
                  _buildSettingRow(
                    theme: theme,
                    name: 'trimLines',
                    description: '제한할 줄 수 (Line 모드)',
                  ),
                  const Divider(height: 1),
                  _buildSettingRow(
                    theme: theme,
                    name: 'trimLength',
                    description: '제한할 글자 수 (Length 모드)',
                  ),
                  const Divider(height: 1),
                  _buildSettingRow(
                    theme: theme,
                    name: 'trimCollapsedText',
                    description: '펼치기 버튼 텍스트',
                  ),
                  const Divider(height: 1),
                  _buildSettingRow(
                    theme: theme,
                    name: 'trimExpandedText',
                    description: '접기 버튼 텍스트',
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
                    text: '뉴스, 리뷰, 설명 등에 활용',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'Line 모드: 레이아웃 일관성 유지',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'Length 모드: 정확한 글자 수 제어',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'moreStyle로 버튼 스타일 커스터마이징',
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
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          child,
        ],
      ),
    );
  }

  // 뉴스 카드
  Widget _buildNewsCard({
    required ThemeData theme,
    required String title,
    required String date,
    required String content,
  }) {
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
        spacing: 8,
        children: [
          Row(
            children: [
              Icon(
                Icons.article,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Text(
            date,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          ReadMoreText(
            content,
            trimMode: TrimMode.Line,
            trimLines: 2,
            colorClickableText: theme.colorScheme.primary,
            trimCollapsedText: '기사 더보기',
            trimExpandedText: '접기',
            moreStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  // 리뷰 카드
  Widget _buildReviewCard({
    required ThemeData theme,
    required String userName,
    required int rating,
    required String review,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.secondary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: theme.colorScheme.secondary,
                child: Text(
                  userName[0],
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                            (index) => Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          size: 14,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ReadMoreText(
            review,
            trimMode: TrimMode.Line,
            trimLines: 3,
            colorClickableText: theme.colorScheme.secondary,
            trimCollapsedText: '리뷰 전체보기',
            trimExpandedText: '접기',
            moreStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.secondary,
            ),
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  // 설정 행
  Widget _buildSettingRow({
    required ThemeData theme,
    required String name,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              name,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
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