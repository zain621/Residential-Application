import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Bottom navigation bar with 4 items: Home, Chats, Facilities, Profile.
/// Active tab uses app theme (primaryGold) with light cream pill background.
const Color _inactiveColor = Color(0xFF515151);
const Color _activeIconBg = Color(0xFFF5E5C2);

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<_NavItem> _items = [
    _NavItem(asset: 'assets/nav/Home.png', label: 'Home', fallbackIcon: Icons.home_outlined),
    _NavItem(asset: 'assets/nav/message.png', label: 'Chats', fallbackIcon: Icons.chat_bubble_outline),
    _NavItem(asset: 'assets/nav/Services_filled.png', label: 'Facilities', fallbackIcon: Icons.grid_view_rounded),
    _NavItem(asset: 'assets/nav/user.png', label: 'Profile', fallbackIcon: Icons.person_outline),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _items.length,
              (index) => _NavBarItem(
                item: _items[index],
                isActive: currentIndex == index,
                onTap: () => onTap(index),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.asset,
    required this.label,
    required this.fallbackIcon,
  });
  final String asset;
  final String label;
  final IconData fallbackIcon;
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 36,
              decoration: BoxDecoration(
                color: isActive ? _activeIconBg : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Image.asset(
                  item.asset,
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                  color: isActive ? AppTheme.primaryGold : _inactiveColor,
                  errorBuilder: (_, __, ___) => Icon(
                    item.fallbackIcon,
                    size: 24,
                    color: isActive ? AppTheme.primaryGold : _inactiveColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isActive ? AppTheme.primaryGold : _inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
