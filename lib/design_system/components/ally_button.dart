// ally_button.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

import '../tokens/dimensions.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';
import '../themes/ally_semantics.dart';

/// Visual kind of an [AllyButton].
enum AllyButtonKind { primary, secondary, ghost, danger }

/// The single button primitive of the design system.
///
/// - [AllyButtonKind.primary]   — monochrome ink fill; the main CTA.
/// - [AllyButtonKind.secondary] — hairline border on surface.
/// - [AllyButtonKind.ghost]     — text only, for understated actions.
/// - [AllyButtonKind.danger]    — semantic error tone (destructive only).
class AllyButton extends StatelessWidget {
  const AllyButton({
    super.key,
    required this.label,
    this.onPressed,
    this.kind = AllyButtonKind.primary,
    this.icon,
    this.isLoading = false,
    this.expanded = true,
    this.small = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AllyButtonKind kind;
  final IconData? icon;
  final bool isLoading;
  final bool expanded;
  final bool small;

  bool get _isDisabled => onPressed == null || isLoading;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final AllySemanticPalette semantics = context.allySemantics;

    final double height = small
        ? AllyDimensions.buttonHeightSm
        : AllyDimensions.buttonHeight;
    final TextStyle textStyle = AllyTypography.label(size: small ? 14 : 15);

    ButtonStyle style;
    switch (kind) {
      case AllyButtonKind.primary:
        style = theme.elevatedButtonTheme.style!.copyWith(
          minimumSize: WidgetStateProperty.all(Size(expanded ? 0 : 64, height)),
          textStyle: WidgetStateProperty.all(textStyle),
        );
      case AllyButtonKind.secondary:
        style = theme.outlinedButtonTheme.style!.copyWith(
          minimumSize: WidgetStateProperty.all(Size(expanded ? 0 : 64, height)),
          textStyle: WidgetStateProperty.all(textStyle),
        );
      case AllyButtonKind.ghost:
        style =
            TextButton.styleFrom(
              foregroundColor: scheme.onSurfaceVariant,
              minimumSize: Size(expanded ? 0 : 64, height),
              padding: const EdgeInsets.symmetric(horizontal: AllySpacing.lg),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: textStyle,
            ).copyWith(
              overlayColor: WidgetStateProperty.all(
                scheme.primary.withValues(alpha: 0.05),
              ),
            );
      case AllyButtonKind.danger:
        style = ElevatedButton.styleFrom(
          backgroundColor: semantics.error,
          foregroundColor: Colors.white,
          disabledBackgroundColor: scheme.outlineVariant,
          disabledForegroundColor: theme.textTheme.bodySmall?.color,
          minimumSize: Size(expanded ? 0 : 64, height),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: textStyle,
        );
    }

    final Widget labelWidget = Row(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                _foregroundColor(context),
              ),
            ),
          ),
          const SizedBox(width: AllySpacing.md),
        ] else if (icon != null) ...[
          Icon(icon, size: AllyDimensions.iconSm),
          const SizedBox(width: AllySpacing.md),
        ],
        Flexible(
          child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );

    final Widget button = switch (kind) {
      AllyButtonKind.ghost => TextButton(
        style: style,
        onPressed: _isDisabled ? null : onPressed,
        child: labelWidget,
      ),
      AllyButtonKind.secondary => OutlinedButton(
        style: style,
        onPressed: _isDisabled ? null : onPressed,
        child: labelWidget,
      ),
      _ => ElevatedButton(
        style: style,
        onPressed: _isDisabled ? null : onPressed,
        child: labelWidget,
      ),
    };

    if (!expanded) return button;
    return SizedBox(width: double.infinity, child: button);
  }

  Color _foregroundColor(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    switch (kind) {
      case AllyButtonKind.danger:
        return Colors.white;
      case AllyButtonKind.ghost:
      case AllyButtonKind.secondary:
        return theme.colorScheme.onSurfaceVariant;
      case AllyButtonKind.primary:
        return theme.colorScheme.onPrimary;
    }
  }
}
