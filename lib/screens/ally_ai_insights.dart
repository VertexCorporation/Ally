// ally_ai_insights.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Ally AI — structured health insights. NOT a chatbot.
//
// Product policy (docs/AI_INTEGRATION.md):
//  • The AI never initiates contact, greets, asks questions, or chats.
//  • Insights are generated only on an explicit user action.
//  • Outputs render as structured cards (type label, timestamp, model meta) —
//    no chat bubbles, no assistant persona, no unsolicited pushes.
//  • A one-time consent gate explains exactly what data is sent before the
//    first request; declining keeps the rest of the app fully functional.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../design_system/design_system.dart';
import '../l10n/app_localizations.dart';
import '../providers/health.dart';
import '../services/ally_ai_service.dart';

/// One generated insight shown as a structured card.
class _InsightEntry {
  const _InsightEntry({
    required this.kind,
    required this.text,
    required this.createdAt,
    this.model,
    this.remaining,
    this.isError = false,
  });

  final AllyInsightKind kind;
  final String text;
  final DateTime createdAt;
  final String? model;
  final int? remaining;
  final bool isError;
}

class AllyAiInsightsScreen extends StatefulWidget {
  const AllyAiInsightsScreen({super.key});

  @override
  State<AllyAiInsightsScreen> createState() => _AllyAiInsightsScreenState();
}

class _AllyAiInsightsScreenState extends State<AllyAiInsightsScreen> {
  static const String _consentKey = 'ai_consent_v1';

