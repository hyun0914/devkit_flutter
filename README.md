# DevKit Flutter

실무에서 직접 구현·검증하며 쌓은 Flutter 위젯 & 패키지 레퍼런스

## 구성 현황

- **67개 이상**의 실무 검증 구현 사례
- **107개 이상**의 패키지 직접 통합 및 검증
- **7개 카테고리** 탭 네비게이션으로 체계적 분류
- **즐겨찾기** 기능으로 자주 쓰는 레퍼런스 바로 접근
- **레퍼런스 검색** (탭 내 실시간 필터링 + pull-to-refresh 초기화)
- **Material 3** 디자인 적용
- **다크모드** 완벽 지원

## 카테고리

### 1. 기본 위젯
- Text 위젯, 공통 위젯 모음
- 탭바, Scaffold, Dialog/Sheet
- 텍스트 필드, 테이블 위젯
- 버튼 트리거, 위젯 숨기기
- 반응형 위젯, Animated 위젯
- Flexible/Expanded, 복잡한 드래그
- ListWheelScrollView, GridView + PageView

### 2. 데이터 처리
- String 관련 (포맷, 변환)
- 숫자 관련 (포맷, 계산)
- 날짜 관련 (포맷, 계산)
- List, Map 관련 (조작, 변환)
- 데이터 비교 (Equatable)
- ValueListenableBuilder
- SharedPreferences, 보안 저장소

### 3. UI 패키지
- 🎨 **로딩 & 스켈레톤** (Shimmer, Skeletonizer, SpinKit)
- ⏱️ **타이머 & 카운트다운**
- 🎯 **인디케이터 & 페이지네이션**
- 📊 **차트 & 게이지** (D-Chart, Syncfusion Gauges)
- 🗺️ **히트맵** (Contribution, FL Heatmap, BodyChart)
- 📅 **캘린더 & 시간** (Board DateTime Picker, Table Calendar)
- 🎛️ **입력 위젯** (Rating, Slider, PinPut, Dropdown)
- 🎠 **캐러셀 & 탭** (Carousel Widget, Tab Container)
- 🎭 **애니메이션** (Hero, OpenContainer, SharedAxis, FadeScale)
- 💻 **코드 하이라이팅** (flutter_code_view, syntax_highlight)
- 🛠️ **기타** (점선, 드래그 리스트, 온보딩, Swipe Action)

### 4. 네트워크
- **HTTP 통신** (Dio, HTTP)
- **네트워크 상태** (Connectivity Plus)
- **WebView** (웹 페이지 표시)
- **주소 검색** (카카오 우편번호 API)

### 5. 이미지 & 파일
- **캐시 이미지** (Fast/Cached Network Image)
- **이미지 선택 & 관리** (Image Picker)
- **파일 선택 & 열기** (File Picker)
- **PDF** (생성, 뷰어, 인쇄)

### 6. 고급 기능
- **센서** (가속도계, 자이로스코프, 나침반)
- **Wakelock** (화면 켜짐 유지)
- **앱 라이프 사이클**
- **앱 & 기기 정보**
- **로깅** (Talker)
- **피드백** (사용자 피드백 수집)
- **다국어** (Easy Localization)
- **Dart 3.x 신기능** (Sealed Classes, Records, Pattern Matching)
- **MQTT Client** (IoT 실시간 메시징)
- **온디바이스 AI** (flutter_local_ai, Gemini Nano)

### 7. 상태 관리
- **Provider**
- **Riverpod**
- **BLoC**
- **Flutter Hooks**

## 시작하기

```bash
git clone https://github.com/yourusername/devkit_flutter.git
cd devkit_flutter
flutter pub get
flutter run
```

**실행 중 단축키:**
- `r` — 핫 리로드
- `R` — 핫 리스타트
- `q` — 종료

## 실무 구현 레퍼런스

### 애니메이션
- **Hero** — 이미지 확대 전환
- **OpenContainer** — 카드 → 상세 페이지 전환
- **SharedAxisTransition** — 페이지 간 슬라이드/스케일 전환
- **FadeScaleTransition** — 모달/다이얼로그 페이드

### 히트맵
- **Contribution Heatmap** — GitHub 스타일 기여도
- **FL Heatmap** — 데이터 시각화
- **BodyChart Heatmap** — 신체 부위 시각화

### 센서
- 가속도계 (기기 기울기), 자이로스코프 (회전 속도), 나침반 (방향)

### 날짜 & 시간
- Board DateTime Picker, Table Calendar, Syncfusion DatePicker

### 피드백 & 로깅
- Talker (강력한 로거), Feedback (사용자 피드백), Easy Localization (다국어)

### 반응형 & 레이아웃
- ResponsiveBuilder, Sizer, Flexible/Expanded

