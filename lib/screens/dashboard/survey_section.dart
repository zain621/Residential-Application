import 'package:flutter/material.dart';

import 'package:resedential_app/theme/app_theme.dart';

/// "Survey" section with horizontal scroll of survey cards.
class SurveySection extends StatelessWidget {
  const SurveySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.horizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Survey',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'View',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            // Extra height so all options + Vote button fit without overflow.
            height: 300,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                return const _SurveyCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum _SurveyOption {
  verySatisfied,
  satisfied,
  neutral,
  dissatisfied,
  veryDissatisfied,
}

class _SurveyCard extends StatefulWidget {
  const _SurveyCard();

  @override
  State<_SurveyCard> createState() => _SurveyCardState();
}

class _SurveyCardState extends State<_SurveyCard> {
  _SurveyOption? _selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Parking Facility Satisfaction',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'How satisfied are you wit the parking facilities at Belgrade Waterfront?',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          _buildOption(
            context,
            option: _SurveyOption.verySatisfied,
            label: 'Very Satisfied',
          ),
          _buildOption(
            context,
            option: _SurveyOption.satisfied,
            label: 'Satisfied',
          ),
          _buildOption(
            context,
            option: _SurveyOption.neutral,
            label: 'Satisfied',
          ),
          _buildOption(
            context,
            option: _SurveyOption.dissatisfied,
            label: 'Dissatisfied',
          ),
          _buildOption(
            context,
            option: _SurveyOption.veryDissatisfied,
            label: 'Ver Dissatisfied',
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
                padding: const EdgeInsets.symmetric(vertical: 10),
                side: const BorderSide(
                  color: AppTheme.textSecondary,
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                foregroundColor: AppTheme.textSecondary,
              ),
              onPressed: () {},
              child: const Text(
                'Vote',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required _SurveyOption option,
    required String label,
  }) {
    final selected = _selected == option;

    return InkWell(
      onTap: () {
        setState(() => _selected = option);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? Theme.of(context).colorScheme.primary
                      : AppTheme.textSecondary,
                  width: 1.4,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

