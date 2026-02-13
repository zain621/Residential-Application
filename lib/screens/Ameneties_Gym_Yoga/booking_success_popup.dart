import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// Shows the "You're All Set!" confirmation as a modal popup after payment/booking.
void showBookingSuccessPopup(
  BuildContext context, {
  String? confirmationCode,
  String? totalAmount,
  String? date,
  String? venue,
  String? email,
  String? serviceName,
  String? venueName,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _BookingSuccessPopup(
      confirmationCode: confirmationCode ?? 'TRN-077BSE',
      totalAmount: totalAmount ?? 'PKR: 3000',
      date: date ?? '1/24/2026',
      venue: venue ?? 'Top Garden',
      email: email ?? 'abc@ab.com',
      serviceName: serviceName ?? 'Jacuzzi',
      venueName: venueName ?? 'roshan trade center',
      onDone: () => Navigator.of(ctx).pop(),
    ),
  );
}

class _BookingSuccessPopup extends StatelessWidget {
  const _BookingSuccessPopup({
    required this.confirmationCode,
    required this.totalAmount,
    required this.date,
    required this.venue,
    required this.email,
    required this.serviceName,
    required this.venueName,
    required this.onDone,
  });

  final String confirmationCode;
  final String totalAmount;
  final String date;
  final String venue;
  final String email;
  final String serviceName;
  final String venueName;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.of(context).size.height * 0.92;
    final horizontalPadding = MediaQuery.of(context).size.width > 600 ? 24.0 : AppTheme.horizontalPadding;

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
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 24),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryGold,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, color: AppTheme.white, size: 40),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "You're All Set!",
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "You've successfully registered for $serviceName at $venueName",
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      _detailRow('Confirmation Code', confirmationCode),
                      _detailRow('Total Amount', totalAmount),
                      _detailRow('Date', date),
                      _detailRow('Venue', venue),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.email_outlined, size: 20, color: Colors.blue.shade300),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'A confirmation email has been sent to $email',
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onDone,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryGold,
                                foregroundColor: AppTheme.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: const Text('Done', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                onDone();
                                // TODO: share action
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryGold,
                                foregroundColor: AppTheme.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: const Text('Share', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.textPrimary,
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
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
