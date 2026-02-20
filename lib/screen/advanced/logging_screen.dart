import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../widget/default_scaffold.dart';

class LoggingScreen extends StatelessWidget {
  const LoggingScreen({super.key});

  // Talker 인스턴스 (앱 전역에서 공유할 때는 싱글톤으로 관리)
  static final _talker = TalkerFlutter.init();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
    );

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('로깅 (Logging)'),
        actions: [
          // TalkerScreen으로 이동
          IconButton(
            icon: const Icon(Icons.monitor_heart_outlined),
            tooltip: 'Talker 로그 보기',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TalkerScreen(talker: _talker),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              '로깅 방법',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '개발 중 디버그 메시지 출력하기',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // ── 1. 기본 방법 ──
            _buildSectionHeader(theme, '기본 로깅 방법'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'print()',
              description: '❌ 프로덕션에서 사용 금지',
              code: "print('message')",
              status: '권장하지 않음',
              statusColor: Colors.red,
              child: FilledButton(
                onPressed: () => print('🔴 print: 테스트 메시지'),
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('실행 (콘솔 확인)'),
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'debugPrint()',
              description: '✅ Flutter 권장 방법',
              code: "debugPrint('message')",
              status: '권장',
              statusColor: Colors.green,
              child: FilledButton(
                onPressed: () => debugPrint('🟢 debugPrint: 테스트 메시지'),
                style: FilledButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('실행 (콘솔 확인)'),
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'log()',
              description: '추가 정보 포함 가능 (dart:developer)',
              code: "log('message', name: 'MyApp')",
              status: '권장',
              statusColor: Colors.blue,
              child: FilledButton(
                onPressed: () => log(
                  '🔵 log: 테스트 메시지',
                  name: 'PrintScreen',
                  time: DateTime.now(),
                ),
                style: FilledButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text('실행 (콘솔 확인)'),
              ),
            ),

            const SizedBox(height: 24),

            // ── 2. Logger 패키지 ──
            _buildSectionHeader(theme, 'Logger 패키지'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: theme.colorScheme.primary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '로그 레벨별로 구분하여 출력',
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildLoggerCard(theme: theme, level: 'Trace', emoji: '📍', description: '가장 상세한 로그', code: "logger.t('message')", color: Colors.grey, onPressed: () => logger.t('📍 Trace: 가장 상세한 로그')),
            const SizedBox(height: 8),
            _buildLoggerCard(theme: theme, level: 'Debug', emoji: '🐛', description: '디버깅 정보', code: "logger.d('message')", color: Colors.cyan, onPressed: () => logger.d('🐛 Debug: 디버깅 정보')),
            const SizedBox(height: 8),
            _buildLoggerCard(theme: theme, level: 'Info', emoji: 'ℹ️', description: '일반 정보', code: "logger.i('message')", color: Colors.blue, onPressed: () => logger.i('ℹ️ Info: 일반 정보')),
            const SizedBox(height: 8),
            _buildLoggerCard(theme: theme, level: 'Warning', emoji: '⚠️', description: '경고 메시지', code: "logger.w('message')", color: Colors.orange, onPressed: () => logger.w('⚠️ Warning: 경고 메시지')),
            const SizedBox(height: 8),
            _buildLoggerCard(theme: theme, level: 'Error', emoji: '❌', description: '에러 발생', code: "logger.e('message')", color: Colors.red, onPressed: () => logger.e('❌ Error: 에러 발생')),
            const SizedBox(height: 8),
            _buildLoggerCard(theme: theme, level: 'Fatal', emoji: '💀', description: '치명적 오류', code: "logger.f('message')", color: Colors.purple, onPressed: () => logger.f('💀 Fatal: 치명적 오류')),

            const SizedBox(height: 24),

            // ── 3. Talker 패키지 ──
            _buildSectionHeader(theme, 'Talker 패키지'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.tertiary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.monitor_heart_outlined, color: theme.colorScheme.tertiary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '앱 UI에서 로그 확인 • 히스토리 저장 • 공유 가능',
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildTalkerCard(theme: theme, level: 'verbose', emoji: '📋', description: '상세 로그', code: "talker.verbose('message')", color: Colors.grey, onPressed: () => _talker.verbose('📋 Verbose: 상세 로그')),
            const SizedBox(height: 8),
            _buildTalkerCard(theme: theme, level: 'debug', emoji: '🐛', description: '디버깅 정보', code: "talker.debug('message')", color: Colors.cyan, onPressed: () => _talker.debug('🐛 Debug: 디버깅 정보')),
            const SizedBox(height: 8),
            _buildTalkerCard(theme: theme, level: 'info', emoji: 'ℹ️', description: '일반 정보', code: "talker.info('message')", color: Colors.blue, onPressed: () => _talker.info('ℹ️ Info: 일반 정보')),
            const SizedBox(height: 8),
            _buildTalkerCard(theme: theme, level: 'warning', emoji: '⚠️', description: '경고 메시지', code: "talker.warning('message')", color: Colors.orange, onPressed: () => _talker.warning('⚠️ Warning: 경고 메시지')),
            const SizedBox(height: 8),
            _buildTalkerCard(theme: theme, level: 'error', emoji: '❌', description: '에러 발생', code: "talker.error('message')", color: Colors.red, onPressed: () => _talker.error('❌ Error: 에러 발생')),
            const SizedBox(height: 8),
            _buildTalkerCard(theme: theme, level: 'critical', emoji: '🚨', description: '치명적 오류', code: "talker.critical('message')", color: Colors.deepOrange, onPressed: () => _talker.critical('🚨 Critical: 치명적 오류')),
            const SizedBox(height: 8),

            // 예외 처리 예제
            _buildExampleCard(
              theme: theme,
              title: 'handle() - 예외 처리',
              description: 'Exception/Error를 catch해서 Talker에 전달',
              code: "try { ... } catch (e, st) {\n  talker.handle(e, st);\n}",
              status: 'Talker 전용',
              statusColor: theme.colorScheme.tertiary,
              child: FilledButton(
                onPressed: () {
                  try {
                    throw Exception('테스트 예외 발생!');
                  } catch (e, st) {
                    _talker.handle(e, st, '예외 처리 예제');
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.tertiary,
                ),
                child: const Text('예외 발생 후 handle()'),
              ),
            ),
            const SizedBox(height: 12),

            // TalkerScreen 이동 버튼
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TalkerScreen(talker: _talker),
                  ),
                );
              },
              icon: const Icon(Icons.monitor_heart_outlined),
              label: const Text('TalkerScreen에서 로그 확인하기'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: theme.colorScheme.tertiary,
              ),
            ),

            const SizedBox(height: 24),

            // ── 비교표 ──
            _buildSectionHeader(theme, '비교표'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: Row(
                      children: [
                        Expanded(flex: 2, child: Text('방법', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold))),
                        Expanded(child: Text('릴리즈에서 동작', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                        Expanded(child: Text('로그 레벨 구분', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                        Expanded(child: Text('앱 내 로그 확인', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                      ],
                    ),
                  ),
                  _buildComparisonRow(theme, 'print', '❌', '❌', '❌'),
                  _buildComparisonRow(theme, 'debugPrint', '✅', '❌', '❌'),
                  _buildComparisonRow(theme, 'log', '✅', '❌', '❌'),
                  _buildComparisonRow(theme, 'Logger', '✅', '✅', '❌'),
                  _buildComparisonRow(theme, 'Talker', '✅', '✅', '✅'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── 권장 사항 ──
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
                spacing: 12,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Text('💡 권장 사항', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  _buildInfoItem(theme: theme, text: 'print() 대신 debugPrint() 사용'),
                  _buildInfoItem(theme: theme, text: 'log()는 상세 정보 필요할 때'),
                  _buildInfoItem(theme: theme, text: 'Logger는 레벨 관리가 필요한 중규모 프로젝트에'),
                  _buildInfoItem(theme: theme, text: 'Talker는 UI 로그 뷰어가 필요한 대규모 프로젝트에'),
                  _buildInfoItem(theme: theme, text: 'Release 빌드에서는 자동으로 제거됨'),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
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

  Widget _buildExampleCard({
    required ThemeData theme,
    required String title,
    required String description,
    required String code,
    required String status,
    required Color statusColor,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: statusColor),
                ),
                child: Text(
                  status,
                  style: theme.textTheme.labelSmall?.copyWith(color: statusColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Text(description, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              code,
              style: theme.textTheme.bodyMedium?.copyWith(fontFamily: 'monospace', color: theme.colorScheme.primary),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildLoggerCard({
    required ThemeData theme,
    required String level,
    required String emoji,
    required String description,
    required String code,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                Text(level, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: color)),
                Text(description, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                Text(code, style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace', color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(backgroundColor: color, padding: const EdgeInsets.symmetric(horizontal: 16)),
            child: const Text('실행'),
          ),
        ],
      ),
    );
  }

  // Talker 카드 (Logger 카드와 동일한 구조)
  Widget _buildTalkerCard({
    required ThemeData theme,
    required String level,
    required String emoji,
    required String description,
    required String code,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                Text(level, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: color)),
                Text(description, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                Text(code, style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace', color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(backgroundColor: color, padding: const EdgeInsets.symmetric(horizontal: 16)),
            child: const Text('실행'),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(ThemeData theme, String method, String production, String level, String uiViewer) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.2))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(method, style: theme.textTheme.bodyMedium?.copyWith(fontFamily: 'monospace', fontWeight: FontWeight.w600)),
          ),
          Expanded(child: Text(production, style: theme.textTheme.bodyMedium, textAlign: TextAlign.center)),
          Expanded(child: Text(level, style: theme.textTheme.bodyMedium, textAlign: TextAlign.center)),
          Expanded(child: Text(uiViewer, style: theme.textTheme.bodyMedium, textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget _buildInfoItem({required ThemeData theme, required String text}) {
    return Row(
      children: [
        Icon(Icons.check_circle, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ),
      ],
    );
  }
}