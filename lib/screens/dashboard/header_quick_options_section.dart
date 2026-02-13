import 'package:flutter/material.dart';
import 'package:resedential_app/screens/Announcements/announcements_screen.dart';
import 'package:resedential_app/screens/Actions_Emergency_Services/emergency_services_screen.dart';
import 'package:resedential_app/screens/Actions_Bill/bills_list_screen.dart';

import 'package:resedential_app/theme/app_theme.dart';

/// Top dark header with apartment info and quick options row.
class HeaderQuickOptionsSection extends StatelessWidget {
  const HeaderQuickOptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppTheme.topBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppTheme.horizontalPadding,
        22,
        AppTheme.horizontalPadding,
        22,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(),
          SizedBox(height: 24),
          _QuickOptionsRow(),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your apartments',
                style: TextStyle(
                  color: AppTheme.textMuted.withOpacity(0.9),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Suite 202, Roshan Trade Center',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const AnnouncementsScreen(),
              ),
            );
          },
          child: const Icon(
            Icons.notifications_none_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }
}

class _QuickOptionsRow extends StatelessWidget {
  const _QuickOptionsRow();

  static const _options = [
    _QuickOptionData(
      icon: Icons.account_balance_wallet_outlined,
      label: 'Bills\nPayment',
      isPrimary: true,
    ),
    _QuickOptionData(
      icon: Icons.health_and_safety_outlined,
      label: 'Emergency\nservices',
      isPrimary: false,
    ),
    _QuickOptionData(
      icon: Icons.campaign_outlined,
      label: 'Announcement\nand notices',
      isPrimary: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Options',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _options
              .map(
                (opt) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _QuickOptionItem(data: opt),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _QuickOptionData {
  const _QuickOptionData({
    required this.icon,
    required this.label,
    required this.isPrimary,
  });

  final IconData icon;
  final String label;
  final bool isPrimary;
}

class _QuickOptionItem extends StatelessWidget {
  const _QuickOptionItem({required this.data});

  final _QuickOptionData data;

  @override
  Widget build(BuildContext context) {
    final bool isBills = data.isPrimary;

    return GestureDetector(
      onTap: isBills
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const BillsListScreen(),
                ),
              );
            }
          : data.label.contains('Announcement')
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => const AnnouncementsScreen(),
                    ),
                  );
                }
              : data.label.contains('Emergency')
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => const EmergencyServicesScreen(),
                        ),
                      );
                    }
                  : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: AppTheme.quickOptionCircle,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.16),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              data.icon,
            color: Theme.of(context).colorScheme.primary,
              size: 26,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

