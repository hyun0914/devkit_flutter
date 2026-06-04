import 'package:flutter/material.dart';

// ── 기본 위젯 ──
import 'screen/basic_widget/animated_widget_screen.dart';
import 'screen/basic_widget/basic_widget_screen.dart';
import 'screen/basic_widget/button_style_screen.dart';
import 'screen/basic_widget/button_trigger_screen.dart';
import 'screen/basic_widget/dialog_sheet_screen.dart';
import 'screen/basic_widget/flexible_expanded_screen.dart';
import 'screen/basic_widget/grid_page_screen.dart';
import 'screen/basic_widget/hide_widgets_screen.dart';
import 'screen/basic_widget/list_wheel_scroll_view_screen.dart';
import 'screen/basic_widget/scaffold_screen.dart';
import 'screen/basic_widget/tab_bar_screen.dart';
import 'screen/basic_widget/table_widget_screen.dart';
import 'screen/basic_widget/text_field_screen.dart';
import 'screen/basic_widget/text_overflow_screen.dart';
import 'screen/basic_widget/text_widget_screen.dart';

// ── 데이터 처리 ──
import 'screen/data_processing/date_related_screen.dart';
import 'screen/data_processing/sqflite_screen.dart';
import 'screen/data_processing/equatable_screen.dart';
import 'screen/data_processing/list_map_related_screen.dart';
import 'screen/data_processing/number_related_screen.dart';
import 'screen/data_processing/secure_storage_screen.dart';
import 'screen/data_processing/shared_preferences_screen.dart';
import 'screen/data_processing/string_related_screen.dart';
import 'screen/data_processing/value_listenable_builder_screen.dart';

// ── UI 패키지 ──
import 'screen/ui_package/animations_screen.dart';
import 'screen/ui_package/code_view_screen.dart';
import 'screen/ui_package/complex_drag_screen.dart';
import 'screen/ui_package/dotted_border_screen.dart';
import 'screen/ui_package/drag_reorder_screen.dart';
import 'screen/ui_package/heatmap_screen.dart';
import 'screen/ui_package/keyboard_actions_screen.dart';
import 'screen/ui_package/list_scroll_compare_screen.dart';
import 'screen/ui_package/onboarding_screen.dart';
import 'screen/ui_package/page_tween_animation_screen.dart';
import 'screen/ui_package/pin_input_screen.dart';
import 'screen/ui_package/read_more_screen.dart';
import 'screen/ui_package/responsive_screen.dart';
import 'screen/ui_package/splash_screen.dart';
import 'screen/ui_package/swipe_action_screen.dart';
import 'screen/ui_package/touch_blocking_loading_screen.dart';
import 'screen/ui_package/packages/package_calendar_screen.dart';
import 'screen/ui_package/packages/package_carousel_screen.dart';
import 'screen/ui_package/packages/package_chart_screen.dart';
import 'screen/ui_package/packages/package_indicator_screen.dart';
import 'screen/ui_package/packages/package_input_screen.dart';
import 'screen/ui_package/packages/package_loading_screen.dart';
import 'screen/ui_package/packages/package_timer_screen.dart';
import 'screen/ui_package/packages/package_utility_screen.dart';

// ── 네트워크 ──
import 'screen/network/address_search_screen.dart';
import 'screen/network/connectivity_screen.dart';
import 'screen/network/go_router_screen.dart';
import 'screen/network/dio_screen.dart';
import 'screen/network/web_view_screen.dart';

// ── 이미지/파일 ──
import 'screen/image_file/camera_screen.dart';
import 'screen/image_file/file_image_picker_screen.dart';
import 'screen/image_file/image_widget_screen.dart';
import 'screen/image_file/pdf_screen.dart';

