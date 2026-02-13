import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'actual_news_section.dart';
import 'bills_payments_section.dart';
import 'package:resedential_app/theme/app_theme.dart';
import 'header_quick_options_section.dart';
import 'special_offers_section.dart';
import 'survey_section.dart';
import 'upcoming_booking_section.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.pageBackground,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.pageBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                HeaderQuickOptionsSection(),
                SizedBox(height: AppTheme.sectionSpacing),
                UpcomingBookingSection(),
                SizedBox(height: AppTheme.sectionSpacing),
                BillsPaymentsSection(),
                SizedBox(height: AppTheme.sectionSpacing),
                ActualNewsSection(),
                SizedBox(height: AppTheme.sectionSpacing),
                SpecialOffersSection(),
                SizedBox(height: AppTheme.sectionSpacing),
                SurveySection(),
                SizedBox(height: AppTheme.sectionSpacing),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

