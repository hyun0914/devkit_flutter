# DevKit Flutter

Flutter 위젯 & 패키지 예제를 빠르게 참조하는 개인 레퍼런스 앱

## 이 앱은?

실무에서 자주 쓰는 Flutter/Dart 코드와 위젯·패키지 예제를 직접 코딩해서 모아둔 개인 레퍼런스입니다.
실무 검증 여부와 무관하게 관심 있는 패키지도 예제로 추가하며 지속 확장 중입니다.

## 구성 현황

- **78개**의 예제 화면
- **115개**의 패키지 통합
- **7개 카테고리** + **실무 / 특수** 필터 탭
- **즐겨찾기** 기능으로 자주 쓰는 레퍼런스 바로 접근
- **검색** — 탭 내 실시간 필터링 + pull-to-refresh 초기화
- **Material 3** 디자인 적용
- **다크모드** 완벽 지원

## 탭 구조

```
상단: [ 전체 | 실무 | 특수 ]
하단: [ 기본 위젯 | 데이터 처리 | UI 패키지 | ... ]
```

- **실무** — 일반적인 앱 개발에서 자주 사용하는 예제
- **특수** — 특정 도메인(IoT, 온디바이스 AI 등)에서만 필요한 예제
- 해당 조합에 예제가 없는 카테고리 탭은 자동으로 숨김

## 카테고리

### 1. 기본 위젯
- Text 위젯, 공통 위젯 모음
- 탭바, Scaffold, Dialog / Sheet
- 텍스트 필드, 테이블 위젯
- 버튼 트리거 / 스타일, 위젯 숨기기
- Flexible / Expanded, Animated 위젯, 텍스트 Overflow
- ListWheelScrollView, GridView + PageView

**주요 예제:**
- `Scaffold` — BottomNavigationBar (fixed / shifting 타입, 애니메이션 제거)
- `TextField / Form` — 입력 트리거 비교 (디바운스 / onSubmitted / FocusNode), 한국어 입력 정규식, Multiline + Scrollbar 공유, Form 다중 필드 validate() → save(), 다음 필드 포커스 이동 체인
- `Dialog / Sheet` — showGeneralDialog 상단 고정 시트, AlertDialog 너비 조정, Wrap 높이 제어, SnappingSheet (`lockOverflowDrag`, `sheetAbove`)
- `BottomSheet` — DraggableScrollableSheet, Wrap 자동 높이, 높이 제어 5가지 방법 비교
- `Dropdown` — OverlayEntry 커스텀 드롭다운 (LayerLink + CompositedTransformFollower), InputDecorator 데코레이션

### 2. 데이터 처리
- String / 숫자 / 날짜 관련
- List, Map 관련
- Equatable, ValueListenableBuilder
- SharedPreferences, 보안 저장소
- **sqflite** (로컬 DB — CRUD)

**주요 예제:**
- `ValueNotifier / ValueListenableBuilder` — `child` 파라미터 리빌드 최적화, 동일 값 중복 알림 방지, List/Map 참조형 타입 주의사항 (새 객체 할당 필수), setState와 비교표

### 3. UI 패키지
- 로딩 & 스켈레톤 (Shimmer, Skeletonizer, SpinKit)
- 타이머 & 카운트다운
- 인디케이터 & 페이지네이션
- 차트 & 게이지 (D-Chart, Syncfusion Gauges)
- 캘린더 & 시간 (Table Calendar, Syncfusion DatePicker)
- 입력 위젯 (PinPut, Rating, Slider, Dropdown)
- 캐러셀 & 탭, 온보딩, Splash
- 애니메이션 (SharedAxis, OpenContainer 등)
- 드래그 & 리오더, 복잡한 드래그 & 드롭
- Swipe Action, ReadMore, KeyboardActions
- 히트맵 시각화, Dotted Border, 코드 뷰어
- 반응형 레이아웃, 리스트 스크롤 비교
- PageView + TweenAnimation, 터치 차단 로딩

**주요 예제:**
- `스크롤 팁` — 스크롤 오프셋 추적, animateTo / jumpTo, Scrollable.ensureVisible, ClampingScrollPhysics / BouncingScrollPhysics, ScrollBehavior 글로우 제거, PrimaryScrollController
- `드래그 & 리오더` — `LongPressDraggable` vs `Draggable`, `ReorderableDragStartListener` 커스텀 핸들 (`buildDefaultDragHandles: false`)
- `ListWheelScrollView` — `FixedExtentScrollController` 두 휠 동기화 (`addListener` + `jumpToItem`)
- `GridView` — `mainAxisExtent` (고정 픽셀) vs `childAspectRatio` (비율) 반응형 공식 비교

