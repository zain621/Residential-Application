import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class WelcomeModal extends StatelessWidget {
  final VoidCallback onGoToDashboard;

  const WelcomeModal({super.key, required this.onGoToDashboard});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: screenHeight * 0.04),
            // Success Icon - Gold Circle with Checkmark
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: AppTheme.primaryGold,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: AppTheme.white,
                size: 60,
              ),
            ),
            SizedBox(height: screenHeight * 0.025),
            // Welcome Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Welcome to Tai Trade Center!',
                style: TextStyle(
                  color: AppTheme.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            // Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Your tenant account is now active',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            // Features - Side by Side Layout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Service Requests
                  Expanded(
                    child: _buildFeatureItem(
                      icon: Icons.chat_bubble_outline,
                      iconSize: 40,
                      title: 'Service Requests',
                      description: 'Report maintenance issues quickly.',
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  // Direct Communication
                  Expanded(
                    child: _buildFeatureItem(
                      icon: Icons.message_outlined,
                      iconSize: 40,
                      title: 'Direct Communication',
                      description: 'Connect with building management.',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            // Go to Dashboard Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onGoToDashboard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGold,
                    foregroundColor: AppTheme.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Login now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required double iconSize,
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppTheme.primaryGold,
          size: iconSize,
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
