import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'conversation_screen.dart';

/// Chats inbox screen: search, filter chips (New/Archive/Closed), list of conversations.
/// Opened when user taps the chat icon on a facility member.
class ChatsInboxScreen extends StatefulWidget {
  const ChatsInboxScreen({super.key});

  @override
  State<ChatsInboxScreen> createState() => _ChatsInboxScreenState();
}

class _ChatsInboxScreenState extends State<ChatsInboxScreen> {
  int _filterIndex = 0; // 0 = New, 1 = Active, 2 = Closed
  final _searchController = TextEditingController();

  static const Color _chipInactiveBg = Color(0xFFF3F4F6);
  static const Color _textMuted = Color(0xFF6B7280);

  static const List<({String name, String lastMessage, String time, int unread})> _chats = [
    (name: 'Ahmed Riaz', lastMessage: 'I have a question about the facility', time: '12:44 AM', unread: 2),
    (name: 'Sarah Iqbal', lastMessage: 'Thanks for the update', time: '11:20 PM', unread: 0),
    (name: 'John Doe', lastMessage: 'Whats update about the maintenance?', time: '10:15 PM', unread: 0),
    (name: 'Meesum Raza', lastMessage: 'I need Jacuzi pool', time: '9:00 PM', unread: 0),
    (name: 'Kamran', lastMessage: 'Booking Payment done', time: '8:30 PM', unread: 0),
    (name: 'Razia', lastMessage: 'Need to check the booking', time: '7:45 PM', unread: 0),
    (name: 'Alexendar', lastMessage: 'My booking is cancelled', time: '6:00 PM', unread: 0),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.sizeOf(context).width > 400 ? 20.0 : 16.0;

    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.black, size: 22),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search + filter icon
            Padding(
              padding: EdgeInsets.fromLTRB(padding, 8, padding, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search contacts',
                        hintStyle: const TextStyle(color: _textMuted, fontSize: 14),
                        prefixIcon: const Icon(Icons.search, color: _textMuted, size: 22),
                        filled: true,
                        fillColor: _chipInactiveBg,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _chipInactiveBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.tune, color: AppTheme.black, size: 22),
                  ),
                ],
              ),
            ),
            // Filter chips (center-aligned)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _FilterChip(
                      label: 'New(9)',
                      isSelected: _filterIndex == 0,
                      onTap: () => setState(() => _filterIndex = 0),
                    ),
                    const SizedBox(width: 10),
                    _FilterChip(
                      label: 'Active',
                      isSelected: _filterIndex == 1,
                      onTap: () => setState(() => _filterIndex = 1),
                    ),
                    const SizedBox(width: 10),
                    _FilterChip(
                      label: 'Closed',
                      isSelected: _filterIndex == 2,
                      onTap: () => setState(() => _filterIndex = 2),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Chat list
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: padding),
                itemCount: _chats.length,
                separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade200),
                itemBuilder: (context, index) {
                  final chat = _chats[index];
                  return _ChatTile(
                    name: chat.name,
                    lastMessage: chat.lastMessage,
                    time: chat.time,
                    unreadCount: chat.unread,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => ConversationScreen(contactName: chat.name),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  static const Color _inactiveBg = Color(0xFFF3F4F6);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppTheme.primaryGold : _inactiveBg,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppTheme.white : AppTheme.black,
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  const _ChatTile({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    this.onTap,
  });

  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final VoidCallback? onTap;

  static const Color _textMuted = Color(0xFF6B7280);
  static const Color _avatarBg = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: _avatarBg,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, size: 28, color: _textMuted),
            ),
            const SizedBox(width: 14),
            // Name, message, time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGold,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$unreadCount',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.white,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(width: 8),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 12,
                          color: _textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lastMessage,
                    style: const TextStyle(
                      fontSize: 13,
                      color: _textMuted,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
