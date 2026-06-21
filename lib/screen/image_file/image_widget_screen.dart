import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widget/default_scaffold.dart';

class ImageWidgetScreen extends StatefulWidget {
  const ImageWidgetScreen({super.key});

  @override
  State<ImageWidgetScreen> createState() => _ImageWidgetScreenState();
}

class _ImageWidgetScreenState extends State<ImageWidgetScreen> {
  static const String _pizzaUrl =
      'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800';
  static const String _chickenUrl =
      'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=800';
  static const String _svgIconUrl =
      'https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/android.svg';
  static const String _svgLogoUrl =
      'https://raw.githubusercontent.com/dnfield/flutter_svg/7d374d7107561cbd906d7c0ca26fef02cc01e7c8/example/assets/flutter_logo.svg?sanitize=true';
  static const String _bgImageUrl =
      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800';
  static const String _brokenUrl = 'https://broken-url-example.xyz/404.jpg';

  // 1x1 투명 GIF — FadeInImage placeholder용 (transparent_image 패키지 대체)
  static final Uint8List _transparentImage = Uint8List.fromList([
    0x47, 0x49, 0x46, 0x38, 0x39, 0x61, 0x01, 0x00, 0x01, 0x00,
    0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0x21,
    0xf9, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x2c, 0x00, 0x00,
    0x00, 0x00, 0x01, 0x00, 0x01, 0x00, 0x00, 0x02, 0x01, 0x44,
    0x00, 0x3b,
  ]);

  late TransformationController _transformController;
  late Matrix4 _initialMatrix;

  @override
  void initState() {
    super.initState();
    _transformController = TransformationController();
    // initState에서 초기값 저장 → 버튼으로 원래 크기 복귀에 사용
    _initialMatrix = _transformController.value;
  }

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

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
            Text(
              '이미지 & SVG 위젯',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              'InteractiveViewer, BoxFit, SVG, FadeInImage, 배경 이미지',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),

            const SizedBox(height: 24),

