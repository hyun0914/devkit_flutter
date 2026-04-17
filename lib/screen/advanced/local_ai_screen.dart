import 'package:flutter/material.dart';
import 'package:flutter_local_ai/flutter_local_ai.dart';

class LocalAiScreen extends StatefulWidget {
  const LocalAiScreen({super.key});

  @override
  State<LocalAiScreen> createState() => _LocalAiScreenState();
}

class _LocalAiScreenState extends State<LocalAiScreen> {
  final FlutterLocalAi _ai = FlutterLocalAi();
  final TextEditingController _promptController = TextEditingController();

  bool _isAvailable = false;
  bool _isInitialized = false;
  bool _isLoading = false;
  bool _isChecking = true;
  String _result = '';
  String _statusMessage = '기기 지원 여부 확인 중...';

  @override
  void initState() {
    super.initState();
    _checkAvailability();
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  /// 온디바이스 AI 지원 여부 확인
  Future<void> _checkAvailability() async {
    try {
      final isAvailable = await _ai.isAvailable();
      setState(() {
        _isAvailable = isAvailable;
        _isChecking = false;
        _statusMessage = isAvailable ? '지원 기기 ✅' : '미지원 기기 ❌';
      });
    } catch (e) {
      setState(() {
        _isChecking = false;
        _statusMessage = '확인 실패: $e';
      });
    }
  }

  /// AI 초기화 (사용 전 필수)
  Future<void> _initialize() async {
    setState(() => _isLoading = true);
    try {
      await _ai.initialize(instructions: 'You are a helpful assistant.');
      setState(() {
        _isInitialized = true;
        _result = '초기화 완료! 프롬프트를 입력해보세요.';
      });
    } catch (e) {
      setState(() => _result = '초기화 실패: $e\n\n'
          'Android: Google AICore 앱이 설치되어 있어야 합니다.\n'
          '지원 기기: Pixel 9/10, Galaxy S25/S26 등');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 텍스트 생성
  Future<void> _generateText() async {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      final response = await _ai.generateText(prompt: prompt);
      setState(() => _result = response.text ?? '응답 없음');
    } catch (e) {
      setState(() => _result = '생성 실패: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('On-Device AI'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── 1. 패키지 소개 카드 ──────────────────
            _InfoCard(
              title: 'flutter_local_ai',
              items: const [
                '🤖 OS 내장 AI 모델을 사용 (모델 다운로드 불필요)',
                '📱 Android: ML Kit GenAI (Gemini Nano via AICore)',
                '🍎 iOS: Apple Foundation Models (iOS 26.0+)',
                '🖥️ Windows: Windows AI Foundry APIs',
                '🔒 완전 온디바이스 처리 — 인터넷 연결 불필요',
              ],
            ),
            const SizedBox(height: 16),

            // ── 2. 기기 지원 상태 카드 ───────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Step 1. 지원 여부 확인',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '⚠️ AICore 지원 기기만 동작합니다.\n'
                          'Pixel 9/10, Galaxy S25/S26, Z Fold7 등 일부 플래그십 기기',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    if (_isChecking)
                      const Row(
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 8),
                          Text('확인 중...'),
                        ],
                      )
                    else
                      Row(
                        children: [
                          Icon(
                            _isAvailable ? Icons.check_circle : Icons.cancel,
                            color: _isAvailable ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _statusMessage,
                            style: TextStyle(
                              color: _isAvailable ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),
                    // 재확인 버튼
                    OutlinedButton.icon(
                      onPressed: _isChecking ? null : _checkAvailability,
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('다시 확인'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── 3. 초기화 카드 ───────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Step 2. 초기화',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'initialize()로 AI 세션을 시작합니다.\n'
                          'instructions 파라미터로 시스템 프롬프트를 설정할 수 있어요.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    // 코드 스니펫
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'await _ai.initialize(\n'
                            '  instructions: \'You are a helpful assistant.\',\n'
                            ');',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed:
                      (_isAvailable && !_isInitialized && !_isLoading)
                          ? _initialize
                          : null,
                      icon: _isLoading
                          ? const SizedBox(
                        width: 16,
                        height: 16,
                        child:
                        CircularProgressIndicator(strokeWidth: 2),
                      )
                          : Icon(
                        _isInitialized
                            ? Icons.check
                            : Icons.play_arrow,
                      ),
                      label: Text(_isInitialized ? '초기화 완료' : '초기화'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── 4. 텍스트 생성 카드 ──────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Step 3. 텍스트 생성',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'generateText()로 프롬프트를 전달하면 AI가 응답을 생성합니다.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _promptController,
                      enabled: _isInitialized && !_isLoading,
                      decoration: const InputDecoration(
                        hintText: '예: Flutter BLoC을 한 줄로 설명해줘',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed:
                        (_isInitialized && !_isLoading) ? _generateText : null,
                        icon: _isLoading
                            ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Icon(Icons.send),
                        label: Text(_isLoading ? '생성 중...' : '생성'),
                      ),
                    ),
                    if (_result.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 8),
                      const Text(
                        'AI 응답',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          _result,
                          style: const TextStyle(fontSize: 14, height: 1.5),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── 5. 주의사항 카드 ─────────────────────
            _InfoCard(
              title: '⚠️ 주의사항',
              titleColor: Colors.orange,
              items: const [
                'Android: Google AICore 앱이 기기에 설치되어 있어야 동작',
                'AICore 미설치 시 에러 코드 -101 발생',
                '지원 기기가 아닌 경우 isAvailable()이 false 반환',
                '실제 기기에서만 테스트 가능 (에뮬레이터 미지원)',
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── 공통 정보 카드 위젯 ──────────────────────────
class _InfoCard extends StatelessWidget {
  final String title;
  final List<String> items;
  final Color? titleColor;

  const _InfoCard({
    required this.title,
    required this.items,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 8),
            ...items.map(
                  (item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 13, height: 1.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}