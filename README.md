# DevKit Flutter

Flutter 개발자를 위한 위젯 & 패키지 예제 모음

## 📱 주요 기능

- **64개 이상**의 실용적인 예제
- **105개 이상**의 패키지 활용
- **7개 카테고리**로 체계적 분류
- **Material 3** 디자인 적용
- **다크모드** 완벽 지원

## 🎯 카테고리

### 1. 기본 위젯
- Text 위젯, 공통 위젯 모음
- 탭바, Scaffold, Dialog/Sheet
- 텍스트 필드, 테이블 위젯
- 버튼 트리거, 위젯 숨기기
- 반응형 위젯, Animated 위젯
- Flexible/Expanded, 복잡한 드래그
- 클릭 위젯, ListWheelScrollView

### 2. 데이터 처리
- String 관련 (포맷, 변환)
- 숫자 관련 (포맷, 계산)
- 날짜 관련 (포맷, 계산)
- List, Map 관련 (조작, 변환)
- 데이터 비교 (Equatable)
- print 관련 (디버깅)
- ValueListenableBuilder

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
- 📝 **피드백 & 로깅** (Talker, Feedback, Easy Localization)
- 💻 **코드 하이라이팅** (flutter_code_view, syntax_highlight)
- 🛠️ **기타** (점선, 드래그 리스트, 스포일러, 온보딩)

### 4. 네트워크
- **HTTP 통신** (Dio, HTTP)
- **네트워크 상태** (Connectivity Plus)
- **WebView** (웹 페이지 표시)

### 5. 이미지 & 파일
- **캐시 이미지** (Fast/Cached Network Image)
- **이미지 선택 & 관리** (Image Picker, Multi Image Picker)
- **SVG 이미지** (flutter_svg)
- **파일 선택 & 열기** (File Picker, Open File Plus)
- **PDF** (생성, 뷰어, 인쇄)
- **스크린샷** (Scroll Screenshot)
- **내부 저장** (Path Provider)

### 6. 고급 기능
- **센서** (가속도계, 자이로스코프, 나침반)
- **보안 저장소** (Secure Storage)
- **Wakelock** (화면 깨우기 유지)
- **앱 라이프 사이클**
- **기기 & 패키지 정보**

### 7. 상태 관리
- **Provider**
- **Riverpod**
- **BLoC**
- **Flutter Hooks**

## 🚀 시작하기

### 1. 프로젝트 클론
```bash
git clone https://github.com/yourusername/devkit_flutter.git
cd devkit_flutter
```

### 2. 패키지 설치
```bash
flutter pub get
```

### 3. 실행

**에뮬레이터 준비:**
```bash
# Android Studio 또는 Xcode에서 에뮬레이터 실행
# 또는 실제 기기를 USB로 연결
```

**앱 실행:**
```bash
# 기본 실행 (디버그 모드)
flutter run

# 연결된 기기 확인
flutter devices

# 특정 기기에서 실행
flutter run -d <device_id>

# 릴리즈 모드 (최종 배포용)
flutter run --release

# 프로파일 모드 (성능 분석용)
flutter run --profile
```

**실행 중 단축키:** (터미널에서 키만 누르면 됨)
- `r` - 핫 리로드 (코드 수정 즉시 반영)
- `R` - 핫 리스타트 (앱 재시작)
- `h` - 도움말 (모든 단축키 보기)
- `q` - 앱 종료

> 💡 디버그 모드에서는 핫 리로드(`r`)로 빠르게 개발할 수 있습니다.

## 🧪 테스트

```bash
# 모든 테스트 실행
flutter test
```

**테스트 항목:**
- 위젯 UI 검증
- 아이콘 표시 확인
- 네비게이션 테스트

## 📦 사용된 주요 패키지

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
- **파일 선택**: image_picker, multi_image_picker_view, file_picker
- **PDF**: pdf, printing, syncfusion_flutter_pdfviewer
- **기타**: open_file, scroll_screenshot, gal

