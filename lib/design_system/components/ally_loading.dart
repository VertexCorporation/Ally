// ally_loading.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// Loading primitives of the design system.
abstract final class AllyLoading {
  /// A centered, theme-aware progress indicator.
  static Widget spinner({
    BuildContext? context,
    String? label,
    double size = 32,
  }) {
    return Builder(
      builder: (context) {
        final ThemeData theme = Theme.of(context);
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  strokeWidth: 2.6,
                  color: theme.colorScheme.primary,
                ),
              ),
              if (label != null) ...[
                const SizedBox(height: AllySpacing.lg),
                Text(
                  label,
                  style: AllyTypography.caption(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  /// A thin horizontal determinate bar.
  static Widget bar(BuildContext context, {double? value}) {
    return LinearProgressIndicator(
      value: value,
      minHeight: 4,
      borderRadius: BorderRadius.circular(2),
    );
  }
}
