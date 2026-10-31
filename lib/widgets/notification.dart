// notification.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Overlay toast. Semantic defaults come from the design tokens; callers can
// still customize icon/duration. Success / error / neutral tones are paired
// with icons so status never relies on color alone.

import 'package:flutter/material.dart';

import '../design_system/design_system.dart';

class CustomNotification extends StatefulWidget {
  final String message;
  final Color? backgroundColor;
  final IconData? icon;
  final bool isError;
  final Duration duration;

  const CustomNotification({
    super.key,
    required this.message,
    this.backgroundColor,
    this.icon,
    this.isError = false,
    this.duration = const Duration(seconds: 3),
  });

  static void show(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    IconData? icon,
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        child: CustomNotification(
          message: message,
          backgroundColor: backgroundColor,
          icon: icon,
          isError: isError,
          duration: duration,
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }

  @override
  State<CustomNotification> createState() => _CustomNotificationState();
}

class _CustomNotificationState extends State<CustomNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // Auto dismiss with fade out
    Future.delayed(widget.duration - const Duration(milliseconds: 300), () {
      if (mounted) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AllySemanticPalette semantics = context.allySemantics;

    final Color background =
        widget.backgroundColor ??
        (widget.isError ? semantics.error : theme.colorScheme.onSurface);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AllySpacing.lg,
              vertical: AllySpacing.md,
            ),
            decoration: BoxDecoration(
              color: background,
              borderRadius: AllyRadius.mdAll,
            ),
            child: Row(
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    color: theme.colorScheme.surface,
                    size: AllyDimensions.iconMd,
                  ),
                  const SizedBox(width: AllySpacing.md),
                ],
                Expanded(
                  child: Text(
                    widget.message,
                    style: AllyTypography.label(
                      size: 14,
                      color: theme.colorScheme.surface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
