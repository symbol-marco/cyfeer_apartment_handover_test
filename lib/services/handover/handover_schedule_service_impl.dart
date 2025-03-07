part of 'handover_Schedule_service.dart';

/// Implementation of the [HandoverScheduleService] interface.
///
/// Uses Hive database for local storage and persistence of handover schedules.
/// Includes methods for initializing data from JSON resources when needed.
class HandoverScheduleServiceImpl implements HandoverScheduleService {
  /// Path to the JSON file containing initial handover schedule data
  static const String _handoversJsonFile = 'assets/resources/handovers.json';

  /// Hive box for storing handover schedule data
  late final Box<HandoverSchedule> _handoversBox;

  /// Creates a new instance of the handover schedule service implementation.
  HandoverScheduleServiceImpl();

  @override
  List<HandoverSchedule> loadHandovers() {
    return _handoversBox.values.toList();
  }

  @override
  Future<void> saveHandovers(List<HandoverSchedule> handovers) async {
    final map = {for (final handover in handovers) handover.id: handover};
    await _handoversBox.putAll(map);
  }

  @override
  Future<void> updateHandover(int index, HandoverSchedule handover) async {
    await _handoversBox.put(index, handover);
  }

  @override
  Future<void> init() async {
    // Initialize the database configuration
    await DatabaseConfig.init();

    // Get the handovers box from Hive
    _handoversBox = Hive.box<HandoverSchedule>(DatabaseConfig.handoversBox);

    // If the box is empty, load initial data from assets
    if (_handoversBox.isEmpty) {
      final String jsonString = await rootBundle.loadString(_handoversJsonFile);
      final List<dynamic> jsonData = jsonDecode(jsonString);
      final handovers =
          jsonData.map((json) => HandoverSchedule.fromJson(json)).toList();
      await saveHandovers(handovers);
    }
  }

  @override
  HandoverScheduleList loadHandoversByDate(DateTime selectedDate) {
    try {
      final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      final String selectedDateStr = dateFormat.format(selectedDate);

      // Filter handovers by date
      final HandoverSchedules handoverSchedules =
          _handoversBox.values.where((handover) {
        final handoverDateStr = dateFormat.format(handover.date);
        return handoverDateStr == selectedDateStr;
      }).toList();

      final HandoverScheduleList handoverScheduleList =
          HandoverScheduleList.from(handoverSchedules);
      return handoverScheduleList;
    } catch (e) {
      // Return empty list on error
      return HandoverScheduleList.from([]);
    }
  }

  @override
  HandoverScheduleList searchHandovers(
      {String? apartmentCode, DateTime? handoverDate}) {
    try {
      final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

      // Filter handovers by apartment code and/or date
      final handoverSchedules = _handoversBox.values.where((handover) {
        bool matchesApartmentCode = true;
        bool matchesDate = true;

        // Check for apartment code match if provided
        if (apartmentCode != null && apartmentCode.isNotEmpty) {
          matchesApartmentCode = handover.apartmentCode
              .toLowerCase()
              .contains(apartmentCode.toLowerCase());
        }

        // Check for date match if provided
        if (handoverDate != null) {
          final String selectedDateStr = dateFormat.format(handoverDate);
          final String handoverDateStr = dateFormat.format(handover.date);
          matchesDate = handoverDateStr == selectedDateStr;
        }

        return matchesApartmentCode && matchesDate;
      }).toList();

      return HandoverScheduleList.from(handoverSchedules);
    } catch (e) {
      // Return empty list on error
      return HandoverScheduleList.from([]);
    }
  }

  @override
  HandoverScheduleList searchHandoversByApartmentCode(String apartmentCode) {
    try {
      // Filter handovers by apartment code with case-insensitive search
      final handoverSchedules = _handoversBox.values
          .where((handover) => handover.apartmentCode
              .toLowerCase()
              .contains(apartmentCode.toLowerCase()))
          .toList();

      return HandoverScheduleList.from(handoverSchedules);
    } catch (e) {
      // Return empty list on error
      return HandoverScheduleList.from([]);
    }
  }
}
