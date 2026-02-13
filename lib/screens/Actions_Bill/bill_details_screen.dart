import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_theme.dart';
import '../widgets/shimmer_widget.dart';
import 'bills_payment_screen.dart';
import 'bill_model.dart';

/// Bill Details Screen: Shows detailed bill information with payment history and breakdown.
class BillDetailsScreen extends StatefulWidget {
  const BillDetailsScreen({
    super.key,
    required this.bill,
  });

  final BillItem bill;

  @override
  State<BillDetailsScreen> createState() => _BillDetailsScreenState();
}

class _BillDetailsScreenState extends State<BillDetailsScreen> {
  bool _isLoading = true;

  static const List<_PaymentHistoryItem> _paymentHistory = [
    _PaymentHistoryItem(
      method: 'Card*** 7326',
      date: '14 July 2026',
      icon: Icons.credit_card,
    ),
  ];

  static const List<String> _servicesBreakdown = [
    'Cleaning and janitorial services for common areas',
    'Landscaping and groundskeeping',
    'Security services, including personnel and surveillance equipment',
    'Maintenance of communal facilities like gyms, pools, and clubhouses',
    'Utilities for common areas (e.g., lighting in hallways)',
    'Emergency repairs and general upkeep',
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
            'Bills',
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
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          _buildBillCard(),
          const SizedBox(height: 32),
          _buildPaymentHistory(),
          const SizedBox(height: 32),
          _buildServicesBreakdown(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBillCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bill',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.bill.title,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            label: 'Bill date:',
            value: widget.bill.billDate,
            valueStyle: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Pay before ${widget.bill.payBefore}',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            label: 'Amount:',
            value: widget.bill.amount,
            valueStyle: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            label: 'Status:',
            value: widget.bill.status,
            valueWidget: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: widget.bill.status == 'Unpaid'
                    ? const Color(0xFFFEF3C7)
                    : const Color(0xFFD1FAE5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.bill.status,
                style: TextStyle(
                  color: widget.bill.status == 'Unpaid'
                      ? const Color(0xFFB45309)
                      : const Color(0xFF065F46),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (widget.bill.showPayButton) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BillsPaymentScreen(bill: widget.bill),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB99146),
                  foregroundColor: AppTheme.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Pay Now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    String? value,
    Widget? valueWidget,
    TextStyle? valueStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
          ),
        ),
        if (valueWidget != null)
          valueWidget
        else
          Text(
            value ?? '',
            style: valueStyle ??
                TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                ),
          ),
      ],
    );
  }

  Widget _buildPaymentHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment History',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ..._paymentHistory.map((payment) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B6B), Color(0xFFFFA500)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.credit_card,
                      color: AppTheme.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      payment.method,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    payment.date,
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildServicesBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Breakdown of Services',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'This fee includes maintenance services such as:',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        ..._servicesBreakdown.map((service) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6, right: 12),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppTheme.textPrimary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      service,
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildShimmerContent(double horizontalPadding) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          // Bill card shimmer
          ShimmerContainer(
            width: double.infinity,
            height: 250,
            borderRadius: BorderRadius.circular(12),
          ),
          const SizedBox(height: 32),
          // Payment history title shimmer
          ShimmerContainer(
            width: 180,
            height: 24,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 16),
          // Payment history item shimmer
          ShimmerContainer(
            width: double.infinity,
            height: 72,
            borderRadius: BorderRadius.circular(12),
          ),
          const SizedBox(height: 32),
          // Breakdown title shimmer
          ShimmerContainer(
            width: 200,
            height: 24,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 8),
          ShimmerContainer(
            width: double.infinity,
            height: 20,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 16),
          // Service items shimmer
          ...List.generate(6, (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    ShimmerContainer(
                      width: 6,
                      height: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    const SizedBox(width: 12),
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
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _PaymentHistoryItem {
  const _PaymentHistoryItem({
    required this.method,
    required this.date,
    required this.icon,
  });

  final String method;
  final String date;
  final IconData icon;
}
