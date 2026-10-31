// exit.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Exit confirmation dialog, built on the shared dialog factory.

import 'package:ally/design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';

/// Displays a centralized dialog to confirm app exit.
Future<bool> showExitConfirmationDialog(BuildContext context) async {
  final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

  final bool result = await AllyDialog.confirm(
    context,
    title: appLocalizations.exitAppTitle,
    message: appLocalizations.exitAppConfirmation,
    confirmLabel: appLocalizations.yes,
    cancelLabel: appLocalizations.no,
    destructive: true,
  );

  return result;
}
