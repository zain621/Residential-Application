import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_theme.dart';
import 'pick_slot_screen.dart';
import '../widgets/shimmer_widget.dart';

/// "Customize Your Session" screen: Session Type selection (Solo, Personal Training, Group Class).
/// Opened when tapping Gym or Yoga card on Facilities screen.
class CustomizeSessionScreen extends StatefulWidget {
  const CustomizeSessionScreen({
    super.key,
    this.amenityTitle,
  });

  final String? amenityTitle;

  @override
  State<CustomizeSessionScreen> createState() => _CustomizeSessionScreenState();
}

class _CustomizeSessionScreenState extends State<CustomizeSessionScreen> {
  bool _isLoading = true;
  
  /// 0 = Solo Workout, 1 = Personal Training, 2 = Group Class
  int _sessionTypeIndex = 0;

  static const List<({
    String label,
    String description,
    String price,
    bool isPremium,
  })> _sessionTypes = [
    (
      label: 'Solo Workout',
      description: 'Train independently at your own pace',
      price: 'Free for residents',
      isPremium: false,
    ),
    (
      label: 'Personal Training',
      description: 'Train independently at your own pace',
      price: 'PKR: 3000/per person',
      isPremium: true,
    ),
    (
      label: 'Group Class',
      description: 'Join scheduled fitness classes',
      price: 'PKR: 3000/per person',
      isPremium: false,
    ),
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
        appBar: AppBar(
          backgroundColor: AppTheme.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.black, size: 22),
            onPressed: () => Navigator.of(context).pop(),
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
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final horizontalPadding = width > 600 ? 24.0 : AppTheme.horizontalPadding;
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  20,
                  horizontalPadding,
                  32,
                ),
                child: _isLoading ? _buildShimmerContent() : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Customize Your Session',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Choose the type of workout you prefer',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _buildSectionLabel('Session Type'),
                    const SizedBox(height: 12),
                    _buildSessionTypeList(width, horizontalPadding),
                    const SizedBox(height: 40),
                    _buildContinueButton(width, horizontalPadding),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ShimmerContainer(width: 220, height: 28),
        const SizedBox(height: 6),
        const ShimmerContainer(width: 280, height: 18),
        const SizedBox(height: 28),
        const ShimmerContainer(width: 130, height: 20),
        const SizedBox(height: 12),
        ...List.generate(3, (_) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ShimmerContainer(width: double.infinity, height: 100),
        )),
        const SizedBox(height: 40),
        const ShimmerContainer(width: double.infinity, height: 56),
      ],
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppTheme.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSessionTypeList(double width, double horizontalPadding) {
    return Column(
      children: List.generate(
        _sessionTypes.length,
        (i) {
          final sessionType = _sessionTypes[i];
          final isSelected = _sessionTypeIndex == i;
          return Padding(
            padding: EdgeInsets.only(bottom: i < _sessionTypes.length - 1 ? 12 : 0),
            child: GestureDetector(
              onTap: () => setState(() => _sessionTypeIndex = i),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFAF5ED) : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppTheme.primaryGold : const Color(0xFFEEEEEE),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Radio<int>(
                      value: i,
                      groupValue: _sessionTypeIndex,
                      onChanged: (value) => setState(() => _sessionTypeIndex = value ?? 0),
                      activeColor: AppTheme.primaryGold,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  sessionType.label,
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (sessionType.isPremium)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8E0D0),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Premium',
                                    style: TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            sessionType.description,
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            sessionType.price,
                            style: TextStyle(
                              color: sessionType.price.contains('Free')
                                  ? AppTheme.primaryGold
                                  : AppTheme.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContinueButton(double width, double horizontalPadding) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => PickSlotScreen(
                amenityTitle: widget.amenityTitle,
                sessionType: _sessionTypes[_sessionTypeIndex].label,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryGold,
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
}
