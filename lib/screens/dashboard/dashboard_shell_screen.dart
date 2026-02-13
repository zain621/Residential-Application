import 'package:flutter/material.dart';
import 'package:resedential_app/screens/dashboard/dashboard_screen.dart';
import 'package:resedential_app/screens/Facilities/facilities_screen.dart';
import 'package:resedential_app/screens/chat/chats_screen.dart';
import 'package:resedential_app/screens/profile/profile_screen.dart';
import 'package:resedential_app/screens/widgets/bottom_nav_bar.dart';

/// Host screen with 4 tabs: Home, Chats, Facilities, Profile.
class DashboardShellScreen extends StatefulWidget {
  const DashboardShellScreen({super.key});

  @override
  State<DashboardShellScreen> createState() => _DashboardShellScreenState();
}

class _DashboardShellScreenState extends State<DashboardShellScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const DashboardScreen(),
          ChatsScreen(onBack: () => setState(() => _currentIndex = 0)),
          FacilitiesScreen(
            showBottomNav: false,
            onBack: () => setState(() => _currentIndex = 0),
          ),
          ProfileScreen(onBack: () => setState(() => _currentIndex = 0)),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
