import 'package:flutter/material.dart';

import '../../example_item.dart';

class ExampleListTile extends StatelessWidget {
  final ExampleItem example;
  final bool isFavorite;
  final bool showCategory;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const ExampleListTile({
    super.key,
    required this.example,
    required this.isFavorite,
    required this.showCategory,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                example.icon,
                size: 22,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    example.title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (showCategory) ...[
                    const SizedBox(height: 3),
                    Text(
                      example.category,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            GestureDetector(
              onTap: onFavoriteToggle,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  isFavorite
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  size: 22,
                  color: isFavorite ? Colors.orange : theme.colorScheme.outline,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
