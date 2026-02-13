import 'package:flutter/material.dart';

import 'package:resedential_app/theme/app_theme.dart';

/// "Actual News" section with horizontal scroll of news cards.
class ActualNewsSection extends StatelessWidget {
  const ActualNewsSection({super.key});

  static const _newsItems = [
    _NewsItem(
      title: 'Scheduled Water Tank Cleaning',
      dateTime: '31 July, 12:00',
      description:
          'Please be advised that the main water supply for the East Wing will be suspended this Sunday from 9:00 AM to 1:00 PM for biannual tank maintenance.',
      titleColor: Color(0xFFEAB308),
    ),
    _NewsItem(
      title: 'Network maintenance',
      dateTime: '31 July, 12:00',
      description:
          'Please be advised that the East Wing maintenance will be conducted from 9:00 AM to 1:00 PM.',
      titleColor: Color(0xFF3B82F6),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.horizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Actual News',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'View',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _newsItems.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final item = _newsItems[index];
                return _NewsCard(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsItem {
  const _NewsItem({
    required this.title,
    required this.dateTime,
    required this.description,
    required this.titleColor,
  });

  final String title;
  final String dateTime;
  final String description;
  final Color titleColor;
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.item});

  final _NewsItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: item.titleColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: item.titleColor,
                ),
              ),
              const Spacer(),
              Text(
                item.dateTime,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item.title,
            style: TextStyle(
              color: item.titleColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              item.description,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
                height: 1.4,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
