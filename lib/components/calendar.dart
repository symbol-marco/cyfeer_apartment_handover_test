import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:intl/intl.dart';

/// Defines the starting day of the week for the calendar.
enum WeekStartFrom { Sunday, Monday }

/// A horizontal calendar widget that displays a week view with navigation.
///
/// This widget allows users to select dates and navigate between weeks.
/// It supports customization of colors, text styles, and behaviors.
class HorizontalWeekCalendar extends StatefulWidget {
  /// Determines which day the week starts from.
  final WeekStartFrom? weekStartFrom;

  /// Callback function when a date is selected.
  final Function(DateTime)? onDateChange;

  /// Callback function when the displayed week changes.
  final Function(List<DateTime>)? onWeekChange;

  /// Background color for the selected date.
  final Color? activeBackgroundColor;

  /// Background color for unselected dates that are selectable.
  final Color? inactiveBackgroundColor;

  /// Background color for dates that are disabled.
  final Color? disabledBackgroundColor;

  /// Text color for the selected date.
  final Color? activeTextColor;

  /// Text color for unselected dates that are selectable.
  final Color? inactiveTextColor;

  /// Text color for dates that are disabled.
  final Color? disabledTextColor;

  /// Color for active navigation controls.
  final Color? activeNavigatorColor;

  /// Color for inactive (disabled) navigation controls.
  final Color? inactiveNavigatorColor;

  /// Color for the month text in the header.
  final Color? monthColor;

  /// Border radius for date items.
  final BorderRadiusGeometry? borderRadius;

  /// Scroll physics for the calendar carousel.
  final ScrollPhysics? scrollPhysics;

  /// Whether to show navigation buttons.
  final bool? showNavigationButtons;

  /// Format string for displaying the month.
  final String? monthFormat;

  /// Minimum selectable date.
  final DateTime minDate;

  /// Maximum selectable date.
  final DateTime maxDate;

  /// Initial date to be selected when the calendar is first displayed.
  final DateTime initialDate;

  /// Whether to show the top navigation bar.
  final bool showTopNavbar;

  /// Controller for programmatically controlling the calendar.
  final HorizontalWeekCalenderController? controller;

  /// Whether to use Vietnamese weekday abbreviations instead of English.
  final bool useVietnameseWeekdays;

  /// Creates a horizontal week calendar.
  ///
  /// [minDate] must be before [maxDate], and [initialDate] must be between them.
  HorizontalWeekCalendar({
    super.key,
    this.onDateChange,
    this.onWeekChange,
    this.activeBackgroundColor,
    this.controller,
    this.inactiveBackgroundColor,
    this.disabledBackgroundColor = Colors.grey,
    this.activeTextColor = Colors.white,
    this.inactiveTextColor = Colors.white,
    this.disabledTextColor = Colors.white,
    this.activeNavigatorColor,
    this.inactiveNavigatorColor,
    this.monthColor,
    this.weekStartFrom = WeekStartFrom.Monday,
    this.borderRadius,
    this.scrollPhysics = const ClampingScrollPhysics(),
    this.showNavigationButtons = true,
    this.monthFormat,
    required this.minDate,
    required this.maxDate,
    required this.initialDate,
    this.showTopNavbar = true,
    this.useVietnameseWeekdays = false,
  })  : assert(minDate.isBefore(maxDate)),
        assert(
            minDate.isBefore(initialDate) && (initialDate).isBefore(maxDate)),
        super();

  @override
  State<HorizontalWeekCalendar> createState() => _HorizontalWeekCalendarState();
}

class _HorizontalWeekCalendarState extends State<HorizontalWeekCalendar> {
  /// Controller for the carousel slider.
  CarouselSliderController carouselController = CarouselSliderController();

  /// Initial page index for the carousel.
  final int _initialPage = 1;

  /// Today's date for reference.
  DateTime today = DateTime.now();

  /// Currently selected date.
  DateTime selectedDate = DateTime.now();

  /// List of dates in the current week.
  List<DateTime> currentWeek = [];

  /// Index of the currently displayed week in [listOfWeeks].
  int currentWeekIndex = 0;

  /// List of all weeks that have been generated.
  List<List<DateTime>> listOfWeeks = [];

