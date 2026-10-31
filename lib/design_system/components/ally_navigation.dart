// ally_navigation.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

import '../tokens/dimensions.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// One destination of the [AllyNavBar].
class AllyNavItem {
  const AllyNavItem({
    required this.icon,
    required this.label,
    required this.onSelected,
  });

  final IconData icon;
  final String label;
  final VoidCallback onSelected;
}

/// Bottom navigation bar of the app.
///
/// Neutral surface, hairline top divider, muted inactive icons and a clear
/// monochrome active pill. No blur, no transparency, no gradients.
class AllyNavBar extends StatelessWidget {
  const AllyNavBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    this.trailing,
  });

  final List<AllyNavItem> items;
  final int selectedIndex;

  /// Optional trailing widget (e.g. a menu button) placed after the items.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: AllyDimensions.bottomNavHeight,
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 0; i < items.length; i++)
                      _AllyNavButton(
                        item: items[i],
                        selected: i == selectedIndex,
                      ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

class _AllyNavButton extends StatelessWidget {
  const _AllyNavButton({required this.item, required this.selected});

  final AllyNavItem item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final Color iconColor = selected
        ? scheme.onSurface
        : scheme.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: Tooltip(
        message: item.label,
        waitDuration: const Duration(milliseconds: 600),
        child: InkWell(
          onTap: item.onSelected,
          borderRadius: AllyRadius.pill,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            constraints: const BoxConstraints(
              minWidth: AllyDimensions.minTouchTarget,
              minHeight: AllyDimensions.minTouchTarget,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: selected ? AllySpacing.lg : AllySpacing.md,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? scheme.onSurface.withValues(alpha: 0.08)
                  : Colors.transparent,
              borderRadius: AllyRadius.pill,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item.icon, size: AllyDimensions.iconMd, color: iconColor),
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  child: selected
                      ? Padding(
                          padding: const EdgeInsets.only(left: AllySpacing.sm),
                          child: Text(
                            item.label,
                            maxLines: 1,
                            style: AllyTypography.label(
                              size: 14,
                              color: scheme.onSurface,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Square icon action button used in headers (profile, notifications…).
class AllyIconButton extends StatelessWidget {
  const AllyIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Semantics(
      button: true,
      label: semanticLabel ?? tooltip,
      child: Tooltip(
        message: tooltip ?? '',
        child: Material(
          color: theme.colorScheme.surface,
          borderRadius: AllyRadius.mdAll,
          child: InkWell(
            onTap: onTap,
            borderRadius: AllyRadius.mdAll,
            child: Container(
              width: AllyDimensions.minTouchTarget,
              height: AllyDimensions.minTouchTarget,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: AllyRadius.mdAll,
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Icon(
                icon,
                size: AllyDimensions.iconMd,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