### 4. 네트워크
- 네트워크 연결 상태 (connectivity_plus)
- **go_router** (선언적 라우팅, Path Parameter, Redirect)
- HTTP 통신 (Dio, HTTP)
- WebView
- 주소 검색 (카카오 우편번호 API)

### 5. 이미지 & 파일
- **카메라** (촬영, 플래시, 전후면 전환)
- 이미지 선택 & 표시 (Image Picker, 캐시 이미지)
- 파일 선택 & 열기 (File Picker)
- PDF (생성, 뷰어, 인쇄)

**주요 예제:**
- `이미지 & SVG` — `Image.asset / .file / .memory / .network` 타입 비교, `pubspec.yaml` 등록 안내, `errorBuilder` 실패 대체 위젯, `FadeInImage` 투명 GIF placeholder → 페이드인, `DecorationImage` 배경 이미지 (colorFilter 오버레이), `InteractiveViewer + TransformationController` 원래 크기 복귀, SVG `colorFilter` / defs 주의사항
- `이미지 & 캐시` — `pickVideo` 동영상 선택, `Image.network cacheWidth/cacheHeight` + `devicePixelRatio` 최적화 (Extension 패턴), `FastCachedImageConfig.init(clearCacheAfter:)` 캐시 만료 기간 설정 (화면 이동 전 재호출로 화면별 변경 가능, `main.dart` 참고)
- `PDF` — `pw.MemoryImage` 이미지 삽입 (Asset / 파일 / 네트워크 3가지 방법), 커스텀 폰트 (한글 NotoSansKR), 인쇄 & 공유

### 6. 고급 기능
- **생체 인증** (local_auth — 지문 / Face ID)
- **QR / 바코드 스캔** (mobile_scanner)
- **Isolate / compute** (백그라운드 처리)
- **get_it** (의존성 주입 — Singleton / Factory / LazySingleton)
- **오디오 재생** (just_audio)
- **비디오 재생** (video_player)
- **로컬 알림** (flutter_local_notifications)
- 앱 라이프 사이클, 앱 & 기기 정보
- 로깅 (Talker, Logger), 다국어 (Easy Localization)
- Dart 3.x 신기능 (Sealed Classes, Records, Pattern Matching)
- Feedback, Wakelock
- MQTT Client `[특수]`, 온디바이스 AI `[특수]`, 디바이스 센서 `[특수]`

### 7. 상태 관리
- Provider, Riverpod, BLoC, Flutter Hooks

## 최근 업데이트

### 코드 정리 & 빌드 수정
- 예제 화면 공통 위젯 추출 — `SectionHeader`, `ExampleCard`, `DemoCard`, `InfoBox`, `InfoItem`, `CodeBlock`, `MethodCard`, `PackageItem`, `showResultDialog()` (`lib/screen/widget/example_widgets.dart`)
- 인자만 넘기던 `DefaultScaffold` 래퍼 제거 → 기본 `Scaffold` 사용
- 오픈소스 라이선스 화면을 Flutter 내장 `showLicensePage()`로 교체 (`dart_pubspec_licenses`·정리 스크립트 제거, 사용법은 README에 보관)
- `Sliver 탭` — `SliverPersistentHeaderDelegate`의 `shrinkOffset`으로 축소 비율 계산, 아이콘 페이드 + 축소 % 표시
- Flutter 3.47 빌드 오류 수정 — `page_transition` 2.2.2 업데이트, `CupertinoPageTransitionsBuilder` cupertino import

### 스크롤 & 드래그
- `ListWheelScrollView` — `FixedExtentScrollController` 두 휠 동기화
- `GridView` — `mainAxisExtent` vs `childAspectRatio` 비교, 반응형 공식
- `ReorderableListView` — `buildDefaultDragHandles: false` + `ReorderableDragStartListener` 커스텀 핸들 토글
- `Draggable` — `LongPressDraggable` 추가, DragTarget 공유 패턴
- **스크롤 팁 탭 신설** — 오프셋 뱃지, jump/animate 버튼, Physics 비교, 글로우 제거, `ensureVisible` 4개 앵커 데모, `PrimaryScrollController` 안내