            // pubspec.yaml 안내
            _buildSectionHeader(theme, 'pubspec.yaml 등록'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer
                    .withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: theme.colorScheme.tertiary.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Row(children: [
                    Icon(Icons.settings_outlined,
                        size: 18, color: theme.colorScheme.tertiary),
                    const SizedBox(width: 8),
                    Text(
                      '등록 방법',
                      style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.tertiary),
                    ),
                  ]),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'flutter:\n'
                      '  assets:\n'
                      '    - assets/images/   # 폴더 끝 / → 폴더 전체 포함\n'
                      '    - assets/icons/icon.svg\n'
                      '  fonts:\n'
                      '    - family: MyFont\n'
                      '      fonts:\n'
                      '        - asset: assets/fonts/MyFont.ttf\n'
                      '          weight: 400',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        height: 1.6,
                      ),
                    ),
                  ),
                  Text(
                    '⚠️ 들여쓰기 필수 • 수정 후 flutter pub get 실행\n'
                    '⚠️ 폰트 파일명 영문만 사용 가능',
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 이미지 타입 비교
            _buildSectionHeader(theme, '이미지 타입 비교'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2)),
              ),
              child: Column(
                spacing: 12,
                children: [
                  _buildTypeRow(
                    theme,
                    'Image.asset(path)',
                    '앱 번들에 포함된 로컬 이미지\npubspec.yaml에 assets 등록 필수',
                    Icons.folder_outlined,
                  ),
                  const Divider(height: 1),
                  _buildTypeRow(
                    theme,
                    'Image.file(file)',
                    '디바이스 파일시스템 이미지\n갤러리 선택 / 카메라 촬영 결과물에 사용',
                    Icons.photo_library_outlined,
                  ),
                  const Divider(height: 1),
                  _buildTypeRow(
                    theme,
                    'Image.memory(bytes)',
                    'Uint8List를 바로 렌더링\n서버 응답 바이트 데이터 / 디코딩 이미지에 사용',
                    Icons.memory_outlined,
                  ),
                  const Divider(height: 1),
                  _buildTypeRow(
                    theme,
                    'Image.network(url)',
                    'URL로 네트워크 이미지 로드\nloadingBuilder / errorBuilder 설정 가능',
                    Icons.cloud_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // SVG 섹션
            _buildSectionHeader(theme, '0. SVG (flutter_svg)'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  Text('네트워크 SVG',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(children: [
                        SvgPicture.network(
                          _svgIconUrl,
                          height: 80,
                          placeholderBuilder: (context) =>
                              const CircularProgressIndicator(),
                        ),
                        const SizedBox(height: 8),
                        Text('기본', style: theme.textTheme.bodySmall),
                      ]),
                      Column(children: [
                        SvgPicture.network(
                          _svgIconUrl,
                          height: 80,
                          colorFilter: const ColorFilter.mode(
                              Colors.blue, BlendMode.srcIn),
                        ),
                        const SizedBox(height: 8),
                        Text('파란색', style: theme.textTheme.bodySmall),
                      ]),
                      Column(children: [
                        SvgPicture.network(
                          _svgIconUrl,
                          height: 80,
                          colorFilter: const ColorFilter.mode(
                              Colors.red, BlendMode.srcIn),
                        ),
                        const SizedBox(height: 8),
                        Text('빨간색', style: theme.textTheme.bodySmall),
                      ]),
                    ],
                  ),
                  const Divider(),
                  Center(
                    child: Column(
                      children: [
                        SvgPicture.network(_svgLogoUrl, height: 100),
                        const SizedBox(height: 8),
                        Text(
                          'Flutter Logo (SVG)',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _buildHintCard(
              theme,
              '• SvgPicture.asset("assets/icons/icon.svg") — 로컬 SVG\n'
              '• colorFilter: ColorFilter.mode(color, BlendMode.srcIn)\n'
              '⚠️ SVG defs 태그는 최상단에 위치해야 함 (Figma export 시 확인)\n'
              '⚠️ class 방식 스타일 → 인라인 스타일로 변환 필요\n'
              '⚠️ 그라데이션 등 일부 효과 미지원',
            ),

            const SizedBox(height: 24),

            // 1. InteractiveViewer + TransformationController
            _buildSectionHeader(theme, '1. InteractiveViewer (핀치 줌/패닝)'),
            const SizedBox(height: 12),
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2)),
              ),
              // ClipRect: 확대 시 위젯 경계 밖으로 그려지는 것 방지
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: InteractiveViewer(
                  transformationController: _transformController,
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
            FilledButton.tonalIcon(
              onPressed: () =>
                  _transformController.value = _initialMatrix,
              icon: const Icon(Icons.zoom_out_map, size: 18),
              label: const Text('원래 크기 복귀'),
            ),
            const SizedBox(height: 8),
            _buildHintCard(
              theme,
              '• ClipRect로 감싸면 확대 시 위젯 경계 밖으로 그려지는 것 방지\n'
              '• TransformationController: initState에서 초기값 저장 → 버튼으로 복귀\n'
              '  onInteractionEnd: (details) => _controller.value = _initialMatrix  // 자동 복귀\n'
              '• panEnabled: false → 이동 비활성 / scaleEnabled: false → 줌 비활성',
            ),

            const SizedBox(height: 24),

            // 2. Image.network loadingBuilder + errorBuilder
            _buildSectionHeader(
                theme, '2. Image.network (loadingBuilder / errorBuilder)'),
            const SizedBox(height: 12),
            Row(
              spacing: 12,
              children: [
                Expanded(
                  child: Column(
                    spacing: 8,
                    children: [
                      Text(
                        'loadingBuilder',
                        style: theme.textTheme.labelMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        height: 140,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            _chickenUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 8,
                                  children: [
                                    CircularProgressIndicator(
                                      value: progress.expectedTotalBytes != null
                                          ? progress.cumulativeBytesLoaded /
                                              progress.expectedTotalBytes!
                                          : null,
                                    ),
                                    Text('로딩 중...',
                                        style: theme.textTheme.bodySmall),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    spacing: 8,
                    children: [
                      Text(
                        'errorBuilder',
                        style: theme.textTheme.labelMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        height: 140,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            _brokenUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 8,
                                  children: [
                                    Icon(Icons.broken_image_outlined,
                                        size: 40,
                                        color: theme.colorScheme.error),
                                    Text(
                                      '이미지 로드 실패',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                              color:
                                                  theme.colorScheme.error),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 3. FadeInImage
            _buildSectionHeader(
                theme, '3. FadeInImage (플레이스홀더 → 페이드인)'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2)),
              ),
              child: Column(
                spacing: 12,
                children: [
                  Row(
                    spacing: 12,
                    children: [
                      Expanded(
                        child: Column(
                          spacing: 8,
                          children: [
                            Text(
                              'FadeInImage',
                              style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Container(
                              height: 120,
                              decoration: BoxDecoration(
                                color: theme.colorScheme
                                    .surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: FadeInImage(
                                  // 로컬 asset 있으면: AssetImage('assets/images/placeholder.png')
                                  placeholder: MemoryImage(_transparentImage),
                                  image: NetworkImage(_pizzaUrl),
                                  fadeInDuration:
                                      const Duration(milliseconds: 800),
                                  fit: BoxFit.cover,
                                  imageErrorBuilder:
                                      (context, error, stack) =>
                                          const Icon(
                                              Icons.broken_image_outlined),
                                ),
                              ),
                            ),
                            Text(
                              '투명 GIF → 페이드인',
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color:
                                      theme.colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          spacing: 8,
                          children: [
                            Text(
                              'Image.network (비교)',
                              style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Container(
                              height: 120,
                              decoration: BoxDecoration(
                                color: theme.colorScheme
                                    .surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(_pizzaUrl,
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Text(
                              '페이드 없이 즉시 표시',
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color:
                                      theme.colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  _buildHintCard(
                    theme,
                    'FadeInImage.assetNetwork(placeholder: "assets/placeholder.png", image: url)\n'
                    'FadeInImage.memoryNetwork(placeholder: bytes, image: url)\n'
                    '• fadeInDuration: 페이드 애니메이션 시간\n'
                    '• imageErrorBuilder: 로드 실패 시 대체 위젯',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 4. 배경 이미지
            _buildSectionHeader(theme, '4. 배경 이미지 (DecorationImage)'),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(_bgImageUrl),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withValues(alpha: 0.35),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Text(
                        '배경 이미지 위에 텍스트',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: const [
                            Shadow(blurRadius: 4, color: Colors.black54),
                          ],
                        ),
                      ),
                      Text(
                        'DecorationImage + colorFilter',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _buildHintCard(
              theme,
              '방법 1 (권장): Scaffold를 Container(BoxDecoration)로 감싸기\n'
              '  → Scaffold(backgroundColor: Colors.transparent) 필수\n'
              '방법 2: Scaffold body 안에 Stack + Container(BoxDecoration) 배치\n'
              '• DecorationImage(image: NetworkImage(url)) — 네트워크 배경\n'
              '• colorFilter: BlendMode.darken → 어둡게 처리해 텍스트 가독성 확보',
            ),

            const SizedBox(height: 24),

            // 5. BoxFit 옵션
            _buildSectionHeader(theme, '5. BoxFit 옵션'),
            const SizedBox(height: 12),

            _buildBoxFitExample(
              theme: theme,
              title: 'BoxFit.fill',
              description: '지정 영역을 꽉 채움 (비율 변경됨)',
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 16),
            _buildBoxFitExample(
              theme: theme,
              title: 'BoxFit.cover',
              description: '지정 영역을 꽉 채움 (비율 유지, 잘림)',
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            _buildBoxFitExample(
              theme: theme,
              title: 'BoxFit.contain',
              description: '비율 유지하며 전체 표시 (여백 가능)',
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            _buildBoxFitExample(
              theme: theme,
              title: 'BoxFit.fitHeight',
              description: '높이에 맞게 확대/축소',
              fit: BoxFit.fitHeight,
            ),
            const SizedBox(height: 16),
            _buildBoxFitExample(
              theme: theme,
              title: 'BoxFit.fitWidth',
              description: '너비에 맞게 확대/축소',
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 16),
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
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          'BoxFit',
                          style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Text(
                          '비율',
                          style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Text(
                          '잘림',
                          style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '실무 용도',
                          style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary),
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
                      usage: '배경 이미지'),
                  const Divider(height: 16),
                  _buildComparisonRow(
                      theme: theme,
                      fit: 'cover',
                      ratio: '✅',
                      crop: '⚠️',
                      usage: '썸네일, 카드'),
                  const Divider(height: 16),
                  _buildComparisonRow(
                      theme: theme,
                      fit: 'contain',
                      ratio: '✅',
                      crop: '✅',
                      usage: '갤러리, 상세'),
                  const Divider(height: 16),
                  _buildComparisonRow(
                      theme: theme,
                      fit: 'fitHeight',
                      ratio: '✅',
                      crop: '⚠️',
                      usage: '세로 이미지'),
                  const Divider(height: 16),
                  _buildComparisonRow(
                      theme: theme,
                      fit: 'fitWidth',
                      ratio: '✅',
                      crop: '⚠️',
                      usage: '가로 이미지'),
                  const Divider(height: 16),
                  _buildComparisonRow(
                      theme: theme,
                      fit: 'none',
                      ratio: '✅',
                      crop: '✅',
                      usage: '아이콘, 로고'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 실무 팁 카드
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Row(children: [
                    Icon(Icons.info_outline,
                        color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '💡 실무 팁',
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ]),
                  _buildTipItem(theme: theme, text: 'SVG: 아이콘/로고에 사용 (확대해도 깨지지 않음, colorFilter로 색상 변경)'),
                  _buildTipItem(theme: theme, text: '썸네일/카드: BoxFit.cover 사용'),
                  _buildTipItem(theme: theme, text: '상품 상세: BoxFit.contain 사용'),
                  _buildTipItem(theme: theme, text: '확대/축소: InteractiveViewer + TransformationController (원래 크기 복귀)'),
                  _buildTipItem(theme: theme, text: '배경 이미지: DecorationImage + colorFilter 오버레이로 텍스트 가독성 확보'),
                  _buildTipItem(theme: theme, text: 'FadeInImage: 로딩 중 placeholder → 완료 후 fade 전환으로 부드러운 UX'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeRow(
      ThemeData theme, String name, String desc, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              Text(
                name,
                style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold, fontFamily: 'monospace'),
              ),
              Text(
                desc,
                style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHintCard(ThemeData theme, String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }

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
        Text(title,
            style:
                theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        Text(description,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(_chickenUrl, fit: fit, width: double.infinity),
          ),
        ),
      ],
    );
  }

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
                fontWeight: FontWeight.bold, fontFamily: 'monospace'),
          ),
        ),
        SizedBox(
          width: 40,
          child: Text(ratio,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center),
        ),
        SizedBox(
          width: 40,
          child: Text(crop,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(usage,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ),
      ],
    );
  }

  Widget _buildTipItem({required ThemeData theme, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}
