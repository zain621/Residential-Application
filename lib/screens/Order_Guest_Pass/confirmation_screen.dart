import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_theme.dart';
import '../widgets/shimmer_widget.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({
    super.key,
    required this.passType,
    required this.visitorName,
    required this.email,
    required this.phone,
    required this.company,
    required this.selectedDate,
    required this.startTime,
    required this.endTime,
  });

  final String passType;
  final String visitorName;
  final String email;
  final String phone;
  final String company;
  final DateTime? selectedDate;
  final String startTime;
  final String endTime;

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  bool _isLoading = true;
  final String _confirmationCode = 'TRN-B3M5P8';

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
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      _buildQrCode(),
                      const SizedBox(height: 24),
                      _buildScanToCheckInText(),
                      const SizedBox(height: 8),
                      _buildInstructionText(),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                      _buildConfirmationCode(),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                      _buildDownloadButton(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildQrCode() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.textMuted.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Center(
        child: Image.asset(
          kIsWeb ? 'services/qr-code.png' : 'assets/services/qr-code.png',
          width: 180,
          height: 180,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.qr_code,
              size: 150,
              color: AppTheme.textSecondary,
            );
          },
        ),
      ),
    );
  }

  Widget _buildScanToCheckInText() {
    return const Text(
      'Scan to Check-In',
      style: TextStyle(
        color: AppTheme.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInstructionText() {
    return Text(
      'Show this code at the venue',
      style: TextStyle(
        color: AppTheme.textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildConfirmationCode() {
    return Column(
      children: [
        const Text(
          'Confirmation Code',
          style: TextStyle(
            color: AppTheme.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _confirmationCode,
          style: const TextStyle(
            color: AppTheme.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // TODO: Implement QR code download functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('QR code download functionality will be implemented'),
              duration: Duration(seconds: 2),
            ),
          );
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
          'Download QR Code',
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
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          ShimmerContainer(
            width: 200,
            height: 200,
            borderRadius: BorderRadius.circular(12),
          ),
          const SizedBox(height: 24),
          ShimmerContainer(
            width: 150,
            height: 24,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 8),
          ShimmerContainer(
            width: 200,
            height: 18,
            borderRadius: BorderRadius.circular(8),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          ShimmerContainer(
            width: 150,
            height: 20,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 8),
          ShimmerContainer(
            width: 120,
            height: 28,
            borderRadius: BorderRadius.circular(8),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          ShimmerContainer(
            width: double.infinity,
            height: 50,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }
}
