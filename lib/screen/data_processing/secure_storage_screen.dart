import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/default_scaffold.dart';

class SecureStorageScreen extends StatefulWidget {
  const SecureStorageScreen({super.key});

  @override
  State<SecureStorageScreen> createState() => _SecureStorageScreenState();
}

class _SecureStorageScreenState extends State<SecureStorageScreen> {
  static const _storage = FlutterSecureStorage();

  // 저장된 데이터
  String? _authToken;
  String? _userName;
  String? _lastLogin;
  bool _isFirstLaunch = true;

  // 입력 컨트롤러
  final _keyController = TextEditingController();
  final _valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _clearSecureStorageOnReinstall();
    _loadData();
  }

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  // iOS에서 앱 재설치 시 secure storage 클리어
  Future<void> _clearSecureStorageOnReinstall() async {
    const key = 'hasRunBefore';
    final prefs = await SharedPreferences.getInstance();
    final hasRunBefore = prefs.getBool(key) ?? false;

    if (!hasRunBefore) {
      await _storage.deleteAll();
      await prefs.setBool(key, true);
      debugPrint('Secure storage cleared on fresh install');
    }
  }

  // 저장된 데이터 로드
  Future<void> _loadData() async {
    final authToken = await _storage.read(key: 'auth_token');
    final userName = await _storage.read(key: 'user_name');
    final lastLogin = await _storage.read(key: 'last_login');
    final firstLaunch = await _storage.read(key: 'first_launch');

    setState(() {
      _authToken = authToken;
      _userName = userName;
      _lastLogin = lastLogin;
      _isFirstLaunch = firstLaunch == null || firstLaunch == 'true';
    });
  }

  // 샘플 로그인 시뮬레이션
  Future<void> _simulateLogin() async {
    await _storage.write(key: 'auth_token', value: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...');
    await _storage.write(key: 'user_name', value: 'flutter_user');
    await _storage.write(key: 'last_login', value: DateTime.now().toString());
    await _storage.write(key: 'first_launch', value: 'false');

    await _loadData();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 정보가 안전하게 저장되었습니다')),
      );
    }
  }

  // 로그아웃 (저장된 데이터 삭제)
  Future<void> _simulateLogout() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_name');
    await _storage.delete(key: 'last_login');

    await _loadData();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그아웃되었습니다')),
      );
    }
  }

  // 커스텀 key-value 저장
  Future<void> _saveCustomData() async {
    if (_keyController.text.isEmpty || _valueController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('키와 값을 모두 입력하세요')),
      );
      return;
    }

    await _storage.write(key: _keyController.text, value: _valueController.text);
    _keyController.clear();
    _valueController.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('데이터가 안전하게 저장되었습니다')),
      );
    }
  }

  // 커스텀 key로 조회
  Future<void> _readCustomData() async {
    if (_keyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('조회할 키를 입력하세요')),
      );
      return;
    }

    final value = await _storage.read(key: _keyController.text);

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('저장된 값: ${_keyController.text}'),
          content: Text(value ?? '(값이 없습니다)'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  // 전체 데이터 조회
  Future<void> _showAllData() async {
    final allData = await _storage.readAll();

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('저장된 모든 데이터'),
          content: SizedBox(
            width: double.maxFinite,
            child: allData.isEmpty
                ? const Text('저장된 데이터가 없습니다')
                : ListView.builder(
              shrinkWrap: true,
              itemCount: allData.length,
              itemBuilder: (context, index) {
                final entry = allData.entries.elementAt(index);
                return ListTile(
                  title: Text(entry.key),
                  subtitle: Text(
                    entry.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  dense: true,
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('닫기'),
            ),
          ],
        ),
      );
    }
  }

  // 모든 데이터 삭제
  Future<void> _deleteAllData() async {
    await _storage.deleteAll();
    await _loadData();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 데이터가 삭제되었습니다')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('보안 저장소'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              'Secure Storage',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '민감한 데이터를 암호화하여 안전하게 저장',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 16),

            // iOS 주의사항
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Row(
                    children: [
                      Icon(Icons.apple, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'iOS 주의사항',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'iOS에서는 앱 삭제 후에도 Keychain 데이터가 남아있습니다. '
                        '재설치 시 자동으로 클리어되도록 구현되어 있습니다.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.blue.shade800,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 로그인 시뮬레이션 섹션
            _buildSectionHeader(theme, Icons.account_circle, '로그인 시뮬레이션'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  _buildDataRow(theme, '인증 토큰', _authToken, Icons.vpn_key),
                  _buildDataRow(theme, '사용자명', _userName, Icons.person),
                  _buildDataRow(theme, '마지막 로그인', _lastLogin, Icons.access_time),
                  _buildDataRow(
                    theme,
                    '최초 실행',
                    _isFirstLaunch ? '예' : '아니오',
                    Icons.new_releases,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _simulateLogin,
                          icon: const Icon(Icons.login, size: 18),
                          label: const Text('로그인'),
                        ),
                      ),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _authToken == null ? null : _simulateLogout,
                          icon: const Icon(Icons.logout, size: 18),
                          label: const Text('로그아웃'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 커스텀 데이터 저장 섹션
            _buildSectionHeader(theme, Icons.storage, '커스텀 데이터 관리'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  TextField(
                    controller: _keyController,
                    decoration: const InputDecoration(
                      labelText: 'Key',
                      hintText: '예: api_key',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextField(
                    controller: _valueController,
                    decoration: const InputDecoration(
                      labelText: 'Value',
                      hintText: '예: my_secret_key_123',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _saveCustomData,
                          icon: const Icon(Icons.save, size: 18),
                          label: const Text('저장'),
                        ),
                      ),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _readCustomData,
                          icon: const Icon(Icons.search, size: 18),
                          label: const Text('조회'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 전체 관리 섹션
            _buildSectionHeader(theme, Icons.manage_search, '전체 데이터 관리'),
            const SizedBox(height: 12),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _showAllData,
                    icon: const Icon(Icons.list, size: 18),
                    label: const Text('전체 조회'),
                  ),
                ),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _deleteAllData,
                    icon: const Icon(Icons.delete_sweep, size: 18),
                    label: const Text('전체 삭제'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 활용 예시
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '💡 실무 활용 예시',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  _buildUseCaseItem(theme, Icons.vpn_key, '인증 토큰 (JWT)'),
                  _buildUseCaseItem(theme, Icons.lock, '비밀번호'),
                  _buildUseCaseItem(theme, Icons.credit_card, '결제 정보'),
                  _buildUseCaseItem(theme, Icons.key, 'API 키'),
                  _buildUseCaseItem(theme, Icons.fingerprint, '생체인증 데이터'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 플랫폼별 저장소 안내
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '플랫폼별 저장소',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  _buildPlatformItem(theme, 'iOS/macOS', 'Keychain'),
                  _buildPlatformItem(theme, 'Android', 'Custom Secure Ciphers (RSA+AES)'),
                  _buildPlatformItem(theme, 'Windows', 'wincred.h'),
                  _buildPlatformItem(theme, 'Linux', 'libsecret'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 24),
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

  Widget _buildDataRow(ThemeData theme, String label, String? value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary.withValues(alpha: 0.7)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value ?? '(없음)',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: value != null ? 'monospace' : null,
                  color: value != null ? theme.colorScheme.onSurface : theme.colorScheme.outline,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUseCaseItem(ThemeData theme, IconData icon, String text) {
    return Row(
      spacing: 12,
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary.withValues(alpha: 0.7)),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlatformItem(ThemeData theme, String platform, String storage) {
    return Padding(
      padding: const EdgeInsets.only(left: 28),
      child: Row(
        children: [
          Text(
            '• $platform: ',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            storage,
            style: theme.textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}