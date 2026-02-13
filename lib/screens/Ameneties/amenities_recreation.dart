import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../Facilities/facilities_nav.dart';
import '../widgets/bottom_nav_bar.dart';
import '../Ameneties_Sports/amenities_list_screen.dart';

/// Amenities screen - Recreation sub-tab (e.g. Sports). Main tab: Amenities, sub tab: Recreation active.
class AmenitiesRecreationScreen extends StatelessWidget {
  const AmenitiesRecreationScreen({super.key});

  /// Web build doubles "assets/" prefix, so use path without it. Mobile uses full path.
  static String get _sportsIconPath =>
      kIsWeb ? 'services/sports.png' : 'assets/services/sports.png';

  static List<_AmenityItem> get _items => [
    _AmenityItem(
      title: 'Sports',
      description: 'A wonderful muliple sports indoor activity center.',
      iconPath: _sportsIconPath,
      showCrown: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.black, size: 22),
          onPressed: () => Navigator.of(context).pop(2), // Return chip index 2 (Recreation)
        ),
        centerTitle: true,
        title: const Text(
          'Amenities',
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
            const _PrimaryTabs(),
            const _ChipsRow(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.horizontalPadding,
                  vertical: 16,
                ),
                child: _AmenityGrid(items: _items),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else if (index == 2) {
            // Already on Facilities; stay on this screen.
          } else {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
      ),
    );
  }
}

class _PrimaryTabs extends StatelessWidget {
  const _PrimaryTabs();

  @override
  Widget build(BuildContext context) {
    const inactiveBg = Color(0xFFF3F4F6);
    const selectedBg = Color(0xFFE8E8E8);
    const selectedText = AppTheme.black;
    const inactiveText = Color(0xFF9CA3AF);

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppTheme.horizontalPadding, 8, AppTheme.horizontalPadding, 12),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: inactiveBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selectedBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Amenities',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: selectedText,
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(kPopResultSwitchToActionsTab),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: const Text(
                    'Actions',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: inactiveText,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(kPopResultSwitchToServicesTab),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: const Text(
                    'Services',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: inactiveText,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChipsRow extends StatelessWidget {
  const _ChipsRow();

  @override
  Widget build(BuildContext context) {
    const inactiveBg = Color(0xFFF3F4F6);
    const selectedBg = Color(0xFFE8E8E8);
    const inactiveText = Color(0xFF9CA3AF);

    const chips = ['Relaxation', 'Social/Utility', 'Recreation', 'Utility/Specialized'];
    const selectedIndex = 2; // Recreation 

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding),
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final selected = index == selectedIndex;
          return GestureDetector(
            onTap: () {
              if (index == 0) Navigator.of(context).pop(0);
              else if (index == 1) Navigator.of(context).pop(1);
              else if (index == 3) Navigator.of(context).pop(3);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? selectedBg : inactiveBg,
                borderRadius: BorderRadius.circular(22),
              ),
              alignment: Alignment.center,
              child: Text(
                chips[index],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: selected ? AppTheme.black : inactiveText,
                ),
                softWrap: true,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Grid spacing and margins to match design (16–20px between cards).
const double _gridSpacing = 16.0;
/// Card height so title and full description (3 lines) are visible.
const double _cardHeight = 200.0;

class _AmenityGrid extends StatelessWidget {
  const _AmenityGrid({required this.items});

  final List<_AmenityItem> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const crossAxisCount = 2;
        final width = (constraints.maxWidth - _gridSpacing) / crossAxisCount;

        return Wrap(
          spacing: _gridSpacing,
          runSpacing: _gridSpacing,
          children: List.generate(
            items.length,
            (i) => SizedBox(
              width: width,
              height: _cardHeight,
              child: _AmenityCard(item: items[i]),
            ),
          ),
        );
      },
    );
  }
}

class _AmenityItem {
  const _AmenityItem({
    required this.title,
    required this.description,
    required this.iconPath,
    this.showCrown = false,
  });

  final String title;
  final String description;
  final String iconPath;
  final bool showCrown;
}

/// Card internal padding and spacing to match design exactly.
const double _cardPadding = 16.0;
const double _iconTitleSpacing = 12.0;
const double _titleDescSpacing = 6.0;

class _AmenityCard extends StatelessWidget {
  const _AmenityCard({required this.item});

  final _AmenityItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item.title.toLowerCase() == 'sports') {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const AmenitiesListScreen(),
            ),
          );
        }
      },
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(_cardPadding),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppTheme.textMuted.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  item.iconPath,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.sports_soccer,
                    size: 32,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
              if (item.showCrown) ...[
                const Spacer(),
                Icon(
                  Icons.workspace_premium,
                  size: 22,
                  color: AppTheme.primaryGold,
                ),
              ],
            ],
          ),
          SizedBox(height: _iconTitleSpacing),
          Text(
            item.title,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          SizedBox(height: _titleDescSpacing),
          Expanded(
            child: Text(
              item.description,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
                height: 1.4,
              ),
              maxLines: 4,
              overflow: TextOverflow.fade,
            ),
          ),
        ],
      ),
      ),
    );
  }
}

