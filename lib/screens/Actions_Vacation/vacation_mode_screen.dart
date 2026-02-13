import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_theme.dart';
import '../widgets/shimmer_widget.dart';
import 'select_vacation_dates_screen.dart';

/// Vacation Mode Screen: Allows users to activate vacation mode for their home.
class VacationModeScreen extends StatefulWidget {
  const VacationModeScreen({super.key});

  @override
  State<VacationModeScreen> createState() => _VacationModeScreenState();
}

class _VacationModeScreenState extends State<VacationModeScreen> {
  bool _isLoading = true;

  /// Returns the correct asset path for web vs mobile.
  static String _getImagePath(String path) {
    if (kIsWeb && path.startsWith('assets/')) {
      return path.substring(7); // Remove 'assets/' prefix
    }
    return path;
  }

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
        body: SafeArea(
          child: _isLoading ? _buildShimmerContent() : _buildContent(horizontalPadding),
        ),
      ),
    );
  }

  Widget _buildContent(double horizontalPadding) {
    return Container(
      color: AppTheme.white,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildTitle(),
            const SizedBox(height: 32),
            _buildIllustration(),
            const SizedBox(height: 32),
            _buildDescription(),
            const SizedBox(height: 24),
            _buildBulletPoints(),
            const SizedBox(height: 24),
            _buildAdditionalDescription(),
            const SizedBox(height: 40),
            _buildContinueButton(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Set Your Peace of Mind with Vacation Mode',
      style: TextStyle(
        color: AppTheme.textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        height: 1.3,
      ),
      textAlign: TextAlign.left,
    );
  }

  Widget _buildIllustration() {
    return Center(
      child: Image.asset(
        _getImagePath('assets/vacation-bg.png'),
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Container(
          height: 280,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.beach_access, size: 80, color: Color(0xFF9CA3AF)),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return const Text(
      'Going away? Let us take care of your home while you\'re on vacation.',
      style: TextStyle(
        color: AppTheme.textPrimary,
        fontSize: 16,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildBulletPoints() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Activate Vacation Mode to schedule:',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        _buildBulletPoint('regular checks on your apartment,'),
        const SizedBox(height: 8),
        _buildBulletPoint('water your plants,'),
        const SizedBox(height: 8),
        _buildBulletPoint('and more.'),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8, right: 12),
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: AppTheme.textPrimary,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalDescription() {
    return Text(
      'Simply set your vacation dates, choose the services you need, and relax knowing everything is handled.',
      style: TextStyle(
        color: AppTheme.textSecondary,
        fontSize: 14,
        height: 1.5,
      ),
      textAlign: TextAlign.left,
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SelectVacationDatesScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFB99146), // Golden-brown color
          foregroundColor: AppTheme.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Continue',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerContent() {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width > 600 ? 24.0 : (width > 400 ? 20.0 : 16.0);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          // Title shimmer
          ShimmerContainer(
            width: double.infinity,
            height: 32,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 32),
          // Illustration shimmer
          ShimmerContainer(
            width: double.infinity,
            height: 280,
            borderRadius: BorderRadius.circular(16),
          ),
          const SizedBox(height: 32),
          // Description shimmer
          ShimmerContainer(
            width: double.infinity,
            height: 24,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 16),
          ShimmerContainer(
            width: double.infinity,
            height: 24,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 24),
          // Bullet points shimmer
          ShimmerContainer(
            width: 200,
            height: 20,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 16),
          ShimmerContainer(
            width: double.infinity,
            height: 20,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 8),
          ShimmerContainer(
            width: double.infinity,
            height: 20,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 8),
          ShimmerContainer(
            width: 150,
            height: 20,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 24),
          // Additional description shimmer
          ShimmerContainer(
            width: double.infinity,
            height: 20,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 8),
          ShimmerContainer(
            width: double.infinity,
            height: 20,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 40),
          // Button shimmer
          ShimmerContainer(
            width: double.infinity,
            height: 56,
            borderRadius: BorderRadius.circular(12),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
