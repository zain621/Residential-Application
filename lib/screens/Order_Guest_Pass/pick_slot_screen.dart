import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_theme.dart';
import '../widgets/shimmer_widget.dart';
import 'confirmation_screen.dart';

class PickSlotScreen extends StatefulWidget {
  const PickSlotScreen({
    super.key,
    required this.passType,
    required this.visitorName,
    required this.email,
    required this.phone,
    required this.company,
  });

  final String passType;
  final String visitorName;
  final String email;
  final String phone;
  final String company;

  @override
  State<PickSlotScreen> createState() => _PickSlotScreenState();
}

class _PickSlotScreenState extends State<PickSlotScreen> {
  bool _isLoading = true;
  DateTime? _selectedDate;
  final TextEditingController _startHourController = TextEditingController();
  final TextEditingController _startMinuteController = TextEditingController(text: '00');
  final TextEditingController _endHourController = TextEditingController();
  final TextEditingController _endMinuteController = TextEditingController(text: '00');
  bool _isStartAm = true;
  bool _isEndAm = true;
  bool _rentForAllDay = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _startHourController.dispose();
    _startMinuteController.dispose();
    _endHourController.dispose();
    _endMinuteController.dispose();
    super.dispose();
  }

  double _horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width > 600) return 24.0;
    if (width > 400) return 20.0;
    return 16.0 + (width - 320).clamp(0.0, 80.0) * 0.05; // 16–20 on small screens
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = _horizontalPadding(context);

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
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.black, size: 22),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: const Text(
            'Order new pass',
            style: TextStyle(
              color: AppTheme.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: _isLoading
            ? SafeArea(child: _buildShimmerContent(horizontalPadding))
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          _buildTitle(),
                          const SizedBox(height: 8),
                          _buildSubtitle(),
                          const SizedBox(height: 28),
                          _buildSelectDateSection(horizontalPadding),
                          const SizedBox(height: 28),
                          _buildTimeSlotsSection(),
                          const SizedBox(height: 28),
                          _buildRentForAllDayButton(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        16,
                        horizontalPadding,
                        16,
                      ),
                      child: _buildContinueButton(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTitle() {
    final width = MediaQuery.sizeOf(context).width;
    return Text(
      'Pick Your Slot',
      style: TextStyle(
        color: AppTheme.black,
        fontSize: width > 400 ? 24 : 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'Choose the date and time that works best for you',
      style: TextStyle(
        color: AppTheme.textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildSelectDateSection(double horizontalPadding) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = (screenWidth > 400) ? 64.0 : 56.0;
    final gap = 12.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date',
          style: TextStyle(
            color: AppTheme.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 86,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(right: horizontalPadding),
            itemCount: 7,
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index));
              final isToday = index == 0;
              final isSelected = _selectedDate != null &&
                  _selectedDate!.year == date.year &&
                  _selectedDate!.month == date.month &&
                  _selectedDate!.day == date.day;

              return GestureDetector(
                onTap: () => setState(() => _selectedDate = date),
                child: Container(
                  width: cardWidth,
                  margin: EdgeInsets.only(right: index < 6 ? gap : 0),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryGold
                        : AppTheme.white,
                    borderRadius: BorderRadius.circular(10),
                    border: isSelected
                        ? null
                        : Border.all(color: const Color(0xFFE5E7EB), width: 1),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: AppTheme.primaryGold.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      else
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          isToday ? 'Today' : _getDayName(date.weekday),
                          style: TextStyle(
                            color: isSelected
                                ? AppTheme.white
                                : AppTheme.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          color: isSelected ? AppTheme.white : AppTheme.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Flexible(
                        child: Text(
                          _getMonthName(date.month),
                          style: TextStyle(
                            color: isSelected
                                ? AppTheme.white
                                : AppTheme.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  static const _timeInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: Color(0xFFE5E7EB)),
  );

  Widget _buildTimeSlotsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Time Slots',
          style: TextStyle(
            color: AppTheme.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 320;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      flex: 1,
                      child: _buildTimeInput(
                        hourController: _startHourController,
                        minuteController: _startMinuteController,
                        isAm: _isStartAm,
                        onAmPmChanged: (value) => setState(() => _isStartAm = value),
                        compact: compact,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 10),
                      child: const Text(
                        'to',
                        style: TextStyle(
                          color: AppTheme.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: _buildTimeInput(
                        hourController: _endHourController,
                        minuteController: _endMinuteController,
                        isAm: _isEndAm,
                        onAmPmChanged: (value) => setState(() => _isEndAm = value),
                        compact: compact,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTimeInput({
    required TextEditingController hourController,
    required TextEditingController minuteController,
    required bool isAm,
    required Function(bool) onAmPmChanged,
    bool compact = false,
  }) {
    final inputWidth = compact ? 44.0 : 50.0;
    final padH = compact ? 6.0 : 10.0;
    final padV = compact ? 10.0 : 12.0;

    return IntrinsicWidth(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        SizedBox(
          width: inputWidth,
          child: TextField(
            controller: hourController,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(2),
            ],
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.white,
              border: _timeInputBorder,
              enabledBorder: _timeInputBorder,
              focusedBorder: _timeInputBorder.copyWith(
                borderSide: const BorderSide(color: AppTheme.primaryGold, width: 1.5),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: padV, horizontal: padH),
              isDense: true,
            ),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            ':',
            style: TextStyle(
              color: AppTheme.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          width: inputWidth,
          child: TextField(
            controller: minuteController,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(2),
            ],
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.white,
              border: _timeInputBorder,
              enabledBorder: _timeInputBorder,
              focusedBorder: _timeInputBorder.copyWith(
                borderSide: const BorderSide(color: AppTheme.primaryGold, width: 1.5),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: padV, horizontal: padH),
              isDense: true,
            ),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: compact ? 6 : 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => onAmPmChanged(true),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 10 : 12,
                  vertical: compact ? 8 : 10,
                ),
                decoration: BoxDecoration(
                  color: isAm ? AppTheme.primaryGold : AppTheme.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isAm ? AppTheme.primaryGold : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Text(
                  'AM',
                  style: TextStyle(
                    color: isAm ? AppTheme.white : AppTheme.textSecondary,
                    fontSize: compact ? 12 : 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: compact ? 4 : 6),
            GestureDetector(
              onTap: () => onAmPmChanged(false),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 10 : 12,
                  vertical: compact ? 8 : 10,
                ),
                decoration: BoxDecoration(
                  color: !isAm ? AppTheme.primaryGold : AppTheme.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: !isAm ? AppTheme.primaryGold : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Text(
                  'PM',
                  style: TextStyle(
                    color: !isAm ? AppTheme.white : AppTheme.textSecondary,
                    fontSize: compact ? 12 : 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        ],
      ),
    );
  }

  Widget _buildRentForAllDayButton() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _rentForAllDay = !_rentForAllDay;
              if (_rentForAllDay) {
                _startHourController.clear();
                _startMinuteController.text = '00';
                _endHourController.clear();
                _endMinuteController.text = '00';
              }
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryGold,
            foregroundColor: AppTheme.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Rent for all day',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ConfirmationScreen(
                passType: widget.passType,
                visitorName: widget.visitorName,
                email: widget.email,
                phone: widget.phone,
                company: widget.company,
                selectedDate: _selectedDate,
                startTime: _rentForAllDay
                    ? 'All Day'
                    : '${_startHourController.text}:${_startMinuteController.text} ${_isStartAm ? 'AM' : 'PM'}',
                endTime: _rentForAllDay
                    ? 'All Day'
                    : '${_endHourController.text}:${_endMinuteController.text} ${_isEndAm ? 'AM' : 'PM'}',
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryGold,
          foregroundColor: AppTheme.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Continue',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  Widget _buildShimmerContent(double horizontalPadding) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          ShimmerContainer(
            width: 200,
            height: 28,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 8),
          ShimmerContainer(
            width: double.infinity,
            height: 20,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 32),
          ShimmerContainer(
            width: 120,
            height: 20,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(right: index < 6 ? 12 : 0),
                child: ShimmerContainer(
                  width: 70,
                  height: 80,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          ShimmerContainer(
            width: 180,
            height: 20,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 20),
          ShimmerContainer(
            width: double.infinity,
            height: 50,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 32),
          ShimmerContainer(
            width: 150,
            height: 40,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 40),
          ShimmerContainer(
            width: double.infinity,
            height: 50,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }
}
