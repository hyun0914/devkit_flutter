import 'package:flutter/material.dart';

// Syncfusion Community License 안내 위젯
// Syncfusion을 사용하는 화면에서 라이선스 정책을 안내하기 위한 공통 위젯입니다.

class SyncfusionLicenseInfo extends StatelessWidget {
  const SyncfusionLicenseInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.tertiary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: theme.colorScheme.tertiary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '📌 Syncfusion Community License',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.tertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoItem(
            theme: theme,
            text: '✅ 무료 조건:',
            isBold: true,
          ),
          const SizedBox(height: 4),
          _buildInfoItem(
            theme: theme,
            text: '  • 연간 매출 100만 달러 미만',
          ),
          const SizedBox(height: 2),
          _buildInfoItem(
            theme: theme,
            text: '  • 개발자 5명 이하',
          ),
          const SizedBox(height: 2),
          _buildInfoItem(
            theme: theme,
            text: '  • 전체 직원 10명 이하',
          ),
          const SizedBox(height: 8),
          _buildInfoItem(
            theme: theme,
            text: '⚠️ 대규모 기업: 유료 라이선스 필요',
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required ThemeData theme,
    required String text,
    bool isBold = false,
  }) {
    return Text(
      text,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}