### BottomNavigationBar
- `Scaffold` — `BottomNavigationBar` 섹션 추가: fixed/shifting 타입, `activeIcon` 아이콘 전환, 라벨 숨기기, elevation 제거, `Theme(splashColor/highlightColor: transparent)` 애니메이션 제거

### BottomSheet / Dialog / Dropdown
- `BottomSheet 탭` — `Wrap` 자동 높이 시트, 높이 제어 5가지 방법 비교표
- `SnappingSheet 탭` — `lockOverflowDrag: true` 권장 설정, `pixels` 방식, `sheetAbove` 안내
- `Dialog Sheet` — `showGeneralDialog` + `SlideTransition` 상단 고정 시트, `StatefulBuilder` + `insetPadding` AlertDialog 너비 조정
- `기본 위젯` — `OverlayEntry` 커스텀 드롭다운 (LayerLink + CompositedTransformFollower), `InputDecorator + DropdownButtonHideUnderline` 권장 데코레이션

### ValueNotifier / ValueListenableBuilder
- `child` 파라미터로 정적 위젯 리빌드 방지 데모
- 동일 값(`==`) 중복 리스너 호출 방지 동작 확인
- List/Map 참조형 타입 경고 카드 (`n.value = [...n.value, x]` 패턴)
- setState와 기능 비교 Table

### TextField / Form / 입력 제어
- 한국어 정규식 버그 수정 — `[ᄀ-ᇿ㄰-㆏가-힯]` (천지인/10키 조합 중 글자 사라짐 방지)
- `Scrollbar + TextField` — `ScrollController` 공유로 멀티라인 스크롤바 구현
- `Form` 다중 필드 — `TextFormField` 3개 + `validate() → save() → onSaved` 패턴
- 다음 필드 포커스 이동 — `textInputAction.next` + `FocusScope.of(context).nextFocus()` 체인, 마지막 필드 `unfocus()`

### 이미지 처리
- `이미지 & SVG` — `StatefulWidget` 전환, 이미지 타입 비교, `pubspec.yaml` 등록 안내, `errorBuilder`, `FadeInImage`, 배경 이미지, `TransformationController` 원래 크기 복귀
- `이미지 & 캐시` — `pickVideo`, `Image.network cacheWidth × devicePixelRatio` 최적화, Extension 패턴
- `PDF` — `pw.MemoryImage` Asset / 파일 / 네트워크 이미지 삽입 코드

## 시작하기

```bash
git clone https://github.com/hyun0914/devkit_flutter.git
cd devkit_flutter
flutter pub get
flutter run
```

**실행 중 단축키:**
- `r` — 핫 리로드
- `R` — 핫 리스타트
- `q` — 종료

## 사용된 주요 패키지

### 상태 관리
- provider, flutter_riverpod, flutter_bloc, flutter_hooks

### 라우팅
- go_router

### 로컬 DB & 저장소
- sqflite, shared_preferences, flutter_secure_storage, path_provider

### 의존성 주입
- get_it

### 카메라 & 미디어
- camera, just_audio, video_player, mobile_scanner

### 생체 인증
- local_auth

### UI & 애니메이션
- animations, shimmer, skeletonizer, flutter_spinkit
- slide_countdown, flutter_timer_countdown
- smooth_page_indicator, introduction_screen, tutorial_coach_mark
- flutter_slidable, animated_reorderable, drag_and_drop_lists

### 차트 & 시각화
- d_chart, gauge_indicator, geekyants_flutter_gauges
- contribution_heatmap, fl_heatmap, bodychart_heatmap
- table_calendar, syncfusion_flutter_datepicker, board_datetime_picker

### 이미지 & 파일
- fast_cached_network_image, cached_network_image, flutter_svg
- image_picker, file_picker, gal, open_file
- pdf, printing, syncfusion_flutter_pdfviewer

### 네트워크 & 연결
- dio, http, connectivity_plus, webview_flutter, mqtt_client

### 알림 & 기기
- flutter_local_notifications, local_auth, mobile_scanner
- sensors_plus, wakelock_plus, battery_plus
- device_info_plus, package_info_plus, permission_handler

### 로깅 & 피드백
- talker_flutter, logger, feedback, fluttertoast

