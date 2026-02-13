import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_theme.dart';
import 'pick_slot_screen.dart';
import '../widgets/shimmer_widget.dart';

/// "Customize Your Visit" screen: guests, booking type, duration, then Continue.
/// Opened when tapping any card on the amenities list.
class CustomizeVisitScreen extends StatefulWidget {
  const CustomizeVisitScreen({
    super.key,
    this.amenityTitle,
    this.onContinue,
  });

  final String? amenityTitle;
  final VoidCallback? onContinue;

  @override
  State<CustomizeVisitScreen> createState() => _CustomizeVisitScreenState();
}

class _CustomizeVisitScreenState extends State<CustomizeVisitScreen> {
  int _adults = 1;
  static const int _maxGuests = 6;
  bool _isLoading = true;

  /// 0 = Private Session, 1 = Shared Session
  int _bookingTypeIndex = 0;

  /// 0 = 30 Min, 1 = 60 Min, 2 = 90 Min
  int _durationIndex = -1;

  static const List<({String label, String price})> _bookingTypes = [
    (label: 'Private Session', price: 'PKR 3000/hour'),
    (label: 'Shared Session', price: 'PKR 1500/hour'),
  ];

  static const List<String> _durations = ['30 Min', '60 Min', '90 Min'];

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
        backgroundColor: const Color(0xFFF4F5F7),
        appBar: AppBar(
          backgroundColor: AppTheme.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.black, size: 22),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: const Text(
            'Customize Your Visit',
            style: TextStyle(
              color: AppTheme.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
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
                      'Customize Your Visit',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tell us about your preferences',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _buildSectionLabel('Number of Guests'),
                    const SizedBox(height: 12),
                    _buildAdultsRow(),
                    const SizedBox(height: 6),
                    Text(
                      'Maximum capacity: $_maxGuests guests',
                      style: const TextStyle(
                        color: AppTheme.tagRed,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionLabel('Booking Type'),
                    const SizedBox(height: 12),
                    _buildBookingTypeRow(width, horizontalPadding),
                    const SizedBox(height: 24),
                    _buildSectionLabel('Duration'),
                    const SizedBox(height: 12),
                    _buildDurationRow(width, horizontalPadding),
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
        const ShimmerContainer(width: 200, height: 28),
        const SizedBox(height: 6),
        const ShimmerContainer(width: 250, height: 18),
        const SizedBox(height: 28),
        const ShimmerContainer(width: 150, height: 20),
        const SizedBox(height: 12),
        const ShimmerContainer(width: double.infinity, height: 50),
        const SizedBox(height: 24),
        const ShimmerContainer(width: 150, height: 20),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: ShimmerContainer(width: double.infinity, height: 80)),
            const SizedBox(width: 12),
            Expanded(child: ShimmerContainer(width: double.infinity, height: 80)),
          ],
        ),
        const SizedBox(height: 24),
        const ShimmerContainer(width: 100, height: 20),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: ShimmerContainer(width: double.infinity, height: 50)),
            const SizedBox(width: 10),
            Expanded(child: ShimmerContainer(width: double.infinity, height: 50)),
            const SizedBox(width: 10),
            Expanded(child: ShimmerContainer(width: double.infinity, height: 50)),
          ],
        ),
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

  Widget _buildAdultsRow() {
    const fieldBg = Color(0xFFF3F4F6);
    const radius = 12.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: fieldBg,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Row(
        children: [
          const Text(
            'Adults',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CircleButton(
                icon: Icons.remove,
                onPressed: _adults > 1
                    ? () => setState(() => _adults--)
                    : null,
              ),
              const SizedBox(width: 16),
              Text(
                '$_adults',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 16),
              _CircleButton(
                icon: Icons.add,
                onPressed: _adults < _maxGuests
                    ? () => setState(() => _adults++)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingTypeRow(double width, double horizontalPadding) {
    const selectedBg = Color(0xFFE8E8E8);
    const unselectedBg = Color(0xFFFAFAFA);
    const borderColor = Color(0xFFEEEEEE);

    const spacing = 12.0;

    return Row(
      children: List.generate(
        _bookingTypes.length,
        (i) {
          final isSelected = _bookingTypeIndex == i;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i == 0 ? spacing : 0),
              child: GestureDetector(
                onTap: () => setState(() => _bookingTypeIndex = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? selectedBg : unselectedBg,
                    borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryGold : borderColor,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _bookingTypes[i].label,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _bookingTypes[i].price,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDurationRow(double width, double horizontalPadding) {
    const unselectedBg = Color(0xFFF3F4F6);
    const selectedBg = Color(0xFFE8E8E8);

    const spacing = 10.0;

    return Row(
      children: List.generate(
        _durations.length,
        (i) {
          final isSelected = _durationIndex == i;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < _durations.length - 1 ? spacing : 0),
              child: GestureDetector(
                onTap: () => setState(() => _durationIndex = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected ? selectedBg : unselectedBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryGold : const Color(0xFFEEEEEE),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _durations[i],
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
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
          widget.onContinue?.call();
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => PickSlotScreen(amenityTitle: widget.amenityTitle),
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

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: onPressed != null ? const Color(0xFFE8E8E8) : const Color(0xFFE0E0E0),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, size: 20, color: onPressed != null ? AppTheme.textPrimary : AppTheme.textMuted),
        ),
      ),
    );
  }
}
