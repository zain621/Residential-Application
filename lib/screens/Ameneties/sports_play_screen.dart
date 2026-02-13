import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Sports & Play category content (used inside Services screen).
class SportsPlayScreen extends StatelessWidget {
  const SportsPlayScreen({
    super.key,
    this.onCardTap,
  });

  final VoidCallback? onCardTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Sports & Play',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
