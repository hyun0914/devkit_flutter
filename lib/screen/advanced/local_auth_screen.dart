import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../widget/default_scaffold.dart';

class LocalAuthScreen extends StatefulWidget {
  const LocalAuthScreen({super.key});

  @override
  State<LocalAuthScreen> createState() => _LocalAuthScreenState();
}

class _LocalAuthScreenState extends State<LocalAuthScreen> {
  final _auth = LocalAuthentication();

  bool _isSupported = false;
  bool _isDeviceSupported = false;
  List<BiometricType> _availableBiometrics = [];
  String _authResult = '';
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _checkSupport();
  }

  Future<void> _checkSupport() async {
    bool isSupported = false;
    bool isDeviceSupported = false;
    List<BiometricType> biometrics = [];

    isDeviceSupported = await _auth.isDeviceSupported();
    isSupported = await _auth.canCheckBiometrics;
    biometrics = await _auth.getAvailableBiometrics();

    setState(() {
      _isSupported = isSupported;
      _isDeviceSupported = isDeviceSupported;
      _availableBiometrics = biometrics;
    });
  }

  Future<void> _authenticate() async {
    setState(() {
      _isAuthenticating = true;
      _authResult = '';
    });

    try {
      final authenticated = await _auth.authenticate(
        localizedReason: '생체 인증으로 본인 확인을 해주세요',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      setState(() {
        _authResult = authenticated ? '✅ 인증 성공' : '❌ 인증 실패';
      });
    } on PlatformException catch (e) {
      setState(() {
        _authResult = '오류: ${e.message}';
      });
    } finally {
      setState(() => _isAuthenticating = false);
    }
  }

  Future<void> _cancelAuthentication() async {
    await _auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  String _biometricName(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return 'Face ID';
      case BiometricType.fingerprint:
        return '지문 인식';
      case BiometricType.iris:
        return '홍채 인식';
      case BiometricType.strong:
        return '강한 생체 인증';
      case BiometricType.weak:
        return '약한 생체 인증';
    }
  }

  IconData _biometricIcon(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return Icons.face_rounded;
      case BiometricType.fingerprint:
        return Icons.fingerprint_rounded;
      case BiometricType.iris:
        return Icons.remove_red_eye_rounded;
      default:
        return Icons.security_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(title: const Text('생체 인증 (local_auth)')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'local_auth',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              '지문 / Face ID / PIN 인증',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),

            const SizedBox(height: 24),

            // 기기 지원 현황
            _buildSectionHeader(theme, '기기 지원 현황'),
            const SizedBox(height: 12),
            _buildSupportCard(theme),

            const SizedBox(height: 24),

            // 사용 가능한 생체 인식
            if (_availableBiometrics.isNotEmpty) ...[
              _buildSectionHeader(theme, '사용 가능한 인증 방식'),
              const SizedBox(height: 12),
              ..._availableBiometrics.map(
                (type) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(_biometricIcon(type),
                            color: theme.colorScheme.primary),
                        const SizedBox(width: 12),
                        Text(
                          _biometricName(type),
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // 인증 버튼
            _buildSectionHeader(theme, '인증 테스트'),
            const SizedBox(height: 12),

            if (_isAuthenticating)
              FilledButton.icon(
                onPressed: _cancelAuthentication,
                icon: const Icon(Icons.cancel_outlined),
                label: const Text('인증 취소'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  backgroundColor: theme.colorScheme.error,
                ),
              )
            else
              FilledButton.icon(
                onPressed: _isDeviceSupported ? _authenticate : null,
                icon: const Icon(Icons.fingerprint_rounded),
                label: const Text('생체 인증 실행'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
              ),

            if (!_isDeviceSupported)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '이 기기는 생체 인증을 지원하지 않습니다',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            // 결과
            if (_authResult.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _authResult.contains('✅')
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _authResult.contains('✅')
                        ? Colors.green.withValues(alpha: 0.3)
                        : Colors.red.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  _authResult,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],

            const SizedBox(height: 24),

            // 플랫폼 설정 안내
            _buildSectionHeader(theme, '플랫폼 설정'),
            const SizedBox(height: 12),
            _buildPlatformGuide(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          _buildSupportRow(theme, '기기 생체 인증 지원', _isDeviceSupported),
          const Divider(height: 24),
          _buildSupportRow(theme, '생체 인식 등록됨', _isSupported),
        ],
      ),
    );
  }

  Widget _buildSupportRow(ThemeData theme, String label, bool supported) {
    return Row(
      children: [
        Icon(
          supported ? Icons.check_circle_rounded : Icons.cancel_rounded,
          color: supported ? Colors.green : Colors.red,
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(label, style: theme.textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildPlatformGuide(ThemeData theme) {
    final isIOS = Platform.isIOS;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(isIOS ? Icons.apple : Icons.android,
                  color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                isIOS ? 'iOS 설정' : 'Android 설정',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (isIOS) ...[
            _buildGuideItem(theme, 'Info.plist에 NSFaceIDUsageDescription 추가'),
          ] else ...[
            _buildGuideItem(
                theme, 'AndroidManifest.xml에 USE_BIOMETRIC 권한 추가'),
            _buildGuideItem(
                theme, 'FlutterFragmentActivity로 MainActivity 변경'),
          ],
        ],
      ),
    );
  }

  Widget _buildGuideItem(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.arrow_right_rounded,
              size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 4),
          Expanded(
            child: Text(text,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                )),
          ),
        ],
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