  final AllyAiService _service = AllyAiService();
  final TextEditingController _queryController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<_InsightEntry> _entries = [];
  final Set<AllyInsightKind> _running = {};
  bool _customRunning = false;
  bool _consent = false;
  bool _consentLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadConsent();
  }

  @override
  void dispose() {
    _queryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadConsent() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _consent = prefs.getBool(_consentKey) ?? false;
      _consentLoaded = true;
    });
  }

  Future<void> _acceptConsent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_consentKey, true);
    if (mounted) setState(() => _consent = true);
  }

  Future<void> _declineConsent() async {
    Navigator.of(context).maybePop();
  }

  /// Real, local data summary — the only health context ever sent.
  Map<String, Object?> _dataFor(AllyInsightKind kind) {
    final healthData = context.read<HealthProvider>().healthData;
    switch (kind) {
      case AllyInsightKind.activity:
        return {
          'stepsToday': healthData.currentSteps,
          'stepsGoal': healthData.stepsGoal,
          'exerciseStreakDays': healthData.exerciseStreak,
        };
      case AllyInsightKind.sleep:
        return {
          'lastSleepHours': healthData.sleepHours,
          'sleepGoalHours': healthData.sleepGoal,
        };
      case AllyInsightKind.overview:
        return {
          'stepsToday': healthData.currentSteps,
          'stepsGoal': healthData.stepsGoal,
          'waterGlassesToday': healthData.waterGlasses,
          'waterGoal': healthData.waterGoal,
          'caloriesToday': healthData.caloriesConsumed,
          'caloriesGoal': healthData.caloriesGoal,
          'sleepHours': healthData.sleepHours,
          'exerciseStreakDays': healthData.exerciseStreak,
          'weightKg': healthData.currentWeight > 0
              ? healthData.currentWeight
              : null,
        };
    }
  }

  Future<void> _generate(AllyInsightKind kind) async {
    if (_running.contains(kind)) return;
    setState(() => _running.add(kind));

    final request = AllyAiPrompts.buildInsightRequest(kind, _dataFor(kind));
    await _runRequest(kind: kind, request: request);

    if (mounted) setState(() => _running.remove(kind));
  }

  Future<void> _runCustomQuery() async {
    final query = _queryController.text.trim();
    if (query.isEmpty || _customRunning) return;

    setState(() => _customRunning = true);
    final request = AllyAiPrompts.buildCustomRequest(query);
    await _runRequest(kind: null, request: request);

    if (mounted) {
      setState(() => _customRunning = false);
      _queryController.clear();
    }
  }

  Future<void> _runRequest({
    required AllyInsightKind? kind,
    required String request,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      final response = await _service.generateResponse(request);
      if (!mounted) return;
      setState(() {
        _entries.insert(
          0,
          _InsightEntry(
            kind: kind ?? AllyInsightKind.overview,
            text: response.answer,
            createdAt: DateTime.now(),
            model: response.model,
            remaining: response.remainingToday,
          ),
        );
      });
    } on AllyAiException catch (error) {
      if (!mounted) return;
      setState(() {
        _entries.insert(
          0,
          _InsightEntry(
            kind: kind ?? AllyInsightKind.overview,
            text: _localizedError(l10n, error.code),
            createdAt: DateTime.now(),
            isError: true,
          ),
        );
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _entries.insert(
          0,
          _InsightEntry(
            kind: kind ?? AllyInsightKind.overview,
            text: l10n.aiErrorGeneric,
            createdAt: DateTime.now(),
            isError: true,
          ),
        );
      });
    }
  }

  String _localizedError(AppLocalizations l10n, String code) {
    switch (code) {
      case 'unauthenticated':
        return l10n.aiErrorUnauthenticated;
      case 'resource-exhausted':
        return l10n.aiErrorRateLimit;
      case 'failed-precondition':
        return l10n.aiErrorUnavailable;
      case 'deadline-exceeded':
      case 'unavailable':
        return l10n.aiErrorUnavailable;
      default:
        return l10n.aiErrorGeneric;
    }
  }

  String _kindLabel(AppLocalizations l10n, AllyInsightKind kind) {
    switch (kind) {
      case AllyInsightKind.activity:
        return l10n.aiInsightActivity;
      case AllyInsightKind.sleep:
        return l10n.aiInsightSleep;
      case AllyInsightKind.overview:
        return l10n.aiInsightOverview;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AllyAppBar(title: l10n.allyAi),
      body: SafeArea(
        child: !_consentLoaded
            ? const SizedBox.shrink()
            : _consent
            ? _buildInsights(l10n)
            : _buildConsentGate(l10n),
      ),
    );
  }

  // ── Consent gate ──────────────────────────────────────────────────────────

  Widget _buildConsentGate(AppLocalizations l10n) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final AllySemanticPalette semantics = context.allySemantics;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AllySpacing.xl),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AllySpacing.xl),
              Container(
                width: 72,
                height: 72,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scheme.onSurface.withValues(alpha: 0.05),
                  borderRadius: AllyRadius.lgAll,
                ),
                child: Icon(
                  Icons.lock_outline_rounded,
                  size: AllyDimensions.iconHero - 12,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AllySpacing.xxl),
              Text(
                l10n.aiConsentTitle,
                textAlign: TextAlign.center,
                style: AllyTypography.headline(
                  size: 22,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: AllySpacing.lg),
              Text(
                l10n.aiConsentBody,
                style: AllyTypography.body(
                  size: 14,
                  color: scheme.onSurfaceVariant,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: AllySpacing.lg),
              Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: AllyDimensions.iconSm,
                    color: semantics.warning,
                  ),
                  const SizedBox(width: AllySpacing.sm),
                  Expanded(
                    child: Text(
                      l10n.aiNotMedicalAdvice,
                      style: AllyTypography.caption(color: semantics.warning),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AllySpacing.xxl),
              AllyButton(
                label: l10n.aiConsentAccept,
                onPressed: _acceptConsent,
              ),
              const SizedBox(height: AllySpacing.md),
              AllyButton(
                label: l10n.aiConsentDecline,
                kind: AllyButtonKind.ghost,
                onPressed: _declineConsent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Insights surface ──────────────────────────────────────────────────────

  Widget _buildInsights(AppLocalizations l10n) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final AllySemanticPalette semantics = context.allySemantics;

    return Column(
      children: [
        Expanded(
          child: _entries.isEmpty
              ? AllyEmptyState(
                  icon: Icons.insights_rounded,
                  title: l10n.allyAi,
                  message: l10n.allyAiTagline,
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(
                    AllySpacing.xl,
                    AllySpacing.lg,
                    AllySpacing.xl,
                    AllySpacing.lg,
                  ),
                  itemCount: _entries.length,
                  itemBuilder: (context, index) =>
                      _InsightCard(entry: _entries[index]),
                ),
        ),

        // ── Request bar: user-initiated only ──────────────────────────────
        Container(
          padding: const EdgeInsets.fromLTRB(
            AllySpacing.xl,
            AllySpacing.md,
            AllySpacing.xl,
            AllySpacing.lg,
          ),
          decoration: BoxDecoration(
            color: scheme.surface,
            border: Border(top: BorderSide(color: scheme.outlineVariant)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // On-demand insight generators (explicit user action).
              AllySettingsGroup(
                tiles: [
                  for (final kind in AllyInsightKind.values)
                    AllySettingsTile(
                      title: _kindLabel(l10n, kind),
                      icon: switch (kind) {
                        AllyInsightKind.activity =>
                          Icons.directions_walk_rounded,
                        AllyInsightKind.sleep => Icons.bedtime_rounded,
                        AllyInsightKind.overview => Icons.dashboard_rounded,
                      },
                      accent: semantics.ai,
                      showChevron: false,
                      trailing: _running.contains(kind)
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: scheme.primary,
                              ),
                            )
                          : Icon(
                              Icons.play_arrow_rounded,
                              size: AllyDimensions.iconMd,
                              color: scheme.onSurfaceVariant,
                            ),
                      onTap: _running.contains(kind)
                          ? null
                          : () => _generate(kind),
                    ),
                ],
              ),
              const SizedBox(height: AllySpacing.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _queryController,
                      maxLines: 1,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _runCustomQuery(),
                      inputFormatters: [LengthLimitingTextInputFormatter(2000)],
                      style: theme.textTheme.bodyLarge,
                      cursorColor: scheme.primary,
                      decoration: InputDecoration(
                        hintText: l10n.aiInputHint,
                        filled: true,
                        fillColor: scheme.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AllySpacing.lg,
                          vertical: AllySpacing.md,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: AllyRadius.lgAll,
                          borderSide: BorderSide(color: scheme.outlineVariant),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: AllyRadius.lgAll,
                          borderSide: BorderSide(color: scheme.outlineVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: AllyRadius.lgAll,
                          borderSide: BorderSide(
                            color: scheme.primary,
                            width: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AllySpacing.md),
                  _SendButton(
                    enabled:
                        !_customRunning &&
                        _queryController.text.trim().isNotEmpty,
                    isLoading: _customRunning,
                    semanticLabel: l10n.aiSend,
                    onPressed: _runCustomQuery,
                  ),
                ],
              ),
              const SizedBox(height: AllySpacing.sm),
              Text(
                l10n.aiNotMedicalAdvice,
                style: AllyTypography.caption(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Structured insight card — deliberately not a chat bubble.
class _InsightCard extends StatelessWidget {
  final _InsightEntry entry;

  const _InsightCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final AllySemanticPalette semantics = context.allySemantics;
    final l10n = AppLocalizations.of(context)!;

    final String kindLabel = entry.isError
        ? l10n.anErrorOccurred
        : switch (entry.kind) {
            AllyInsightKind.activity => l10n.aiInsightActivity,
            AllyInsightKind.sleep => l10n.aiInsightSleep,
            AllyInsightKind.overview => l10n.aiInsightOverview,
          };

    final Color accent = entry.isError ? semantics.error : semantics.ai;
    final String time =
        '${entry.createdAt.hour.toString().padLeft(2, '0')}:${entry.createdAt.minute.toString().padLeft(2, '0')}';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AllySpacing.md),
      padding: const EdgeInsets.all(AllySpacing.lg),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: AllyRadius.mdAll,
        border: Border.all(
          color: entry.isError
              ? semantics.error.withValues(alpha: 0.4)
              : scheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AllyDimensions.iconChipSm,
                height: AllyDimensions.iconChipSm,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: AllyRadius.smAll,
                ),
                child: Icon(
                  entry.isError
                      ? Icons.error_outline_rounded
                      : Icons.insights_rounded,
                  size: AllyDimensions.iconSm,
                  color: accent,
                ),
              ),
              const SizedBox(width: AllySpacing.md),
              Expanded(
                child: Text(
                  kindLabel,
                  style: AllyTypography.label(
                    size: 14,
                    color: scheme.onSurface,
                  ),
                ),
              ),
              Text(
                time,
                style: AllyTypography.caption(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: AllySpacing.md),
          Text(
            entry.text,
            style: AllyTypography.body(
              size: 15,
              color: entry.isError ? semantics.error : scheme.onSurface,
              height: 1.5,
            ),
          ),
          if (!entry.isError && entry.model != null) ...[
            const SizedBox(height: AllySpacing.sm),
            Text(
              l10n.aiModelMeta(entry.model!, entry.remaining ?? 0),
              style: AllyTypography.caption(color: scheme.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

/// Monochrome send action for user-initiated requests.
class _SendButton extends StatelessWidget {
  final bool enabled;
  final bool isLoading;
  final String semanticLabel;
  final VoidCallback onPressed;

  const _SendButton({
    required this.enabled,
    required this.isLoading,
    required this.semanticLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: enabled ? scheme.onSurface : scheme.outlineVariant,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: enabled ? onPressed : null,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: AllyDimensions.minTouchTarget,
            height: AllyDimensions.minTouchTarget,
            child: isLoading
                ? Padding(
                    padding: const EdgeInsets.all(AllySpacing.lg),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor: AlwaysStoppedAnimation<Color>(scheme.surface),
                    ),
                  )
                : Icon(
                    Icons.arrow_upward_rounded,
                    size: AllyDimensions.iconMd,
                    color: enabled ? scheme.surface : scheme.onSurfaceVariant,
                  ),
          ),
        ),
      ),
    );
  }
}
