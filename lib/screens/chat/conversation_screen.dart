import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Conversation/chat detail screen: messages (left/right bubbles), input with attach & send.
/// Opened when user taps a chat in [ChatsInboxScreen].
class ConversationScreen extends StatefulWidget {
  const ConversationScreen({
    super.key,
    this.contactName = 'Contact',
  });

  final String contactName;

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

typedef _Message = ({
  bool isMe,
  String sender,
  String text,
  String time,
  String? attachmentName,
  String? attachmentSize,
});

class _ConversationScreenState extends State<ConversationScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  static const Color _textMuted = Color(0xFF6B7280);
  static const Color _inputBg = Color(0xFFF3F4F6);

  /// In-memory messages (not persisted). Grows as user sends and auto-replies are added.
  List<_Message> _messages = [];

  static String _formatTime(DateTime dt) {
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }

  /// Returns an automated reply based on the user's message (no backend; in-memory only).
  String _getAutoReply(String userMessage) {
    final lower = userMessage.toLowerCase();
    if (lower.contains('hello') || lower.contains('hi') || lower.contains('hey')) {
      return "Hello! Thanks for reaching out. How can I help you today?";
    }
    if (lower.contains('help') || lower.contains('issue') || lower.contains('problem')) {
      return "We've noted your concern. Our team will look into this and get back to you shortly.";
    }
    if (lower.contains('thank')) {
      return "You're welcome! Let us know if you need anything else.";
    }
    if (lower.contains('bye') || lower.contains('goodbye')) {
      return "Goodbye! Have a great day.";
    }
    // Default automated reply
    return "Thank you for your message. We've received it and will get back to you soon.";
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now();
    final timeStr = _formatTime(now);

    // Add outgoing (user) message
    setState(() {
      _messages = [
        ..._messages,
        (
          isMe: true,
          sender: 'You',
          text: text,
          time: timeStr,
          attachmentName: null,
          attachmentSize: null,
        ),
      ];
    });
    _messageController.clear();
    _scrollToBottom();

    // After a short delay, add automated incoming reply (no persistence)
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    final reply = _getAutoReply(text);
    setState(() {
      _messages = [
        ..._messages,
        (
          isMe: false,
          sender: widget.contactName,
          text: reply,
          time: _formatTime(DateTime.now()),
          attachmentName: null,
          attachmentSize: null,
        ),
      ];
    });
    _scrollToBottom();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.sizeOf(context).width > 400 ? 20.0 : 16.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Chats',
          style: TextStyle(
            color: AppTheme.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? Center(
                      child: Text(
                        'Send a message to start the conversation.',
                        style: TextStyle(
                          fontSize: 14,
                          color: _textMuted,
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final m = _messages[index];
                        return _MessageBubble(
                          isMe: m.isMe,
                          sender: m.sender,
                          text: m.text,
                          time: m.time,
                          attachmentName: m.attachmentName,
                          attachmentSize: m.attachmentSize,
                        );
                      },
                    ),
            ),
            _buildInputBar(padding),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(double padding) {
    return Container(
      padding: EdgeInsets.fromLTRB(padding, 10, padding, 10),
      color: AppTheme.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: 'Send message',
                hintStyle: const TextStyle(color: _textMuted, fontSize: 14),
                filled: true,
                fillColor: _inputBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              // TODO: Attach file
            },
            icon: const Icon(Icons.attach_file, color: AppTheme.black, size: 24),
          ),
          IconButton(
            onPressed: _sendMessage,
            icon: const Icon(Icons.send, color: AppTheme.primaryGold, size: 24),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.isMe,
    required this.sender,
    required this.text,
    required this.time,
    this.attachmentName,
    this.attachmentSize,
  });

  final bool isMe;
  final String sender;
  final String text;
  final String time;
  final String? attachmentName;
  final String? attachmentSize;

  static const Color _bubbleOther = Color(0xFFFFFFFF);
  static const Color _bubbleMe = Color(0xFFB99146);
  static const Color _textMuted = Color(0xFF6B7280);
  static const Color _avatarBg = Color(0xFFE5E7EB);

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '?';
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    if (isMe) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('$time · $sender', style: const TextStyle(fontSize: 11, color: _textMuted)),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: _bubbleMe,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        text,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.white,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Other user: avatar left, bubble, name + time above bubble
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: _avatarBg,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _initials(sender),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$sender · $time', style: const TextStyle(fontSize: 11, color: _textMuted)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: _bubbleOther,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.black,
                          height: 1.4,
                        ),
                      ),
                      if (attachmentName != null && attachmentSize != null) ...[
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.table_chart_outlined, size: 20, color: _textMuted),
                            const SizedBox(width: 8),
                            Text(
                              attachmentName!,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.black,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              attachmentSize!,
                              style: const TextStyle(fontSize: 12, color: _textMuted),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
