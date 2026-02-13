import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'color_picker_sheet.dart';
import 'set_typography_screen.dart';

/// Change Color screen: color scheme grid, progress (step 2/5), Continue.
class ChangeColorScreen extends StatefulWidget {
  const ChangeColorScreen({super.key});

  @override
  State<ChangeColorScreen> createState() => _ChangeColorScreenState();
}

class _ChangeColorScreenState extends State<ChangeColorScreen> {
  int? _selectedIndex;

  static const Color _textMuted = Color(0xFF6B7280);

  static const List<Color> _swatches = [
    Color(0xFFEF4444),
    Color(0xFFEC4899),
    Color(0xFFD946EF),
    Color(0xFF8B5CF6),
    Color(0xFF4F46E5),
    Color(0xFF3B82F6),
    Color(0xFF06B6D4),
    Color(0xFF14B8A6),
    Color(0xFF22C55E),
    Color(0xFF84CC16),
    Color(0xFFCA8A04),
    Color(0xFFF97316),
    Color(0xFFEA580C),
    Color(0xFFDC2626),
    Color(0xFFE3D3B5),
    Color(0xFFB99146),
    Color(0xFF1E3A5F),
  ];

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.sizeOf(context).width > 400 ? 20.0 : 16.0;
    final width = MediaQuery.sizeOf(context).width - padding * 2;
    const crossCount = 5;
    const spacing = 12.0;
    final itemSize = (width - (crossCount - 1) * spacing) / crossCount;

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
              'Change Color',
              style: TextStyle(
                color: AppTheme.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            _buildProgressIndicator(2, 5),
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
                'Color scheme',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose the color for your app now you can always edit this later.',
                style: TextStyle(
                  fontSize: 15,
                  color: AppTheme.black,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  ...List.generate(_swatches.length, (i) {
                    final selected = _selectedIndex == i;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedIndex = i),
                      child: Container(
                        width: itemSize,
                        height: itemSize,
                        decoration: BoxDecoration(
                          color: _swatches[i],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected ? AppTheme.black : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  // Add color
                  GestureDetector(
                    onTap: () => showColorPickerSheet(context),
                    child: Container(
                      width: itemSize,
                      height: itemSize,
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFD1D5DB)),
                      ),
                      child: const Icon(Icons.add, color: AppTheme.black, size: 28),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Only you will see your wallet color.',
                  style: TextStyle(fontSize: 13, color: _textMuted),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const SetTypographyScreen(),
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
