// ally_section_header.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

import '../tokens/typography.dart';

/// Section title with an optional trailing action. Establishes the vertical
/// rhythm between dashboard sections.
class AllySectionHeader extends StatelessWidget {
  const AllySectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AllyTypography.headline(
              size: 18,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        if (actionLabel != null && onAction != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: Text(
              actionLabel!,
              style: AllyTypography.label(
                size: 13,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}
