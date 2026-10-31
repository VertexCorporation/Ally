// ally_brand.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Brand primitives: the Ally mark (geometric "A" with an ECG-pulse crossbar —
// the apex is the vertex point) rendered from the theme-aware SVG variants.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The Ally symbol, automatically picking the ink variant on light surfaces
/// and the paper variant on dark surfaces.
class AllyMark extends StatelessWidget {
  const AllyMark({super.key, this.size = 26, this.monochrome});

  /// Rendered side length of the square mark.
  final double size;

  /// Forces a specific tint; when null the active theme decides.
  /// [Colors.white] / light tints render the paper variant, anything else the
  /// ink variant.
  final Color? monochrome;

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    final String asset = monochrome != null
        ? (monochrome!.computeLuminance() > 0.5
              ? 'assets/branding/ally_mark_paper.svg'
              : 'assets/branding/ally_mark_ink.svg')
        : (brightness == Brightness.dark
              ? 'assets/branding/ally_mark_paper.svg'
              : 'assets/branding/ally_mark_ink.svg');

    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.asset(
        asset,
        fit: BoxFit.contain,
        colorFilter: monochrome != null
            ? ColorFilter.mode(monochrome!, BlendMode.srcIn)
            : null,
      ),
    );
  }
}
