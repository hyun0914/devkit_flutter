import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../widget/default_scaffold.dart';

class ButtonStyleScreen extends StatelessWidget {
  const ButtonStyleScreen({super.key});

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('버튼 스타일'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Text(
              '클릭 & 버튼 위젯',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '다양한 클릭 이벤트와 버튼 스타일',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // 클릭 감지 위젯
            _buildSectionHeader(theme, '클릭 감지 위젯'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'InkWell',
              description: '물결 효과가 있는 클릭 영역',
              child: Center(
                child: InkWell(
                  onTap: () => _showSnackBar(context, 'InkWell 클릭'),
                  borderRadius: BorderRadius.circular(8),
                  child: Ink(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('InkWell (물결 효과)'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'GestureDetector',
              description: '다양한 제스처 감지',
              child: Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showSnackBar(context, 'onTap'),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '탭',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onDoubleTap: () => _showSnackBar(context, 'onDoubleTap'),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '더블탭',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onLongPress: () => _showSnackBar(context, 'onLongPress'),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '길게누르기',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Material 3 버튼
            _buildSectionHeader(theme, 'Material 3 버튼'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'FilledButton (권장)',
              description: 'Material 3의 주요 액션 버튼',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  FilledButton(
                    onPressed: () => _showSnackBar(context, 'FilledButton'),
                    child: const Text('Filled'),
                  ),
                  FilledButton.icon(
                    onPressed: () => _showSnackBar(context, 'FilledButton.icon'),
                    icon: const Icon(Icons.add),
                    label: const Text('아이콘'),
                  ),
                  FilledButton.tonal(
                    onPressed: () => _showSnackBar(context, 'FilledButton.tonal'),
                    child: const Text('Tonal'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'ElevatedButton',
              description: '그림자가 있는 버튼',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton(
                    onPressed: () => _showSnackBar(context, 'ElevatedButton'),
                    child: const Text('Elevated'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showSnackBar(context, 'ElevatedButton.icon'),
                    icon: const Icon(Icons.star),
                    label: const Text('아이콘'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'OutlinedButton',
              description: '테두리만 있는 버튼',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  OutlinedButton(
                    onPressed: () => _showSnackBar(context, 'OutlinedButton'),
                    child: const Text('Outlined'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _showSnackBar(context, 'OutlinedButton.icon'),
                    icon: const Icon(Icons.download),
                    label: const Text('아이콘'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'TextButton',
              description: '텍스트만 있는 버튼',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  TextButton(
                    onPressed: () => _showSnackBar(context, 'TextButton'),
                    child: const Text('Text'),
                  ),
                  TextButton.icon(
                    onPressed: () => _showSnackBar(context, 'TextButton.icon'),
                    icon: const Icon(Icons.info),
                    label: const Text('아이콘'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 버튼 스타일링
            _buildSectionHeader(theme, '버튼 스타일 커스터마이징'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'styleFrom으로 커스터마이징',
              description: '색상, 그림자, 테두리 등 설정',
              child: Column(
                spacing: 12,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => _showSnackBar(context, 'styleFrom'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 4,
                        shadowColor: Colors.deepPurple.withValues(alpha: 0.5),
                      ),
                      child: const Text('커스텀 FilledButton'),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _showSnackBar(context, 'styleFrom'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange,
                        side: const BorderSide(color: Colors.orange, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('커스텀 OutlinedButton'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'ButtonStyle로 상태별 스타일',
              description: 'WidgetStateProperty 사용',
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showSnackBar(context, 'ButtonStyle'),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.green.shade700;
                      }
                      return Colors.green;
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.white;
                      }
                      return Colors.black87;
                    }),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  child: const Text('눌렀을 때 색상 변경'),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 버튼 Shape
            _buildSectionHeader(theme, '버튼 Shape'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: '다양한 모양',
              description: 'RoundedRectangle, Beveled, Circle',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton(
                    onPressed: () => _showSnackBar(context, 'RoundedRectangle'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Rounded'),
                  ),
                  ElevatedButton(
                    onPressed: () => _showSnackBar(context, 'BeveledRectangle'),
                    style: ElevatedButton.styleFrom(
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Beveled'),
                  ),
                  ElevatedButton(
                    onPressed: () => _showSnackBar(context, 'Circle'),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: const Text('●'),
                  ),
                  ElevatedButton(
                    onPressed: () => _showSnackBar(context, 'Stadium'),
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Stadium'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 특수 버튼
            _buildSectionHeader(theme, '특수 버튼'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'IconButton',
              description: '아이콘만 있는 버튼',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  IconButton(
                    onPressed: () => _showSnackBar(context, 'IconButton'),
                    icon: const Icon(Icons.favorite),
                  ),
                  IconButton.filled(
                    onPressed: () => _showSnackBar(context, 'IconButton.filled'),
                    icon: const Icon(Icons.add),
                  ),
                  IconButton.filledTonal(
                    onPressed: () => _showSnackBar(context, 'IconButton.filledTonal'),
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton.outlined(
                    onPressed: () => _showSnackBar(context, 'IconButton.outlined'),
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'FloatingActionButton',
              description: 'FAB 버튼',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  FloatingActionButton.small(
                    onPressed: () => _showSnackBar(context, 'FAB.small'),
                    child: const Icon(Icons.add),
                  ),
                  FloatingActionButton(
                    onPressed: () => _showSnackBar(context, 'FAB'),
                    child: const Icon(Icons.add),
                  ),
                  FloatingActionButton.extended(
                    onPressed: () => _showSnackBar(context, 'FAB.extended'),
                    icon: const Icon(Icons.add),
                    label: const Text('Extended'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'PopupMenuButton',
              description: '팝업 메뉴',
              child: Center(
                child: PopupMenuButton<int>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    _showSnackBar(context, '선택: 아이템 $value');
                  },
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: 0,
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 12),
                            Text('수정'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.share),
                            SizedBox(width: 12),
                            Text('공유'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 2,
                        child: Row(
                          children: [
                            Icon(Icons.delete),
                            SizedBox(width: 12),
                            Text('삭제'),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 토글 버튼
            _buildSectionHeader(theme, '토글 버튼'),
            const SizedBox(height: 12),
            _buildExampleCard(
              theme: theme,
              title: 'ToggleSwitch',
              description: '여러 옵션 중 선택',
              child: Center(
                child: ToggleSwitch(
                  initialLabelIndex: 0,
                  totalSwitches: 4,
                  labels: const ['모니터', '본체', '키보드', '마우스'],
                  minWidth: 70.0,
                  activeBgColor: [theme.colorScheme.primary],
                  activeFgColor: theme.colorScheme.onPrimary,
                  inactiveBgColor: theme.colorScheme.surfaceContainerHighest,
                  inactiveFgColor: theme.colorScheme.onSurfaceVariant,
                  onToggle: (index) {
                    _showSnackBar(context, '선택: $index번');
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 정보 카드
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
                      Icon(
                        Icons.info_outline,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '💡 버튼 선택 가이드',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'FilledButton: 주요 액션 (권장)',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'ElevatedButton: 중요한 액션',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'OutlinedButton: 보조 액션',
                  ),
                  _buildInfoItem(
                    theme: theme,
                    text: 'TextButton: 덜 중요한 액션',
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

  // 예제 카드
  Widget _buildExampleCard({
    required ThemeData theme,
    required String title,
    required String description,
    required Widget child,
  }) {
    return Container(
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
        spacing: 8,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  // 정보 아이템
  Widget _buildInfoItem({
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