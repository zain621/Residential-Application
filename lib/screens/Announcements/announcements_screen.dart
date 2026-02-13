import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/notifications_data.dart';
import '../../theme/app_theme.dart';
import '../widgets/shimmer_widget.dart';

/// Notification Screen: Displays list of notifications (announcements, maintenance, etc.).
/// Opened from home dashboard bell icon or Announcements quick option.
class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width > 600 ? 24.0 : (width > 400 ? 20.0 : 16.0);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFF7F7F7),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.white,
        appBar: AppBar(
          backgroundColor: AppTheme.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.black, size: 22),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: const Text(
            'Notification',
            style: TextStyle(
              color: AppTheme.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: _isLoading
              ? _buildShimmerContent(horizontalPadding)
              : _buildContent(horizontalPadding),
        ),
      ),
    );
  }

  Widget _buildContent(double horizontalPadding) {
    return Container(
      color: AppTheme.white,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
        children: [
          ...appNotifications.map((notification) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _NotificationCard(notification: notification),
              )),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildShimmerContent(double horizontalPadding) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
      children: [
        ...List.generate(4, (index) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ShimmerContainer(
                width: double.infinity,
                height: 100,
                borderRadius: BorderRadius.circular(12),
              ),
            )),
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.notification});

  final AppNotification notification;

  static const Color _cardBg = Color(0xFFF5F5F5);
  static const Color _textMuted = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFF5E7CF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: AppTheme.primaryGold,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.description,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            notification.time,
            style: const TextStyle(
              color: _textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
