import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';
import 'notification_screen.dart';
import 'logout_confirmation_sheet.dart';
import 'app_language_sheet.dart';
import '../wishlist/set_image_screen.dart';

/// Main Profile screen: user card (photo, name, email, department) and menu list.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    this.onBack,
  });

  final VoidCallback? onBack;

  static const Color _cardBg = Color(0xFFF5F5F0);
  static const Color _textMuted = Color(0xFF6B7280);
  static const Color _logoutRed = Color(0xFFDC2626);

  static const List<({IconData icon, String label, bool isLogout})> _menuItems = [
    (icon: Icons.person_outline, label: 'Edit profile', isLogout: false),
    (icon: Icons.lock_outline, label: 'Change password', isLogout: false),
    (icon: Icons.language, label: 'App language', isLogout: false),
    (icon: Icons.favorite_border, label: 'Wish list', isLogout: false),
    (icon: Icons.notifications_outlined, label: 'Notification', isLogout: false),
    (icon: Icons.logout, label: 'Logout', isLogout: true),
  ];

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
          onPressed: () {
            if (onBack != null) {
              onBack!();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: AppTheme.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // User card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE5E7EB),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person, size: 36, color: _textMuted),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Bakir Ali',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'bakirali786@gmail.com',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.black.withOpacity(0.85),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Membership: Gold',
                            style: const TextStyle(
                              fontSize: 13,
                              color: _textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Menu list
              ..._menuItems.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _onMenuItemTap(context, item),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        child: Row(
                          children: [
                            Icon(
                              item.icon,
                              size: 24,
                              color: item.isLogout ? _logoutRed : AppTheme.black,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                item.label,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: item.isLogout ? _logoutRed : AppTheme.black,
                                ),
                              ),
                            ),
                            if (!item.isLogout)
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: AppTheme.black,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _onMenuItemTap(BuildContext context, ({IconData icon, String label, bool isLogout}) item) {
    if (item.isLogout) {
      showLogoutConfirmationSheet(context);
      return;
    }
    switch (item.label) {
      case 'Edit profile':
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const EditProfileScreen()),
        );
        break;
      case 'Change password':
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const ChangePasswordScreen()),
        );
        break;
      case 'Notification':
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const NotificationScreen()),
        );
        break;
      case 'Wish list':
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const SetImageScreen()),
        );
        break;
      case 'App language':
        showAppLanguageSheet(context);
        break;
      default:
        break;
    }
  }
}
