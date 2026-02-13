import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Edit Profile screen: profile picture, name field, Save button.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController(text: 'Zeeshan Ali');

  static const Color _fieldBg = Color(0xFFF5F5F5);
  static const Color _textMuted = Color(0xFF757575);
  static const Color _saveButtonBg = Color(0xFFD9D9D9);

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.sizeOf(context).width > 400 ? 20.0 : 16.0;
    final avatarSize = MediaQuery.sizeOf(context).width * 0.35;
    final avatarSizeClamped = avatarSize.clamp(120.0, 160.0);

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
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: AppTheme.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(padding, 24, padding, 24),
          child: Column(
            children: [
              // Profile picture
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: avatarSizeClamped,
                    height: avatarSizeClamped,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE5E7EB),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      size: avatarSizeClamped * 0.5,
                      color: _textMuted,
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGold,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.white, width: 2),
                    ),
                    child: const Icon(Icons.edit, color: AppTheme.white, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Profile Picture',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.black,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'png, jpg, jpeg up to 2MB',
                style: TextStyle(
                  fontSize: 13,
                  color: _textMuted,
                ),
              ),
              const SizedBox(height: 28),
              // Name field
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _fieldBg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  suffixIcon: const Icon(Icons.edit, color: _textMuted, size: 20),
                ),
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.08),
              // Save
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _saveButtonBg,
                    foregroundColor: _textMuted,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
