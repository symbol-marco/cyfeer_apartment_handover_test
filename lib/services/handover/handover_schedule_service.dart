import 'dart:convert';

import 'package:cyfeer_apartment_handover/database/database_config.dart';
import 'package:cyfeer_apartment_handover/models/handover/handover_schedule.dart';
import 'package:cyfeer_apartment_handover/models/handover/handover_schedule_list.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

part 'handover_schedule_service_impl.dart';

/// Abstract class defining the interface for the handover schedule service.
///
/// This service provides data access and operations for handover schedules,
/// including loading, searching, and updating handover records.
abstract class HandoverScheduleService {
  /// Loads all handover schedules from storage.
  ///
  /// Returns a list of all available [HandoverSchedule] objects.
  List<HandoverSchedule> loadHandovers();

  /// Initializes the service and sets up any required resources.
  ///
  /// Should be called before any other methods to ensure the service is ready.
  Future<void> init();

  /// Saves a list of handover schedules to storage.
  ///
  /// [handovers] The list of handover schedules to save.
  Future<void> saveHandovers(List<HandoverSchedule> handovers);

  /// Updates a specific handover schedule in storage.
  ///
  /// [index] The unique identifier of the handover schedule to update.
  /// [handover] The updated handover schedule data.
  Future<void> updateHandover(int index, HandoverSchedule handover);

  /// Loads handover schedules for a specific date.
  ///
  /// [selectedDate] The date to filter handover schedules by.
  /// Returns a list of handover schedules occurring on the selected date.
  HandoverScheduleList loadHandoversByDate(DateTime selectedDate);

  /// Searches for handover schedules by apartment code and/or date.
  ///
  /// [apartmentCode] Optional apartment code to search for.
  /// [handoverDate] Optional date to filter results by.
  /// Returns a list of handover schedules matching the search criteria.
  HandoverScheduleList searchHandovers(
      {String? apartmentCode, DateTime? handoverDate});

  /// Searches for handover schedules by apartment code.
  ///
  /// [apartmentCode] The apartment code to search for.
  /// Returns a list of handover schedules matching the apartment code.
  HandoverScheduleList searchHandoversByApartmentCode(String apartmentCode);
}

/// Provider for accessing the handover schedule service.
///
/// Creates and provides a singleton instance of the [HandoverScheduleService]
/// implementation for dependency injection throughout the application.
final handoverScheduleServiceProvider =
    Provider<HandoverScheduleService>((ref) {
  return HandoverScheduleServiceImpl();
});
