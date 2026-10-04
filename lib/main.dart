import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 이미지 캐시 크기 설정 (200MB)
  PaintingBinding.instance.imageCache.maximumSizeBytes = 200 * 1024 * 1024;
  await EasyLocalization.ensureInitialized();
  // 캐시 이미지 기본 만료 기간 (7일)
  // 특정 화면만 다르게 하려면 그 화면으로 이동하기 전에 다시 호출하면 된다.
  // 예) await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 15));
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 7));

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
