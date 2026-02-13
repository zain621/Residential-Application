import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../services/electrical_services_order_screen.dart';
import '../Services/phone_number_popup.dart';
import 'amenities_list_screen.dart';
import 'sports_play_screen.dart';

/// Main Services screen with category tabs (Amenities, Actions, Services).
/// Uses icons from assets/services/.
class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key, this.onBack});

  /// When set (e.g. when used as a tab), back button calls this instead of Navigator.pop.
  final VoidCallback? onBack;

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  int _selectedCategoryIndex = 2; // Services tab is active by default

  static const Color _tabInactiveText = Color(0xFF6B7280);
  static const Color _tabInactiveBg = Color(0xFFF3F4F6);
  static const Color _activeOrderCardBg = Color(0xFFFBF6EB);
  static const Color _activeOrderLabel = Color(0xFFB87333);
  static const Color _descriptionGrey = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.sizeOf(context).width > 400 ? 20.0 : 16.0;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategoryTabs(horizontalPadding),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                if (_selectedCategoryIndex == 2) ...[
                  _buildActiveOrderCard(context),
                  const SizedBox(height: 24),
                ],
                _buildContentGrid(context, horizontalPadding),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );

    // If used as a tab (onBack is provided), don't wrap in Scaffold
    // The parent FacilitiesScreen will handle the AppBar
    if (widget.onBack != null) {
      return content;
    }

    // If used standalone, wrap in Scaffold with AppBar
    return Scaffold(
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
      body: SafeArea(child: content),
    );
  }

  Widget _buildCategoryTabs(double horizontalPadding) {
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
            final isSelected = _selectedCategoryIndex == index;
            final isAmenities = index == 0;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedCategoryIndex = index),
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

  Widget _buildActiveOrderCard(BuildContext context) {
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

  Widget _buildContentGrid(BuildContext context, double horizontalPadding) {
    const crossAxisCount = 2;
    const spacing = 14.0;
    const aspectRatio = 0.82;

    if (_selectedCategoryIndex == 0) {
      final services = [
        _ServiceItem(
          iconPath: 'assets/services/broom.png',
          title: 'Steam',
          description: 'Standard, General\nAfter renovation',
          hasCrown: true,
        ),
        _ServiceItem(
          iconPath: 'assets/services/sauna.png',
          title: 'Sauna',
          description: 'Standard, General\nAfter renovation',
          hasCrown: true,
        ),
        _ServiceItem(
          iconPath: 'assets/services/Jacuzzi.png',
          title: 'Jacuzzi',
          description: 'Standard, General\nAfter renovation',
          hasCrown: true,
        ),
        _ServiceItem(
          iconPath: 'assets/services/info-circle.png',
          title: 'Gym',
          description: 'Standard, General\nAfter renovation',
          hasCrown: false,
        ),
        _ServiceItem(
          iconPath: 'assets/services/info-circle.png',
          title: 'Yoga room',
          description: 'Standard, General\nAfter renovation',
          hasCrown: false,
        ),
      ];
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          childAspectRatio: aspectRatio,
        ),
        itemCount: services.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            // Steam (0), Sauna (1), Jacuzzi (2) → Amenities list flow; rest → order screen
            if (index <= 2) {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => AmenitiesListScreen(),
                ),
              );
            } else {
              _openServiceOrderScreen(context);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: _ServiceCard(item: services[index]),
        ),
      );
    }

    if (_selectedCategoryIndex == 1) {
      return SportsPlayScreen(
        onCardTap: () => _openServiceOrderScreen(context),
      );
    }

    // Services tab (index 2) - Service cards grid
    final services = [
      _ServiceUtilItem(
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
      _ServiceUtilItem(
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
      _ServiceUtilItem(
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
      _ServiceUtilItem(
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
      _ServiceUtilItem(
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
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        childAspectRatio: 0.85,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
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
          child: _ServiceUtilCard(service: service),
        );
      },
    );
  }

  void _openServiceOrderScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ElectricalServicesOrderScreen(),
      ),
    );
  }
}

class _ServiceItem {
  const _ServiceItem({
    required this.iconPath,
    required this.title,
    required this.description,
    required this.hasCrown,
  });
  final String iconPath;
  final String title;
  final String description;
  final bool hasCrown;
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.item});

  final _ServiceItem item;

  static const Color _cardBorder = Color(0xFFE5E7EB);
  static const Color _descriptionGrey = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Image.asset(
                item.iconPath,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
                color: _descriptionGrey,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.grid_view_rounded,
                  size: 40,
                  color: _descriptionGrey,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.black,
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: _descriptionGrey,
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (item.hasCrown)
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                'assets/services/Icon.png',
                width: 20,
                height: 20,
                fit: BoxFit.contain,
                color: AppTheme.primaryGold,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.workspace_premium,
                  size: 20,
                  color: AppTheme.primaryGold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ServiceUtilItem {
  const _ServiceUtilItem({
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

class _ServiceUtilCard extends StatelessWidget {
  const _ServiceUtilCard({required this.service});

  final _ServiceUtilItem service;

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