// ── 고급 기능 ──
import 'screen/advanced/app_device_info_screen.dart';
import 'screen/advanced/app_life_cycle_screen.dart';
import 'screen/advanced/dart3_screen.dart';
import 'screen/advanced/easy_localization_screen.dart';
import 'screen/advanced/feedback_screen.dart';
import 'screen/advanced/local_ai_screen.dart';
import 'screen/advanced/audio_screen.dart';
import 'screen/advanced/get_it_screen.dart';
import 'screen/advanced/isolate_screen.dart';
import 'screen/advanced/local_auth_screen.dart';
import 'screen/advanced/video_player_screen.dart';
import 'screen/advanced/logging_screen.dart';
import 'screen/advanced/mobile_scanner_screen.dart';
import 'screen/advanced/mqtt_screen.dart';
import 'screen/advanced/notifications_screen.dart';
import 'screen/advanced/sensors_screen.dart';
import 'screen/advanced/wakelock_screen.dart';

// ── 상태 관리 ──
import 'screen/stateManagement/bloc_screen.dart';
import 'screen/stateManagement/hooks_screen.dart';
import 'screen/stateManagement/provider_screen.dart';
import 'screen/stateManagement/river_pod_screen.dart';

import 'example_item.dart';

class ExampleData {
  static List<ExampleItem> get items => [
        // 기본 위젯
        ExampleItem(
          title: 'Text 위젯',
          screen: const TextWidgetScreen(),
          category: Categories.basicWidget,
          icon: Icons.text_fields,
        ),
        ExampleItem(
          title: '기본 위젯 모음',
          screen: const BasicWidgetScreen(),
          category: Categories.basicWidget,
          icon: Icons.widgets,
        ),
        ExampleItem(
          title: '탭바',
          screen: const TabBarScreen(),
          category: Categories.basicWidget,
          icon: Icons.tab,
        ),
        ExampleItem(
          title: 'Scaffold',
          screen: const ScaffoldScreen(),
          category: Categories.basicWidget,
          icon: Icons.space_dashboard,
        ),
        ExampleItem(
          title: 'Dialog, Sheet',
          screen: const DialogSheetScreen(),
          category: Categories.basicWidget,
          icon: Icons.dashboard_customize,
        ),
        ExampleItem(
          title: '텍스트 필드',
          screen: const TextFieldScreen(),
          category: Categories.basicWidget,
          icon: Icons.input,
        ),
        ExampleItem(
          title: '테이블 위젯',
          screen: const TableWidgetScreen(),
          category: Categories.basicWidget,
          icon: Icons.table_chart,
        ),
        ExampleItem(
          title: '버튼 트리거',
          screen: const ButtonTriggerScreen(),
          category: Categories.basicWidget,
          icon: Icons.touch_app,
        ),
        ExampleItem(
          title: '위젯 숨기기',
          screen: const HideWidgetsScreen(),
          category: Categories.basicWidget,
          icon: Icons.visibility_off,
        ),
        ExampleItem(
          title: 'Flexible & Expanded',
          screen: const FlexibleExpandedScreen(),
          category: Categories.basicWidget,
          icon: Icons.view_column,
        ),
        ExampleItem(
          title: 'Animated 위젯',
          screen: const AnimatedWidgetScreen(),
          category: Categories.basicWidget,
          icon: Icons.animation,
        ),
        ExampleItem(
          title: '버튼 스타일',
          screen: const ButtonStyleScreen(),
          category: Categories.basicWidget,
          icon: Icons.smart_button,
        ),
        ExampleItem(
          title: 'ListWheelScrollView',
          screen: const ListWheelScrollViewScreen(),
          category: Categories.basicWidget,
          icon: Icons.view_carousel,
        ),
        ExampleItem(
          title: '텍스트 Overflow',
          screen: const TextOverflowScreen(),
          category: Categories.basicWidget,
          icon: Icons.text_format,
        ),
        ExampleItem(
          title: 'GridView + PageView',
          screen: const GridPageScreen(),
          category: Categories.basicWidget,
          icon: Icons.grid_view,
        ),

        // 데이터 처리
        ExampleItem(
          title: 'String 관련',
          screen: const StringRelatedScreen(),
          category: Categories.dataProcessing,
          icon: Icons.abc,
        ),
        ExampleItem(
          title: '숫자 관련',
          screen: const NumberRelatedScreen(),
          category: Categories.dataProcessing,
          icon: Icons.numbers,
        ),
        ExampleItem(
          title: '날짜 관련',
          screen: const DateRelatedScreen(),
          category: Categories.dataProcessing,
          icon: Icons.calendar_today,
        ),
        ExampleItem(
          title: 'List, Map 관련',
          screen: const ListMapRelatedScreen(),
          category: Categories.dataProcessing,
          icon: Icons.list,
        ),
        ExampleItem(
          title: 'Equatable (객체 비교)',
          screen: const EquatableScreen(),
          category: Categories.dataProcessing,
          icon: Icons.compare_arrows,
        ),
        ExampleItem(
          title: 'ValueListenableBuilder',
          screen: const ValueListenableBuilderScreen(),
          category: Categories.dataProcessing,
          icon: Icons.build,
        ),
        ExampleItem(
          title: 'SharedPreferences',
          screen: const SharedPreferencesScreen(),
          category: Categories.dataProcessing,
          icon: Icons.storage,
        ),
        ExampleItem(
          title: '보안 저장소',
          screen: const SecureStorageScreen(),
          category: Categories.dataProcessing,
          icon: Icons.security,
        ),
        ExampleItem(
          title: 'sqflite (로컬 DB)',
          screen: const SqfliteScreen(),
          category: Categories.dataProcessing,
          icon: Icons.table_rows_rounded,
        ),

        // UI 패키지
        ExampleItem(
          title: '로딩 & 스켈레톤',
          screen: const PackageLoadingScreen(),
          category: Categories.uiPackage,
          icon: Icons.hourglass_bottom,
        ),
        ExampleItem(
          title: '타이머 & 카운트다운',
          screen: const PackageTimerScreen(),
          category: Categories.uiPackage,
          icon: Icons.timer,
        ),
        ExampleItem(
          title: '인디케이터 & 페이지네이션',
          screen: const PackageIndicatorScreen(),
          category: Categories.uiPackage,
          icon: Icons.fiber_manual_record,
        ),
        ExampleItem(
          title: '차트 & 게이지',
          screen: const PackageChartScreen(),
          category: Categories.uiPackage,
          icon: Icons.bar_chart,
        ),
        ExampleItem(
          title: '캘린더 & 시간',
          screen: const PackageCalendarScreen(),
          category: Categories.uiPackage,
          icon: Icons.event,
        ),
        ExampleItem(
          title: '입력 위젯',
          screen: const PackageInputScreen(),
          category: Categories.uiPackage,
          icon: Icons.input,
        ),
        ExampleItem(
          title: '캐러셀 & 탭',
          screen: const PackageCarouselScreen(),
          category: Categories.uiPackage,
          icon: Icons.view_carousel,
        ),
        ExampleItem(
          title: '유틸리티',
          screen: const PackageUtilityScreen(),
          category: Categories.uiPackage,
          icon: Icons.build_circle,
        ),
        ExampleItem(
          title: 'Onboarding (앱 소개)',
          screen: const OnboardingScreen(),
          category: Categories.uiPackage,
          icon: Icons.slideshow,
        ),
        ExampleItem(
          title: 'Splash Screen',
          screen: const SplashScreen(),
          category: Categories.uiPackage,
          icon: Icons.rocket_launch,
        ),
        ExampleItem(
          title: 'PIN 입력 (PinPut)',
          screen: const PinInputScreen(),
          category: Categories.uiPackage,
          icon: Icons.pin,
        ),
        ExampleItem(
          title: 'Swipe Action',
          screen: const SwipeActionScreen(),
          category: Categories.uiPackage,
          icon: Icons.touch_app,
        ),
        ExampleItem(
          title: 'PageView + TweenAnimation',
          screen: const PageTweenAnimationScreen(),
          category: Categories.uiPackage,
          icon: Icons.pages,
        ),
        ExampleItem(
          title: '터치 차단 로딩',
          screen: const TouchBlockingLoadingScreen(),
          category: Categories.uiPackage,
          icon: Icons.hourglass_empty,
        ),
        ExampleItem(
          title: 'ReadMore',
          screen: const ReadMoreScreen(),
          category: Categories.uiPackage,
          icon: Icons.read_more,
        ),
        ExampleItem(
          title: '리스트 스크롤 비교',
          screen: const ListScrollCompareScreen(),
          category: Categories.uiPackage,
          icon: Icons.compare_arrows,
        ),
        ExampleItem(
          title: 'KeyboardActions',
          screen: const KeyboardActionsScreen(),
          category: Categories.uiPackage,
          icon: Icons.keyboard,
        ),
        ExampleItem(
          title: 'Dotted Border & Line',
          screen: const DottedBorderScreen(),
          category: Categories.uiPackage,
          icon: Icons.border_style,
        ),
        ExampleItem(
          title: '반응형 레이아웃',
          screen: const ResponsiveScreen(),
          category: Categories.uiPackage,
          icon: Icons.devices,
        ),
        ExampleItem(
          title: 'Drag & Reorder',
          screen: const DragReorderScreen(),
          category: Categories.uiPackage,
          icon: Icons.drag_indicator,
        ),
        ExampleItem(
          title: '복잡한 드래그 & 드롭',
          screen: const ComplexDragScreen(),
          category: Categories.uiPackage,
          icon: Icons.view_column,
        ),
        ExampleItem(
          title: '히트맵 시각화',
          screen: const HeatmapScreen(),
          category: Categories.uiPackage,
          icon: Icons.grid_on,
          isPractical: false,
        ),
        ExampleItem(
          title: '애니메이션',
          screen: const AnimationsScreen(),
          category: Categories.uiPackage,
          icon: Icons.animation,
        ),
        ExampleItem(
          title: 'Code View',
          screen: const CodeViewScreen(),
          category: Categories.uiPackage,
          icon: Icons.code,
          isPractical: false,
        ),

        // 네트워크
        ExampleItem(
          title: '네트워크 연결 상태',
          screen: const ConnectivityScreen(),
          category: Categories.network,
          icon: Icons.wifi_tethering_rounded,
        ),
        ExampleItem(
          title: 'go_router (라우팅)',
          screen: const GoRouterScreen(),
          category: Categories.network,
          icon: Icons.route_rounded,
        ),
        ExampleItem(
          title: 'Dio (HTTP 통신)',
          screen: const DioScreen(),
          category: Categories.network,
          icon: Icons.cloud_download,
        ),
        ExampleItem(
          title: '주소 검색 (카카오)',
          screen: const AddressSearchScreen(),
          category: Categories.network,
          icon: Icons.location_on,
        ),
        ExampleItem(
          title: 'WebView',
          screen: const WebViewScreen(),
          category: Categories.network,
          icon: Icons.web,
        ),

        // 이미지/파일
        ExampleItem(
          title: '카메라',
          screen: const CameraScreen(),
          category: Categories.imageFile,
          icon: Icons.camera_alt_rounded,
        ),
        ExampleItem(
          title: '파일 & 이미지 선택',
          screen: const FileImagePickerScreen(),
          category: Categories.imageFile,
          icon: Icons.image,
        ),
        ExampleItem(
          title: '이미지 표시',
          screen: const ImageWidgetScreen(),
          category: Categories.imageFile,
          icon: Icons.photo_library,
        ),
        ExampleItem(
          title: 'PDF 뷰어 & 생성',
          screen: const PdfScreen(),
          category: Categories.imageFile,
          icon: Icons.picture_as_pdf,
        ),

        // 고급 기능
        ExampleItem(
          title: '앱 라이프 사이클',
          screen: const AppLifeCycleScreen(),
          category: Categories.advanced,
          icon: Icons.autorenew,
        ),
        ExampleItem(
          title: '앱 & 기기 정보',
          screen: const AppDeviceInfoScreen(),
          category: Categories.advanced,
          icon: Icons.info,
        ),
        ExampleItem(
          title: '로깅 (Logging)',
          screen: const LoggingScreen(),
          category: Categories.advanced,
          icon: Icons.terminal,
        ),
        ExampleItem(
          title: 'EasyLocalization',
          screen: const EasyLocalizationScreen(),
          category: Categories.advanced,
          icon: Icons.translate,
        ),
        ExampleItem(
          title: 'Feedback',
          screen: const FeedbackScreen(),
          category: Categories.advanced,
          icon: Icons.feedback_outlined,
        ),
        ExampleItem(
          title: '디바이스 센서',
          screen: const SensorsScreen(),
          category: Categories.advanced,
          icon: Icons.sensors,
          isPractical: false,
        ),
        ExampleItem(
          title: '화면 켜짐 유지',
          screen: const WakelockScreen(),
          category: Categories.advanced,
          icon: Icons.lightbulb,
        ),
        ExampleItem(
          title: 'Dart 3.x 신기능',
          screen: const Dart3Screen(),
          category: Categories.advanced,
          icon: Icons.new_releases,
        ),
        ExampleItem(
          title: 'MQTT Client',
          screen: const MqttScreen(),
          category: Categories.advanced,
          icon: Icons.cloud_sync,
          isPractical: false,
        ),
        ExampleItem(
          title: 'Local AI (On-Device)',
          screen: const LocalAiScreen(),
          category: Categories.advanced,
          icon: Icons.psychology,
          isPractical: false,
        ),
        ExampleItem(
          title: '로컬 알림',
          screen: const NotificationsScreen(),
          category: Categories.advanced,
          icon: Icons.notifications_rounded,
        ),
        ExampleItem(
          title: '생체 인증 (local_auth)',
          screen: const LocalAuthScreen(),
          category: Categories.advanced,
          icon: Icons.fingerprint_rounded,
        ),
        ExampleItem(
          title: 'QR / 바코드 스캔',
          screen: const MobileScannerScreen(),
          category: Categories.advanced,
          icon: Icons.qr_code_scanner_rounded,
        ),
        ExampleItem(
          title: 'Isolate (백그라운드)',
          screen: const IsolateScreen(),
          category: Categories.advanced,
          icon: Icons.memory_rounded,
        ),
        ExampleItem(
          title: 'get_it (의존성 주입)',
          screen: const GetItScreen(),
          category: Categories.advanced,
          icon: Icons.hub_rounded,
        ),
        ExampleItem(
          title: '오디오 재생 (just_audio)',
          screen: const AudioScreen(),
          category: Categories.advanced,
          icon: Icons.music_note_rounded,
        ),
        ExampleItem(
          title: '비디오 재생 (video_player)',
          screen: const VideoPlayerScreen(),
          category: Categories.advanced,
          icon: Icons.play_circle_rounded,
        ),

        // 상태 관리
        ExampleItem(
          title: 'Flutter Hooks',
          screen: const HooksScreen(),
          category: Categories.stateManagement,
          icon: Icons.extension,
        ),
        ExampleItem(
          title: 'Provider',
          screen: const ProviderScreen(),
          category: Categories.stateManagement,
          icon: Icons.layers,
        ),
        ExampleItem(
          title: 'RiverPod',
          screen: const RiverPodScreen(),
          category: Categories.stateManagement,
          icon: Icons.waves,
        ),
        ExampleItem(
          title: 'BLoC',
          screen: const BlocScreen(),
          category: Categories.stateManagement,
          icon: Icons.architecture,
        ),
      ];
}
