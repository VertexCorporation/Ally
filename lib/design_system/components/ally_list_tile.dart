// ally_list_tile.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

import '../tokens/dimensions.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';
import '../tokens/radius.dart';

/// A settings-style row: leading icon chip, title, optional trailing value,
/// chevron or toggle. Rows are grouped with [AllySettingsGroup].
class AllySettingsTile extends StatelessWidget {
  const AllySettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.accent,
    this.trailing,
    this.onTap,
    this.showChevron = true,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? accent;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color chipColor = accent ?? theme.colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: AllyRadius.smAll,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AllySpacing.lg,
          vertical: AllySpacing.md,
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                width: AllyDimensions.iconChipSm,
                height: AllyDimensions.iconChipSm,
                decoration: BoxDecoration(
                  color: chipColor.withValues(alpha: 0.14),
                  borderRadius: AllyRadius.smAll,
                ),
                child: Icon(
                  icon,
                  size: AllyDimensions.iconSm,
                  color: chipColor,
                ),
              ),
              const SizedBox(width: AllySpacing.lg),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AllyTypography.label(
                      size: 15,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AllyTypography.caption(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AllySpacing.md),
              trailing!,
            ] else if (showChevron && onTap != null)
              Icon(
                Icons.chevron_right_rounded,
                size: AllyDimensions.iconMd,
                color: theme.colorScheme.outline,
              ),
          ],
        ),
      ),
    );
  }
}

/// Groups settings rows inside one bordered surface with internal dividers.
class AllySettingsGroup extends StatelessWidget {
  const AllySettingsGroup({super.key, required this.tiles});

  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: AllyRadius.mdAll,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (int i = 0; i < tiles.length; i++) ...[
            tiles[i],
            if (i < tiles.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                indent:
                    AllySpacing.lg + AllyDimensions.iconChipSm + AllySpacing.lg,
                color: theme.colorScheme.outlineVariant,
              ),
          ],
        ],
      ),
    );
  }
}
