// elevation.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Elevation philosophy: prefer subtle 1px borders over shadows. Shadows exist
// only to lift floating elements (dialogs, sheets, toasts) off the canvas.

import 'package:flutter/material.dart';

abstract final class AllyElevation {
  static const double none = 0;
  static const double card = 0;
  static const double raised = 4;
  static const double overlay = 8;

  /// Soft shadow for floating surfaces (dialogs / sheets / toasts).
  static List<BoxShadow> overlayShadow(Brightness brightness) {
    final Color tint = brightness == Brightness.dark
        ? Colors.black.withValues(alpha: 0.5)
        : Colors.black.withValues(alpha: 0.12);
    return [BoxShadow(color: tint, blurRadius: 24, offset: const Offset(0, 8))];
  }
}
