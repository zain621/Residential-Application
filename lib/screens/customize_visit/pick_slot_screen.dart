import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_theme.dart';
import 'banking_details_popup.dart';
import 'booking_summary_screen.dart';

/// "Pick Your Slot" screen: date picker, time slots grid, rules, checkbox, Confirm Booking.
/// Opened when tapping Continue on the customize visit screen.
class PickSlotScreen extends StatefulWidget {
  const PickSlotScreen({
    super.key,
    this.amenityTitle,
  });

  final String? amenityTitle;

  @override
  State<PickSlotScreen> createState() => _PickSlotScreenState();
}

class _PickSlotScreenState extends State<PickSlotScreen> {
  /// 0 = Daily, 1 = Weekly, 2 = Monthly
  int _viewIndex = 0;

  /// For Daily: single selected date (month from _displayMonth).
  DateTime? _selectedDateDaily;
  /// For Weekly/Monthly: multiple dates selected.
  final Set<DateTime> _selectedDatesWeekly = {};
  /// Month shown in Daily/Weekly/Monthly (first day of month).
  DateTime _displayMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  /// "Select for whole week" (Weekly tab).
  bool _selectWholeWeek = false;
  /// "Select for whole month" (Monthly tab).
  bool _selectWholeMonth = false;

  int? _selectedTimeSlotIndex;
  bool _agreedToRules = false;

  static const List<String> _viewLabels = ['Daily', 'Weekly', 'Monthly'];

  static const List<String> _rules = [
    'Shower before entering the jacuzzi',
    'No glass containers allowed',
    'Maximum session duration: 90 minutes',
    'Children under 12 must be supervised',
    'Please clean up after your session',
    'Respectful behavior towards other guests',
  ];

  /// Predefined time slots: (time, duration, isAvailable)
  static const List<({String time, String duration, bool available})> _timeSlots = [
    (time: '10 AM', duration: '60 min', available: false),
    (time: '12 AM', duration: '30 min', available: true),
    (time: '3 PM', duration: '60 min', available: false),
    (time: '5 PM', duration: '60 min', available: false),
    (time: '10 AM', duration: '30 min', available: false),
    (time: '12 PM', duration: '60 min', available: true),
  ];


  static const List<String> _weekdays = ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'];
  static const List<String> _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  static const Color _dateCardCream = Color(0xFFFAF5ED);
  static const Color _dateCardBorder = Color(0xFFE3D3B5);

