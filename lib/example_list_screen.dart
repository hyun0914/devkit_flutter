import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

// ── 기본 위젯 ──
import 'screen/basic_widget/animated_widget_screen.dart';
import 'screen/basic_widget/basic_widget_screen.dart';
import 'screen/basic_widget/button_style_screen.dart';
import 'screen/basic_widget/button_trigger_screen.dart';
import 'screen/basic_widget/dialog_sheet_screen.dart';
import 'screen/basic_widget/grid_page_screen.dart';
import 'screen/basic_widget/hide_widgets_screen.dart';
import 'screen/basic_widget/list_wheel_scroll_view_screen.dart';
import 'screen/basic_widget/flexible_expanded_screen.dart';
import 'screen/basic_widget/scaffold_screen.dart';
import 'screen/basic_widget/tab_bar_screen.dart';
import 'screen/basic_widget/table_widget_screen.dart';
import 'screen/basic_widget/text_field_screen.dart';
import 'screen/basic_widget/text_overflow_screen.dart';
import 'screen/basic_widget/text_widget_screen.dart';

// ── 데이터 처리 ──
import 'screen/data_processing/date_related_screen.dart';
import 'screen/data_processing/equatable_screen.dart';
import 'screen/data_processing/list_map_related_screen.dart';
import 'screen/data_processing/number_related_screen.dart';
import 'screen/data_processing/secure_storage_screen.dart';
import 'screen/data_processing/shared_preferences_screen.dart';
import 'screen/data_processing/string_related_screen.dart';
import 'screen/data_processing/value_listenable_builder_screen.dart';

// ── UI 패키지 ──
import 'screen/ui_package/animations_screen.dart';
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
import 'screen/network/dio_screen.dart';
import 'screen/network/web_view_screen.dart';

// ── 이미지/파일 ──
import 'screen/image_file/file_image_picker_screen.dart';
import 'screen/image_file/image_widget_screen.dart';
import 'screen/image_file/pdf_screen.dart';

// ── 고급 기능 ──
import 'screen/advanced/app_device_info_screen.dart';
import 'screen/advanced/app_life_cycle_screen.dart';
import 'screen/advanced/hooks_screen.dart';
import 'screen/advanced/logging_screen.dart';
import 'screen/advanced/easy_localization_screen.dart';
import 'screen/advanced/feedback_screen.dart';
import 'screen/advanced/sensors_screen.dart';
import 'screen/advanced/wakelock_screen.dart';

// ── 공용 ──
import 'screen/widget/default_scaffold.dart';

// 카테고리 목록
class Categories {
  static const String all = '전체';
  static const String basicWidget = '기본 위젯';
  static const String dataProcessing = '데이터 처리';
  static const String uiPackage = 'UI 패키지';
  static const String network = '네트워크';
  static const String imageFile = '이미지/파일';
  static const String advanced = '고급 기능';
}

// 예제 아이템 모델
class ExampleItem {
  final String title;
  final Widget screen;
  final String category;
  final IconData icon;

  ExampleItem({
    required this.title,
    required this.screen,
    required this.category,
    required this.icon,
  });
}

class ExampleListScreen extends StatefulWidget {
  const ExampleListScreen({super.key});

  @override
  State<ExampleListScreen> createState() => _ExampleListScreenState();
}

