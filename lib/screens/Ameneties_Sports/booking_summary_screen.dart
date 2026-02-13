import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_theme.dart';

/// Shows the booking summary as a modal popup (bottom sheet) on the current screen.
/// [onContinueToPayment] is called when "Continue for payment" is tapped (after closing the sheet).
void showBookingSummaryPopup(
  BuildContext context, {
  DateTime? bookingDate,
  String? timeLabel,
  int durationMinutes = 60,
  int guests = 2,
  String sessionType = 'Shared Session',
  String? amenityTitle,
  String imagePath = 'assets/jacuzzi.png',
  VoidCallback? onContinueToPayment,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _BookingSummaryPopup(
      bookingDate: bookingDate,
      timeLabel: timeLabel,
      durationMinutes: durationMinutes,
      guests: guests,
      sessionType: sessionType,
      amenityTitle: amenityTitle,
      imagePath: imagePath,
      onClose: () => Navigator.of(ctx).pop(),
      onContinueToPayment: onContinueToPayment,
    ),
  );
}

/// Booking summary shown after confirming a slot: image, status, details, Continue for payment.
/// Can be used as full screen or inside a popup.
class BookingSummaryScreen extends StatelessWidget {
  const BookingSummaryScreen({
    super.key,
    this.bookingDate,
    this.timeLabel,
    this.durationMinutes = 60,
    this.guests = 2,
    this.sessionType = 'Shared Session',
    this.amenityTitle,
    this.imagePath = 'assets/jacuzzi.png',
  });

  final DateTime? bookingDate;
  final String? timeLabel;
  final int durationMinutes;
  final int guests;
  final String sessionType;
  final String? amenityTitle;
  final String imagePath;

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static const List<String> _weekdays = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(d.year, d.month, d.day);
    if (date == today) {
      return 'Today, ${_months[d.month - 1]} ${d.day}, ${d.year}';
    }
    return '${_weekdays[d.weekday - 1]}, ${_months[d.month - 1]} ${d.day}, ${d.year}';
  }

  String _generateBookingId(DateTime d) {
    final y = d.year;
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '#JZ-$y$m$day-001';
  }

  @override
  Widget build(BuildContext context) {
    final date = bookingDate ?? DateTime.now();
    final timeText = timeLabel ?? '6:00 PM - 7:00 PM';
    final durationText = '$durationMinutes minutes';
    final guestsText = '$guests people';
    final bookingId = _generateBookingId(date);

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
          backgroundColor: const Color(0xFFF4F5F7),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.black, size: 22),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: const Text(
            'Booking Summary',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppTheme.textMuted,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding = constraints.maxWidth > 600 ? 24.0 : AppTheme.horizontalPadding;
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Booking Confirmation',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildBookingCard(
                      context,
                      imagePath: imagePath,
                      dateText: _formatDate(date),
                      timeText: timeText,
                      durationText: durationText,
                      guestsText: guestsText,
                      sessionType: sessionType,
                      bookingId: bookingId,
                    ),
                    const SizedBox(height: 40),
                    _buildContinueButton(context),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard(
    BuildContext context, {
    required String imagePath,
    required String dateText,
    required String timeText,
    required String durationText,
    required String guestsText,
    required String sessionType,
    required String bookingId,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                color: AppTheme.textMuted.withOpacity(0.2),
                child: const Icon(Icons.image_not_supported, size: 48, color: AppTheme.textMuted),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Booking Status',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Confirmed',
                        style: TextStyle(
                          color: Color(0xFF166534),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _detailRow('Date', dateText),
                _detailRow('Time', timeText),
                _detailRow('Duration', durationText),
                _detailRow('Guests', guestsText),
                _detailRow('Type', sessionType),
                _detailRow('Booking ID', bookingId),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
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
          'Continue for payment',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Popup content for modal bottom sheet: same layout as BookingSummaryScreen.
class _BookingSummaryPopup extends StatelessWidget {
  const _BookingSummaryPopup({
    this.bookingDate,
    this.timeLabel,
    this.durationMinutes = 60,
    this.guests = 2,
    this.sessionType = 'Shared Session',
    this.amenityTitle,
    this.imagePath = 'assets/jacuzzi.png',
    required this.onClose,
    this.onContinueToPayment,
  });

  final DateTime? bookingDate;
  final String? timeLabel;
  final int durationMinutes;
  final int guests;
  final String sessionType;
  final String? amenityTitle;
  final String imagePath;
  final VoidCallback onClose;
  final VoidCallback? onContinueToPayment;

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static const List<String> _weekdays = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(d.year, d.month, d.day);
    if (date == today) {
      return 'Today, ${_months[d.month - 1]} ${d.day}, ${d.year}';
    }
    return '${_weekdays[d.weekday - 1]}, ${_months[d.month - 1]} ${d.day}, ${d.year}';
  }

  String _generateBookingId(DateTime d) {
    final y = d.year;
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '#JZ-$y$m$day-001';
  }

  @override
  Widget build(BuildContext context) {
    final date = bookingDate ?? DateTime.now();
    final timeText = timeLabel ?? '6:00 PM - 7:00 PM';
    final durationText = '$durationMinutes minutes';
    final guestsText = '$guests people';
    final bookingId = _generateBookingId(date);
    final horizontalPadding = MediaQuery.of(context).size.width > 600 ? 24.0 : AppTheme.horizontalPadding;

    final maxH = MediaQuery.of(context).size.height * 0.92;

    return Container(
      height: maxH,
      decoration: const BoxDecoration(
        color: Color(0xFFF4F5F7),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.black, size: 22),
                    onPressed: onClose,
                  ),
                  const Expanded(
                    child: Text(
                      'Booking Summary',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Booking Confirmation',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCard(
                      imagePath: imagePath,
                      dateText: _formatDate(date),
                      timeText: timeText,
                      durationText: durationText,
                      guestsText: guestsText,
                      sessionType: sessionType,
                      bookingId: bookingId,
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onContinueToPayment?.call();
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
                          'Continue for payment',
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
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String imagePath,
    required String dateText,
    required String timeText,
    required String durationText,
    required String guestsText,
    required String sessionType,
    required String bookingId,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                color: AppTheme.textMuted.withOpacity(0.2),
                child: const Icon(Icons.image_not_supported, size: 48, color: AppTheme.textMuted),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Booking Status',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Confirmed',
                        style: TextStyle(
                          color: Color(0xFF166534),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _row('Date', dateText),
                _row('Time', timeText),
                _row('Duration', durationText),
                _row('Guests', guestsText),
                _row('Type', sessionType),
                _row('Booking ID', bookingId),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
