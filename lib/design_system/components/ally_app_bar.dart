// ally_app_bar.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

/// Consistent screen header: transparent app bar with a leading back button.
///
/// Used by every pushed screen so navigation feedback and safe-area handling
/// stay identical across the app.
class AllyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AllyAppBar({
    super.key,
    this.title,
    this.actions,
    this.onBack,
    this.showBackButton = true,
    this.bottom,
  });

  final String? title;
  final List<Widget>? actions;
  final VoidCallback? onBack;
  final bool showBackButton;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title == null ? null : Text(title!),
      actions: actions,
      bottom: bottom,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back_rounded),
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            )
          : null,
    );
  }
}
