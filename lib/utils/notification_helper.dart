import 'package:flutter/material.dart';

class NotificationHelper {
  static void showSuccess(BuildContext context, String title, String message, {Color backgroundColor = const Color(0xFF66BB6A), IconData icon = Icons.check_circle}) {
    _showNotification(context, title, message, backgroundColor, icon);
  }

  static void showError(BuildContext context, String title, String message) {
    _showNotification(context, title, message, const Color(0xFFEF5350), Icons.error);
  }

  static void showInfo(BuildContext context, String title, String message, {Color? backgroundColor}) {
    _showNotification(context, title, message, backgroundColor ?? const Color(0xFF64B5F6), Icons.info);
  }

  static void _showNotification(BuildContext context, String title, String message, Color backgroundColor, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (message.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
