import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_theme.dart';
import 'package:resedential_app/screens/Ameneties/amenities_recreation.dart';
import 'package:resedential_app/screens/Ameneties/amenities_social_utility_screen.dart';
import 'package:resedential_app/screens/Ameneties/amenities_utility_specialized_screen.dart';
import 'package:resedential_app/screens/Ameneties/amenities_list_screen.dart';
import '../Ameneties_Gym_Yoga/customize_session_screen.dart';
import 'package:resedential_app/screens/Services/services_dashboard_screen.dart';
import 'package:resedential_app/screens/Actions/actions_dashboard_screen.dart';
import '../widgets/bottom_nav_bar.dart';

import 'facilities_nav.dart';

/// Amenities/Facilities screen matching the design: app bar, primary tabs,
/// scrollable category chips, facility grid (icons from assets/services).
class FacilitiesScreen extends StatefulWidget {
  const FacilitiesScreen({
    super.key,
    this.initialNavIndex = 0,
    this.initialPrimaryTabIndex = 0,
    this.showBottomNav = true,
    this.onBack,
  });

  /// Bottom nav index to show as selected when [showBottomNav] is true.
  final int initialNavIndex;
  /// Primary tab to show: 0 = Amenities, 1 = Actions, 2 = Services. Use when opening from any screen.
  final int initialPrimaryTabIndex;
  /// When false (e.g. when used as a tab), the screen does not show its own bottom nav.
  final bool showBottomNav;
  /// When set (e.g. when used as a tab), back button calls this instead of Navigator.pop.
  final VoidCallback? onBack;

  @override
  State<FacilitiesScreen> createState() => _FacilitiesScreenState();
}

class _FacilitiesScreenState extends State<FacilitiesScreen> {
  late int _primaryTabIndex;
  int _chipIndex = 0;
  int _bottomNavIndex = 0;
  int? _lastNavigatedChipIndex; // Track which chip screen we just navigated to

  @override
  void initState() {
    super.initState();
    _primaryTabIndex = widget.initialPrimaryTabIndex.clamp(0, 2);
  }

  static const List<String> _primaryTabs = ['Amenities', 'Actions', 'Services'];
  static const List<String> _chips = [
    'Relaxation',
    'Social/Utility',
    'Recreation',
    'Utility/Specialized',
  ];

  /// Facility titles that open the Amenities list screen (Steam, Sauna, Jacuzzi).
  static const Set<String> _opensAmenityList = {'Steam', 'Sauna', 'Jacuzzi'};

