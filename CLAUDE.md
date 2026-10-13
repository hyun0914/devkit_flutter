# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 프로젝트 성격

Flutter 위젯·패키지 예제를 모아둔 **개인 레퍼런스 앱**이다 (제품 앱 아님). 예제 화면 하나하나가 "이렇게 쓴다"를 보여주는 학습 자료이므로:

- 죽은 코드·디버그 로그·도달 불가 분기처럼 보여도 의도된 데모일 수 있다. 지우기 전에 확인하고, 지울 때는 그 지식을 화면 데모·주석·README로 옮긴다.
- 같은 일을 하는 패키지가 여러 개 들어 있는 것(`http`/`dio`, `cached_network_image`/`fast_cached_network_image`, 상태 관리 4종 등)은 비교용으로 의도된 것이다. 중복이라고 정리하지 않는다.
- 주석·UI 문구·커밋 메시지는 한국어다 (`feat:` / `fix:` / `refactor:` 접두어 + 한국어 설명).

## 명령어

```bash
flutter pub get
flutter run                          # 디버그 실행 (DevicePreview가 자동으로 켜짐)
flutter analyze                      # flutter_lints 기본 규칙, build/android/ios 제외
flutter test                         # 전체 테스트
flutter test test/widget_test.dart --plain-name 'HomeScreen 기본 UI 테스트'   # 단일 테스트
flutter build apk
flutter build ios --simulator
```

- 위젯 테스트는 홈 화면을 폰 크기(390x844)로 띄운다. 테스트 기본 화면(800x600)에서는 홈 화면 `Column`이 세로로 넘쳐 실패하므로, 홈 화면 테스트를 추가할 때는 `pumpHome()` 헬퍼를 쓴다.
- 요구 사항: Dart SDK ^3.10.8 (Flutter 3.47.5에서 빌드 확인), iOS 15.5+, Android API 26+.
- iOS: `ios/Podfile`의 `post_install`이 시뮬레이터에서 `x86_64`를 제외한다 (터미널 빌드 아키텍처 오류 대응). Podfile을 재생성할 때 이 설정을 유지한다.

## 아키텍처

### 앱 부트스트랩 (`lib/main.dart` → `lib/home_screen.dart`)

`main()`의 래퍼 순서: `ProviderScope` → `BetterFeedback` → `EasyLocalization` → `DevicePreview`(`kDebugMode`에서만) → `HomeScreen`.

`HomeScreen`이 `MaterialApp`을 소유한다. 앱 전역 설정은 모두 여기 있다:

- 테마: `ColorScheme.fromSeed(seedColor: Colors.green)` Material 3, `themeMode: ThemeMode.system`. 공통 스타일을 바꿀 때는 `theme`와 `darkTheme` **양쪽**에 지정해야 한다.
- 로케일은 `ko` 고정, `textScaler`는 1.0 고정.
- `easy_localization`(`assets/translations/`)은 다국어 예제 화면용이고, `MaterialApp` 자체는 `GlobalMaterialLocalizations`만 쓴다. 두 가지가 별개로 동작한다.
- 앱 전역 내비게이션은 `Navigator.push` 기반이다. `go_router`·`get_it`·`flutter_bloc` 등은 해당 예제 화면 안에서만 쓰인다.

### 예제 레지스트리 (`lib/example_data.dart`, `lib/example_item.dart`)

`ExampleData.items`가 모든 예제 화면의 단일 레지스트리다. 각 항목은 `ExampleItem(title, screen, category, icon, isPractical)`.

- `category`는 `Categories`의 문자열 상수를 쓴다. 하단 탭 순서는 `Categories.ordered`가 정한다.
- `isPractical`(기본 `true`)이 상단 필터를 결정한다: `true` → 실무, `false` → 특수(IoT·온디바이스 AI 등 특정 도메인).
- 홈 화면의 예제·카테고리 수는 `items`에서 자동 계산된다. **`totalPackages`만 수동 상수**라서 pubspec 의존성을 추가·삭제하면 함께 고친다 (SDK 항목 제외한 개수). README의 "구성 현황" 숫자도 수동이다.

### 목록 화면 (`lib/example_list_screen.dart`)

상단 필터(전체/실무/특수) × 하단 카테고리 탭 × 검색어로 `items`를 걸러 보여준다. 현재 조합에 예제가 없는 카테고리 탭은 자동으로 숨긴다.

즐겨찾기는 `SharedPreferences`의 `favorites` 키에 **예제 `title` 문자열**로 저장된다. `ExampleItem.title`을 바꾸면 기존 즐겨찾기가 끊어진다.

### 예제 화면 (`lib/screen/<category>/`)

화면 하나가 한 파일이고 서로 독립적이다. 폴더는 카테고리와 1:1 대응한다 (`stateManagement`만 camelCase). 탭이 많은 화면은 하위 폴더로 쪼개져 있다 (`basic_widget/tab_bar/`, `ui_package/packages/`).

### 새 예제 추가

1. `lib/screen/<category>/xxx_screen.dart` 작성
2. `lib/example_data.dart`에 import(카테고리별 주석 구역) + `ExampleData.items`에 `ExampleItem` 추가
3. 패키지를 새로 넣었다면 `totalPackages`와 README 갱신

### 공통 UI 규칙

- 섹션 헤더·카드·정보 박스·코드 블록은 직접 만들지 말고 `lib/screen/widget/example_widgets.dart`의 공통 위젯을 쓴다: `SectionHeader`, `ExampleCard`, `DemoCard`, `InfoBox`, `InfoItem`, `CodeBlock`, `MethodCard`, `PackageItem`, `showResultDialog()`. 스낵바는 `snackBarView()`.
- `Scaffold`는 래퍼 없이 Flutter 기본 위젯을 그대로 쓴다 (인자만 넘기던 `DefaultScaffold`는 제거됨). `SafeArea`·키보드 닫기 같은 공통 동작이 실제로 필요해질 때만 래퍼를 추가한다.
- 오픈소스 라이선스 화면은 내장 `showLicensePage()`를 쓴다. 패키지를 추가·삭제해도 별도 생성 스크립트가 필요 없다.
