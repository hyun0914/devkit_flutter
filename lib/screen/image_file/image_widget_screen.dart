import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widget/default_scaffold.dart';

class ImageWidgetScreen extends StatelessWidget {
  const ImageWidgetScreen({super.key});

  // 네트워크 이미지 URL
  static const String _pizzaUrl = 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800';
  static const String _chickenUrl = 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=800';

  // SVG URL
  static const String _svgIconUrl = 'https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/android.svg';
  static const String _svgLogoUrl = 'https://raw.githubusercontent.com/dnfield/flutter_svg/7d374d7107561cbd906d7c0ca26fef02cc01e7c8/example/assets/flutter_logo.svg?sanitize=true';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('이미지 & SVG'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              '이미지 & SVG 위젯',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'InteractiveViewer, BoxFit, SVG',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // 0. SVG 섹션
            _buildSectionHeader(theme, '0. SVG (flutter_svg)'),
            const SizedBox(height: 12),

            // SVG 네트워크 로드
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  Text(
                    '네트워크 SVG',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // 기본 SVG
                      Column(
                        children: [
                          SvgPicture.network(
                            _svgIconUrl,
                            height: 80,
                            placeholderBuilder: (context) => const CircularProgressIndicator(),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '기본',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      // 색상 변경 (파란색)
                      Column(
                        children: [
                          SvgPicture.network(
                            _svgIconUrl,
                            height: 80,
                            colorFilter: const ColorFilter.mode(
                              Colors.blue,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '파란색',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      // 색상 변경 (빨간색)
                      Column(
                        children: [
                          SvgPicture.network(
                            _svgIconUrl,
                            height: 80,
                            colorFilter: const ColorFilter.mode(
                              Colors.red,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '빨간색',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  // Flutter 로고
                  Center(
                    child: Column(
                      children: [
                        SvgPicture.network(
                          _svgLogoUrl,
                          height: 100,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Flutter Logo (SVG)',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'SVG 장점',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '• 벡터 그래픽으로 확대해도 깨지지 않음\n'
                        '• PNG/JPG보다 파일 크기 작음\n'
                        '• 코드로 색상 변경 가능 (colorFilter)\n'
                        '• 아이콘, 로고, 일러스트에 적합',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 1. InteractiveViewer
            _buildSectionHeader(theme, '1. InteractiveViewer (확대/축소)'),
            const SizedBox(height: 12),
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.network(
                    _pizzaUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.touch_app,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '핀치 줌, 드래그로 이미지 확대/축소 가능 (0.5x ~ 4.0x)',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 2. BoxFit 옵션들
            _buildSectionHeader(theme, '2. BoxFit 옵션'),
            const SizedBox(height: 12),

            // fill
            _buildBoxFitExample(
              theme: theme,
              title: 'BoxFit.fill',
              description: '지정 영역을 꽉 채움 (비율 변경됨)',
              fit: BoxFit.fill,
            ),

            const SizedBox(height: 16),

            // cover
            _buildBoxFitExample(
              theme: theme,
              title: 'BoxFit.cover',
              description: '지정 영역을 꽉 채움 (비율 유지, 잘림)',
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 16),

            // contain
            _buildBoxFitExample(
              theme: theme,
              title: 'BoxFit.contain',
              description: '비율 유지하며 전체 표시 (여백 가능)',
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 16),

            // fitHeight
            _buildBoxFitExample(
              theme: theme,
              title: 'BoxFit.fitHeight',
              description: '높이에 맞게 확대/축소',
              fit: BoxFit.fitHeight,
            ),

            const SizedBox(height: 16),

            // fitWidth
            _buildBoxFitExample(
              theme: theme,
              title: 'BoxFit.fitWidth',
              description: '너비에 맞게 확대/축소',
              fit: BoxFit.fitWidth,
            ),

            const SizedBox(height: 16),

            // none
            _buildBoxFitExample(
              theme: theme,
              title: 'BoxFit.none',
              description: '원본 크기 유지 (가운데 정렬)',
              fit: BoxFit.none,
            ),

            const SizedBox(height: 24),

            // BoxFit 비교표
            _buildSectionHeader(theme, 'BoxFit 비교표'),
            const SizedBox(height: 12),
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
                children: [
                  // 헤더 행
                  Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          'BoxFit',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Text(
                          '비율',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Text(
                          '잘림',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '실무 용도',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  _buildComparisonRow(
                    theme: theme,
                    fit: 'fill',
                    ratio: '❌',
                    crop: '❌',
                    usage: '배경 이미지',
                  ),
                  const Divider(height: 16),
                  _buildComparisonRow(
                    theme: theme,
                    fit: 'cover',
                    ratio: '✅',
                    crop: '⚠️',
                    usage: '썸네일, 카드',
                  ),
                  const Divider(height: 16),
                  _buildComparisonRow(
                    theme: theme,
                    fit: 'contain',
                    ratio: '✅',
                    crop: '✅',
                    usage: '갤러리, 상세',
                  ),
                  const Divider(height: 16),
                  _buildComparisonRow(
                    theme: theme,
                    fit: 'fitHeight',
                    ratio: '✅',
                    crop: '⚠️',
                    usage: '세로 이미지',
                  ),
                  const Divider(height: 16),
                  _buildComparisonRow(
                    theme: theme,
                    fit: 'fitWidth',
                    ratio: '✅',
                    crop: '⚠️',
                    usage: '가로 이미지',
                  ),
                  const Divider(height: 16),
                  _buildComparisonRow(
                    theme: theme,
                    fit: 'none',
                    ratio: '✅',
                    crop: '✅',
                    usage: '아이콘, 로고',
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
                        '💡 실무 팁',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  _buildTipItem(
                    theme: theme,
                    text: 'SVG: 아이콘/로고 (확대해도 깨지지 않음)',
                  ),
                  _buildTipItem(
                    theme: theme,
                    text: '썸네일/카드: BoxFit.cover 사용',
                  ),
                  _buildTipItem(
                    theme: theme,
                    text: '상품 상세: BoxFit.contain 사용',
                  ),
                  _buildTipItem(
                    theme: theme,
                    text: '확대/축소: InteractiveViewer 사용',
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

  // BoxFit 예제
  Widget _buildBoxFitExample({
    required ThemeData theme,
    required String title,
    required String description,
    required BoxFit fit,
  }) {
    return Column(
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
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              _chickenUrl,
              fit: fit,
              width: double.infinity,
            ),
          ),
        ),
      ],
    );
  }

  // 비교표 행
  Widget _buildComparisonRow({
    required ThemeData theme,
    required String fit,
    required String ratio,
    required String crop,
    required String usage,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            fit,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ),
        SizedBox(
          width: 40,
          child: Text(
            ratio,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: 40,
          child: Text(
            crop,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            usage,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  // 팁 아이템
  Widget _buildTipItem({
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