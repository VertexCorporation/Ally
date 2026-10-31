// ally_empty_state.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

import '../tokens/dimensions.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';
import '../themes/ally_semantics.dart';
import 'ally_button.dart';

/// Empty state placeholder — professional, calm and actionable.
class AllyEmptyState extends StatelessWidget {
  const AllyEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(compact ? AllySpacing.xl : AllySpacing.massive),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: compact
                  ? AllyDimensions.iconHero
                  : AllyDimensions.iconHero + 24,
              height: compact
                  ? AllyDimensions.iconHero
                  : AllyDimensions.iconHero + 24,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                borderRadius: AllyRadius.lgAll,
              ),
              child: Icon(
                icon,
                size: AllyDimensions.iconHero - 8,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: compact ? AllySpacing.md : AllySpacing.xl),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AllyTypography.cardTitle(
                size: 17,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AllySpacing.sm),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 280),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: AllyTypography.body(
                  size: 13,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AllySpacing.xl),
              AllyButton(
                label: actionLabel!,
                kind: AllyButtonKind.secondary,
                small: true,
                expanded: false,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Error state — same anatomy as the empty state but with the error tone and
/// an explicit retry affordance.
class AllyErrorState extends StatelessWidget {
  const AllyErrorState({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AllySemanticPalette semantics = context.allySemantics;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AllySpacing.massive),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AllyDimensions.iconHero + 24,
              height: AllyDimensions.iconHero + 24,
              decoration: BoxDecoration(
                color: semantics.error.withValues(alpha: 0.12),
                borderRadius: AllyRadius.lgAll,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: AllyDimensions.iconHero - 8,
                color: semantics.error,
              ),
            ),
            const SizedBox(height: AllySpacing.xl),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AllyTypography.cardTitle(
                size: 17,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AllySpacing.sm),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 280),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: AllyTypography.body(
                  size: 13,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AllySpacing.xl),
              AllyButton(
                label: actionLabel!,
                kind: AllyButtonKind.secondary,
                small: true,
                expanded: false,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
