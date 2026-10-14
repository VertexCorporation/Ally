import 'package:flutter/material.dart';

import '../services/ally_ai_service.dart';

class AllyAiChatScreen extends StatefulWidget {
  const AllyAiChatScreen({super.key});

  @override
  State<AllyAiChatScreen> createState() => _AllyAiChatScreenState();
}

class _AllyAiChatScreenState extends State<AllyAiChatScreen> {
  final AllyAiService _aiService = AllyAiService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = <_ChatMessage>[];

  bool _isSending = false;
  String? _errorMessage;
  int? _remainingToday;

  bool get _isTurkish =>
      Localizations.localeOf(context).languageCode.toLowerCase() == 'tr';

  String _copy(String tr, String en) => _isTurkish ? tr : en;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _isSending) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _messages.add(_ChatMessage(text: message, isFromUser: true));
      _isSending = true;
      _errorMessage = null;
    });
    _scrollToBottom();

    try {
      final response = await _aiService.generateResponse(message);
      if (!mounted) return;

      setState(() {
        _messages.add(
          _ChatMessage(text: response.answer, isFromUser: false),
        );
        _remainingToday = response.remainingToday;
        _messageController.clear();
      });
      _scrollToBottom();
    } on AllyAiException catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = error.message);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = _copy(
          'Ally AI şu anda yanıt veremiyor. Lütfen tekrar dene.',
          'Ally AI could not respond right now. Please try again.',
        );
      });
    } finally {
      if (mounted) setState(() => _isSending = false);
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF4BAADF).withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Color(0xFF4BAADF),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ally AI',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    _remainingToday == null
                        ? _copy('Sağlık ve iyi yaşam desteği', 'Wellness companion')
                        : _copy(
                            'Bugün $_remainingToday istek kaldı',
                            '$_remainingToday requests left today',
                          ),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? _buildWelcome(colorScheme, theme)
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                      itemCount: _messages.length + (_isSending ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _messages.length) {
                          return _buildTypingIndicator(theme);
                        }
                        return _buildMessage(_messages[index], theme, colorScheme);
                      },
                    ),
            ),
            if (_errorMessage != null)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded, color: colorScheme.onErrorContainer),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: colorScheme.onErrorContainer),
                      ),
                    ),
                  ],
                ),
              ),
            _buildComposer(theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcome(ColorScheme colorScheme, ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 44, 24, 24),
      children: [
        Center(
          child: Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: const Color(0xFF4BAADF).withValues(alpha: 0.13),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 38,
              color: Color(0xFF4BAADF),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          _copy('Bugün sana nasıl yardımcı olabilirim?', 'How can I help you today?'),
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _copy(
            'Alışkanlıklar, uyku, hareket ve genel iyi yaşam hakkında sorular sorabilirsin.',
            'Ask about habits, sleep, movement, and general wellness.',
          ),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.75),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        _suggestion(
          _copy('Daha düzenli uyumak için nereden başlamalıyım?', 'How can I build a better sleep routine?'),
        ),
        _suggestion(
          _copy('Günlük hareketimi artırmak için fikir ver.', 'Suggest ways to move more during the day.'),
        ),
        _suggestion(
          _copy('Daha sürdürülebilir alışkanlıklar nasıl kurarım?', 'How do I build habits that last?'),
        ),
        const SizedBox(height: 20),
        Text(
          _copy(
            'Ally AI genel bilgilendirme içindir; tanı veya acil sağlık desteği yerine geçmez. Hassas kişisel bilgileri paylaşma.',
            'Ally AI provides general information, not a diagnosis or emergency care. Avoid sharing sensitive personal information.',
          ),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.65),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _suggestion(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _isSending
              ? null
              : () {
                  _messageController.text = text;
                  _messageController.selection = TextSelection.collapsed(
                    offset: text.length,
                  );
                  _sendMessage();
                },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: Color(0xFF4BAADF)),
                const SizedBox(width: 10),
                Expanded(child: Text(text)),
                const Icon(Icons.arrow_outward_rounded, size: 17),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(
    _ChatMessage message,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final isUser = message.isFromUser;
    final bubbleColor = isUser
        ? colorScheme.primary
        : theme.cardColor;
    final textColor = isUser
        ? colorScheme.onPrimary
        : theme.textTheme.bodyLarge?.color;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.82,
        ),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 5),
            bottomRight: Radius.circular(isUser ? 5 : 18),
          ),
          border: isUser
              ? null
              : Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
        ),
        child: SelectableText(
          message.text,
          style: TextStyle(color: textColor, height: 1.45),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(ThemeData theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildComposer(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        12,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: theme.dividerColor.withValues(alpha: 0.5))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              minLines: 1,
              maxLines: 4,
              maxLength: 8000,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.newline,
              onChanged: (_) {
                if (_errorMessage != null) setState(() => _errorMessage = null);
              },
              decoration: InputDecoration(
                hintText: _copy('Ally AI’ye mesaj yaz...', 'Message Ally AI...'),
                counterText: '',
                filled: true,
                fillColor: theme.cardColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 48,
            width: 48,
            child: IconButton.filled(
              tooltip: _copy('Gönder', 'Send'),
              onPressed: _isSending ? null : _sendMessage,
              icon: const Icon(Icons.arrow_upward_rounded),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFF4BAADF),
                foregroundColor: Colors.white,
                disabledBackgroundColor: colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({required this.text, required this.isFromUser});

  final String text;
  final bool isFromUser;
}
