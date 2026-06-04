# DevKit Flutter

Flutter 위젯 & 패키지 예제를 빠르게 참조하는 개인 레퍼런스 앱

## 이 앱은?

실무에서 자주 쓰는 Flutter/Dart 코드와 위젯·패키지 예제를 직접 코딩해서 모아둔 개인 레퍼런스입니다.
실무 검증 여부와 무관하게 관심 있는 패키지도 예제로 추가하며 지속 확장 중입니다.

## 구성 현황

- **77개**의 예제 화면
- **117개**의 패키지 통합
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
- Flexible / Expanded, Animated 위젯
- ListWheelScrollView, GridView + PageView

### 2. 데이터 처리
- String / 숫자 / 날짜 관련
- List, Map 관련
- Equatable, ValueListenableBuilder
- SharedPreferences, 보안 저장소
- **sqflite** (로컬 DB — CRUD)

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
- 반응형 레이아웃

### 4. 네트워크
- **go_router** (선언적 라우팅, Path Parameter, Redirect)
- HTTP 통신 (Dio, HTTP)
- WebView
- 주소 검색 (카카오 우편번호 API)

### 5. 이미지 & 파일
- **카메라** (촬영, 플래시, 전후면 전환)
- 이미지 선택 & 표시 (Image Picker, 캐시 이미지)
- 파일 선택 & 열기 (File Picker)
- PDF (생성, 뷰어, 인쇄)

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
- device_preview, dart_pubspec_licenses
- flutter_code_view, syntax_highlight

### 온디바이스 AI
- flutter_local_ai (ML Kit GenAI, Gemini Nano)

## OSS 라이선스 업데이트

```bash
dart run dart_pubspec_licenses:generate
python3 tools/clean_oss_licenses.py
```

## 요구 사항

- Flutter SDK: ^3.10.8
- Dart SDK: ^3.10.8
- iOS 15.5 이상 (mobile_scanner 7.x 요구 사항)
- Android API 21 이상
- Python 3 (OSS 라이선스 정리용)

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
│   ├── oss_licenses/
│   ├── home_screen.dart
│   ├── example_list_screen.dart
│   ├── example_data.dart
│   └── main.dart
├── assets/
│   └── translations/
├── tools/
│   └── clean_oss_licenses.py
└── pubspec.yaml
```

## 라이선스

MIT License