  /// Returns the Vietnamese weekday abbreviation for a given date.
  ///
  /// Maps the weekday to a Vietnamese abbreviation:
  /// - Sunday: CN (Chủ Nhật)
  /// - Monday: Hai (Thứ Hai)
  /// - Tuesday: Ba (Thứ Ba)
  /// - etc.
  String _getVietnameseWeekday(DateTime date) {
    final List<String> vietnameseWeekdays = [
      'CN', // Sunday (Chủ Nhật)
      'Hai', // Monday (Thứ Hai)
      'Ba', // Tuesday (Thứ Ba)
      'Tư', // Wednesday (Thứ Tư)
      'Năm', // Thursday (Thứ Năm)
      'Sáu', // Friday (Thứ Sáu)
      'Bảy', // Saturday (Thứ Bảy)
    ];

    return vietnameseWeekdays[
        date.weekday % 7]; // weekday is 1-7, we need 0-6 for indexing
  }

  @override
  void initState() {
    initCalender();
    super.initState();
  }

  /// Returns a DateTime with the time component set to midnight.
  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Initializes the calendar with default values and sets up controllers.
  void initCalender() {
    final date = widget.initialDate;
    selectedDate = widget.initialDate;

    // Determine the start of the current week based on the weekStartFrom setting
    DateTime startOfCurrentWeek = widget.weekStartFrom == WeekStartFrom.Monday
        ? getDate(date.subtract(Duration(days: date.weekday - 1)))
        : getDate(date.subtract(Duration(days: date.weekday % 7)));

    // Add all days of the week to currentWeek
    currentWeek.add(startOfCurrentWeek);
    for (int index = 0; index < 6; index++) {
      DateTime addDate = startOfCurrentWeek.add(Duration(days: (index + 1)));
      currentWeek.add(addDate);
    }

    listOfWeeks.add(currentWeek);

    // Generate additional weeks
    _getMorePreviousWeeks();
    _getMoreNextWeeks();

    // Set up controller listeners if provided
    if (widget.controller != null) {
      widget.controller!._stateChangerPre.addListener(() {
        _onBackClick();
      });

      widget.controller!._stateChangerNex.addListener(() {
        _onNextClick();
      });
    }
  }

  /// Generates a previous week and adds it to [listOfWeeks].
  ///
  /// This adds a week before the earliest week in [listOfWeeks].
  /// Only adds the week if at least one day is after [widget.minDate].
  void _getMorePreviousWeeks() {
    List<DateTime> minus7Days = [];
    DateTime startFrom = listOfWeeks[currentWeekIndex].first;

    bool canAdd = false;
    for (int index = 0; index < 7; index++) {
      DateTime minusDate = startFrom.add(Duration(days: -(index + 1)));
      minus7Days.add(minusDate);
      if (minusDate.add(const Duration(days: 1)).isAfter(widget.minDate)) {
        canAdd = true;
      }
    }
    if (canAdd == true) {
      listOfWeeks.add(minus7Days.reversed.toList());
    }
    setState(() {});
  }

  /// Generates a next week and adds it to [listOfWeeks].
  ///
  /// This adds a week after the latest week in [listOfWeeks].
  void _getMoreNextWeeks() {
    List<DateTime> plus7Days = [];
    DateTime startFrom = listOfWeeks[currentWeekIndex].last;

    for (int index = 0; index < 7; index++) {
      DateTime addDate = startFrom.add(Duration(days: (index + 1)));
      plus7Days.add(addDate);
    }
    listOfWeeks.insert(0, plus7Days);
    currentWeekIndex = 1;
    setState(() {});
  }

  /// Handles date selection and triggers the onDateChange callback.
  void _onDateSelect(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    widget.onDateChange?.call(selectedDate);
  }

  /// Navigates to the previous week.
  void _onBackClick() {
    carouselController.nextPage();
  }

  /// Navigates to the next week.
  void _onNextClick() {
    carouselController.previousPage();
  }

