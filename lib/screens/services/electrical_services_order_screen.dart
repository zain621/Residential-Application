import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Electrical Services Order screen: service card, problem categories, Continue.
/// Uses icons from lib/assets (and assets/services for web-safe paths).
class ElectricalServicesOrderScreen extends StatelessWidget {
  const ElectricalServicesOrderScreen({super.key});

  static const Color _cardBg = Color(0xFFF3F4F6);
  static const Color _descriptionGrey = Color(0xFF6B7280);
  static const Color _continueButtonBg = Color(0xFFB89A50);

  static const List<String> _problemCategories = [
    'Lighting issues',
    'Outlets and switches',
    'Wiring',
    'Electrical Panel',
    'Appliance Installation',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.sizeOf(context).width > 400 ? 20.0 : 16.0;
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.black, size: 22),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Electrical',
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
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildServiceOrderCard(context),
                    const SizedBox(height: 28),
                    const Text(
                      'Select your problem',
                      style: TextStyle(
                        color: AppTheme.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ..._problemCategories.map(
                      (label) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _ProblemCategoryCard(label: label),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(horizontalPadding, 12, horizontalPadding, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _continueButtonBg,
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
                      fontWeight: FontWeight.bold,
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

  Widget _buildServiceOrderCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/services/flash.png',
            width: 32,
            height: 32,
            fit: BoxFit.contain,
            color: AppTheme.black,
            errorBuilder: (_, __, ___) => Icon(
              Icons.bolt_outlined,
              size: 32,
              color: AppTheme.black,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Electrical Services Order',
            style: TextStyle(
              color: AppTheme.black,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select a category, describe your issue, and schedule an electrician visit.',
            style: TextStyle(
              color: _descriptionGrey,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProblemCategoryCard extends StatelessWidget {
  const _ProblemCategoryCard({required this.label});

  final String label;

  static const Color _categoryCardBg = Color(0xFFFAFAFA);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _categoryCardBg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: _categoryCardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEEEEEE)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Image.asset(
                'assets/services/arrow-down.png',
                width: 20,
                height: 20,
                fit: BoxFit.contain,
                color: AppTheme.black,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.keyboard_arrow_down,
                  size: 24,
                  color: AppTheme.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
