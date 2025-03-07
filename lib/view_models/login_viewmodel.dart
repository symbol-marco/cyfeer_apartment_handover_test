import 'package:cyfeer_apartment_handover/services/user/user_service.dart';
import 'package:cyfeer_apartment_handover/util/extension/string_extension.dart';
import 'package:cyfeer_apartment_handover/view_models/models/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider that manages the login state and authentication process.
///
/// This provider creates and maintains a [LoginViewModel] which is responsible
/// for handling user authentication and session management.
final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState?>((ref) {
  final userService = ref.watch(userServiceProvider);
  return LoginViewModel(userService)..loadCurrentUser();
});

/// View model for handling user authentication and session management.
///
/// Manages the login process, user session validation, and logout functionality.
/// Interfaces with [UserService] to handle backend authentication operations.
class LoginViewModel extends StateNotifier<LoginState> {
  /// Service responsible for user authentication operations
  final UserService _userService;

  /// Creates a new instance of [LoginViewModel].
  ///
  /// Requires a [UserService] for handling authentication operations.
  /// Initializes the state with default values.
  LoginViewModel(this._userService) : super(LoginState.initial());

  /// Attempts to authenticate the user with the provided credentials.
  ///
  /// [phoneNumber] The user's phone number for authentication.
  /// [password] The user's password for authentication.
  ///
  /// First validates the inputs, then attempts to login via the user service,
  /// and finally updates the state based on the authentication result.
  Future<void> attemptLogin(String phoneNumber, String password) async {
    try {
      if (phoneNumber.isNotEmpty && password.isNotEmpty) {
        await validateInput(phoneNumber, password);
        await _userService.login(phoneNumber, password);
        final user = await _userService.getCurrentUser();
        if (user != null) {
          state = state.copyWith(user: user);
        } else {
          state = state.copyWith(
            user: null,
          );
        }
      }
    } catch (e) {
      state = state.copyWith(user: null);
    }
  }

  /// Loads the current authenticated user from persistent storage or token.
  ///
  /// Attempts to retrieve the current user session from the user service.
  /// Updates the state with the user information if available.
  /// Throws an exception if the operation fails.
  Future<void> loadCurrentUser() async {
    try {
      final user = await _userService.getCurrentUser();
      state = state.copyWith(user: user);
    } catch (e) {
      throw Exception('Failed to load current user: $e');
    }
  }

  /// Logs out the current user and clears the session.
  ///
  /// Calls the logout method on the user service and
  /// updates the state to reflect that no user is logged in.
  Future<void> logout() async {
    await _userService.logout();
    state = state.copyWith(user: null);
  }

  /// Validates the login input fields before submission.
  ///
  /// [phoneNumber] The phone number to validate.
  /// [password] The password to validate.
  ///
  /// Checks if the phone number is a valid Vietnamese phone number
  /// and if the password meets the required format criteria.
  /// Updates the state with an error message if validation fails.
  Future<void> validateInput(String phoneNumber, String password) async {
    if (!phoneNumber.isValidVietnamPhoneNumber()) {
      state = state.copyWith(error: 'Số điện thoại không hợp lệ');
    }
    if (!password.isValidPassword()) {
      state = state.copyWith(error: 'Mật khẩu không hợp lệ');
    }
  }
}
