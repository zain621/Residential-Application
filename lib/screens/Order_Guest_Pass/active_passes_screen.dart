import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_theme.dart';
import '../widgets/shimmer_widget.dart';

class ActivePassesScreen extends StatefulWidget {
  const ActivePassesScreen({super.key});

  @override
  State<ActivePassesScreen> createState() => _ActivePassesScreenState();
}

class _ActivePassesScreenState extends State<ActivePassesScreen> {
  bool _isLoading = true;

  final List<_GuestPass> _passes = [
    _GuestPass(
      visitorName: 'Baqir',
      passType: 'Multi-Use Pass, Limited',
      startDate: DateTime(2024, 8, 19),
      endDate: DateTime(2024, 9, 3),
      numberOfVisits: 4,
      visitsLeft: 2,
      contactNumber: '+92-300389',
      daysRemaining: 3,
    ),
    _GuestPass(
      visitorName: 'Baqir',
      passType: 'Multi-Use Pass, Limited',
      startDate: DateTime(2024, 8, 19),
      endDate: DateTime(2024, 9, 3),
      numberOfVisits: 4,
      visitsLeft: 2,
      contactNumber: '+92-300389',
      daysRemaining: null,
    ),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width > 600 ? 24.0 : (width > 400 ? 20.0 : AppTheme.horizontalPadding);

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
            'Order new pass',
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
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 24),
                        itemCount: _passes.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final pass = _passes[index];
                          return _GuestPassCard(pass: pass);
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: SizedBox(
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
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Order new pass',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildShimmerContent(double horizontalPadding) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 24),
      itemCount: 2,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => ShimmerContainer(
        width: double.infinity,
        height: 180,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class _GuestPass {
  const _GuestPass({
    required this.visitorName,
    required this.passType,
    required this.startDate,
    required this.endDate,
    required this.numberOfVisits,
    required this.visitsLeft,
    required this.contactNumber,
    this.daysRemaining,
  });

  final String visitorName;
  final String passType;
  final DateTime startDate;
  final DateTime endDate;
  final int numberOfVisits;
  final int visitsLeft;
  final String contactNumber;
  final int? daysRemaining;
}

class _GuestPassCard extends StatelessWidget {
  const _GuestPassCard({required this.pass});

  final _GuestPass pass;

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.textMuted.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (pass.daysRemaining != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9C4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'End in ${pass.daysRemaining} days',
                    style: const TextStyle(
                      color: AppTheme.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          _buildInfoRow('Visitor', pass.visitorName, isBold: true),
          const SizedBox(height: 12),
          _buildInfoRow('Type', pass.passType),
          const SizedBox(height: 12),
          _buildInfoRow('Period', '${_formatDate(pass.startDate)} ${_formatDate(pass.endDate)}'),
          const SizedBox(height: 12),
          _buildInfoRow('Number of visits', '${pass.numberOfVisits} visits ${pass.visitsLeft} left'),
          const SizedBox(height: 12),
          _buildInfoRow('Contact Number', pass.contactNumber),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: AppTheme.black,
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
