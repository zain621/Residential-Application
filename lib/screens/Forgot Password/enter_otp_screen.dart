import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

class EnterOtpScreen extends StatefulWidget {
  final String email;

  const EnterOtpScreen({super.key, required this.email});

  @override
  State<EnterOtpScreen> createState() => _EnterOtpScreenState();
}

class _EnterOtpScreenState extends State<EnterOtpScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isOtpComplete = false;

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _checkOtpComplete() {
    bool isComplete = _otpControllers.every(
      (controller) => controller.text.isNotEmpty,
    );
    setState(() {
      _isOtpComplete = isComplete;
    });
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    _checkOtpComplete();
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
          'Enter OTP',
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
                SizedBox(height: screenHeight * 0.02),
                // Title
                Text(
                  'Enter OTP',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppTheme.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: screenHeight * 0.01),
                // Instruction
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                    children: [
                      const TextSpan(text: 'Send OTP on '),
                      TextSpan(
                        text: widget.email,
                        style: const TextStyle(
                          color: AppTheme.primaryGold,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                // OTP Input Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: screenWidth * 0.12,
                      child: TextField(
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: _focusNodes[index].hasFocus
                                  ? AppTheme.primaryGold
                                  : Colors.grey[300]!,
                              width: _focusNodes[index].hasFocus ? 2 : 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppTheme.primaryGold,
                              width: 2,
                            ),
                          ),
                          hintText: '-',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 24,
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) => _onOtpChanged(index, value),
                      ),
                    );
                  }),
                ),
                SizedBox(height: screenHeight * 0.02),
                // Resend OTP
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Handle resend OTP
                    },
                    child: Text(
                      'Resend OTP',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.primaryGold,
                          ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                // Sign Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isOtpComplete
                        ? () {
                            // Handle OTP verification
                            Navigator.pop(context);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isOtpComplete
                          ? AppTheme.primaryGold
                          : Colors.grey[300],
                      foregroundColor: _isOtpComplete
                          ? AppTheme.white
                          : Colors.grey[600],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Sign'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

