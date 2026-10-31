// error.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Shared error view. The previous version referenced a missing SVG asset;
// it now uses the [AllyErrorState] primitive (icon-based, theme-aware).

import 'package:flutter/material.dart';

import 'design_system/design_system.dart';

class ErrorView extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onRetry;

  const ErrorView({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    assert(
      (buttonText == null && onRetry == null) ||
          (buttonText != null && onRetry != null),
      'Both buttonText and onRetry must be provided together, or both must be null.',
    );

    return AllyErrorState(
      title: title,
      message: message,
      actionLabel: buttonText,
      onAction: onRetry,
    );
  }
}
