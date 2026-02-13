import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../Forgot Password/forgot_password_screen.dart';
import '../Tenant Register/unit_identification_screen.dart';
import '../dashboard/dashboard_shell_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _customerIdController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _customerIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppTheme.white, // White background
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo Section - Increased size
              Center(
                child: Image.asset(
                  'lib/assets/splash-logo.png',
                  height: screenHeight * 0.13, // Increased logo size
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.image_not_supported,
                      color: AppTheme.textSecondary,
                      size: 80,
                    );
                  },
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              // Login Heading
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Login to your account',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppTheme.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                ),
              ),
              SizedBox(height: screenHeight * 0.012),
              // Customer ID Field
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Customer ID',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _customerIdController,
                decoration: InputDecoration(
                  hintText: 'Customer ID',
                  hintStyle: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 14,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppTheme.textMuted.withOpacity(0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppTheme.textMuted.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppTheme.primaryGold,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: AppTheme.white,
                ),
              ),
              SizedBox(height: screenHeight * 0.008),
              // Password Field
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Enter Password',
                  hintStyle: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 14,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppTheme.textMuted.withOpacity(0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppTheme.textMuted.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppTheme.primaryGold,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: AppTheme.white,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppTheme.textMuted,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              // Remember Me and Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                        activeColor: AppTheme.primaryGold,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                      Text(
                        'Remember me',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.black,
                              fontSize: 13,
                            ),
                      ),
                    ],
                  ),
                  Flexible(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Forgot password?',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.primaryGold,
                              fontSize: 13,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const DashboardShellScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGold,
                    foregroundColor: AppTheme.white,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              // Or Divider
              Center(
                child: Text(
                  'or',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.black,
                        fontSize: 13,
                      ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              // Create New Account Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const UnitIdentificationScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    side: BorderSide(
                      color: AppTheme.textMuted.withOpacity(0.3),
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Create New Account',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              // Biometric Authentication Icons at bottom
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Fingerprint Icon
                  GestureDetector(
                    onTap: () {
                      // Handle fingerprint authentication
                    },
                    child: Image.asset(
                      'assets/services/fingerprint.png',
                      height: 38,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.fingerprint,
                          size: 38,
                          color: AppTheme.textSecondary,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.06),
                  // Facial Icon
                  GestureDetector(
                    onTap: () {
                      // Handle facial authentication
                    },
                    child: Image.asset(
                      'assets/services/facial-icon.png',
                      height: 38,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.face,
                          size: 38,
                          color: AppTheme.textSecondary,
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.003),
            ],
          ),
        ),
      ),
    );
  }
}
