import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../example_list_screen.dart';
import '../widget/default_scaffold.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      body: IntroductionScreen(
        // 페이지들
        pages: [
          PageViewModel(
            title: 'DevKit Flutter에 오신 것을 환영합니다',
            body: 'Flutter 개발자를 위한\n위젯 & 패키지 예제 모음',
            image: _buildImage(
              context,
              icon: Icons.rocket_launch,
              color: theme.colorScheme.primary,
            ),
            decoration: PageDecoration(
              titleTextStyle: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
              bodyTextStyle: TextStyle(
                fontSize: 18,
                color: theme.colorScheme.onSurface,
              ),
              imagePadding: const EdgeInsets.all(24),
              pageColor: theme.colorScheme.surface,
              contentMargin: const EdgeInsets.symmetric(horizontal: 24),
            ),
          ),
          PageViewModel(
            title: '45개 이상의 예제',
            body: '실무에서 바로 활용 가능한\n다양한 위젯 예제를 제공합니다',
            image: _buildImage(
              context,
              icon: Icons.widgets,
              color: theme.colorScheme.secondary,
            ),
            decoration: PageDecoration(
              titleTextStyle: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.secondary,
              ),
              bodyTextStyle: TextStyle(
                fontSize: 18,
                color: theme.colorScheme.onSurface,
              ),
              imagePadding: const EdgeInsets.all(24),
              pageColor: theme.colorScheme.surface,
              contentMargin: const EdgeInsets.symmetric(horizontal: 24),
            ),
          ),
          PageViewModel(
            title: '60개 이상의 패키지',
            body: '인기있는 Flutter 패키지를\n한 곳에서 체험해보세요',
            image: _buildImage(
              context,
              icon: Icons.extension,
              color: theme.colorScheme.tertiary,
            ),
            decoration: PageDecoration(
              titleTextStyle: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.tertiary,
              ),
              bodyTextStyle: TextStyle(
                fontSize: 18,
                color: theme.colorScheme.onSurface,
              ),
              imagePadding: const EdgeInsets.all(24),
              pageColor: theme.colorScheme.surface,
              contentMargin: const EdgeInsets.symmetric(horizontal: 24),
            ),
          ),
          PageViewModel(
            title: '지금 바로 시작하세요!',
            body: '모든 예제는 Material 3 디자인으로\n최신 트렌드를 반영했습니다',
            image: _buildImage(
              context,
              icon: Icons.touch_app,
              color: Colors.green,
            ),
            decoration: PageDecoration(
              titleTextStyle: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              bodyTextStyle: TextStyle(
                fontSize: 18,
                color: theme.colorScheme.onSurface,
              ),
              imagePadding: const EdgeInsets.all(24),
              pageColor: theme.colorScheme.surface,
              contentMargin: const EdgeInsets.symmetric(horizontal: 24),
            ),
          ),
        ],

        // 버튼 설정
        done: Text(
          '시작하기',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        onDone: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const ExampleListScreen(),
            ),
          );
        },
        next: Icon(
          Icons.arrow_forward,
          color: theme.colorScheme.primary,
        ),
        showSkipButton: true,
        skip: Text(
          '건너뛰기',
          style: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        onSkip: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const ExampleListScreen(),
            ),
          );
        },

        // 인디케이터 설정
        dotsDecorator: DotsDecorator(
          size: const Size.square(10),
          activeSize: const Size(24, 10),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          color: theme.colorScheme.outlineVariant,
          activeColor: theme.colorScheme.primary,
        ),

        // 애니메이션
        curve: Curves.easeInOut,
        animationDuration: 300,

        // 스타일
        globalBackgroundColor: theme.colorScheme.surface,
        controlsMargin: const EdgeInsets.all(16),
        controlsPadding: const EdgeInsets.all(12),
      ),
    );
  }

  // Placeholder 이미지 생성
  Widget _buildImage(
      BuildContext context, {
        required IconData icon,
        required Color color,
      }) {
    return Center(
      child: Container(
        width: 280,
        height: 280,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 140,
          color: color,
        ),
      ),
    );
  }
}