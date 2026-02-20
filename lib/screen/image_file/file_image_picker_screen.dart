import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:open_file/open_file.dart';

import '../widget/default_scaffold.dart';

const String urlImg = 'https://i.pinimg.com/736x/26/ef/03/26ef03ec8c0751b4edc938fc8f7b634e.jpg';

class FileImagePickerScreen extends StatefulWidget {
  const FileImagePickerScreen({super.key});

  @override
  State<FileImagePickerScreen> createState() => _FileImagePickerScreenState();
}

class _FileImagePickerScreenState extends State<FileImagePickerScreen> {
  // 컨트롤러
  late final MultiImagePickerController _multiImgController;
  final ImagePicker _picker = ImagePicker();

  // 상태
  XFile? _singleImage;
  List<XFile> _multiImages = [];
  File? _cacheManagerFile;
  String? _selectedFilePath;
  String? _selectedFileName;

  @override
  void initState() {
    super.initState();
    _multiImgController = MultiImagePickerController(
      maxImages: 5,
      picker: (allowMultiple) async {
        return await _pickImagesUsingImagePicker(allowMultiple);
      },
    );
  }

  @override
  void dispose() {
    _multiImgController.dispose();
    super.dispose();
  }

  Future<List<ImageFile>> _pickImagesUsingImagePicker(bool allowMultiple) async {
    final List<XFile> xFiles;
    if (allowMultiple) {
      xFiles = await _picker.pickMultiImage(maxWidth: 1080, maxHeight: 1080);
    } else {
      xFiles = [];
      final xFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 1080,
        maxWidth: 1080,
      );
      if (xFile != null) xFiles.add(xFile);
    }
    return xFiles.map<ImageFile>((e) => convertXFileToImageFile(e)).toList();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && mounted) {
      setState(() {
        _selectedFilePath = result.files.single.path;
        _selectedFileName = result.files.single.name;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('파일 선택: ${result.files.single.name}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _openSelectedFile() async {
    if (_selectedFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('먼저 파일을 선택하세요'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final result = await OpenFile.open(_selectedFilePath!);

    if (mounted) {
      String message;
      switch (result.type) {
        case ResultType.done:
          message = '파일을 열었습니다';
          break;
        case ResultType.fileNotFound:
          message = '파일을 찾을 수 없습니다';
          break;
        case ResultType.noAppToOpen:
          message = '파일을 열 수 있는 앱이 없습니다';
          break;
        case ResultType.permissionDenied:
          message = '권한이 거부되었습니다';
          break;
        case ResultType.error:
        default:
          message = '오류: ${result.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _pickSingleImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 99,
      maxWidth: 2000,
      maxHeight: 2000,
    );
    if (pickedFile != null) {
      setState(() {
        _singleImage = pickedFile;
      });
    }
  }

  Future<void> _pickMultiImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    setState(() {
      _multiImages = pickedFiles;
    });
  }

  Future<void> _loadCacheManagerImage() async {
    final file = await DefaultCacheManager().getSingleFile(urlImg);
    setState(() {
      _cacheManagerFile = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('이미지 & 캐시'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              '이미지 선택 & 캐시',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '파일 선택, 이미지 캐싱, 멀티 선택',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // 1. 파일 선택
            _buildSectionHeader(theme, '1. 파일 선택 & 열기 (FilePicker + OpenFile)'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                spacing: 12,
                children: [
                  if (_selectedFileName != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.colorScheme.outline.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.insert_drive_file,
                            color: theme.colorScheme.primary,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedFileName!,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _selectedFilePath!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontFamily: 'monospace',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _pickFile,
                          icon: const Icon(Icons.attach_file),
                          label: Text(_selectedFileName == null ? '파일 선택' : '다른 파일 선택'),
                        ),
                      ),
                      if (_selectedFileName != null)
                        Expanded(
                          child: FilledButton.tonalIcon(
                            onPressed: _openSelectedFile,
                            icon: const Icon(Icons.open_in_new),
                            label: const Text('파일 열기'),
                          ),
                        ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '파일 선택 후 기본 앱으로 열기',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 2. 단일 이미지 선택
            _buildSectionHeader(theme, '2. 단일 이미지 선택 (ImagePicker)'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                spacing: 12,
                children: [
                  if (_singleImage != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(_singleImage!.path),
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  FilledButton.tonalIcon(
                    onPressed: _pickSingleImage,
                    icon: const Icon(Icons.image),
                    label: Text(_singleImage == null ? '이미지 선택' : '다른 이미지 선택'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 3. 멀티 이미지 선택 (고정 4칸)
            _buildSectionHeader(theme, '3. 멀티 이미지 (고정 4칸)'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                spacing: 12,
                children: [
                  SizedBox(
                    height: 350,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // 카메라 버튼
                          return _buildCameraButton(theme);
                        } else if (index <= _multiImages.length) {
                          // 이미지 표시
                          return _buildImageTile(
                            File(_multiImages[index - 1].path),
                          );
                        } else if (index == 3 && _multiImages.length > 3) {
                          // +N 표시
                          return _buildMoreIndicator(
                            theme,
                            _multiImages.length - 3,
                          );
                        } else {
                          // 빈 슬롯
                          return _buildEmptySlot(theme);
                        }
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '실무 패턴: 고정 레이아웃 (프로필, 상품 이미지 등)',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 4. 멀티 이미지 선택 (스크롤)
            _buildSectionHeader(theme, '4. 멀티 이미지 (스크롤)'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.tertiary.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                spacing: 12,
                children: [
                  if (_multiImages.isNotEmpty)
                    SizedBox(
                      height: 300,
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemCount: _multiImages.length,
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.file(
                                  File(_multiImages[index].path),
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.6),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  else
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.colorScheme.outline.withValues(alpha: 0.3),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_library,
                              size: 48,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '이미지를 선택하세요',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  FilledButton.tonalIcon(
                    onPressed: _pickMultiImages,
                    icon: const Icon(Icons.photo_library),
                    label: Text(
                      _multiImages.isEmpty
                          ? '이미지 선택'
                          : '${_multiImages.length}개 선택됨',
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: theme.colorScheme.tertiary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '실무 패턴: 스크롤 레이아웃 (갤러리, 앨범 등)',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 5. MultiImagePickerView
            _buildSectionHeader(theme, '5. Multi Image Picker (최대 5개)'),
            const SizedBox(height: 12),
            Container(
              height: 280,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: MultiImagePickerView(
                controller: _multiImgController,
                padding: const EdgeInsets.all(8),
              ),
            ),

            const SizedBox(height: 24),

            // 6. CachedNetworkImage
            _buildSectionHeader(theme, '6. CachedNetworkImage'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                spacing: 12,
                children: [
                  CachedNetworkImage(
                    width: 200,
                    height: 200,
                    imageUrl:
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzI7_cvbc0a3ZzlMeePRzmvU8ePhiC6SlRhw&usqp=CAU",
                    memCacheHeight: (200 * MediaQuery.of(context).devicePixelRatio).round(),
                    memCacheWidth: (200 * MediaQuery.of(context).devicePixelRatio).round(),
                    cacheManager: CustomCacheManager.instance,
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: 100,
                      backgroundImage: imageProvider,
                    ),
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      size: 48,
                    ),
                  ),
                  Text(
                    'CustomCacheManager 사용',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 7. flutter_cache_manager
            _buildSectionHeader(theme, '7. CacheManager'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                spacing: 12,
                children: [
                  if (_cacheManagerFile != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _cacheManagerFile!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  FilledButton.tonalIcon(
                    onPressed: _loadCacheManagerImage,
                    icon: const Icon(Icons.download),
                    label: const Text('이미지 캐시 로드'),
                  ),
                  Text(
                    'DefaultCacheManager 사용',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 8. FastCachedImage
            _buildSectionHeader(theme, '8. FastCachedImage'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                spacing: 12,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: FastCachedImage(
                      url: urlImg,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    'fast_cached_network_image 사용',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 패키지 정보
            _buildSectionHeader(theme, '사용된 패키지'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
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
                        '💡 패키지 목록',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  _buildPackageItem(theme, 'file_picker', '파일 선택'),
                  _buildPackageItem(theme, 'open_file_plus', '파일 열기'),
                  _buildPackageItem(theme, 'image_picker', '갤러리/카메라 이미지'),
                  _buildPackageItem(theme, 'multi_image_picker_view', '멀티 이미지 UI'),
                  _buildPackageItem(theme, 'cached_network_image', '네트워크 이미지 캐싱'),
                  _buildPackageItem(theme, 'flutter_cache_manager', '파일 캐시 관리'),
                  _buildPackageItem(theme, 'fast_cached_network_image', '빠른 이미지 캐싱'),
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
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  // 카메라 버튼
  Widget _buildCameraButton(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: InkWell(
        onTap: _pickMultiImages,
        borderRadius: BorderRadius.circular(8),
        child: Icon(
          Icons.camera_alt,
          size: 32,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  // 이미지 타일
  Widget _buildImageTile(File file) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(
        file,
        fit: BoxFit.cover,
      ),
    );
  }

  // 더보기 표시
  Widget _buildMoreIndicator(ThemeData theme, int count) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          '+$count',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // 빈 슬롯
  Widget _buildEmptySlot(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  // 패키지 아이템
  Widget _buildPackageItem(ThemeData theme, String name, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.extension,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodySmall,
                children: [
                  TextSpan(
                    text: name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                  TextSpan(
                    text: ' - $description',
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// CustomCacheManager
class CustomCacheManager {
  static const key = 'testCacheImgKey';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 4),
      maxNrOfCacheObjects: 10,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileSystem: IOFileSystem(key),
      fileService: HttpFileService(),
    ),
  );
}