### 유틸리티
- easy_localization, intl, equatable
- url_launcher, postal_ko, currency_text_input_formatter
- focus_detector, visibility_detector

### 개발자 도구
- device_preview
- flutter_code_view, syntax_highlight

### 온디바이스 AI
- flutter_local_ai (ML Kit GenAI, Gemini Nano)

## 오픈소스 라이선스

홈 화면의 `오픈소스 라이선스`는 Flutter 내장 `showLicensePage()`를 사용합니다.
패키지마다 들어 있는 LICENSE를 빌드할 때 자동으로 모으므로, 패키지를 추가하거나 지워도 따로 할 일이 없습니다.
화면 문구는 `lib/home_screen.dart`의 `MaterialApp`에서 `flutter_localizations`로 한글 고정되어 있습니다 (날짜 선택기·복사/붙여넣기 등 Flutter 기본 위젯도 동일).

```dart
showLicensePage(context: context, applicationName: 'DevKit Flutter');
```

### 참고: 라이선스 화면을 직접 꾸미고 싶을 때 (dart_pubspec_licenses)

버전·설명 표시나 커스텀 디자인이 필요하면 `dart_pubspec_licenses`로 패키지 정보를 Dart 코드로 생성해 직접 화면을 만들 수 있습니다.

```yaml
# pubspec.yaml
dev_dependencies:
  dart_pubspec_licenses: ^3.0.15
```

```bash
# 패키지를 추가·삭제할 때마다 다시 실행
dart run dart_pubspec_licenses:generate
```

- 생성 파일: `lib/oss_licenses.dart`
- `dependencies` (직접 추가한 패키지), `devDependencies` 목록 제공
- 각 `Package`에서 `name`, `version`, `description`, `homepage`, `license`(라이선스 본문) 사용 가능

```dart
import 'oss_licenses.dart';

ListView(
  children: [
    for (final p in dependencies)
      ListTile(title: Text(p.name), subtitle: Text('v${p.version}')),
  ],
);
```

## 요구 사항

- Dart SDK: ^3.10.8 (Flutter 3.47.5에서 빌드 확인)
- iOS 15.5 이상 (mobile_scanner 7.x 요구 사항)
- Android API 26 이상

## 프로젝트 구조

```
devkit_flutter/
├── lib/
│   ├── screen/
│   │   ├── basic_widget/        # 기본 위젯
│   │   ├── data_processing/     # 데이터 처리
│   │   ├── ui_package/          # UI 패키지
│   │   ├── network/             # 네트워크
│   │   ├── image_file/          # 이미지 & 파일
│   │   ├── advanced/            # 고급 기능
│   │   ├── stateManagement/     # 상태 관리
│   │   └── widget/              # 공통 위젯
│   ├── home_screen.dart
│   ├── example_list_screen.dart
│   ├── example_data.dart
│   ├── example_item.dart
│   └── main.dart
├── assets/
│   └── translations/
└── pubspec.yaml
```

## 예제 추가 방법

- 새 예제 화면은 `lib/example_data.dart`의 `ExampleData.items`에 `ExampleItem`으로 추가합니다.
- 홈 화면의 예제·카테고리 수는 이 목록에서 자동 계산됩니다. 패키지 수(`totalPackages`)만 직접 수정합니다.

## 공통 UI 규칙

- **예제 화면 공통 위젯**: 섹션 헤더·예제 카드·정보 박스·안내 문구·코드 블록 등은 `lib/screen/widget/example_widgets.dart`의 공통 위젯을 사용합니다.
  - `SectionHeader`, `ExampleCard`, `DemoCard`, `InfoBox`, `InfoItem`, `CodeBlock`, `MethodCard`, `PackageItem`, `showResultDialog()`
- **Scaffold**: 별도 래퍼 없이 Flutter 기본 `Scaffold`를 그대로 사용합니다.
  - 배경색·AppBar 등 **스타일**을 공통으로 바꾸려면 `lib/home_screen.dart`의 `ThemeData`(`scaffoldBackgroundColor`, `appBarTheme` 등)를 수정합니다. `theme`와 `darkTheme` 양쪽에 함께 지정해야 합니다.
  - `SafeArea`, 키보드 닫기 등 **공통 동작**이 필요해지면 그때 래퍼 위젯을 추가합니다.

## 라이선스

MIT License
