// ally_ai_chat.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Ally AI chat.
//
// Presentation only — all model/provider logic stays server-side in the AI-lly
// callable (see `services/ally_ai_service.dart` and docs/AI_INTEGRATION.md).
// The chat keeps the user's draft on failure, shows localized errors and never
// logs message content.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design_system/design_system.dart';
import '../l10n/app_localizations.dart';
import '../services/ally_ai_service.dart';

/// A single chat message shown in the transcript.
class _ChatMessage {
  const _ChatMessage({
    required this.text,
    required this.isUser,
    this.error = false,
    this.remaining,
  });

  final String text;
  final bool isUser;
  final bool error;
  final int? remaining;
}

class AllyAiChatScreen extends StatefulWidget {
  const AllyAiChatScreen({super.key});

  @override
  State<AllyAiChatScreen> createState() => _AllyAiChatScreenState();
}

class _AllyAiChatScreenState extends State<AllyAiChatScreen> {
  final AllyAiService _service = AllyAiService();
  final TextEditingController _composerController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _composerFocus = FocusNode();

  final List<_ChatMessage> _messages = [];
  bool _isSending = false;

  @override
  void dispose() {
    _composerController.dispose();
    _scrollController.dispose();
    _composerFocus.dispose();
    super.dispose();
  }

  bool get _canSend =>
      !_isSending && _composerController.text.trim().isNotEmpty;

  Future<void> _send() async {
    final l10n = AppLocalizations.of(context)!;
    final text = _composerController.text.trim();
    if (!_canSend) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _isSending = true;
      _composerController.clear();
    });
    _scrollToBottom();

    try {
      final response = await _service.generateResponse(text);
      if (!mounted) return;
      setState(() {
        _messages.add(
          _ChatMessage(
            text: response.answer,
            isUser: false,
            remaining: response.remainingToday,
          ),
        );
        _isSending = false;
      });
    } on AllyAiException catch (error) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          _ChatMessage(
            text: _localizedError(l10n, error.code, error.message),
            isUser: false,
            error: true,
          ),
        );
        _isSending = false;
        _composerController.text = text; // Keep the draft on failure.
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          _ChatMessage(text: l10n.aiErrorGeneric, isUser: false, error: true),
        );
        _isSending = false;
        _composerController.text = text;
      });
    }
    _scrollToBottom();
  }

  String _localizedError(AppLocalizations l10n, String code, String fallback) {
    switch (code) {
      case 'unauthenticated':
        return l10n.aiErrorUnauthenticated;
      case 'invalid-argument':
        return l10n.aiErrorInvalidArgument;
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

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final AllySemanticPalette semantics = context.allySemantics;

    return Scaffold(
      appBar: AllyAppBar(title: l10n.allyAi),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? AllyEmptyState(
                      icon: Icons.auto_awesome_rounded,
                      title: l10n.allyAi,
                      message: l10n.aiWelcome,
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AllySpacing.xl,
                        vertical: AllySpacing.lg,
                      ),
                      itemCount: _messages.length + (_isSending ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _messages.length) {
                          return _TypingIndicator(accent: semantics.ai);
                        }
                        return _MessageBubble(message: _messages[index]);
                      },
                    ),
            ),

            // ── Composer ────────────────────────────────────────────────────
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _composerController,
                      focusNode: _composerFocus,
                      maxLines: 5,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      inputFormatters: [LengthLimitingTextInputFormatter(8000)],
                      onChanged: (_) => setState(() {}),
                      style: theme.textTheme.bodyLarge,
                      cursorColor: scheme.primary,
                      decoration: InputDecoration(
                        hintText: l10n.aiMessageHint,
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
                    enabled: _canSend,
                    isLoading: _isSending,
                    semanticLabel: l10n.aiSend,
                    onPressed: _send,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One transcript bubble. User messages are the inverse ink panel; assistant
/// messages sit on the plain surface with a hairline border. No neon, no
/// gradients.
class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final AllySemanticPalette semantics = context.allySemantics;

    final bool isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AllySpacing.md),
        padding: const EdgeInsets.symmetric(
          horizontal: AllySpacing.lg,
          vertical: AllySpacing.md,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: message.error
              ? semantics.error.withValues(alpha: 0.10)
              : isUser
              ? scheme.onSurface
              : scheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isUser ? AllyRadius.lg : AllyRadius.sm),
            topRight: Radius.circular(isUser ? AllyRadius.sm : AllyRadius.lg),
            bottomLeft: const Radius.circular(AllyRadius.lg),
            bottomRight: const Radius.circular(AllyRadius.lg),
          ),
          border: isUser || message.error
              ? null
              : Border.all(color: scheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: AllyTypography.body(
                size: 15,
                color: message.error
                    ? semantics.error
                    : isUser
                    ? scheme.surface
                    : scheme.onSurface,
              ),
            ),
            if (message.remaining != null) ...[
              const SizedBox(height: AllySpacing.xs),
              Text(
                AppLocalizations.of(
                  context,
                )!.aiGuestLimitHint(message.remaining!),
                style: AllyTypography.caption(color: scheme.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Three-dot typing indicator while awaiting the assistant response.
class _TypingIndicator extends StatelessWidget {
  final Color accent;

  const _TypingIndicator({required this.accent});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AllySpacing.md),
        padding: const EdgeInsets.symmetric(
          horizontal: AllySpacing.lg,
          vertical: AllySpacing.md,
        ),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AllyRadius.sm),
            topRight: Radius.circular(AllyRadius.lg),
            bottomLeft: Radius.circular(AllyRadius.lg),
            bottomRight: Radius.circular(AllyRadius.lg),
          ),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: SizedBox(
          width: 44,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(3, (i) {
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.2, end: 1.0),
                duration: Duration(milliseconds: 500 + i * 150),
                curve: Curves.easeInOut,
                builder: (context, value, _) {
                  return Opacity(
                    opacity: value,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}

/// The send action: monochrome ink circle, disabled until there is input.
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
