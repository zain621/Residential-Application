import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'chats_inbox_screen.dart';

/// Facility Members bottom sheet: list of members with avatar, name, role, chat and add actions.
/// Shown when user taps the + icon on [ChatsScreen].
void showFacilityMembersSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _FacilityMembersSheet(),
  );
}

class _FacilityMembersSheet extends StatelessWidget {
  const _FacilityMembersSheet();

  static const List<({String name, String role})> _members = [
    (name: 'Annette Black', role: 'Electrician'),
    (name: 'Jacob Jones', role: 'Mechanic'),
    (name: 'Kathryn Murphy', role: 'Manager'),
    (name: 'Marvin McKinney', role: 'Maintainance'),
    (name: 'Arlene McCoy', role: 'Security'),
  ];

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.sizeOf(context).width > 400 ? 20.0 : 16.0;

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.7,
      decoration: const BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.black, size: 22),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Expanded(
                    child: Text(
                      'Facility Members',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // List
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(padding, 0, padding, 24),
                itemCount: _members.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final member = _members[index];
                  return _MemberTile(
                    name: member.name,
                    role: member.role,
                    onChat: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => const ChatsInboxScreen(),
                        ),
                      );
                    },
                    onAdd: () {
                      // TODO: Add member
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

class _MemberTile extends StatelessWidget {
  const _MemberTile({
    required this.name,
    required this.role,
    required this.onChat,
    required this.onAdd,
  });

  final String name;
  final String role;
  final VoidCallback onChat;
  final VoidCallback onAdd;

  static const Color _cardBg = Color(0xFFF3F4F6);
  static const Color _textMuted = Color(0xFF6B7280);
  static const Color _avatarBg = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          // Avatar placeholder
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: _avatarBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              size: 28,
              color: _textMuted,
            ),
          ),
          const SizedBox(width: 14),
          // Name & role
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  role,
                  style: const TextStyle(
                    fontSize: 13,
                    color: _textMuted,
                  ),
                ),
              ],
            ),
          ),
          // Chat icon
          IconButton(
            onPressed: onChat,
            icon: Icon(
              Icons.chat_bubble_outline,
              color: AppTheme.primaryGold,
              size: 24,
            ),
          ),
          const SizedBox(width: 4),
          // Add button
          Material(
            color: AppTheme.primaryGold,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onAdd,
              customBorder: const CircleBorder(),
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(Icons.add, color: AppTheme.white, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