### 네트워크 & 데이터
- **HTTP**: dio, http
- **연결**: connectivity_plus
- **웹뷰**: webview_flutter

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

## 🔧 OSS 라이선스 관리

패키지 추가 후 라이선스 자동 업데이트:

```bash
# 1. 라이선스 생성
dart run dart_pubspec_licenses:generate

# 2. Python 스크립트로 정리 (SDK 패키지 제거, 죽은 코드 제거)
python3 tools/clean_oss_licenses.py
```

자동으로:
- SDK 기본 패키지 제거 (_flutter, _flutter_test 등)
- 사용하지 않는 패키지 정의 제거
- 빈 줄 정리
- 깔끔한 코드 생성

## 🛠️ 요구 사항

- Flutter SDK: ^3.10.8
- Dart SDK: ^3.5.0
- Python 3 (OSS 라이선스 정리용)

## 📂 프로젝트 구조
```
devkit_flutter/
├── lib/
│   ├── screen/              # 예제 화면들
│   │   ├── basic_widget/   # 기본 위젯
│   │   ├── data_handling/  # 데이터 처리
│   │   ├── ui_package/     # UI 패키지
│   │   ├── network/        # 네트워크
│   │   ├── image_file/     # 이미지 & 파일
│   │   ├── advanced/       # 고급 기능
│   │   └── stateManagement/  # 상태 관리
│   ├── widget/              # 공통 위젯
│   ├── oss_licenses/        # OSS 라이선스
│   │   ├── oss_licenses.dart         # 패키지 데이터
│   │   └── oss_licenses_page.dart    # 라이선스 화면 UI
│   ├── home_screen.dart
│   ├── example_list_screen.dart
│   └── main.dart
├── assets/
│   └── translations/        # 다국어 파일 (ko, en, ja)
├── tools/
│   └── clean_oss_licenses.py  # 라이선스 정리 스크립트
├── test/
│   └── widget_test.dart     # 위젯 테스트
└── pubspec.yaml
```

## 🌟 주요 예제 하이라이트

### 애니메이션
- **Hero**: 이미지 확대 전환
- **OpenContainer**: 카드 → 상세 페이지 전환
- **SharedAxisTransition**: 페이지 간 슬라이드/스케일 전환
- **FadeScaleTransition**: 모달/다이얼로그 페이드

### 히트맵
- **Contribution Heatmap**: GitHub 스타일 기여도
- **FL Heatmap**: 데이터 시각화
- **BodyChart Heatmap**: 신체 부위 시각화

### 센서
- 가속도계 (기기 기울기)
- 자이로스코프 (회전 속도)
- 나침반 (방향)

### 이미지 & SVG
- SVG 네트워크 로드
- SVG 색상 변경 (ColorFilter)
- 캐시 이미지 (Fast/Cached)
- 이미지 확대/축소 (InteractiveViewer)

### 날짜 & 시간
- Board DateTime Picker (날짜/시간 선택)
- Table Calendar (달력)
- Syncfusion DatePicker (고급 날짜 선택)

### 피드백 & 로깅
- Talker (강력한 로거)
- Feedback (사용자 피드백 수집)
- Easy Localization (다국어)

### 반응형 & 레이아웃
- ResponsiveBuilder (화면 크기별 UI)
- Sizer (반응형 크기)
- Flexible/Expanded (유연한 레이아웃)

## 👨‍💻 프로젝트 소개

Flutter 개발 시 자주 사용하는 위젯과 패키지를 모아둔 개인 레퍼런스입니다.

**목적:**
- 실무에서 빠른 코드 참조 및 재사용
- Flutter 개발 역량 강화 및 학습
- 체계적인 예제 라이브러리 구축

**주요 성과:**
- 64개 이상의 실용적인 예제 작성
- 105개 패키지 통합 및 활용
- Python을 활용한 자동화 스크립트 개발
- 체계적인 문서화 및 테스트 코드 작성

## 📄 라이선스

MIT License

---

**DevKit Flutter** - Flutter 개발을 더 쉽게! 🚀