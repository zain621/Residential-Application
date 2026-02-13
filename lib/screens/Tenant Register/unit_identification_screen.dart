import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'personal_details_screen.dart';

class UnitIdentificationScreen extends StatefulWidget {
  const UnitIdentificationScreen({super.key});

  @override
  State<UnitIdentificationScreen> createState() =>
      _UnitIdentificationScreenState();
}

class _UnitIdentificationScreenState extends State<UnitIdentificationScreen> {
  final _unitCodeController = TextEditingController(text: 'Tai-Unite-202');
  final _companyNameController = TextEditingController();
  final _primaryContactController = TextEditingController();

  @override
  void dispose() {
    _unitCodeController.dispose();
    _companyNameController.dispose();
    _primaryContactController.dispose();
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
                _buildProgressIndicator(1, 2),
                SizedBox(height: screenHeight * 0.04),
                // Unit Identification Number Section
                Text(
                  'Unit Identification Number',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppTheme.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                ),
                SizedBox(height: screenHeight * 0.02),
                // Unit/Office Code
                Text(
                  'Unit/Office Code',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.black,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _unitCodeController,
                  decoration: InputDecoration(
                    hintText: 'Tai-Unite-202',
                    prefixIcon: const Icon(Icons.vpn_key, color: Colors.grey),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                // Optional Profile Information
                Text(
                  'Optional Profile Information',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppTheme.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                ),
                SizedBox(height: screenHeight * 0.02),
                // Company Name
                Text(
                  'Company Name',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _companyNameController,
                  decoration: const InputDecoration(
                    hintText: 'Flat 209',
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                // Primary Contact Information
                Text(
                  'Primary Contact Information',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _primaryContactController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: '361556',
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                // Next Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PersonalDetailsScreen(
                            unitCode: _unitCodeController.text,
                            companyName: _companyNameController.text,
                            primaryContact: _primaryContactController.text,
                          ),
                        ),
                      );
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

