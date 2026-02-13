import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_theme.dart';
import 'booking_success_popup.dart';
import 'cod_confirmation_popup.dart';

/// Shows the Banking Details modal popup (payment type + form).
void showBankingDetailsPopup(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => const _BankingDetailsPopup(),
  );
}

class _BankingDetailsPopup extends StatefulWidget {
  const _BankingDetailsPopup();

  @override
  State<_BankingDetailsPopup> createState() => _BankingDetailsPopupState();
}

class _BankingDetailsPopupState extends State<_BankingDetailsPopup> {
  /// 0 = Card, 1 = COD, 2 = RAAST
  int _paymentTypeIndex = 0;

  /// COD (index 1): Recipient + Message
  final _recipientNameController = TextEditingController(text: 'Baqir');
  final _recipientEmailController = TextEditingController(text: 'abc@abc.com');
  final _recipientPhoneController = TextEditingController(text: '16');
  final _messageController = TextEditingController(text: 'Hi There');

  /// Card & RAAST (index 0, 2): Card-style fields
  final _nameController = TextEditingController(text: 'Baqir');
  final _cardNumberController = TextEditingController(text: '8921721182971 21821');
  final _cardHolderController = TextEditingController(text: 'Baqir');
  final _expiryController = TextEditingController(text: '4/2/2026');
  final _cvvController = TextEditingController(text: '322');

  @override
  void dispose() {
    _recipientNameController.dispose();
    _recipientEmailController.dispose();
    _recipientPhoneController.dispose();
    _messageController.dispose();
    _nameController.dispose();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.of(context).size.height * 0.92;
    final horizontalPadding = MediaQuery.of(context).size.width > 600 ? 24.0 : AppTheme.horizontalPadding;

    return Container(
      height: maxH,
      decoration: const BoxDecoration(
        color: Color(0xFFF4F5F7),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.black, size: 22),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Expanded(
                    child: Text(
                      'Banking Details',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGold,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment Type',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildPaymentTypeRow(),
                    const SizedBox(height: 24),
                    _buildFormFields(),
                    const SizedBox(height: 40),
                    _buildConfirmButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Web prepends "assets/" so we must not include it to avoid "assets/assets/...".
  static String get _cardIconPath => kIsWeb ? 'services/card.png' : 'assets/services/card.png';
  static String get _raastIconPath => kIsWeb ? 'services/raast.png' : 'assets/services/raast.png';

  Widget _buildPaymentTypeRow() {
    return Row(
      children: [
        _buildPaymentPill(0, 'Card', _cardIconPath),
        const SizedBox(width: 10),
        _buildPaymentPill(1, 'COD', _cardIconPath),
        const SizedBox(width: 10),
        _buildPaymentPill(2, 'RAAST', _raastIconPath),
      ],
    );
  }

  Widget _buildPaymentPill(int index, String label, String iconPath) {
    final isSelected = _paymentTypeIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _paymentTypeIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryGold : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 20,
                color: isSelected ? AppTheme.white : const Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? AppTheme.white : const Color(0xFF9CA3AF),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              _buildPaymentIcon(iconPath, index, isSelected),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentIcon(String iconPath, int index, bool isSelected) {
    final color = isSelected ? AppTheme.white : const Color(0xFF9CA3AF);
    final fallbackIcon = index == 2 ? Icons.account_balance_wallet : Icons.credit_card;
    return FutureBuilder<String?>(
      future: rootBundle.load(iconPath).then<String?>((_) => iconPath, onError: (_, __) => null),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Image.asset(
            snapshot.data!,
            width: 22,
            height: 22,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Icon(fallbackIcon, size: 22, color: color),
          );
        }
        return Icon(fallbackIcon, size: 22, color: color);
      },
    );
  }

  Widget _buildFormFields() {
    if (_paymentTypeIndex == 1) {
      return _buildCodFields();
    }
    return _buildCardRaastFields();
  }

  Widget _buildCodFields() {
    const fieldBg = Color(0xFFF3F4F6);
    const borderRadius = 12.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Recipient's Full Name"),
        const SizedBox(height: 6),
        TextField(
          controller: _recipientNameController,
          decoration: InputDecoration(
            filled: true,
            fillColor: fieldBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
        const SizedBox(height: 16),
        _buildLabel("Recipient's Email"),
        const SizedBox(height: 6),
        TextField(
          controller: _recipientEmailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            filled: true,
            fillColor: fieldBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            suffixIcon: const Icon(Icons.arrow_drop_down, color: AppTheme.textSecondary, size: 24),
          ),
        ),
        const SizedBox(height: 16),
        _buildLabel("Recipient's Phone"),
        const SizedBox(height: 6),
        TextField(
          controller: _recipientPhoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            filled: true,
            fillColor: fieldBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
        const SizedBox(height: 16),
        _buildLabel('Message (Optional)'),
        const SizedBox(height: 6),
        TextField(
          controller: _messageController,
          maxLines: 2,
          decoration: InputDecoration(
            filled: true,
            fillColor: fieldBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildCardRaastFields() {
    const fieldBg = Color(0xFFF3F4F6);
    const borderRadius = 12.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Name'),
        const SizedBox(height: 6),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            filled: true,
            fillColor: fieldBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
        const SizedBox(height: 16),
        _buildLabel('Card Number'),
        const SizedBox(height: 6),
        TextField(
          controller: _cardNumberController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d\s]'))],
          decoration: InputDecoration(
            filled: true,
            fillColor: fieldBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
        const SizedBox(height: 16),
        _buildLabel('Card Holder Name'),
        const SizedBox(height: 6),
        TextField(
          controller: _cardHolderController,
          decoration: InputDecoration(
            filled: true,
            fillColor: fieldBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Expiry Date'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _expiryController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: fieldBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Cvv'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _cvvController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(4),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: fieldBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppTheme.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
          if (_paymentTypeIndex == 1) {
            showCodConfirmationPopup(context);
          } else {
            showBookingSuccessPopup(context);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryGold,
          foregroundColor: AppTheme.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Confirm',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
