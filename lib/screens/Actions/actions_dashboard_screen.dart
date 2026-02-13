import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_theme.dart';
import '../widgets/shimmer_widget.dart';
import '../Actions_Vacation/vacation_mode_screen.dart';
import '../Actions_Bill/bills_list_screen.dart';
import '../Order_Guest_Pass/order_guest_pass_screen.dart';

/// Actions Dashboard Screen: Main screen for actions tab.
/// Displays action cards grid (Bills, Vacation Management, Order Guest Pass).
class ActionsDashboardScreen extends StatefulWidget {
  const ActionsDashboardScreen({
    super.key,
    this.onBack,
  });

  /// When set (e.g. when used as a tab), back button calls this instead of Navigator.pop.
  final VoidCallback? onBack;

  @override
  State<ActionsDashboardScreen> createState() => _ActionsDashboardScreenState();
}

class _ActionsDashboardScreenState extends State<ActionsDashboardScreen> {
  bool _isLoading = true;

  static const List<_ActionItem> _actions = [
    _ActionItem(
      title: 'Bills',
      iconPath: 'assets/services/Utility-Bills.png',
      description: 'Standard, General\nAfter renovation',
    ),
    _ActionItem(
      title: 'Vacation Management',
      iconPath: 'assets/services/vacation.png',
      description: 'Standard, General\nAfter renovation',
    ),
    _ActionItem(
      title: 'Order Guest Pass',
      iconPath: 'assets/services/parking.png',
      description: 'Standard, General\nAfter renovation',
    ),
  ];

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

    final content = SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildActionGrid(width, horizontalPadding),
          const SizedBox(height: 24),
        ],
      ),
    );

    // If used as a tab (onBack is provided), don't wrap in Scaffold
    // The parent FacilitiesScreen will handle the AppBar and tabs
    if (widget.onBack != null) {
      return content;
    }

    // If used standalone, wrap in Scaffold with AppBar
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
            'Actions',
            style: TextStyle(
              color: AppTheme.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(child: content),
      ),
    );
  }

  Widget _buildActionGrid(double width, double horizontalPadding) {
    const crossAxisCount = 2;
    const spacing = 14.0;

    if (_isLoading) {
      return _buildShimmerGrid(crossAxisCount, spacing, width, horizontalPadding);
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        childAspectRatio: 0.85,
      ),
      itemCount: _actions.length,
      itemBuilder: (context, index) {
        final action = _actions[index];
        return InkWell(
          onTap: () {
            if (action.title == 'Vacation Management') {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const VacationModeScreen(),
                ),
              );
            } else if (action.title == 'Bills') {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const BillsListScreen(),
                ),
              );
            } else if (action.title == 'Order Guest Pass') {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const OrderGuestPassScreen(),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${action.title} tapped'),
                  duration: const Duration(seconds: 1),
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: _ActionCard(action: action),
        );
      },
    );
  }

  Widget _buildShimmerGrid(int crossAxisCount, double spacing, double width, double horizontalPadding) {
    final cardWidth = (width - (horizontalPadding * 2) - spacing) / crossAxisCount;
    final cardHeight = cardWidth / 0.85;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: List.generate(3, (index) {
        return SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: ShimmerContainer(
            width: cardWidth,
            height: cardHeight,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }
}

class _ActionItem {
  const _ActionItem({
    required this.title,
    required this.iconPath,
    required this.description,
  });

  final String title;
  final String iconPath;
  final String description;
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.action});

  final _ActionItem action;

  /// Returns the correct asset path for web vs mobile.
  static String _getImagePath(String path) {
    if (kIsWeb && path.startsWith('assets/')) {
      return path.substring(7); // Remove 'assets/' prefix
    }
    return path;
  }

  IconData _getFallbackIcon(String title) {
    switch (title.toLowerCase()) {
      case 'bills':
        return Icons.receipt_long;
      case 'vacation management':
        return Icons.beach_access;
      case 'order guest pass':
        return Icons.local_parking;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            _getImagePath(action.iconPath),
            width: 40,
            height: 40,
            fit: BoxFit.contain,
            color: const Color(0xFF374151),
            errorBuilder: (_, __, ___) => Icon(
              _getFallbackIcon(action.title),
              size: 40,
              color: const Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            action.title,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            action.description,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 12,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
