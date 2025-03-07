import 'package:cyfeer_apartment_handover/models/handover/handover_schedule.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Configuration class for database setup and initialization.
///
/// This class provides a centralized configuration for all database operations,
/// including Hive storage setup, type adapters registration, and box management.
/// It is designed as a utility class with static methods only.
class DatabaseConfig {
  /// Private constructor to prevent instantiation of this utility class.
  const DatabaseConfig._();

  /// Box name constant for storing handover schedule data.
  static const String handoversBox = 'handoversBox';

  /// Initializes the database configurations and requirements.
  ///
  /// This method must be called before any database operations to ensure that:
  /// - Hive is properly initialized for Flutter
  /// - All required type adapters are registered
  /// - Storage boxes are opened and ready for use
  ///
  /// Returns a [Future] that completes when initialization is finished.
  static Future<void> init() async {
    // Initialize Hive for Flutter
    await Hive.initFlutter();

    // Register type adapters for all model classes that need persistence
    Hive.registerAdapter(HandoverScheduleAdapter());
    Hive.registerAdapter(HandoverChecklistAdapter());
    Hive.registerAdapter(CheckerItemAdapter());
    Hive.registerAdapter(CompletionStatusAdapter());

    // Open the boxes for storage
    await Hive.openBox<HandoverSchedule>(handoversBox);
  }
}
