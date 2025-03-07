part of 'user_service.dart';

/// Implementation of the [UserService] interface.
///
/// Uses SharedPreferences for persistent user session storage and
/// loads user data from a JSON asset file.
class UserServiceImpl implements UserService {
  /// Path to the JSON file containing user data
  static const String _handoversJsonFile = 'assets/resources/users.json';

  /// SharedPreferences instance for storing user session data
  final SharedPreferences _sharedPreference;

  /// Creates a new instance of the user service implementation.
  ///
  /// [_sharedPreference] The SharedPreferences instance for storing session data.
  UserServiceImpl(this._sharedPreference);

  @override
  Future<List<User>> loadUsers() async {
    // Load user data from the JSON asset file
    final String jsonString = await rootBundle.loadString(_handoversJsonFile);
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((json) => User.fromJson(json)).toList();
  }

  @override
  Future<User?> getCurrentUser() async {
    // Get the current user ID from shared preferences
    final currentUserId =
        _sharedPreference.getInt(AppConstants.currentUserIdKey);
    if (currentUserId != null) {
      // Find the user with the matching ID from the loaded users
      return await loadUsers().then((users) =>
          users.firstWhereOrNull((user) => user.id == currentUserId));
    }
    return null;
  }

  @override
  Future<void> login(String phoneNumber, String password) async {
    // Load all users and find the user with matching credentials
    final users = await loadUsers();
    final hashedInputPassword = generateMd5Hash(password);
    final user = users.firstWhereOrNull((u) =>
        u.phoneNumber == phoneNumber && u.password == hashedInputPassword);
    if (user != null) {
      // Store the authenticated user's ID in shared preferences
      await _sharedPreference.setInt(AppConstants.currentUserIdKey, user.id);
    } else {
      // Throw an exception if authentication fails
      throw Exception(AppConstants.loginExceptionMessage);
    }
  }

  @override
  Future<void> logout() async {
    // Remove the user ID from shared preferences to log out
    await _sharedPreference.remove(AppConstants.currentUserIdKey);
  }

  /// Generates an MD5 hash of the input string.
  ///
  /// [input] The string to hash, typically a password.
  /// Returns the MD5 hash as a hexadecimal string.
  String generateMd5Hash(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
}
