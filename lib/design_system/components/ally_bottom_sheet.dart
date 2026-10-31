// ally_bottom_sheet.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// Centralized modal bottom sheet factory.
///
/// Every form sheet / picker in the app opens through [AllySheet.show] to keep
/// margins, radii, headers and keyboard handling consistent. The content is
/// padded to follow the keyboard automatically.
abstract final class AllySheet {
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required Widget child,
    IconData? icon,
    String? subtitle,
    bool isDismissible = true,
    bool showHandle = true,
  }) {
    final ThemeData theme = Theme.of(context);

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Container(
            margin: const EdgeInsets.fromLTRB(
              AllySpacing.md,
              0,
              AllySpacing.md,
              AllySpacing.md,
            ),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(sheetContext).size.height * 0.85,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: AllyRadius.lgAll,
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showHandle)
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: AllySpacing.md),
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.outline,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AllySpacing.xxl,
                    AllySpacing.lg,
                    AllySpacing.xxl,
                    0,
                  ),
                  child: Row(
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          size: 24,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: AllySpacing.md),
                      ],
                      Expanded(
                        child: Text(
                          title,
                          style: AllyTypography.headline(
                            size: 20,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        icon: const Icon(Icons.close_rounded),
                        tooltip: MaterialLocalizations.of(
                          sheetContext,
                        ).closeButtonTooltip,
                      ),
                    ],
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AllySpacing.xxl,
                      AllySpacing.xs,
                      AllySpacing.xxl,
                      0,
                    ),
                    child: Text(subtitle, style: theme.textTheme.bodyMedium),
                  ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AllySpacing.xxl,
                      AllySpacing.lg,
                      AllySpacing.xxl,
                      AllySpacing.xl,
                    ),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
