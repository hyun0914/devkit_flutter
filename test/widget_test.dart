import 'package:devkit_flutter/example_data.dart';
import 'package:devkit_flutter/example_list_screen.dart';
import 'package:devkit_flutter/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 테스트 기본 화면(800x600 가로)에서는 홈 화면이 세로로 넘치므로 폰 크기로 맞춘다.
Future<void> pumpHome(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const HomeScreen());
}

void main() {
  testWidgets('HomeScreen 기본 UI 테스트', (WidgetTester tester) async {
    await pumpHome(tester);

    // 타이틀 확인
    expect(find.text('DevKit Flutter'), findsOneWidget);
    expect(find.text('Flutter 개발자 도구'), findsOneWidget);
    expect(find.byIcon(Icons.terminal_rounded), findsOneWidget);

    // 통계 텍스트 확인 (ExampleData에서 자동 계산되는 값)
    expect(find.text('${ExampleData.totalExamples}'), findsOneWidget);
    expect(find.text('${ExampleData.totalCategories}'), findsOneWidget);
    expect(find.text('${ExampleData.totalPackages}+'), findsOneWidget);

    // 카테고리 그리드 & 라이선스 버튼 확인
    expect(find.text(Categories.all), findsOneWidget);
    for (final category in Categories.ordered) {
      expect(find.text(category), findsOneWidget);
    }
    expect(find.text('오픈소스 라이선스'), findsOneWidget);
  });

  testWidgets('카테고리 탭 시 예제 목록으로 네비게이션 테스트', (WidgetTester tester) async {
    // ExampleListScreen이 즐겨찾기를 SharedPreferences에서 읽는다.
    SharedPreferences.setMockInitialValues({});
    await pumpHome(tester);

    await tester.tap(find.text(Categories.basicWidget));
    await tester.pumpAndSettle();

    expect(find.byType(ExampleListScreen), findsOneWidget);
  });
}
