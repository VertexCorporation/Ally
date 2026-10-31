// radius.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Corner radius scale. Geometry is part of the Vertex identity: precise,
// slightly squared, never bubbly.

import 'package:flutter/material.dart';

abstract final class AllyRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double full = 999;

  static BorderRadius get smAll => BorderRadius.circular(sm);
  static BorderRadius get mdAll => BorderRadius.circular(md);
  static BorderRadius get lgAll => BorderRadius.circular(lg);
  static BorderRadius get pill => BorderRadius.circular(full);

  static BorderRadius only({
    double tl = 0,
    double tr = 0,
    double bl = 0,
    double br = 0,
  }) => BorderRadius.only(
    topLeft: Radius.circular(tl),
    topRight: Radius.circular(tr),
    bottomLeft: Radius.circular(bl),
    bottomRight: Radius.circular(br),
  );
}
