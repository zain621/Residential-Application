import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_theme.dart';
import '../widgets/shimmer_widget.dart';
import 'select_services_screen.dart';

/// Select Vacation Dates Screen: Allows users to select departure and arrival dates.
class SelectVacationDatesScreen extends StatefulWidget {
  const SelectVacationDatesScreen({
    super.key,
    this.apartment,
    this.name,
  });

  final String? apartment;
  final String? name;

  @override
  State<SelectVacationDatesScreen> createState() => _SelectVacationDatesScreenState();
}

class _SelectVacationDatesScreenState extends State<SelectVacationDatesScreen> {
  bool _isLoading = true;
  DateTime? _departureDate;
  DateTime? _arrivalDate;

  @override
  void initState() {
    super.initState();
    // Set default dates (in the future)
    final now = DateTime.now();
    _departureDate = DateTime(now.year, now.month, now.day + 1);
    _arrivalDate = DateTime(now.year, now.month, now.day + 5);
    
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  Future<void> _selectDepartureDate(BuildContext context) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, now.day);
    final initialDate = _departureDate != null && !_departureDate!.isBefore(firstDate)
        ? _departureDate!
        : firstDate;
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 1, now.month, now.day),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryGold,
              onPrimary: AppTheme.white,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _departureDate) {
      setState(() {
        _departureDate = picked;
        // Ensure arrival date is after departure date
        if (_arrivalDate != null && (_arrivalDate!.isBefore(picked) || _arrivalDate!.isAtSameMomentAs(picked))) {
          _arrivalDate = DateTime(picked.year, picked.month, picked.day + 1);
        }
      });
    }
  }

  Future<void> _selectArrivalDate(BuildContext context) async {
    final now = DateTime.now();
    final departureDate = _departureDate ?? DateTime(now.year, now.month, now.day + 1);
    final firstDate = DateTime(departureDate.year, departureDate.month, departureDate.day + 1);
    final initialDate = _arrivalDate != null && !_arrivalDate!.isBefore(firstDate)
        ? _arrivalDate!
        : firstDate;
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 1, now.month, now.day),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryGold,
              onPrimary: AppTheme.white,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _arrivalDate) {
      setState(() {
        _arrivalDate = picked;
      });
    }
  }

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day} ${_months[date.month - 1]} ${date.year}';
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
                  _buildTitle(),
                  const SizedBox(height: 8),
                  _buildDescription(),
                  const SizedBox(height: 32),
                  _buildDateField(
                    label: 'Departure date',
                    date: _departureDate,
                    onTap: () => _selectDepartureDate(context),
                  ),
                  const SizedBox(height: 24),
                  _buildDateField(
                    label: 'Arrival date',
                    date: _arrivalDate,
                    onTap: () => _selectArrivalDate(context),
                  ),
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

  Widget _buildTitle() {
    return const Text(
      'Select Vacation Dates',
      style: TextStyle(
        color: AppTheme.textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        height: 1.3,
      ),
      textAlign: TextAlign.left,
    );
  }

  Widget _buildDescription() {
    return Text(
      'Select your vacation start and end dates to activate services while you\'re away.',
      style: TextStyle(
        color: AppTheme.textSecondary,
        fontSize: 14,
        height: 1.5,
      ),
      textAlign: TextAlign.left,
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: const Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                Text(
                  _formatDate(date),
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    final isEnabled = _departureDate != null && _arrivalDate != null;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled
            ? () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SelectServicesScreen(
                      departureDate: _departureDate,
                      arrivalDate: _arrivalDate,
                      apartment: widget.apartment,
                      name: widget.name,
                    ),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFB99146), // Golden-brown color
          foregroundColor: AppTheme.white,
          disabledBackgroundColor: const Color(0xFFE5E7EB),
          disabledForegroundColor: const Color(0xFF9CA3AF),
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
          const SizedBox(height: 32),
          // Date field shimmer
          ShimmerContainer(
            width: double.infinity,
            height: 56,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 24),
          ShimmerContainer(
            width: double.infinity,
            height: 56,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }
}
