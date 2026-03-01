import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_view/flutter_code_view.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

import '../widget/default_scaffold.dart';

class CodeViewScreen extends StatefulWidget {
  const CodeViewScreen({super.key});

  @override
  State<CodeViewScreen> createState() => _CodeViewScreenState();
}

class _CodeViewScreenState extends State<CodeViewScreen> {
  Highlighter? _lightHighlighter;
  Highlighter? _darkHighlighter;

  // flutter_code_view 테마 선택
  int _codeViewThemeIndex = 0;
  final List<ThemeType> _codeViewThemes = [
    ThemeType.atomOneDark,
    ThemeType.atomOneLight,
    ThemeType.github,
    ThemeType.monokai,
    ThemeType.dracula,
    ThemeType.vs,
    ThemeType.nightOwl,
  ];
  final List<String> _codeViewThemeNames = [
    'Atom Dark',
    'Atom Light',
    'GitHub',
    'Monokai',
    'Dracula',
    'VS Code',
    'Night Owl',
  ];

  // syntax_highlight 테마 선택
  bool _useDarkTheme = true;

  @override
  void initState() {
    super.initState();
    _initSyntaxHighlight();
  }

  Future<void> _initSyntaxHighlight() async {
    await Highlighter.initialize(['dart']);

    var lightTheme = await HighlighterTheme.loadLightTheme();
    var darkTheme = await HighlighterTheme.loadDarkTheme();

    setState(() {
      _lightHighlighter = Highlighter(
        language: 'dart',
        theme: lightTheme,
      );
      _darkHighlighter = Highlighter(
        language: 'dart',
        theme: darkTheme,
      );
    });
  }

  final String _sampleCode = '''// Flutter Example Code
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Text('Count: \$_counter'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}''';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('Code View'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 헤더
          Text(
            '코드 하이라이팅 & 표시',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '다양한 방법으로 코드 표시하기',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 24),

          // ── 1. 기본 Text 위젯 ──
          _buildSectionHeader(theme, '1. 기본 Text 위젯 (monospace)'),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Text 위젯',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _copyCode(context),
                      icon: const Icon(Icons.copy, size: 20),
                      tooltip: '복사',
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxHeight: 300),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      _sampleCode,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        height: 1.5,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '❌ 하이라이팅 없음 • 단순 표시만 가능',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── 2. flutter_code_view ──
          _buildSectionHeader(theme, '2. flutter_code_view'),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'flutter_code_view',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 테마 전환 버튼
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.palette, size: 14),
                              const SizedBox(width: 4),
                              DropdownButton<int>(
                                value: _codeViewThemeIndex,
                                underline: const SizedBox(),
                                isDense: true,
                                items: List.generate(
                                  _codeViewThemes.length,
                                      (index) => DropdownMenuItem(
                                    value: index,
                                    child: Text(
                                      _codeViewThemeNames[index],
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _codeViewThemeIndex = value;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => _copyCode(context),
                          icon: const Icon(Icons.copy, size: 20),
                          tooltip: '복사',
                        ),
                      ],
                    ),
                  ],
                ),
                FlutterCodeView(
                  source: _sampleCode,
                  themeType: _codeViewThemes[_codeViewThemeIndex],
                  language: Languages.dart,
                  autoDetection: true,
                  height: 400,
                  showLineNumbers: false,
                  selectionColor: Colors.blue.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '✅ 예쁜 하이라이팅 • 다양한 테마 • 복사 기능',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── 3. syntax_highlight ──
          _buildSectionHeader(theme, '3. syntax_highlight (Google 공식)'),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'syntax_highlight',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 테마 전환 버튼
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _useDarkTheme ? Icons.dark_mode : Icons.light_mode,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              DropdownButton<bool>(
                                value: _useDarkTheme,
                                underline: const SizedBox(),
                                isDense: true,
                                items: const [
                                  DropdownMenuItem(
                                    value: true,
                                    child: Text('Dark'),
                                  ),
                                  DropdownMenuItem(
                                    value: false,
                                    child: Text('Light'),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _useDarkTheme = value;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => _copyCode(context),
                          icon: const Icon(Icons.copy, size: 20),
                          tooltip: '복사',
                        ),
                      ],
                    ),
                  ],
                ),
                if (_darkHighlighter != null && _lightHighlighter != null)
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxHeight: 400),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _useDarkTheme ? Colors.black87 : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Text.rich(
                        _useDarkTheme
                            ? _darkHighlighter!.highlight(_sampleCode)
                            : _lightHighlighter!.highlight(_sampleCode),
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(
                    height: 300,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '✅ Google 공식 • Light/Dark 테마 • 가벼움',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── 비교표 ──
          _buildSectionHeader(theme, '패키지 비교'),
          const SizedBox(height: 12),

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
                    Expanded(
                      flex: 2,
                      child: Text(
                        '기능',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Text',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'CodeView',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Syntax',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                _buildComparisonRow(
                  theme: theme,
                  feature: '하이라이팅',
                  text: '❌',
                  codeView: '✅',
                  syntaxHighlight: '✅',
                ),
                const Divider(),
                _buildComparisonRow(
                  theme: theme,
                  feature: '다양한 테마',
                  text: '❌',
                  codeView: '✅',
                  syntaxHighlight: '❌',
                ),
                const Divider(),
                _buildComparisonRow(
                  theme: theme,
                  feature: '앱 테마 연동',
                  text: '❌',
                  codeView: '❌',
                  syntaxHighlight: '✅',
                ),
                const Divider(),
                _buildComparisonRow(
                  theme: theme,
                  feature: '사용 편의성',
                  text: '⭐⭐⭐',
                  codeView: '⭐⭐⭐⭐',
                  syntaxHighlight: '⭐⭐⭐⭐',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── 실무 팁 ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: theme.colorScheme.tertiary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '💡 실무 팁',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                _buildTipItem(
                  theme: theme,
                  icon: Icons.code,
                  text: '간단한 코드 스니펫 → Text (monospace)',
                ),
                _buildTipItem(
                  theme: theme,
                  icon: Icons.color_lens,
                  text: '예쁜 코드 예제 표시 → flutter_code_view',
                ),
                _buildTipItem(
                  theme: theme,
                  icon: Icons.verified,
                  text: 'Google 공식 패키지 → syntax_highlight',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _copyCode(BuildContext context) {
    Clipboard.setData(ClipboardData(text: _sampleCode));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('코드가 복사되었습니다'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }

  // 섹션 헤더
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

  // 비교 행
  Widget _buildComparisonRow({
    required ThemeData theme,
    required String feature,
    required String text,
    required String codeView,
    required String syntaxHighlight,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            feature,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Text(
            codeView,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Text(
            syntaxHighlight,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  // 팁 아이템
  Widget _buildTipItem({
    required ThemeData theme,
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.tertiary,
        ),
        const SizedBox(width: 8),
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
}