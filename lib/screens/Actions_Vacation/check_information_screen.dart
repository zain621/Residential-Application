import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_theme.dart';
import '../widgets/shimmer_widget.dart';
import '../Actions/actions_dashboard_screen.dart';

/// Check Information Screen: Displays summary of vacation mode details.
class CheckInformationScreen extends StatefulWidget {
  const CheckInformationScreen({
    super.key,
    this.departureDate,
    this.arrivalDate,
    this.selectedServices = const [],
    this.regularity,
    this.apartment,
    this.name,
  });

  final DateTime? departureDate;
  final DateTime? arrivalDate;
  final List<String> selectedServices;
  final String? regularity;
  final String? apartment;
  final String? name;

  @override
  State<CheckInformationScreen> createState() => _CheckInformationScreenState();
}

class _CheckInformationScreenState extends State<CheckInformationScreen> {
  bool _isLoading = true;

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day} ${_months[date.month - 1]} ${date.year}';
  }

  DateTime get _displayDepartureDate {
    return widget.departureDate ?? 
        (widget.arrivalDate != null 
            ? widget.arrivalDate!.subtract(const Duration(days: 4))
            : DateTime.now().add(const Duration(days: 1)));
  }

  DateTime get _displayArrivalDate {
    return widget.arrivalDate ?? 
        (widget.departureDate != null 
            ? widget.departureDate!.add(const Duration(days: 4))
            : DateTime.now().add(const Duration(days: 5)));
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 600), () {
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
                  const SizedBox(height: 32),
                  _buildInformationSection(),
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
      'Check information',
      style: TextStyle(
        color: AppTheme.textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        height: 1.3,
      ),
      textAlign: TextAlign.left,
    );
  }

  Widget _buildInformationSection() {
    return Column(
      children: [
        // Dates Group
        _buildInfoRow(
          label: 'Departure date',
          value: _formatDate(_displayDepartureDate),
        ),
        _buildInfoRow(
          label: 'Arrival date',
          value: _formatDate(_displayArrivalDate),
        ),
        _buildDivider(),
        
        // Property/Resident Group
        _buildInfoRow(
          label: 'Apartment',
          value: widget.apartment ?? 'Suite 202',
        ),
        _buildInfoRow(
          label: 'Name',
          value: widget.name ?? 'Tawha Tech',
        ),
        _buildDivider(),
        
        // Services Group
        _buildInfoRow(
          label: 'Services',
          value: widget.selectedServices.isEmpty
              ? 'Plant watering, mail collection'
              : widget.selectedServices.join(', '),
        ),
        _buildInfoRow(
          label: 'Regularity check',
          value: widget.regularity ?? 'Once a week',
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: const Color(0xFFE5E7EB),
      margin: const EdgeInsets.symmetric(vertical: 8),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _showConfirmationPopup(context);
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
          'Confirm booking',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showConfirmationPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return _VacationConfirmationPopup();
      },
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
            width: 200,
            height: 32,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 32),
          // Info rows shimmer
          ...List.generate(6, (index) {
            if (index == 2 || index == 4) {
              // Divider
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  height: 1,
                  color: const Color(0xFFE5E7EB),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerContainer(
                    width: 120,
                    height: 20,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  ShimmerContainer(
                    width: 150,
                    height: 20,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Vacation Confirmation Popup with animation
class _VacationConfirmationPopup extends StatefulWidget {
  @override
  State<_VacationConfirmationPopup> createState() => _VacationConfirmationPopupState();
}

class _VacationConfirmationPopupState extends State<_VacationConfirmationPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Confirmation Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 50,
                    color: Color(0xFF10B981),
                  ),
                ),
                const SizedBox(height: 24),
                // Confirmation Message
                const Text(
                  'Your booking for the vacation management action is now confirmed',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),
                // OK Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close popup
                      for (int i = 0; i < 4 && Navigator.of(context).canPop(); i++) {
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB99146),
                      foregroundColor: AppTheme.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
