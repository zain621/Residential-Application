import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'typography_success_screen.dart';

/// Set Typography screen: Typography card (Roboto, Fonts dropdown, weight, size), progress, Continue.
class SetTypographyScreen extends StatefulWidget {
  const SetTypographyScreen({super.key});

  @override
  State<SetTypographyScreen> createState() => _SetTypographyScreenState();
}

class _SetTypographyScreenState extends State<SetTypographyScreen> {
  String _fontFamily = 'Inter';
  String _fontWeight = 'Semi Bold';
  final _sizeController = TextEditingController(text: '32');

  static const Color _cardBg = Color(0xFFFAFAFA);
  static const Color _textMuted = Color(0xFF6B7280);

  static const List<String> _fonts = [
    'Roboto',
    'Inter',
    'Inter Display',
    'Inter Tight',
    'Inknut Antiqua',
    'Inria Sans',
    'Inria Serif',
  ];

  @override
  void dispose() {
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.sizeOf(context).width > 400 ? 20.0 : 16.0;

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
              'Set Typography',
              style: TextStyle(
                color: AppTheme.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            _buildProgressIndicator(3, 4),
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
                'Select Typography',
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
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Typography',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTypoField(
                      icon: Icons.text_fields,
                      value: 'Roboto',
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Fonts',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTypoField(
                      icon: Icons.search,
                      value: _fontFamily,
                      onTap: () => _showFontPicker(context),
                    ),
                    const SizedBox(height: 12),
                    _buildTypoField(
                      icon: Icons.text_fields,
                      value: _fontWeight,
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _sizeController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppTheme.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppTheme.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.06),
              Center(
                child: Text(
                  'You can always change your image later',
                  style: TextStyle(fontSize: 13, color: _textMuted),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const TypographySuccessScreen(),
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

  Widget _buildTypoField({
    required IconData icon,
    required String value,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppTheme.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: AppTheme.black),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppTheme.black,
                  ),
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: AppTheme.black),
            ],
          ),
        ),
      ),
    );
  }

  void _showFontPicker(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.5;
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Text('All fonts', style: TextStyle(fontWeight: FontWeight.w600)),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView.builder(
                  itemCount: _fonts.length,
                  itemBuilder: (context, i) {
                    final font = _fonts[i];
                    final selected = font == _fontFamily;
                    return ListTile(
                      leading: selected ? const Icon(Icons.check, color: AppTheme.black) : const SizedBox(width: 24),
                      title: Text(
                        font,
                        style: TextStyle(
                          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                          backgroundColor: selected ? const Color(0xFFF3F4F6) : null,
                        ),
                      ),
                      onTap: () {
                        setState(() => _fontFamily = font);
                        Navigator.pop(ctx);
                      },
                    );
                  },
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
