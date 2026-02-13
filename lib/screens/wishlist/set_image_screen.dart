import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'change_color_screen.dart';

/// Set image screen: display image upload, progress (step 1/5), Continue.
/// First step of the wishlist customization flow.
class SetImageScreen extends StatelessWidget {
  const SetImageScreen({super.key});

  static const Color _textMuted = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.sizeOf(context).width > 400 ? 20.0 : 16.0;
    final circleSize = (MediaQuery.sizeOf(context).width - padding * 2) * 0.7;
    final sizeClamped = circleSize.clamp(200.0, 280.0);

    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.black, size: 22),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Set image',
              style: TextStyle(
                color: AppTheme.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            _buildProgressIndicator(1, 5),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(padding, 24, padding, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Set a Display Image',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Let's change a logo for your app. This is only visible to you.",
                style: TextStyle(
                  fontSize: 15,
                  color: AppTheme.black,
                  height: 1.4,
                ),
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.06),
              Center(
                child: GestureDetector(
                  onTap: () {
                    // TODO: Pick image
                  },
                  child: Container(
                    width: sizeClamped,
                    height: sizeClamped,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD1D5DB),
                        width: 2,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 64,
                      color: Color(0xFFD1D5DB),
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.08),
              Center(
                child: Text(
                  'You can always change your image later',
                  style: TextStyle(
                    fontSize: 13,
                    color: _textMuted,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const ChangeColorScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGold,
                    foregroundColor: AppTheme.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(int current, int total) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        final filled = i < current;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 24,
          height: 4,
          decoration: BoxDecoration(
            color: filled ? AppTheme.black : const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}
