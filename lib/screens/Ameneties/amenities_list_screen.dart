import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_theme.dart';
import '../customize_visit/customize_visit_screen.dart';
import '../widgets/bottom_nav_bar.dart';

/// Amenity card item for the list (image on top, title, tags).
class AmenityCardItem {
  const AmenityCardItem({
    required this.title,
    required this.imagePath,
    required this.tags,
  });

  final String title;
  final String imagePath;
  final List<String> tags;
}

/// Amenities list screen: app bar + vertical list of amenity cards
/// (Rooftop Jacuzzi, Indoor Spa Pool, etc.). Opened from Steam/Sauna/Jacuzzi.
class AmenitiesListScreen extends StatelessWidget {
  const AmenitiesListScreen({
    super.key,
    this.onBack,
    this.onCardTap,
  });

  final VoidCallback? onBack;
  final void Function(int index)? onCardTap;

  static const List<AmenityCardItem> amenityCards = [
    AmenityCardItem(
      title: 'Rooftop Jacuzzi',
      imagePath: 'assets/jacuzzi.png',
      tags: ['Great for views', 'higher demand'],
    ),
    AmenityCardItem(
      title: 'Indoor Spa Pool',
      imagePath: 'assets/indoor-spa.png',
      tags: ['Quiet', 'heated, indoor'],
    ),
    AmenityCardItem(
      title: 'Indoor Spa Pool',
      imagePath: 'assets/indoor-spa-two.png',
      tags: ['Quiet', 'heated, indoor'],
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
          child: _buildCardList(context),
        ),
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: 2,
          onTap: (index) {
            if (index == 2) return;
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
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
        'Amenities',
        style: TextStyle(
          color: AppTheme.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCardList(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width > 600 ? 24.0 : AppTheme.horizontalPadding;
    const cardSpacing = 20.0;
    const imageAspectRatio = 16 / 10;

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        16,
        horizontalPadding,
        padding.bottom + 16,
      ),
      itemCount: amenityCards.length,
      separatorBuilder: (_, __) => const SizedBox(height: cardSpacing),
      itemBuilder: (context, i) {
        return _AmenityCard(
          item: amenityCards[i],
          imageAspectRatio: imageAspectRatio,
          onTap: () {
            if (onCardTap != null) {
              onCardTap!(i);
            } else {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => CustomizeVisitScreen(
                    amenityTitle: amenityCards[i].title,
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}

class _AmenityCard extends StatelessWidget {
  const _AmenityCard({
    required this.item,
    required this.imageAspectRatio,
    this.onTap,
  });

  final AmenityCardItem item;
  final double imageAspectRatio;
  final VoidCallback? onTap;

  static const Color _tagBg = Color(0xFFE8E0D0);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final imageWidth = constraints.maxWidth;
        final imageHeight = imageWidth / imageAspectRatio;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppTheme.cardBorderRadius),
                  ),
                  child: Image.asset(
                    item.imagePath,
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: imageWidth,
                      height: imageHeight,
                      color: AppTheme.textMuted.withOpacity(0.3),
                      child: const Icon(
                        Icons.spa_outlined,
                        color: AppTheme.textSecondary,
                        size: 48,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: AppTheme.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (item.tags.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: item.tags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _tagBg,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
