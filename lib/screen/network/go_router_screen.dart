import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widget/default_scaffold.dart';

// ── GoRouter 설정 ──────────────────────────────────────────────
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const _HomeScreen(),
      routes: [
        GoRoute(
          path: 'detail/:id',
          builder: (context, state) => _DetailScreen(
            id: state.pathParameters['id'] ?? '?',
          ),
        ),
        GoRoute(
          path: 'profile',
          redirect: (context, state) {
            // 실제 앱: 미로그인 시 '/'로 redirect
            // return isLoggedIn ? null : '/';
            return null;
          },
          builder: (context, state) => const _ProfileScreen(),
        ),
      ],
    ),
  ],
);

// ── 진입 화면 (예제 설명 + 데모 실행) ──────────────────────────
class GoRouterScreen extends StatelessWidget {
  const GoRouterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(title: const Text('go_router')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'go_router',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              '선언적 라우팅 & 딥링크',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),

            const SizedBox(height: 24),

            // 핵심 개념
            _buildSectionHeader(theme, '핵심 개념'),
            const SizedBox(height: 12),
            _buildConceptCard(theme, Icons.map_rounded, '선언적 라우트 정의',
                'GoRoute로 경로와 화면을 매핑. 중첩 라우트 지원.'),
            const SizedBox(height: 8),
            _buildConceptCard(theme, Icons.link_rounded, '딥링크 지원',
                'URL 기반 라우팅으로 딥링크 자동 처리.'),
            const SizedBox(height: 8),
            _buildConceptCard(theme, Icons.security_rounded, 'Redirect / Guard',
                '페이지 진입 전 조건 체크 (로그인 여부 등).'),
            const SizedBox(height: 8),
            _buildConceptCard(theme, Icons.code_rounded, 'Path Parameters',
                '/detail/:id 형태로 경로 파라미터 전달.'),

            const SizedBox(height: 24),

            // 코드 예시
            _buildSectionHeader(theme, '라우트 정의'),
            const SizedBox(height: 12),
            _buildCodeBlock(theme, '''GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
      routes: [
        GoRoute(
          path: 'detail/:id',
          builder: (context, state) => DetailScreen(
            id: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: 'profile',
          redirect: (context, state) {
            return isLoggedIn ? null : '/';
          },
          builder: (context, state) => ProfileScreen(),
        ),
      ],
    ),
  ],
);'''),

            const SizedBox(height: 24),

            // 네비게이션 방식
            _buildSectionHeader(theme, '네비게이션'),
            const SizedBox(height: 12),
            _buildCodeBlock(theme, '''// push — 스택에 쌓기
context.push('/detail/42');

// go — 스택 교체
context.go('/profile');

// pop — 뒤로가기
context.pop();

// 이름 기반 (name 지정 시)
context.goNamed('profile');'''),

            const SizedBox(height: 24),

            // 데모 실행
            _buildSectionHeader(theme, '데모'),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const _GoRouterDemoApp(),
                    fullscreenDialog: true,
                  ),
                );
              },
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('go_router 데모 실행'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConceptCard(
      ThemeData theme, IconData icon, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                Text(desc,
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeBlock(ThemeData theme, String code) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Text(
        code,
        style: theme.textTheme.bodySmall?.copyWith(
          fontFamily: 'monospace',
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

// ── 데모 앱 (GoRouter 기반 MaterialApp) ───────────────────────
class _GoRouterDemoApp extends StatelessWidget {
  const _GoRouterDemoApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'go_router 데모',
      theme: Theme.of(context),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}

// ── 데모 - 홈 ─────────────────────────────────────────────────
class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('go_router 데모',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('현재 경로: /',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontFamily: 'monospace')),
              const SizedBox(height: 32),
              _NavButton(
                label: 'context.push(\'/detail/42\')',
                description: '스택에 쌓기 — 뒤로가기 가능',
                icon: Icons.arrow_forward_rounded,
                onPressed: () => context.push('/detail/42'),
              ),
              const SizedBox(height: 12),
              _NavButton(
                label: 'context.go(\'/profile\')',
                description: '스택 교체 — 뒤로가기 불가',
                icon: Icons.swap_horiz_rounded,
                onPressed: () => context.go('/profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 데모 - 상세 (Path Parameter) ──────────────────────────────
class _DetailScreen extends StatelessWidget {
  final String id;
  const _DetailScreen({required this.id});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('상세'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('상세 화면',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('현재 경로: /detail/$id',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontFamily: 'monospace')),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Path Parameter',
                        style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 4),
                    Text('state.pathParameters[\'id\'] = "$id"',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('context.pop()'),
                style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 데모 - 프로필 (Redirect) ───────────────────────────────────
class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('프로필')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('프로필 화면',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('현재 경로: /profile',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontFamily: 'monospace')),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Colors.green),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'redirect에서 로그인 확인 후 진입 허용됨',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.home_rounded),
                label: const Text('context.go(\'/\')'),
                style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 공통 네비게이션 버튼 ────────────────────────────────────────
class _NavButton extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final VoidCallback onPressed;

  const _NavButton({
    required this.label,
    required this.description,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: theme.colorScheme.primary, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(description,
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