class _ExampleListScreenState extends State<ExampleListScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  GlobalKey tutorialKey = GlobalKey();
  GlobalKey tutorialKey2 = GlobalKey();
  GlobalKey tutorialKey3 = GlobalKey();

  String searchQuery = '';
  String selectedCategory = Categories.all;
  Set<String> favoriteItems = {};

  List<String> get categories {
    final categorySet = allExamples.map((e) => e.category).toSet();
    return [Categories.all, ...categorySet.toList()..sort()];
  }

  // 예제 데이터
  late final List<ExampleItem> allExamples;

  @override
  void initState() {
    super.initState();
    _initializeExamples();
    _loadFavorites();
  }

  void _initializeExamples() {
    allExamples = [
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
      ),
      ExampleItem(
        title: '애니메이션',
        screen: const AnimationsScreen(),
        category: Categories.uiPackage,
        icon: Icons.animation,
      ),

      // 네트워크
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
        title: 'Flutter Hooks',
        screen: const HooksScreen(),
        category: Categories.advanced,
        icon: Icons.extension,
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
      ),
      ExampleItem(
        title: '화면 켜짐 유지',
        screen: const WakelockScreen(),
        category: Categories.advanced,
        icon: Icons.lightbulb,
      ),
    ];
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteItems = prefs.getStringList('favorites')?.toSet() ?? {};
    });
  }

  Future<void> _toggleFavorite(String title) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favoriteItems.contains(title)) {
        favoriteItems.remove(title);
      } else {
        favoriteItems.add(title);
      }
    });
    await prefs.setStringList('favorites', favoriteItems.toList());
  }

  List<ExampleItem> get filteredExamples {
    return allExamples.where((example) {
      final matchesSearch =
      example.title.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory =
          selectedCategory == Categories.all || example.category == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  dynamic targetFocusBasic({
    required dynamic identify,
    required GlobalKey keyTarget,
    ShapeLightFocus? shape,
    double? paddingFocus,
    required ContentAlign align,
    required EdgeInsets padding,
    required CrossAxisAlignment crossAxisAlignment,
    required List<Widget> children,
  }) {
    return TargetFocus(
      identify: identify,
      keyTarget: keyTarget,
      shape: shape ?? ShapeLightFocus.RRect,
      color: Colors.black26,
      enableOverlayTab: true,
      focusAnimationDuration: const Duration(milliseconds: 400),
      unFocusAnimationDuration: const Duration(milliseconds: 400),
      paddingFocus: paddingFocus,
      contents: [
        TargetContent(
          align: align,
          padding: padding,
          builder: (context, controller) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: crossAxisAlignment,
              children: children,
            );
          },
        ),
      ],
    );
  }

  void showTutorial() {
    TutorialCoachMark(
      targets: [
        targetFocusBasic(
          identify: 'Target 1',
          keyTarget: tutorialKey,
          shape: ShapeLightFocus.Circle,
          paddingFocus: 1,
          align: ContentAlign.left,
          padding: const EdgeInsets.fromLTRB(160, 0, 0, 10),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('위/아래 스크롤 버튼',
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ],
        ),
        targetFocusBasic(
          identify: 'Target 2',
          keyTarget: tutorialKey2,
          shape: ShapeLightFocus.RRect,
          paddingFocus: 1,
          align: ContentAlign.top,
          padding: const EdgeInsets.fromLTRB(160, 0, 0, 10),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('검색 기능으로 예제를 빠르게 찾을 수 있습니다',
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ],
        ),
        targetFocusBasic(
          identify: 'Target 3',
          keyTarget: tutorialKey3,
          shape: ShapeLightFocus.RRect,
          paddingFocus: 1,
          align: ContentAlign.top,
          padding: const EdgeInsets.fromLTRB(160, 0, 0, 10),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('카테고리별로 필터링할 수 있습니다',
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ],
        ),
      ],
      colorShadow: Colors.grey.shade200,
      onClickTarget: (target) {
        debugPrint('onClickTarget $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        debugPrint('onClickTargetWithTapPosition\n$target\n$tapDetails');
      },
      onClickOverlay: (target) {
        debugPrint('onClickOverlay $target');
      },
      onSkip: () {
        debugPrint('onSkip');
        return true;
      },
      onFinish: () {
        debugPrint('onFinish');
      },
    ).show(context: context);
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    return FloatingDraggableWidget(
      floatingWidgetWidth: 48,
      floatingWidgetHeight: 48,
      dx: 340,
      dy: 800,
      floatingWidget: FloatingActionButton.small(
        key: tutorialKey,
        backgroundColor: theme.colorScheme.primaryContainer,
        onPressed: () {
          if (!scrollController.hasClients) return;

          final position = scrollController.position;
          final isAtBottom = position.pixels >= position.maxScrollExtent - 10;
          final target =
          isAtBottom ? position.minScrollExtent : position.maxScrollExtent;

          scrollController.animateTo(
            target,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
          );
        },
        child: const Icon(Icons.swap_vert),
      ),
      mainScreenWidget: DefaultScaffold(
        appBar: AppBar(
          title: const Text('위젯 & 패키지 샘플'),
          actions: [
            IconButton(
              onPressed: showTutorial,
              icon: const Icon(Icons.help_outline),
              tooltip: '튜토리얼',
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                key: tutorialKey2,
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: '예제 검색...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        setState(() {
                          searchQuery = '';
                        });
                      },
                    )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.3),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ),
              Container(
                key: tutorialKey3,
                height: 50,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        backgroundColor: theme.colorScheme.surface,
                        selectedColor: theme.colorScheme.primaryContainer,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      '${filteredExamples.length}개의 예제',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (favoriteItems.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star,
                                size: 12, color: Colors.orange),
                            const SizedBox(width: 4),
                            Text(
                              '즐겨찾기 ${favoriteItems.length}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: CustomMaterialIndicator(
                  onRefresh: () => Future.delayed(const Duration(seconds: 1)),
                  indicatorBuilder: (context, controller) {
                    return const Icon(
                      Icons.refresh,
                      size: 30,
                      color: Colors.green,
                    );
                  },
                  child: filteredExamples.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '검색 결과가 없습니다',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                      : GridView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: filteredExamples.length,
                    itemBuilder: (context, index) {
                      final example = filteredExamples[index];
                      final isFavorite =
                      favoriteItems.contains(example.title);
                      final isImageCacheIndex =
                      example.title.contains('캐시 이미지');

                      Future<void> handleTap() async {
                        if (isImageCacheIndex) {
                          await FastCachedImageConfig.init(
                            clearCacheAfter: const Duration(days: 15),
                          );
                        }
                        if (context.mounted) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => example.screen),
                          );
                        }
                      }

                      return _ExampleCard(
                        title: example.title,
                        icon: example.icon,
                        category: example.category,
                        isFavorite: isFavorite,
                        onTap: handleTap,
                        onFavoriteToggle: () =>
                            _toggleFavorite(example.title),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String category;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const _ExampleCard({
    required this.title,
    required this.icon,
    required this.category,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(16),
      color: theme.colorScheme.surface,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 22,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.star : Icons.star_border,
                      size: 22,
                      color: isFavorite
                          ? Colors.orange
                          : theme.colorScheme.outline,
                    ),
                    onPressed: onFavoriteToggle,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashRadius: 20,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  category,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}