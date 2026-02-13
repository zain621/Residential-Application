import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// App Language bottom sheet: list of languages (English, Uzbek, Russian).
/// Shown when user taps "App language" on Profile screen.
void showAppLanguageSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _AppLanguageSheet(),
  );
}

class _AppLanguageSheet extends StatelessWidget {
  const _AppLanguageSheet();

  static const List<String> _languages = [
    'English',
    'Urdu',
    'Arabic',
  ];

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.sizeOf(context).width > 400 ? 20.0 : 16.0;

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header: title + close
            Padding(
              padding: EdgeInsets.fromLTRB(padding, 8, padding, 16),
              child: Row(
                children: [
                  const Text(
                    'App Language',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.black,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppTheme.black, size: 24),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Language list
            ..._languages.map((lang) => ListTile(
                  title: Text(
                    lang,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.black,
                    ),
                  ),
                  onTap: () {
                    // TODO: Apply language
                    Navigator.of(context).pop();
                  },
                )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
