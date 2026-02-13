import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_theme.dart';
import '../widgets/shimmer_widget.dart';
import 'phone_number_popup.dart';

/// Services Dashboard Screen: Main screen for services tab.
/// Displays Active Order card and service cards grid in 2-column layout.
class ServicesDashboardScreen extends StatefulWidget {
  const ServicesDashboardScreen({
    super.key,
    this.onBack,
  });

  /// When set (e.g. when used as a tab), back button calls this instead of Navigator.pop.
  final VoidCallback? onBack;

  @override
  State<ServicesDashboardScreen> createState() => _ServicesDashboardScreenState();
}

class _ServicesDashboardScreenState extends State<ServicesDashboardScreen> {
  bool _isLoading = true;
  int _selectedTabIndex = 2; // Services tab is selected by default

  static const Color _tabInactiveText = Color(0xFF6B7280);
  static const Color _tabInactiveBg = Color(0xFFF3F4F6);
  static const Color _activeOrderCardBg = Color(0xFFFBF6EB);
  static const Color _activeOrderLabel = Color(0xFFB87333);
  static const Color _descriptionGrey = Color(0xFF6B7280);

  static const List<_ServiceItem> _services = [
    _ServiceItem(
      title: 'Electrical',
      iconPath: 'assets/services/flash.png',
      profession: 'Electrician',
      contacts: [
        ('Azam Ali', '03001234567'),
        ('Zulfiqaar', '03001234568'),
        ('Ahmed', '03001234569'),
        ('Rizwan', '03001234570'),
      ],
    ),
    _ServiceItem(
      title: 'Plumbing',
      iconPath: 'assets/services/flash.png',
      profession: 'Plumber',
      contacts: [
        ('Azam Ali', '03001234571'),
        ('Zulfiqaar', '03001234572'),
        ('Ahmed', '03001234573'),
        ('Rizwan', '03001234574'),
      ],
    ),
    _ServiceItem(
      title: 'Welding',
      iconPath: 'assets/services/flash.png',
      profession: 'Welding',
      contacts: [
        ('Azam Ali', '03001234575'),
        ('Zulfiqaar', '03001234576'),
        ('Ahmed', '03001234577'),
        ('Rizwan', '03001234578'),
      ],
    ),
    _ServiceItem(
      title: 'Sewerage',
      iconPath: 'assets/services/flash.png',
      profession: 'Sewerage',
      contacts: [
        ('Azam Ali', '03001234579'),
        ('Zulfiqaar', '03001234580'),
        ('Ahmed', '03001234581'),
        ('Rizwan', '03001234582'),
      ],
    ),
    _ServiceItem(
      title: 'Tea Services',
      iconPath: 'assets/services/flash.png',
      profession: 'Tea Service',
      contacts: [
        ('Azam Ali', '03001234583'),
        ('Zulfiqaar', '03001234584'),
        ('Ahmed', '03001234585'),
        ('Rizwan', '03001234586'),
      ],
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
          _buildActiveOrderCard(),
          const SizedBox(height: 24),
          _buildServiceGrid(width, horizontalPadding),
          const SizedBox(height: 24),
        ],
      ),
    );

    // If used as a tab (onBack is provided), don't wrap in Scaffold
    // Also don't show segmented control as it's shown by parent FacilitiesScreen
    if (widget.onBack != null) {
      return content;
    }

    // If used standalone, wrap in Scaffold with AppBar and show segmented control
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
            'Services',
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
              _buildSegmentedControl(horizontalPadding),
              Expanded(child: content),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentedControl(double horizontalPadding) {
    const tabs = ['Amenities', 'Actions', 'Services'];
    return Padding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 16),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _tabInactiveBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = _selectedTabIndex == index;
            final isAmenities = index == 0;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTabIndex = index),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isAmenities)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Image.asset(
                            'assets/services/Icon.png',
                            width: 16,
                            height: 16,
                            fit: BoxFit.contain,
                            color: isSelected ? AppTheme.primaryGold : _tabInactiveText,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.workspace_premium,
                              size: 16,
                              color: isSelected ? AppTheme.primaryGold : _tabInactiveText,
                            ),
                          ),
                        ),
                      Text(
                        tabs[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? AppTheme.textPrimary : _tabInactiveText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildActiveOrderCard() {
    if (_isLoading) {
      return ShimmerContainer(
        width: double.infinity,
        height: 100,
        borderRadius: BorderRadius.circular(12),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _activeOrderCardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _activeOrderLabel.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active Order',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _activeOrderLabel,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Cleaning Order C 202',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '2 August 2026, 12:00',
                  style: TextStyle(
                    fontSize: 12,
                    color: _descriptionGrey,
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            'assets/services/notification.png',
            width: 24,
            height: 24,
            fit: BoxFit.contain,
            color: AppTheme.primaryGold,
            errorBuilder: (_, __, ___) => Icon(
              Icons.notifications_outlined,
              size: 24,
              color: AppTheme.primaryGold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceGrid(double width, double horizontalPadding) {
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
      itemCount: _services.length,
      itemBuilder: (context, index) {
        final service = _services[index];
        return InkWell(
          onTap: () {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (ctx) => PhoneNumberPopup(
                serviceTitle: service.title,
                profession: service.profession,
                contacts: service.contacts,
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: _ServiceCard(service: service),
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
      children: List.generate(5, (index) {
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

class _ServiceItem {
  const _ServiceItem({
    required this.title,
    required this.iconPath,
    required this.profession,
    required this.contacts,
  });

  final String title;
  final String iconPath;
  final String profession;
  final List<(String name, String phone)> contacts;
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service});

  final _ServiceItem service;

  IconData _getIconForService(String title) {
    switch (title.toLowerCase()) {
      case 'electrical':
        return Icons.flash_on;
      case 'plumbing':
        return Icons.plumbing;
      case 'welding':
        return Icons.build;
      case 'sewerage':
        return Icons.water_drop;
      case 'tea services':
        return Icons.local_cafe;
      default:
        return Icons.build;
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
            service.iconPath,
            width: 40,
            height: 40,
            fit: BoxFit.contain,
            color: const Color(0xFF374151),
            errorBuilder: (_, __, ___) => Icon(
              _getIconForService(service.title),
              size: 40,
              color: const Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            service.title,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Standard, General\nAfter renovation',
            style: TextStyle(
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
