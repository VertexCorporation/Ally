// ally_dialog.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

import '../tokens/spacing.dart';
import 'ally_button.dart';

/// Centralized dialog factory. Every modal conversation in the app (confirm
/// exit, delete program, information dialogs) resolves through this class so
/// geometry, typography and actions stay identical.
abstract final class AllyDialog {
  /// Shows a standard dialog with a title, message and optional actions.
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    String? message,
    IconData? icon,
    List<Widget> actions = const [],
  }) {
    final ThemeData theme = Theme.of(context);

    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: title,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 340),
            child: AlertDialog(
              icon: icon == null
                  ? null
                  : Icon(
                      icon,
                      size: 28,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
              title: Text(title),
              titleTextStyle: theme.textTheme.headlineSmall,
              content: message == null
                  ? null
                  : Text(message, style: theme.textTheme.bodyMedium),
              actions: actions,
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final CurvedAnimation curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  /// Confirmation dialog with cancel/confirm actions.
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    String? message,
    required String confirmLabel,
    String? cancelLabel,
    IconData? icon,
    bool destructive = false,
  }) async {
    final l10n = MaterialLocalizations.of(context);
    final bool? result = await show<bool>(
      context,
      title: title,
      message: message,
      icon: icon,
      actions: [
        AllyButton(
          label: cancelLabel ?? l10n.cancelButtonLabel,
          kind: AllyButtonKind.secondary,
          small: true,
          expanded: false,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        const SizedBox(width: AllySpacing.md),
        AllyButton(
          label: confirmLabel,
          kind: destructive ? AllyButtonKind.danger : AllyButtonKind.primary,
          small: true,
          expanded: false,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
    return result ?? false;
  }
}