## 사용된 주요 패키지

### 상태 관리
- **Provider**: provider
- **Riverpod**: flutter_riverpod
- **BLoC**: flutter_bloc
- **Hooks**: flutter_hooks

### UI & 애니메이션
- **로딩**: shimmer, skeletonizer, flutter_spinkit
- **애니메이션**: animations (Google Material Design)
- **타이머**: slide_countdown, flutter_timer_countdown
- **인디케이터**: smooth_page_indicator, card_slider
- **온보딩**: tutorial_coach_mark, introduction_screen

### 차트 & 시각화
- **차트**: d_chart, gauge_indicator, geekyants_flutter_gauges
- **히트맵**: contribution_heatmap, fl_heatmap, bodychart_heatmap
- **캘린더**: table_calendar, syncfusion_flutter_datepicker, board_datetime_picker

### 위젯 라이브러리
- **캐러셀**: flutter_carousel_widget, card_slider
- **입력**: pinput, dropdown_button2, keyboard_actions, flutter_rating_bar
- **슬라이딩**: flutter_slidable, flutter_xlider
- **드래그**: drag_and_drop_lists, animated_reorderable
- **기타**: tab_container, snapping_sheet, spoiler_widget

### 이미지 & 파일
- **이미지**: fast_cached_network_image, cached_network_image, flutter_svg
- **파일 선택**: image_picker, file_picker
- **PDF**: pdf, printing, syncfusion_flutter_pdfviewer
- **기타**: open_file, gal

### 네트워크 & 데이터
- **HTTP**: dio, http
- **연결**: connectivity_plus
- **웹뷰**: webview_flutter
- **MQTT**: mqtt_client

### 온디바이스 AI
- **로컬 AI**: flutter_local_ai (ML Kit GenAI, Gemini Nano)

### 저장소 & 보안
- **로컬 저장소**: shared_preferences, path_provider
- **보안**: flutter_secure_storage

### 센서 & 기기
- **센서**: sensors_plus (가속도계, 자이로스코프, 나침반)
- **기기 관리**: wakelock_plus, battery_plus
- **정보**: device_info_plus, package_info_plus, permission_handler

### 반응형 & 레이아웃
- responsive_builder, sizer

### 로깅 & 피드백
- talker_flutter, logger, feedback, fluttertoast

### 유틸리티
- **다국어**: intl, easy_localization
- **객체 비교**: equatable
- **감지**: focus_detector, visibility_detector
- **기타**: postal_ko, url_launcher, sprintf, currency_text_input_formatter

### 개발자 도구
- **코드 하이라이팅**: flutter_code_view, syntax_highlight
- **기기 프리뷰**: device_preview
- **OSS 라이선스**: dart_pubspec_licenses

## OSS 라이선스 관리

패키지 추가 후 라이선스 자동 업데이트:

```bash
dart run dart_pubspec_licenses:generate
python3 tools/clean_oss_licenses.py
```

## 요구 사항

- Flutter SDK: ^3.10.8
- Dart SDK: ^3.5.0
- Python 3 (OSS 라이선스 정리용)

## 프로젝트 구조
```
devkit_flutter/
├── lib/
│   ├── screen/                  # 구현 화면들
│   │   ├── basic_widget/        # 기본 위젯
│   │   ├── data_processing/     # 데이터 처리
│   │   ├── ui_package/          # UI 패키지
│   │   ├── network/             # 네트워크
│   │   ├── image_file/          # 이미지 & 파일
│   │   ├── advanced/            # 고급 기능
│   │   ├── stateManagement/     # 상태 관리
│   │   └── widget/              # 공통 위젯 (DefaultScaffold 등)
│   ├── oss_licenses/            # OSS 라이선스
│   │   ├── oss_licenses.dart         # 패키지 데이터
│   │   └── oss_licenses_page.dart    # 라이선스 화면 UI
│   ├── home_screen.dart
│   ├── example_list_screen.dart
│   └── main.dart
├── assets/
│   └── translations/            # 다국어 파일 (ko, en, ja)
├── tools/
│   └── clean_oss_licenses.py    # 라이선스 정리 스크립트
├── test/
│   └── widget_test.dart
└── pubspec.yaml
```

## 소개

실무 Flutter 개발에서 반복적으로 필요한 위젯과 패키지를 직접 구현하고 검증하며 쌓은 개인 레퍼런스입니다.

단순 예제가 아닌, 실제 프로젝트에 투입 가능한 수준으로 구현하고 동작을 확인한 코드만 포함합니다. 빠른 코드 참조와 재사용을 목적으로 지속적으로 확장하고 있습니다.

## 라이선스

MIT License

---

**DevKit Flutter** — 실무에서 검증한 Flutter 레퍼런스
