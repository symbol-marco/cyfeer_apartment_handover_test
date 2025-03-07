import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'calendar.dart';

class TableCalenderView extends StatefulWidget {
  const TableCalenderView({
    super.key,
    this.onDateChanged,
    this.initialDate,
  });
  final ValueChanged<DateTime>? onDateChanged;
  final DateTime? initialDate;
  @override
  State<TableCalenderView> createState() => _TableCalenderViewState();
}

class _TableCalenderViewState extends State<TableCalenderView> {
  final HorizontalWeekCalenderController _calenderController =
      HorizontalWeekCalenderController();

  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate ?? DateTime.now();
  }

  void _selectDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    if (widget.onDateChanged != null) {
      widget.onDateChanged!(date);
    }
  }

  /// Returns the Vietnamese day of week for the given date
  String _getVietnameseDayOfWeek(DateTime date) {
    // Vietnamese day of week names
    final List<String> vietnameseDays = [
      'Chủ Nhật', // Sunday
      'Thứ Hai', // Monday
      'Thứ Ba', // Tuesday
      'Thứ Tư', // Wednesday
      'Thứ Năm', // Thursday
      'Thứ Sáu', // Friday
      'Thứ Bảy', // Saturday
    ];

    return vietnameseDays[
        date.weekday % 7]; // weekday is 1-7, we need 0-6 for indexing
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final selectDateText = DateFormat('dd/MM/yyyy').format(selectedDate);
    final vietnameseDayOfWeek = _getVietnameseDayOfWeek(selectedDate);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => _calenderController.jumpPre(),
                icon: const Icon(Icons.chevron_left_sharp),
              ),
              Row(
                children: [
                  Text(
                    '$vietnameseDayOfWeek, $selectDateText',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge!.copyWith(
                      color: Color(0xff3E4C59),
                      fontFamily: 'Inter',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => _calenderController.jumpNext(),
                icon: const Icon(Icons.chevron_right_sharp),
              ),
            ],
          ),
          HorizontalWeekCalendar(
            minDate: DateTime(2023, 12, 31),
            maxDate: DateTime(2026, 1, 31),
            initialDate: DateTime.now(),
            onDateChange: (date) => _selectDate(date),
            controller: _calenderController,
            showTopNavbar: false,
            useVietnameseWeekdays: true,
            monthFormat: "MMMM yyyy",
            showNavigationButtons: true,
            weekStartFrom: WeekStartFrom.Monday,
            borderRadius: BorderRadius.circular(7),
            activeBackgroundColor: Color(0xffFF8A00),
            activeTextColor: Colors.white,
            inactiveBackgroundColor: Color(0xffFF8A00).withOpacity(.3),
            inactiveTextColor: Colors.white,
            disabledTextColor: Colors.grey,
            disabledBackgroundColor: Colors.grey.withOpacity(.3),
            activeNavigatorColor: Color(0xffFF8A00),
            inactiveNavigatorColor: Colors.grey,
            monthColor: Color(0xffFF8A00),
            scrollPhysics: const BouncingScrollPhysics(),
          ),
        ],
      ),
    );
  }
}