  /// Handles week change events when the carousel is scrolled.
  ///
  /// Updates the current week index and triggers loading of additional weeks
  /// if needed. Also calls the onWeekChange callback if provided.
  void onWeekChange(int index) {
    if (currentWeekIndex < index) {
      // on back
    }
    if (currentWeekIndex > index) {
      // on next
    }

    currentWeekIndex = index;
    currentWeek = listOfWeeks[currentWeekIndex];

    // If we're at the last week, generate more previous weeks
    if (currentWeekIndex + 1 == listOfWeeks.length) {
      _getMorePreviousWeeks();
    }

    // If we're at the first week, generate more next weeks
    if (index == 0) {
      _getMoreNextWeeks();
      carouselController.nextPage();
    }

    widget.onWeekChange?.call(currentWeek);
    setState(() {});
  }

  /// Checks if a date is after or equal to the minimum selectable date.
  bool _isReachMinimum(DateTime dateTime) {
    return widget.minDate.add(const Duration(days: -1)).isBefore(dateTime);
  }

  /// Checks if a date is before or equal to the maximum selectable date.
  bool _isReachMaximum(DateTime dateTime) {
    return widget.maxDate.add(const Duration(days: 1)).isAfter(dateTime);
  }

  /// Determines if the next navigation button should be disabled.
  ///
  /// The button is disabled if the last date in the current week is after [widget.maxDate].
  bool _isNextDisabled() {
    DateTime lastDate = listOfWeeks[currentWeekIndex].last;
    String lastDateFormatted = DateFormat('yyyy/MM/dd').format(lastDate);
    String maxDateFormatted = DateFormat('yyyy/MM/dd').format(widget.maxDate);
    if (lastDateFormatted == maxDateFormatted) return true;

    bool isAfter = lastDate.isAfter(widget.maxDate);

    return isAfter;
  }

  /// Determines if the back navigation button should be disabled.
  ///
  /// The button is disabled if the first date in the current week is before [widget.minDate].
  bool isBackDisabled() {
    DateTime firstDate = listOfWeeks[currentWeekIndex].first;
    String firstDateFormatted = DateFormat('yyyy/MM/dd').format(firstDate);
    String minDateFormatted = DateFormat('yyyy/MM/dd').format(widget.minDate);
    if (firstDateFormatted == minDateFormatted) return true;

    bool isBefore = firstDate.isBefore(widget.minDate);

    return isBefore;
  }

  /// Checks if the current week is in the current year.
  bool isCurrentYear() {
    return DateFormat('yyyy').format(currentWeek.first) ==
        DateFormat('yyyy').format(today);
  }

