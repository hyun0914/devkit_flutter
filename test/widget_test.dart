import 'package:devkit_flutter/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HomeScreen 기본 UI 테스트', (WidgetTester tester) async {
    // HomeScreen 렌더링
    await tester.pumpWidget(const HomeScreen());

    // 타이틀 확인
    expect(find.text('DevKit Flutter'), findsOneWidget);
    expect(find.text('Flutter 개발자 도구'), findsOneWidget);

    // 통계 텍스트 확인
    expect(find.text('62+'), findsOneWidget); // 총 예제
    expect(find.text('6'), findsOneWidget);   // 카테고리
    expect(find.text('98+'), findsOneWidget); // 패키지

    // 주요 버튼 확인
    expect(find.text('예제 앱 화면 열기'), findsOneWidget);
    expect(find.text('네트워크 상태 체크'), findsOneWidget);
    expect(find.text('오픈소스 라이선스'), findsOneWidget);
  });

  testWidgets('HomeScreen 아이콘 확인', (WidgetTester tester) async {
    await tester.pumpWidget(const HomeScreen());

    // 주요 아이콘들 존재 확인
    expect(find.byIcon(Icons.terminal_rounded), findsOneWidget);
    expect(find.byIcon(Icons.analytics_outlined), findsOneWidget);
    expect(find.byIcon(Icons.widgets_outlined), findsOneWidget);
    expect(find.byIcon(Icons.apps_rounded), findsOneWidget);
    expect(find.byIcon(Icons.wifi_tethering_rounded), findsOneWidget);
    expect(find.byIcon(Icons.description_outlined), findsOneWidget);
  });

  testWidgets('예제 앱 화면으로 네비게이션 테스트', (WidgetTester tester) async {
    await tester.pumpWidget(const HomeScreen());

    // "예제 앱 화면 열기" 버튼 찾기
    final exampleButton = find.text('예제 앱 화면 열기');
    expect(exampleButton, findsOneWidget);

    // 버튼 탭하고 네비게이션 완료 대기
    await tester.tap(exampleButton);
    await tester.pumpAndSettle();

    // ExampleListScreen으로 이동했는지 확인
    // ExampleListScreen에 있는 요소 확인 (카테고리 버튼)
    expect(find.text('기본 위젯'), findsWidgets);
  });
}