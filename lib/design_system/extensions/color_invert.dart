// color_invert.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

/// Extension to make color inversion cleaner and reusable.
///
/// Previously defined in `app.dart`; moved here so design-system files can use
/// it without importing the root application widget.
extension InvertedColor on Color {
  /// Returns the inverted version of this color.
  Color get inverted {
    final int a = (this.a * 255).round();
    final int r = (this.r * 255).round();
    final int g = (this.g * 255).round();
    final int b = (this.b * 255).round();

    return Color.fromARGB(a, 255 - r, 255 - g, 255 - b);
  }
}