  /// Checks if a date is in the past.
  bool _isPastDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final compareDate = DateTime(date.year, date.month, date.day);
    return compareDate.isBefore(today);
  }

  /// Determines the background color for a date based on its state.
  ///
  /// The color depends on whether the date is selected, within the valid range,
  /// or in the past.
  Color _getBackgroundColor(DateTime date, bool isSelected) {
    if (isSelected) {
      return widget.activeBackgroundColor ?? Colors.orange;
    }

    final isInRange = _isReachMaximum(date) && _isReachMinimum(date);
    if (!isInRange) {
      return widget.disabledBackgroundColor ?? Colors.grey;
    }

    if (_isPastDate(date)) {
      return Colors.grey;
    }

    return Colors.orange;
  }

  /// Determines the text color for a date based on its state.
  ///
  /// The color depends on whether the date is selected or within the valid range.
  Color _getTextColor(DateTime date, bool isSelected) {
    if (isSelected) {
      return widget.activeTextColor ?? Colors.white;
    }

    final isInRange = _isReachMaximum(date) && _isReachMinimum(date);
    if (!isInRange) {
      return widget.disabledTextColor ?? Colors.white;
    }

    return Colors.white;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return currentWeek.isEmpty
        ? const SizedBox()
        : Column(
            children: [
              // Top navigation bar with month display and navigation buttons
              if (widget.showTopNavbar)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    widget.showNavigationButtons == true
                        ? GestureDetector(
                            onTap: isBackDisabled()
                                ? null
                                : () {
                                    _onBackClick();
                                  },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 17,
                                  color: isBackDisabled()
                                      ? (widget.inactiveNavigatorColor ??
                                          Colors.grey)
                                      : theme.primaryColor,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "Back",
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                    color: isBackDisabled()
                                        ? (widget.inactiveNavigatorColor ??
                                            Colors.grey)
                                        : theme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    // Month display
                    Text(
                      widget.monthFormat?.isEmpty ?? true
                          ? (isCurrentYear()
                              ? DateFormat('MMMM').format(
                                  currentWeek.first,
                                )
                              : DateFormat('MMMM yyyy').format(
                                  currentWeek.first,
                                ))
                          : DateFormat(widget.monthFormat).format(
                              currentWeek.first,
                            ),
                      style: theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: widget.monthColor ?? theme.primaryColor,
                      ),
                    ),
                    // Next button
                    widget.showNavigationButtons == true
                        ? GestureDetector(
                            onTap: _isNextDisabled()
                                ? null
                                : () {
                                    _onNextClick();
                                  },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Next",
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                    color: _isNextDisabled()
                                        ? (widget.inactiveNavigatorColor ??
                                            Colors.grey)
                                        : theme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 17,
                                  color: _isNextDisabled()
                                      ? (widget.inactiveNavigatorColor ??
                                          Colors.grey)
                                      : theme.primaryColor,
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              if (widget.showTopNavbar) const SizedBox(height: 12),
              // Carousel displaying days of the week
              CarouselSlider(
                controller: carouselController,
                items: [
                  if (listOfWeeks.isNotEmpty)
                    for (int ind = 0; ind < listOfWeeks.length; ind++)
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            for (int weekIndex = 0;
                                weekIndex < listOfWeeks[ind].length;
                                weekIndex++)
                              Builder(builder: (_) {
                                DateTime currentDate =
                                    listOfWeeks[ind][weekIndex];
                                final isSelected = DateFormat('dd-MM-yyyy')
                                        .format(currentDate) ==
                                    DateFormat('dd-MM-yyyy')
                                        .format(selectedDate);

                                return Expanded(
                                  child: GestureDetector(
                                    onTap: _isReachMaximum(currentDate) &&
                                            _isReachMinimum(currentDate)
                                        ? () {
                                            _onDateSelect(
                                              listOfWeeks[ind][weekIndex],
                                            );
                                          }
                                        : null,
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: widget.borderRadius,
                                        color: _getBackgroundColor(
                                            currentDate, isSelected),
                                        border: Border.all(
                                          color: theme.scaffoldBackgroundColor,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // Day of week (English or Vietnamese)
                                          Text(
                                            widget.useVietnameseWeekdays
                                                ? _getVietnameseWeekday(
                                                    listOfWeeks[ind][weekIndex])
                                                : DateFormat('EEE').format(
                                                    listOfWeeks[ind]
                                                        [weekIndex]),
                                            textAlign: TextAlign.center,
                                            style: theme.textTheme.bodyLarge!
                                                .copyWith(
                                              color: _getTextColor(
                                                  currentDate, isSelected),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          // Day number
                                          Text(
                                            "${currentDate.day}",
                                            textAlign: TextAlign.center,
                                            style: theme.textTheme.titleLarge!
                                                .copyWith(
                                              color: _getTextColor(
                                                  currentDate, isSelected),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          ],
                        ),
                      ),
                ],
                options: CarouselOptions(
                  initialPage: _initialPage,
                  scrollPhysics:
                      widget.scrollPhysics ?? const ClampingScrollPhysics(),
                  height: 75,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  reverse: true,
                  onPageChanged: (index, reason) {
                    onWeekChange(index);
                  },
                ),
              ),
            ],
          );
  }
}

/// Controller for programmatically controlling the HorizontalWeekCalendar.
///
/// Provides methods to jump to previous or next weeks.
class HorizontalWeekCalenderController {
  /// Notifies listeners when jumping to previous week.
  final ValueNotifier<int> _stateChangerPre = ValueNotifier<int>(0);

  /// Notifies listeners when jumping to next week.
  final ValueNotifier<int> _stateChangerNex = ValueNotifier<int>(0);

  /// Jumps to the previous week.
  void jumpPre() {
    _stateChangerPre.value = _stateChangerPre.value + 1;
  }

  /// Jumps to the next week.
  void jumpNext() {
    _stateChangerNex.value = _stateChangerNex.value + 1;
  }
}