  static const List<_FacilityItem> _facilities = [
    _FacilityItem(
      title: 'Steam',
      iconPath: 'assets/services/Icon.png',
      subtitle1: 'Refresh your body and skin',
      subtitle2: 'with a calming steam session.',
      showCrown: true,
    ),
    _FacilityItem(
      title: 'Sauna',
      iconPath: 'assets/services/sauna.png',
      subtitle1: 'Relax and detox in a warm,',
      subtitle2: 'soothing heat environment.',
      showCrown: true,
    ),
    _FacilityItem(
      title: 'Jacuzzi',
      iconPath: 'assets/services/Jacuzzi.png',
      subtitle1: 'Unwind in bubbling hot ',
      subtitle2: 'water for ultimate relaxation.',
      showCrown: true,
    ),
    _FacilityItem(
      title: 'Gym',
      iconPath: 'assets/services/gym.jpg',
      subtitle1: 'Fully equipped fitness ',
      subtitle2: 'space for your daily workouts.',
      showCrown: false,
    ),
    _FacilityItem(
      title: 'Yoga room',
      iconPath: 'assets/services/yoga.jpg',
      subtitle1: 'peaceful space for yoga',
      subtitle2: 'and meditation.',
      showCrown: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFF7F7F7),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.white,
        appBar: _buildAppBar(context),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPrimaryTabs(context),
              if (_primaryTabIndex == 0) _buildChips(context),
              Expanded(
                child: _primaryTabIndex == 1
                    ? ActionsDashboardScreen(onBack: widget.onBack)
                    : _primaryTabIndex == 2
                        ? ServicesDashboardScreen(onBack: widget.onBack)
                        : SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.horizontalPadding,
                              vertical: 16,
                            ),
                            child: _buildFacilityGrid(context),
                          ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: widget.showBottomNav
            ? AppBottomNavBar(
                currentIndex: _bottomNavIndex,
                onTap: _onBottomNavTap,
              )
            : null,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final title = _primaryTabIndex == 2 ? 'Services' : _primaryTabs[_primaryTabIndex];
    return AppBar(
      backgroundColor: AppTheme.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.black, size: 22),
        onPressed: () {
          if (widget.onBack != null) {
            widget.onBack!();
          } else {
            Navigator.of(context).pop();
          }
        },
      ),
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          color: AppTheme.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPrimaryTabs(BuildContext context) {
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
          children: List.generate(
            _primaryTabs.length,
            (i) => Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _primaryTabIndex = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: _primaryTabIndex == i ? selectedBg : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _primaryTabs[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _primaryTabIndex == i ? selectedText : inactiveText,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChips(BuildContext context) {
    const inactiveBg = Color(0xFFF3F4F6);
    const selectedBg = Color(0xFFE8E8E8);
    const inactiveText = Color(0xFF9CA3AF);

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding),
        itemCount: _chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final selected = _chipIndex == i;
          return GestureDetector(
            onTap: () {
              setState(() => _chipIndex = i);
              if (_primaryTabIndex != 0) return;

              // Amenities sub-screens: open by chip index and sync active tab on return.
              Future<void> handleReturn(int? value) async {
                if (!mounted || value == null) return;
                // Switch to Actions or Services tab when requested from sub-screen.
                if (value == kPopResultSwitchToActionsTab) {
                  setState(() {
                    _primaryTabIndex = 1;
                    _lastNavigatedChipIndex = null;
                  });
                  return;
                }
                if (value == kPopResultSwitchToServicesTab) {
                  setState(() {
                    _primaryTabIndex = 2;
                    _lastNavigatedChipIndex = null;
                  });
                  return;
                }
                // Update chip index.
                final newChipIndex = value;
                setState(() => _chipIndex = newChipIndex);
                
                // If going to Relaxation (0), stay on main screen - no navigation needed.
                if (newChipIndex == 0) {
                  _lastNavigatedChipIndex = null;
                  return;
                }
                
                // Only navigate if switching to a different chip screen.
                // If returning to the same chip we just came from, don't navigate again.
                if (newChipIndex == _lastNavigatedChipIndex) {
                  return;
                }
                
                // Route to the appropriate sub-screen based on returned chip index.
                // This handles chip switching from within a sub-screen.
                if (newChipIndex == 1) {
                  _lastNavigatedChipIndex = 1;
                  await Navigator.of(context).push<int>(
                    MaterialPageRoute<int>(
                      builder: (_) => const AmenitiesSocialUtilityScreen(),
                    ),
                  );
                } else if (newChipIndex == 2) {
                  _lastNavigatedChipIndex = 2;
                  await Navigator.of(context).push<int>(
                    MaterialPageRoute<int>(
                      builder: (_) => const AmenitiesRecreationScreen(),
                    ),
                  );
                } else if (newChipIndex == 3) {
                  _lastNavigatedChipIndex = 3;
                  await Navigator.of(context).push<int>(
                    MaterialPageRoute<int>(
                      builder: (_) => const AmenitiesUtilitySpecializedScreen(),
                    ),
                  );
                }
              }

              if (i == 1) {
                _lastNavigatedChipIndex = 1;
                Navigator.of(context)
                    .push<int>(
                  MaterialPageRoute<int>(
                    builder: (_) => const AmenitiesSocialUtilityScreen(),
                  ),
                )
                    .then(handleReturn);
              } else if (i == 2) {
                _lastNavigatedChipIndex = 2;
                Navigator.of(context)
                    .push<int>(
                  MaterialPageRoute<int>(
                    builder: (_) => const AmenitiesRecreationScreen(),
                  ),
                )
                    .then(handleReturn);
              } else if (i == 3) {
                _lastNavigatedChipIndex = 3;
                Navigator.of(context)
                    .push<int>(
                  MaterialPageRoute<int>(
                    builder: (_) => const AmenitiesUtilitySpecializedScreen(),
                  ),
                )
                    .then(handleReturn);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? selectedBg : inactiveBg,
                borderRadius: BorderRadius.circular(22),
              ),
              alignment: Alignment.center,
              child: Text(
                _chips[i],
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

  void _onFacilityTap(BuildContext context, _FacilityItem item) {
    final titleLower = item.title.toLowerCase();
    
    // Gym or Yoga -> Customize Session Screen
    if (titleLower.contains('gym') || titleLower.contains('yoga')) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => CustomizeSessionScreen(
            amenityTitle: item.title,
          ),
        ),
      );
      return;
    }
    
    // Steam, Sauna, Jacuzzi -> Amenities List Screen
    if (_opensAmenityList.contains(item.title)) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const AmenitiesListScreen(),
        ),
      );
    }
  }

  Widget _buildFacilityGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const crossAxisCount = 2;
        const spacing = 12.0;
        final width = (constraints.maxWidth - spacing) / crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List.generate(
            _facilities.length,
            (i) => SizedBox(
              width: width,
              child: _FacilityCard(
                item: _facilities[i],
                onTap: () => _onFacilityTap(context, _facilities[i]),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onBottomNavTap(int index) {
    setState(() => _bottomNavIndex = index);
    if (index == 0) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }
}

class _FacilityItem {
  const _FacilityItem({
    required this.title,
    required this.iconPath,
    required this.subtitle1,
    required this.subtitle2,
    this.showCrown = true,
  });

  final String title;
  final String iconPath;
  final String subtitle1;
  final String subtitle2;
  final bool showCrown;
}

class _FacilityCard extends StatelessWidget {
  const _FacilityCard({required this.item, this.onTap});

  final _FacilityItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  item.iconPath,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 48,
                    height: 48,
                    color: AppTheme.textMuted.withOpacity(0.3),
                    child: const Icon(Icons.spa_outlined, color: AppTheme.textSecondary),
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
          const SizedBox(height: 12),
          Text(
            item.title,
            style: const TextStyle(
              color: AppTheme.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.subtitle1,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
          Text(
            item.subtitle2,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    ),
    );
  }
}
