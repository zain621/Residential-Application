import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'login_screen.dart';

class TenantRoleSelectorScreen extends StatelessWidget {
  const TenantRoleSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.05),
                // Logo Section
                Center(
                  child: Image.asset(
                    'lib/assets/splash-logo.png',
                    height: screenHeight * 0.12,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_not_supported,
                        color: AppTheme.textSecondary,
                        size: 80,
                      );
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.06),
                // "I am a" Text
                Text(
                  'I am a',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppTheme.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: screenHeight * 0.04),
                // Role Selection Buttons
                _buildRoleButton(
                  context: context,
                  title: 'Owner',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildRoleButton(
                  context: context,
                  title: 'Maintainace',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildRoleButton(
                  context: context,
                  title: 'Tenant',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          color: AppTheme.beige,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.primaryGold,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }
}

