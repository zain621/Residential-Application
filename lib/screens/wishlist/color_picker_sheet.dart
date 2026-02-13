import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Color picker bottom sheet: hex input, opacity, saved colors grid, + Add.
void showColorPickerSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _ColorPickerSheet(),
  );
}

class _ColorPickerSheet extends StatefulWidget {
  const _ColorPickerSheet();

  @override
  State<_ColorPickerSheet> createState() => _ColorPickerSheetState();
}

class _ColorPickerSheetState extends State<_ColorPickerSheet> {
  final _hexController = TextEditingController(text: '#4F46E5');
  Color _currentColor = const Color(0xFF4F46E5);

  static const List<Color> _savedColors = [
    Color(0xFFEF4444),
    Color(0xFFF97316),
    Color(0xFFEAB308),
    Color(0xFF84CC16),
    Color(0xFF14B8A6),
    Color(0xFF4F46E5),
    Color(0xFFEC4899),
    Color(0xFFDC2626),
    Color(0xFFD946EF),
    Color(0xFF8B5CF6),
    Color(0xFF3B82F6),
    Color(0xFF22C55E),
  ];

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.sizeOf(context).width > 400 ? 20.0 : 16.0;

    return Container(
      padding: EdgeInsets.fromLTRB(padding, 16, padding, MediaQuery.paddingOf(context).bottom + 16),
      decoration: const BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hue-style bar (simplified)
          Container(
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFEF4444),
                  Color(0xFFEAB308),
                  Color(0xFF22C55E),
                  Color(0xFF06B6D4),
                  Color(0xFF4F46E5),
                  Color(0xFFD946EF),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Hex + Alpha row
          Row(
            children: [
              const Text('Hex', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _hexController,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 56,
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  ),
                  controller: TextEditingController(text: '100%'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Saved colors:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.black,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Add current to saved
                },
                child: const Text('+ Add'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ..._savedColors.map((c) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentColor = c;
                        _hexController.text = '#${c.value.toRadixString(16).substring(2).toUpperCase()}';
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: c == _currentColor ? AppTheme.primaryGold : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