  @override
  void initState() {
    super.initState();
    _selectedDateDaily ??= DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFF7F7F7),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
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
            'Pick Your Slot',
            style: TextStyle(
              color: AppTheme.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final horizontalPadding = width > 600 ? 24.0 : AppTheme.horizontalPadding;
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  16,
                  horizontalPadding,
                  32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pick Your Slot',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Choose the date and time that works best for you',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionLabel('Select Date'),
                    const SizedBox(height: 12),
                    _buildViewToggle(),
                    const SizedBox(height: 14),
                    _buildDateSection(),
                    const SizedBox(height: 24),
                    _buildSectionLabel('Available Time Slots'),
                    const SizedBox(height: 12),
                    _buildTimeSlotsGrid(width, horizontalPadding),
                    const SizedBox(height: 24),
                    _buildSectionLabel('Pick Your Slot'),
                    const SizedBox(height: 10),
                    _buildRulesList(),
                    const SizedBox(height: 20),
                    _buildAgreementCheckbox(),
                    const SizedBox(height: 28),
                    _buildConfirmButton(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppTheme.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildViewToggle() {
    const inactiveBg = Color(0xFFF3F4F6);
    const selectedBg = Color(0xFFE8E8E8);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: inactiveBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(
          _viewLabels.length,
          (i) => Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _viewIndex = i),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _viewIndex == i ? selectedBg : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _viewLabels[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _viewIndex == i ? AppTheme.textPrimary : AppTheme.textMuted,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateSection() {
    if (_viewIndex == 0) return _buildDailyDates();
    if (_viewIndex == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildWholeWeekCheckbox(),
          const SizedBox(height: 14),
          _buildWeeklyDates(),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildWholeMonthCheckbox(),
        const SizedBox(height: 14),
        _buildMonthlyDates(),
      ],
    );
  }

  Widget _buildWholeWeekCheckbox() {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _selectWholeWeek == true,
            tristate: false,
            onChanged: (v) {
              setState(() {
                _selectWholeWeek = v ?? false;
                if (_selectWholeWeek) {
                  final now = DateTime.now();
                  final weekday = now.weekday;
                  final start = now.subtract(Duration(days: weekday - 1));
                  _selectedDatesWeekly.clear();
                  for (int i = 0; i < 7; i++) {
                    _selectedDatesWeekly.add(start.add(Duration(days: i)));
                  }
                  _displayMonth = DateTime(start.year, start.month, 1);
                } else {
                  _selectedDatesWeekly.clear();
                }
              });
            },
            activeColor: AppTheme.primaryGold,
            fillColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) return AppTheme.primaryGold;
              return Colors.transparent;
            }),
            side: const BorderSide(color: AppTheme.primaryGold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            setState(() {
              _selectWholeWeek = !_selectWholeWeek;
              if (_selectWholeWeek) {
                final now = DateTime.now();
                final start = now.subtract(Duration(days: now.weekday - 1));
                _selectedDatesWeekly.clear();
                for (int i = 0; i < 7; i++) {
                  _selectedDatesWeekly.add(start.add(Duration(days: i)));
                }
                _displayMonth = DateTime(start.year, start.month, 1);
              } else {
                _selectedDatesWeekly.clear();
              }
            });
          },
          child: const Text(
            'Select for whole week',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWholeMonthCheckbox() {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _selectWholeMonth == true,
            tristate: false,
            onChanged: (v) {
              setState(() {
                _selectWholeMonth = v ?? false;
                if (_selectWholeMonth) {
                  final year = _displayMonth.year;
                  final month = _displayMonth.month;
                  final lastDay = DateTime(year, month + 1, 0).day;
                  _selectedDatesWeekly.clear();
                  for (int d = 1; d <= lastDay; d++) {
                    _selectedDatesWeekly.add(DateTime(year, month, d));
                  }
                } else {
                  _selectedDatesWeekly.clear();
                }
              });
            },
            activeColor: AppTheme.primaryGold,
            fillColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) return AppTheme.primaryGold;
              return Colors.transparent;
            }),
            side: const BorderSide(color: AppTheme.primaryGold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            setState(() {
              _selectWholeMonth = !_selectWholeMonth;
              if (_selectWholeMonth) {
                final year = _displayMonth.year;
                final month = _displayMonth.month;
                final lastDay = DateTime(year, month + 1, 0).day;
                _selectedDatesWeekly.clear();
                for (int d = 1; d <= lastDay; d++) {
                  _selectedDatesWeekly.add(DateTime(year, month, d));
                }
              } else {
                _selectedDatesWeekly.clear();
              }
            });
          },
          child: const Text(
            'Select for whole month',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  /// One date card: cream bg; selected = black border (active), unselected = gold border.
  Widget _buildDateCard(DateTime d, bool isSelected, VoidCallback onTap) {
    final weekday = _weekdays[d.weekday - 1];
    final month = _months[d.month - 1];
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: _dateCardCream,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.black : _dateCardBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              weekday,
              style: TextStyle(
                color: isSelected ? AppTheme.textSecondary : AppTheme.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              '${d.day}',
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              month,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Daily: same as Weekly/Monthly - calendar icon + arrows + full month; single-select.
  Widget _buildDailyDates() {
    final year = _displayMonth.year;
    final month = _displayMonth.month;
    final lastDay = DateTime(year, month + 1, 0).day;
    final dates = List.generate(lastDay, (i) => DateTime(year, month, i + 1));
    final today = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () async {
                final initial = _displayMonth.isBefore(today) ? today : _displayMonth;
                final picked = await showDatePicker(
                  context: context,
                  initialDate: initial,
                  firstDate: DateTime(year - 1),
                  lastDate: DateTime(year + 2),
                );
                if (picked != null && mounted) {
                  setState(() {
                    _displayMonth = DateTime(picked.year, picked.month, 1);
                    _selectedDateDaily = picked;
                  });
                }
              },
              icon: const Icon(Icons.calendar_today_outlined, color: AppTheme.textPrimary, size: 22),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFF3F4F6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${_months[month - 1]} $year',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  if (month == 1) {
                    _displayMonth = DateTime(year - 1, 12, 1);
                    _selectedDateDaily = DateTime(year - 1, 12, 1);
                  } else {
                    _displayMonth = DateTime(year, month - 1, 1);
                    _selectedDateDaily = DateTime(year, month - 1, 1);
                  }
                });
              },
              icon: const Icon(Icons.chevron_left, color: AppTheme.textPrimary, size: 24),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  if (month == 12) {
                    _displayMonth = DateTime(year + 1, 1, 1);
                    _selectedDateDaily = DateTime(year + 1, 1, 1);
                  } else {
                    _displayMonth = DateTime(year, month + 1, 1);
                    _selectedDateDaily = DateTime(year, month + 1, 1);
                  }
                });
              },
              icon: const Icon(Icons.chevron_right, color: AppTheme.textPrimary, size: 24),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 86,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final d = dates[i];
              final isSelected = _selectedDateDaily != null &&
                  _selectedDateDaily!.year == d.year &&
                  _selectedDateDaily!.month == d.month &&
                  _selectedDateDaily!.day == d.day;
              return _buildDateCard(d, isSelected, () {
                setState(() => _selectedDateDaily = d);
              });
            },
          ),
        ),
      ],
    );
  }

  /// Weekly: same as Monthly - calendar icon + arrows + full month date cards (1 to last day).
  Widget _buildWeeklyDates() {
    final year = _displayMonth.year;
    final month = _displayMonth.month;
    final lastDay = DateTime(year, month + 1, 0).day;
    final dates = List.generate(lastDay, (i) => DateTime(year, month, i + 1));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _displayMonth.isBefore(DateTime.now()) ? DateTime.now() : _displayMonth,
                  firstDate: DateTime(year - 1),
                  lastDate: DateTime(year + 2),
                );
                if (picked != null && mounted) {
                  setState(() {
                    _displayMonth = DateTime(picked.year, picked.month, 1);
                    _selectedDatesWeekly.add(picked);
                  });
                }
              },
              icon: const Icon(Icons.calendar_today_outlined, color: AppTheme.textPrimary, size: 22),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFF3F4F6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${_months[month - 1]} $year',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  if (month == 1) {
                    _displayMonth = DateTime(year - 1, 12, 1);
                  } else {
                    _displayMonth = DateTime(year, month - 1, 1);
                  }
                });
              },
              icon: const Icon(Icons.chevron_left, color: AppTheme.textPrimary, size: 24),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  if (month == 12) {
                    _displayMonth = DateTime(year + 1, 1, 1);
                  } else {
                    _displayMonth = DateTime(year, month + 1, 1);
                  }
                });
              },
              icon: const Icon(Icons.chevron_right, color: AppTheme.textPrimary, size: 24),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 86,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final d = dates[i];
              final isSelected = _selectedDatesWeekly.contains(d);
              return _buildDateCard(d, isSelected, () {
                if (_selectWholeWeek) return;
                setState(() {
                  if (_selectedDatesWeekly.contains(d)) {
                    _selectedDatesWeekly.remove(d);
                  } else {
                    _selectedDatesWeekly.add(d);
                  }
                });
              });
            },
          ),
        ),
      ],
    );
  }

  /// Monthly: calendar icon + month nav + horizontal scroll of date cards (Mon 22 Jan style).
  Widget _buildMonthlyDates() {
    final year = _displayMonth.year;
    final month = _displayMonth.month;
    final lastDay = DateTime(year, month + 1, 0).day;
    final dates = List.generate(lastDay, (i) => DateTime(year, month, i + 1));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () async {
                final initial = _displayMonth.isBefore(DateTime.now()) ? DateTime.now() : _displayMonth;
                final picked = await showDatePicker(
                  context: context,
                  initialDate: initial,
                  firstDate: DateTime(year - 1),
                  lastDate: DateTime(year + 2),
                );
                if (picked != null && mounted) {
                  setState(() {
                    _displayMonth = DateTime(picked.year, picked.month, 1);
                    _selectedDatesWeekly.add(picked);
                  });
                }
              },
              icon: const Icon(Icons.calendar_today_outlined, color: AppTheme.textPrimary, size: 22),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFF3F4F6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${_months[month - 1]} $year',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  if (month == 1) {
                    _displayMonth = DateTime(year - 1, 12, 1);
                  } else {
                    _displayMonth = DateTime(year, month - 1, 1);
                  }
                });
              },
              icon: const Icon(Icons.chevron_left, color: AppTheme.textPrimary, size: 24),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  if (month == 12) {
                    _displayMonth = DateTime(year + 1, 1, 1);
                  } else {
                    _displayMonth = DateTime(year, month + 1, 1);
                  }
                });
              },
              icon: const Icon(Icons.chevron_right, color: AppTheme.textPrimary, size: 24),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 86,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final d = dates[i];
              final isSelected = _selectedDatesWeekly.contains(d);
              return _buildDateCard(d, isSelected, () {
                if (_selectWholeMonth) return;
                setState(() {
                  if (_selectedDatesWeekly.contains(d)) {
                    _selectedDatesWeekly.remove(d);
                  } else {
                    _selectedDatesWeekly.add(d);
                  }
                });
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlotsGrid(double width, double horizontalPadding) {
    const spacing = 12.0;
    const bookedBg = Color(0xFFF3F4F6);
    const availableBg = Color(0xFFE8F4FD);
    const availableBorder = Color(0xFF90CAF9);
    const availableText = Color(0xFF1976D2);

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = (constraints.maxWidth - spacing) / 2;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List.generate(
            _timeSlots.length,
            (i) {
              final slot = _timeSlots[i];
              final isAvailable = slot.available;
              final isSelected = _selectedTimeSlotIndex == i && isAvailable;

              return SizedBox(
                width: w,
                child: GestureDetector(
                  onTap: isAvailable
                      ? () => setState(() => _selectedTimeSlotIndex = _selectedTimeSlotIndex == i ? null : i)
                      : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? availableBg : (isAvailable ? availableBg : bookedBg),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isAvailable ? (isSelected ? AppTheme.primaryGold : availableBorder) : const Color(0xFFE0E0E0),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                slot.time,
                                style: const TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                slot.duration,
                                style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isAvailable
                                ? availableBg
                                : const Color(0xFFE8E8E8),
                            borderRadius: BorderRadius.circular(8),
                            border: isAvailable ? Border.all(color: availableBorder) : null,
                          ),
                          child: Text(
                            isAvailable ? 'Available' : 'Booked',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isAvailable ? availableText : AppTheme.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildRulesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _rules.map((rule) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '✓',
                style: TextStyle(
                  color: Color(0xFF22C55E),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  rule,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAgreementCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _agreedToRules == true,
            tristate: false,
            onChanged: (v) => setState(() => _agreedToRules = v ?? false),
            activeColor: AppTheme.primaryGold,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              'I agree to follow all house rules and safety guidelines for the jacuzzi.',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  DateTime _getBookingDate() {
    if (_viewIndex == 0 && _selectedDateDaily != null) return _selectedDateDaily!;
    if (_selectedDatesWeekly.isNotEmpty) {
      final list = _selectedDatesWeekly.toList()..sort();
      return list.first;
    }
    return DateTime.now();
  }

  int _parseDurationMinutes(String duration) {
    final match = RegExp(r'(\d+)').firstMatch(duration);
    return match != null ? int.tryParse(match.group(1) ?? '60') ?? 60 : 60;
  }

  String _endTimeLabel(String start, String duration) {
    final mins = _parseDurationMinutes(duration);
    final s = start.toUpperCase();
    var hour = int.tryParse(RegExp(r'\d+').firstMatch(start)?.group(0) ?? '12') ?? 12;
    if (s.contains('PM') && hour != 12) hour += 12;
    if (s.contains('AM') && hour == 12) hour = 0;
    final totalMins = hour * 60 + mins;
    var endHour = (totalMins ~/ 60) % 24;
    final endMin = totalMins % 60;
    final endPm = endHour >= 12;
    if (endHour > 12) endHour -= 12;
    if (endHour == 0) endHour = 12;
    return '$endHour:${endMin.toString().padLeft(2, '0')} ${endPm ? 'PM' : 'AM'}';
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final date = _getBookingDate();
          final timeSlot = _selectedTimeSlotIndex != null && _selectedTimeSlotIndex! < _timeSlots.length
              ? _timeSlots[_selectedTimeSlotIndex!]
              : null;
          final durationMinutes = timeSlot != null
              ? _parseDurationMinutes(timeSlot.duration)
              : 60;
          final timeLabel = timeSlot != null
              ? '${timeSlot.time} - ${_endTimeLabel(timeSlot.time, timeSlot.duration)}'
              : '6:00 PM - 7:00 PM';

          showBookingSummaryPopup(
            context,
            bookingDate: date,
            timeLabel: timeLabel,
            durationMinutes: durationMinutes,
            imagePath: 'assets/jacuzzi.png',
            onContinueToPayment: () => showBankingDetailsPopup(context),
          );
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
          'Confirm Booking',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
