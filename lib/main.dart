import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_screen.dart';

void main() async {
  // 이미지 캐시 설정
  ImageCacheSetting();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    ProviderScope(
      child: BetterFeedback(
        child: EasyLocalization(
          supportedLocales: [Locale('ko'), Locale('en')],
          path: 'assets/translations',
          fallbackLocale: Locale('ko'),
          child: DevicePreview(
            enabled: kDebugMode, // 디버그 모드에서만 활성화
            builder: (context) => const HomeScreen(),
          ),
        ),
      ),
    ),
  );
}

// 이미지 캐시 크기 설정 (200MB)
class ImageCacheSetting extends WidgetsFlutterBinding {
  @override
  ImageCache createImageCache() {
    ImageCache imageCache = super.createImageCache();
    // 200MB로 설정
    imageCache.maximumSizeBytes = 200 * 1024 * 1024;
    return imageCache;
  }
}