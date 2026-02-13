import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/app_theme.dart';
import '../widgets/shimmer_widget.dart';

/// Ambulance popup: shows ambulance service providers list.
/// Opens when clicking the Ambulance card.
class AmbulancePopup extends StatefulWidget {
  const AmbulancePopup({super.key});

  @override
  State<AmbulancePopup> createState() => _AmbulancePopupState();
}

class _AmbulancePopupState extends State<AmbulancePopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isLoading = true;

  static const List<(String name, String phone)> _ambulanceServices = [
    ('CHIPPA', '1020'),
    ('EDHI', '115'),
    ('Amaan Ambulance', '1021'),
    ('AL KHIDMAT', '1022'),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    try {
      // Clean phone number - remove spaces, dashes, and other non-digit characters except +
      final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
      
      if (cleanedNumber.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid phone number'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        return;
      }
      
      // Use tel: scheme with the cleaned number - parse as URI
      final phoneUri = Uri.parse('tel:$cleanedNumber');
      
      // Try launching with externalApplication mode first (more reliable for tel:)
      try {
        final launched = await launchUrl(
          phoneUri,
          mode: LaunchMode.externalApplication,
        );
        
        if (!launched && mounted) {
          // Fallback to platformDefault if externalApplication fails
          final launched2 = await launchUrl(
            phoneUri,
            mode: LaunchMode.platformDefault,
          );
          
          if (!launched2 && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Unable to make call. Please dial $cleanedNumber manually'),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      } catch (e) {
        // If externalApplication fails, try platformDefault
        try {
          await launchUrl(
            phoneUri,
            mode: LaunchMode.platformDefault,
          );
        } catch (e2) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Unable to make call. Please dial $cleanedNumber manually'),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to make call. Please dial $phoneNumber manually'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.of(context).size.height * 0.7;
    final horizontalPadding = MediaQuery.of(context).size.width > 600 ? 24.0 : AppTheme.horizontalPadding;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
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
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.black, size: 22),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Expanded(
                        child: Text(
                          'Phone Number',
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
                  child: _isLoading ? _buildShimmerList() : _buildContactList(horizontalPadding),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _ambulanceServices.length,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            ShimmerContainer(width: 50, height: 50, borderRadius: BorderRadius.circular(25)),
            const SizedBox(width: 12),
            Expanded(
              child: ShimmerContainer(width: 120, height: 16),
            ),
            ShimmerContainer(width: 40, height: 40, borderRadius: BorderRadius.circular(20)),
          ],
        ),
      ),
    );
  }

  Widget _buildContactList(double horizontalPadding) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 16),
      itemCount: _ambulanceServices.length,
      itemBuilder: (context, index) {
        final contact = _ambulanceServices[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.textMuted.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.local_hospital, color: AppTheme.textSecondary, size: 28),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  contact.$1,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.phone,
                    color: AppTheme.primaryGold,
                    size: 20,
                  ),
                ),
                onPressed: () => _makePhoneCall(contact.$2),
              ),
            ],
          ),
        );
      },
    );
  }
}
