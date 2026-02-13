import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'facility_members_sheet.dart';

/// Chats screen: "Add Facility Member" header with + button, empty state "Your chat looks empty".
/// Used as the Chats tab content in the dashboard shell.
class ChatsScreen extends StatelessWidget {
  const ChatsScreen({
    super.key,
    this.onBack,
  });

  /// When set (e.g. when used as a tab), back button calls this instead of Navigator.pop.
  final VoidCallback? onBack;

  static const Color _textMuted = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.sizeOf(context).width > 400 ? 20.0 : 16.0;

    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppTheme.black,
            size: 22,
          ),
          onPressed: () {
            if (onBack != null) {
              onBack!();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        centerTitle: true,
        title: const Text(
          'Chats',
          style: TextStyle(
            color: AppTheme.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add Facility Member row
            Padding(
              padding: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 0),
              child: Row(
                children: [
                  const Text(
                    'Add Facility Member',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.black,
                    ),
                  ),
                  const Spacer(),
                  Material(
                    color: AppTheme.primaryGold,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () => showFacilityMembersSheet(context),
                      customBorder: const CircleBorder(),
                      child: const SizedBox(
                        width: 44,
                        height: 44,
                        child: Icon(
                          Icons.add,
                          color: AppTheme.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Empty state
            Expanded(
              child: Center(
                child: Text(
                  'Your chat looks empty',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _textMuted,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
