import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_theme.dart';
import '../widgets/shimmer_widget.dart';
import 'check_information_screen.dart';

/// Select Services Screen: Allows users to select required services and regularity check.
class SelectServicesScreen extends StatefulWidget {
  const SelectServicesScreen({
    super.key,
    this.departureDate,
    this.arrivalDate,
    this.apartment,
    this.name,
  });

  final DateTime? departureDate;
  final DateTime? arrivalDate;
  final String? apartment;
  final String? name;

  @override
  State<SelectServicesScreen> createState() => _SelectServicesScreenState();
}

class _SelectServicesScreenState extends State<SelectServicesScreen> {
  bool _isLoading = true;
  final Set<String> _selectedServices = {};
  String _selectedRegularity = '1 times per week';

  static const List<String> _services = [
    'Plant Watering',
    'Mail Collection',
    'Security Checks',
    'Cleaning Services',
    'Window Checks',
    'Appliances Monitoring',
    'Temperature Control',
  ];

  static const List<String> _regularityOptions = [
    '1 times per week',
    '2 times per week',
    '3 times per week',
    'Daily',
    'Every other day',
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  void _toggleService(String service) {
    setState(() {
      if (_selectedServices.contains(service)) {
        _selectedServices.remove(service);
      } else {
        _selectedServices.add(service);
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
          child: _isLoading
              ? _buildShimmerContent(horizontalPadding)
              : _buildContent(horizontalPadding),
        ),
      ),
    );
  }

  Widget _buildContent(double horizontalPadding) {
    return Container(
      color: AppTheme.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildServicesSection(),
                  const SizedBox(height: 32),
                  _buildRegularitySection(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // Continue button at bottom
          Container(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
            decoration: const BoxDecoration(
              color: AppTheme.white,
              border: Border(
                top: BorderSide(color: Color(0xFFE5E7EB), width: 1),
              ),
            ),
            child: _buildContinueButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Required Services',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select your vacation start and end dates to activate services while you\'re away',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        ..._services.map((service) => _buildServiceRadioButton(service)),
      ],
    );
  }

  Widget _buildServiceRadioButton(String service) {
    final isSelected = _selectedServices.contains(service);
    return InkWell(
      onTap: () => _toggleService(service),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Radio<String>(
              value: service,
              groupValue: isSelected ? service : null,
              onChanged: (_) => _toggleService(service),
              activeColor: AppTheme.primaryGold,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                service,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegularitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Regularity check',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose how often you want your apartment check while you are away',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        _buildRegularityDropdown(),
      ],
    );
  }

  Widget _buildRegularityDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedRegularity,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.textPrimary),
        style: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 16,
        ),
        items: _regularityOptions.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedRegularity = newValue;
            });
          }
        },
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CheckInformationScreen(
                departureDate: widget.departureDate,
                arrivalDate: widget.arrivalDate,
                selectedServices: _selectedServices.toList(),
                regularity: _selectedRegularity,
                apartment: widget.apartment,
                name: widget.name,
              ),
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

  Widget _buildShimmerContent(double horizontalPadding) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          // Title shimmer
          ShimmerContainer(
            width: 250,
            height: 32,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 8),
          // Description shimmer
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
          const SizedBox(height: 24),
          // Radio buttons shimmer
          ...List.generate(7, (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    ShimmerContainer(
                      width: 24,
                      height: 24,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ShimmerContainer(
                        width: double.infinity,
                        height: 20,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 32),
          // Regularity section title shimmer
          ShimmerContainer(
            width: 200,
            height: 32,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 8),
          // Regularity description shimmer
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
          const SizedBox(height: 16),
          // Dropdown shimmer
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
