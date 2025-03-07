import 'dart:convert';

import 'package:cyfeer_apartment_handover/models/users/user.dart';
import 'package:cyfeer_apartment_handover/util/app_constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
part 'user_service_impl.dart';

/// Abstract class defining the interface for the user authentication service.
///
/// This service provides functionality for user authentication, including
/// login, logout, and retrieving the current authenticated user's information.
abstract class UserService {
  /// Loads all users from the data source.
  ///
  /// Returns a list of all available [User] objects.
  Future<List<User>> loadUsers();

  /// Gets the currently authenticated user, if any.
  ///
  /// Returns the current [User] if logged in, otherwise null.
  Future<User?> getCurrentUser();

  /// Authenticates a user with email and password credentials.
  ///
  /// [email] The user's email address or phone number.
  /// [password] The user's password.
  ///
  /// Throws an exception if authentication fails.
  Future<void> login(String email, String password);

  /// Logs out the current user and clears authentication data.
  Future<void> logout();
}

/// Provider for accessing the shared preferences instance.
///
/// This provider should be overridden with an initialized SharedPreferences
/// instance before use.
final sharedPreferencesProvider = Provider<SharedPreferences?>((ref) {
  return null;
});

/// Provider for accessing the user service.
///
/// Creates and provides a singleton instance of the [UserService]
/// implementation for dependency injection throughout the application.
final userServiceProvider = Provider<UserService>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  if (sharedPreferences == null) {
    throw Exception('SharedPreferences is not initialized');
  }
  return UserServiceImpl(sharedPreferences);
});
