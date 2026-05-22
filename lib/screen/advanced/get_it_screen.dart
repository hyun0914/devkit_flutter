import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../widget/default_scaffold.dart';

// ── 서비스 정의 ────────────────────────────────────────────────
class ApiService {
  final String baseUrl;
  ApiService({this.baseUrl = 'https://api.example.com'});

  String get(String endpoint) => 'GET $baseUrl/$endpoint';
  String post(String endpoint) => 'POST $baseUrl/$endpoint';
}

class AuthService {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login(String email) {
    _isLoggedIn = true;
  }

  void logout() {
    _isLoggedIn = false;
  }
}

class UserRepository {
  final ApiService _api;
  UserRepository(this._api);

  String fetchUser(int id) => _api.get('users/$id');
}

// ── GetIt 인스턴스 & 등록 ───────────────────────────────────────
final sl = GetIt.instance;

void _setupLocator() {
  if (sl.isRegistered<ApiService>()) return;

  // Singleton — 앱 생명주기 동안 하나의 인스턴스
  sl.registerSingleton<ApiService>(ApiService());

  // LazySingleton — 처음 접근 시 생성
  sl.registerLazySingleton<AuthService>(() => AuthService());

  // Factory — 호출할 때마다 새 인스턴스
  sl.registerFactory<UserRepository>(
    () => UserRepository(sl<ApiService>()),
  );
}

// ── 화면 ──────────────────────────────────────────────────────
class GetItScreen extends StatefulWidget {
  const GetItScreen({super.key});

  @override
  State<GetItScreen> createState() => _GetItScreenState();
}

class _GetItScreenState extends State<GetItScreen> {
  bool _isSetup = false;
  final List<String> _logs = [];

  void _setup() {
    _setupLocator();
    setState(() {
      _isSetup = true;
      _logs.add('✅ GetIt 서비스 등록 완료');
    });
  }

  void _useApiService() {
    final api = sl<ApiService>();
    setState(() {
      _logs.add('ApiService (Singleton)');
      _logs.add('  → ${api.get('posts')}');
    });
  }

  void _useAuthService() {
    final auth = sl<AuthService>();
    auth.login('user@example.com');
    setState(() {
      _logs.add('AuthService (LazySingleton)');
      _logs.add('  → 로그인 상태: ${auth.isLoggedIn}');
    });
  }

  void _useUserRepository() {
    final repo = sl<UserRepository>();
    setState(() {
      _logs.add('UserRepository (Factory)');
      _logs.add('  → ${repo.fetchUser(42)}');
    });
  }

  void _checkSingleton() {
    final a = sl<ApiService>();
    final b = sl<ApiService>();
    setState(() {
      _logs.add('Singleton 동일 인스턴스 확인');
      _logs.add('  → identical(a, b): ${identical(a, b)}');
    });
  }

  void _checkFactory() {
    final a = sl<UserRepository>();
    final b = sl<UserRepository>();
    setState(() {
      _logs.add('Factory 매번 새 인스턴스 확인');
      _logs.add('  → identical(a, b): ${identical(a, b)}');
    });
  }

  void _clearLogs() => setState(() => _logs.clear());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('get_it (의존성 주입)'),
        actions: [
          if (_logs.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all_rounded),
              onPressed: _clearLogs,
              tooltip: '로그 초기화',
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'get_it',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              '서비스 로케이터 패턴 · 의존성 주입',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),

            const SizedBox(height: 24),

            // 등록 타입
            _buildSectionHeader(theme, '등록 타입'),
            const SizedBox(height: 12),
            _buildTypeCard(theme, 'registerSingleton', '항상 같은 인스턴스 반환',
                Colors.blue, '앱 시작 시 즉시 생성'),
            const SizedBox(height: 8),
            _buildTypeCard(theme, 'registerLazySingleton', '항상 같은 인스턴스 반환',
                Colors.green, '처음 접근 시 생성 (지연 초기화)'),
            const SizedBox(height: 8),
            _buildTypeCard(theme, 'registerFactory', '매번 새 인스턴스 반환',
                Colors.orange, '호출할 때마다 새로 생성'),

            const SizedBox(height: 24),

            // 설정 & 테스트
            _buildSectionHeader(theme, '테스트'),
            const SizedBox(height: 12),

            if (!_isSetup)
              FilledButton.icon(
                onPressed: _setup,
                icon: const Icon(Icons.settings_rounded),
                label: const Text('GetIt 서비스 등록'),
                style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)),
              )
            else ...[
              _buildActionButton(theme, Icons.cloud_rounded, 'ApiService 사용',
                  Colors.blue, _useApiService),
              const SizedBox(height: 8),
              _buildActionButton(theme, Icons.person_rounded, 'AuthService 사용',
                  Colors.green, _useAuthService),
              const SizedBox(height: 8),
              _buildActionButton(theme, Icons.storage_rounded,
                  'UserRepository 사용', Colors.orange, _useUserRepository),
              const SizedBox(height: 8),
              _buildActionButton(theme, Icons.compare_arrows_rounded,
                  'Singleton 동일 인스턴스 확인', Colors.blue, _checkSingleton),
              const SizedBox(height: 8),
              _buildActionButton(theme, Icons.fiber_new_rounded,
                  'Factory 새 인스턴스 확인', Colors.orange, _checkFactory),
            ],

            // 로그
            if (_logs.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildSectionHeader(theme, '실행 로그'),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _logs
                      .map((log) => Text(
                            log,
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontFamily: 'monospace',
                              fontSize: 12,
                              height: 1.6,
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // 코드 예시
            _buildSectionHeader(theme, '실제 사용 패턴'),
            const SizedBox(height: 12),
            _buildCodeBlock(theme, '''// main.dart
void main() {
  setupLocator(); // 등록
  runApp(MyApp());
}

// service_locator.dart
final sl = GetIt.instance;

void setupLocator() {
  sl.registerLazySingleton<ApiService>(
    () => ApiService(),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(sl()),
  );
}

// 어디서든 접근
final api = sl<ApiService>();'''),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeCard(ThemeData theme, String method, String behavior,
      Color color, String detail) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(method,
                    style: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                Text(behavior,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: color, fontWeight: FontWeight.w500)),
                Text(detail,
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(ThemeData theme, IconData icon, String label,
      Color color, VoidCallback onPressed) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18, color: color),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(46),
        foregroundColor: color,
        side: BorderSide(color: color.withValues(alpha: 0.4)),
      ),
    );
  }

  Widget _buildCodeBlock(ThemeData theme, String code) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Text(
        code,
        style: theme.textTheme.bodySmall
            ?.copyWith(fontFamily: 'monospace', height: 1.6),
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
