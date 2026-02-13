import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../widgets/welcome_modal.dart';
import '../Tenant Login/login_screen.dart';

class PersonalDetailsScreen extends StatefulWidget {
  final String unitCode;
  final String companyName;
  final String primaryContact;

  const PersonalDetailsScreen({
    super.key,
    required this.unitCode,
    required this.companyName,
    required this.primaryContact,
  });

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final _fullNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create new account',
          style: TextStyle(
            color: AppTheme.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.01),
                // Progress Indicator
                _buildProgressIndicator(2, 2),
                SizedBox(height: screenHeight * 0.04),
                // Personal Details Heading
                Text(
                  'Personal Details',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppTheme.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                ),
                SizedBox(height: screenHeight * 0.03),
                // Full Name Field
                Text(
                  'Full Name',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.black,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    hintText: 'Tai roshan trade',
                    suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                // Phone Number Field
                Text(
                  'Phone Number',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.black,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: 'Flat 209',
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                // Create Password Field
                Text(
                  'Create Password',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.black,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: '361556',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppTheme.primaryGold,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                // Next Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showWelcomeDialog();
                    },
                    child: const Text('Next'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showWelcomeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) => Stack(
        children: [
          // Blur background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          // Modal
          WelcomeModal(
            onGoToDashboard: () {
              Navigator.of(context).pop(); // Close modal
              // Navigate to login screen
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false, // Remove all previous routes
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(int currentStep, int totalSteps) {
    return Row(
      children: List.generate(totalSteps, (index) {
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(
              right: index < totalSteps - 1 ? 4 : 0,
            ),
            decoration: BoxDecoration(
              color: index < currentStep
                  ? AppTheme.primaryGold
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}

