import 'package:cyfeer_apartment_handover/services/handover/handover_Schedule_service.dart';
import 'package:cyfeer_apartment_handover/view_models/models/handover_schedule_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider that exposes the [HandoverScheduleViewmodel] to the widget tree.
/// This provider manages the state of handover schedules in the application.
final handoverScheduleViewmodelProvider =
    StateNotifierProvider<HandoverScheduleViewmodel, HandoverScheduleState>(
        (ref) {
  final handoverScheduleService = ref.watch(handoverScheduleServiceProvider);
  return HandoverScheduleViewmodel(handoverScheduleService);
});

/// View model that manages the handover schedule state and business logic.
///
/// This class handles loading and filtering of handover schedules based on
/// date selection and apartment code search criteria.
class HandoverScheduleViewmodel extends StateNotifier<HandoverScheduleState> {
  /// Service that provides handover schedule data operations.
  final HandoverScheduleService _handoverScheduleService;

  /// Currently selected date for filtering schedules.
  DateTime _currentDate = DateTime.now();

  /// Current search query for apartment code filtering.
  String _searchQuery = '';

  /// Creates a [HandoverScheduleViewmodel] with the required service dependency.
  ///
  /// Initializes with default state and loads handover schedules for current date.
  HandoverScheduleViewmodel(this._handoverScheduleService)
      : super(HandoverScheduleState.initial()) {
    loadHandoverSchedules(_currentDate);
  }

  /// Loads handover schedules for the specified date.
  ///
  /// Updates the [_currentDate] and triggers a search with current filters.
  ///
  /// [selectedDate] The date for which to load schedules.
  void loadHandoverSchedules(DateTime selectedDate) {
    _currentDate = selectedDate;
    _performSearch();
  }

  /// Filters handover schedules by apartment code.
  ///
  /// Updates the [_searchQuery] and triggers a search with current filters.
  ///
  /// [apartmentCode] The apartment code to search for.
  void searchByApartmentCode(String apartmentCode) {
    _searchQuery = apartmentCode;
    _performSearch();
  }

  /// Performs the actual search operation using current filters.
  ///
  /// This private method combines date and apartment code filters
  /// to update the state with filtered handover schedules.
  void _performSearch() {
    final result = _handoverScheduleService.searchHandovers(
      apartmentCode: _searchQuery,
      handoverDate: _currentDate,
    );
    state = state.copyWith(handoverSchedules: result.handoverSchedules);
  }
}
