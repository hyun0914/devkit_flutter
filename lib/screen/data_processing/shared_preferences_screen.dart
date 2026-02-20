import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/default_scaffold.dart';

class SharedPreferencesScreen extends StatefulWidget {
  const SharedPreferencesScreen({super.key});

  @override
  State<SharedPreferencesScreen> createState() =>
      _SharedPreferencesScreenState();
}

class _SharedPreferencesScreenState extends State<SharedPreferencesScreen> {
  late SharedPreferences _prefs;
  bool _isLoaded = false;

  // 저장된 값들
  int? _number;
  double? _decimal;
  bool? _boolean;
  String? _text;
  List<String>? _stringList;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadValues();
  }

  void _loadValues() {
    setState(() {
      _number = _prefs.getInt('number');
      _decimal = _prefs.getDouble('decimal');
      _boolean = _prefs.getBool('boolean');
      _text = _prefs.getString('text');
      _stringList = _prefs.getStringList('stringList');
      _isLoaded = true;
    });
  }

  Future<void> _saveAllData() async {
    await _prefs.setInt('number', 12345);
    await _prefs.setDouble('decimal', 3.14159);
    await _prefs.setBool('boolean', true);
    await _prefs.setString('text', 'Hello, SharedPreferences!');
    await _prefs.setStringList('stringList', ['Flutter', 'Dart', 'Mobile']);

    _loadValues();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ 모든 데이터 저장 완료'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _clearAllData() async {
    await _prefs.clear();
    _loadValues();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🗑️ 모든 데이터 삭제 완료'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _showEditDialog(String key, dynamic currentValue) async {
    final TextEditingController controller = TextEditingController(
      text: currentValue?.toString() ?? '',
    );

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$key 수정'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: '값을 입력하세요',
              border: const OutlineInputBorder(),
              labelText: key,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: const Text('저장'),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      await _updateValue(key, result);
    }
  }

  Future<void> _updateValue(String key, String value) async {
    switch (key) {
      case 'number':
        final intValue = int.tryParse(value);
        if (intValue != null) {
          await _prefs.setInt(key, intValue);
        }
        break;
      case 'decimal':
        final doubleValue = double.tryParse(value);
        if (doubleValue != null) {
          await _prefs.setDouble(key, doubleValue);
        }
        break;
      case 'boolean':
        final boolValue = value.toLowerCase() == 'true';
        await _prefs.setBool(key, boolValue);
        break;
      case 'text':
        await _prefs.setString(key, value);
        break;
    }
    _loadValues();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!_isLoaded) {
      return DefaultScaffold(
        appBar: AppBar(
          title: const Text('SharedPreferences'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('SharedPreferences'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              'SharedPreferences',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '로컬 저장소 (키-값 쌍)',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // 버튼들
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _saveAllData,
                    icon: const Icon(Icons.save),
                    label: const Text('샘플 저장'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: _clearAllData,
                    icon: const Icon(Icons.delete),
                    label: const Text('전체 삭제'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 섹션 헤더
            _buildSectionHeader(theme, '저장된 데이터'),
            const SizedBox(height: 12),

            // 1. Int
            _buildDataCard(
              theme: theme,
              title: 'Int (정수)',
              key: 'number',
              value: _number,
              icon: Icons.numbers,
              color: theme.colorScheme.primaryContainer,
              onTap: () => _showEditDialog('number', _number),
            ),

            const SizedBox(height: 12),

            // 2. Double
            _buildDataCard(
              theme: theme,
              title: 'Double (실수)',
              key: 'decimal',
              value: _decimal,
              icon: Icons.calculate,
              color: theme.colorScheme.secondaryContainer,
              onTap: () => _showEditDialog('decimal', _decimal),
            ),

            const SizedBox(height: 12),

            // 3. Bool
            _buildDataCard(
              theme: theme,
              title: 'Bool (참/거짓)',
              key: 'boolean',
              value: _boolean,
              icon: Icons.toggle_on,
              color: theme.colorScheme.tertiaryContainer,
              onTap: () => _showEditDialog('boolean', _boolean),
            ),

            const SizedBox(height: 12),

            // 4. String
            _buildDataCard(
              theme: theme,
              title: 'String (문자열)',
              key: 'text',
              value: _text,
              icon: Icons.text_fields,
              color: theme.colorScheme.errorContainer,
              onTap: () => _showEditDialog('text', _text),
            ),

            const SizedBox(height: 12),

            // 5. List<String>
            _buildListCard(
              theme: theme,
              title: 'List<String> (문자열 리스트)',
              key: 'stringList',
              value: _stringList,
              icon: Icons.list,
            ),

            const SizedBox(height: 24),

            // 기능 설명
            _buildSectionHeader(theme, '주요 기능'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '💡 기능',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    theme: theme,
                    text: '5가지 데이터 타입 지원',
                  ),
                  const SizedBox(height: 8),
                  _buildFeatureItem(
                    theme: theme,
                    text: '앱 재시작 후에도 유지',
                  ),
                  const SizedBox(height: 8),
                  _buildFeatureItem(
                    theme: theme,
                    text: '간단한 설정/환경변수 저장',
                  ),
                  const SizedBox(height: 8),
                  _buildFeatureItem(
                    theme: theme,
                    text: '카드 탭으로 값 수정 가능',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 패키지 정보
            _buildSectionHeader(theme, '사용된 패키지'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.extension,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: theme.textTheme.bodySmall,
                        children: [
                          const TextSpan(
                            text: 'shared_preferences',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                            ),
                          ),
                          TextSpan(
                            text: ' - 로컬 키-값 저장소',
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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

  // 데이터 카드
  Widget _buildDataCard({
    required ThemeData theme,
    required String title,
    required String key,
    required dynamic value,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value?.toString() ?? '값 없음',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.edit,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  // 리스트 카드
  Widget _buildListCard({
    required ThemeData theme,
    required String title,
    required String key,
    required List<String>? value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 16),
              Text(
                title,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (value != null && value.isNotEmpty)
            ...value.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ))
          else
            Text(
              '값 없음',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }

  // 기능 아이템
  Widget _buildFeatureItem({
    required ThemeData theme,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          Icons.check_circle,
          size: 16,
          color: theme.colorScheme.primary,
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