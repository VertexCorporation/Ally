// ally_card.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

import '../tokens/dimensions.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// The standard surface of the app: flat color, hairline border, no shadow.
class AllyCard extends StatelessWidget {
  const AllyCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AllySpacing.cardPadding),
    this.radius = AllyRadius.md,
    this.elevated = false,
    this.margin,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double radius;
  final bool elevated;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Widget body = Padding(padding: padding, child: child);

    final Widget card = Material(
      color: elevated
          ? theme.colorScheme.surfaceContainerHighest
          : theme.cardColor,
      borderRadius: BorderRadius.circular(radius),
      child: onTap == null
          ? body
          : InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(radius),
              child: body,
            ),
    );

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: card,
    );
  }
}

/// A health metric tile: icon chip in a restrained accent, value in Space
/// Grotesk, label in muted Inter. The accent is meaningful, never decorative —
/// the card itself stays monochrome.
class AllyMetricCard extends StatelessWidget {
  const AllyMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
    this.onTap,
    this.hint,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accent;
  final VoidCallback? onTap;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return AllyCard(
      onTap: onTap,
      radius: AllyRadius.md,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AllyDimensions.iconChipSm,
                height: AllyDimensions.iconChipSm,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: AllyRadius.smAll,
                ),
                child: Icon(icon, color: accent, size: AllyDimensions.iconSm),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right_rounded,
                size: AllyDimensions.iconSm,
                color: scheme.outline,
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AllyTypography.metric(size: 22, color: scheme.onSurface),
          ),
          const SizedBox(height: AllySpacing.xs),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AllyTypography.label(
              size: 12,
              weight: FontWeight.w500,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
