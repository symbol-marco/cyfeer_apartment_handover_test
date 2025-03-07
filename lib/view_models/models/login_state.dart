import 'package:cyfeer_apartment_handover/models/users/user.dart';

class LoginState {
  final User? user;
  final String? error;

  LoginState({this.user, this.error});

  LoginState.initial() : this(user: null, error: null);

  LoginState copyWith({
    User? user,
    String? error,
    bool? isLoading,
  }) {
    return LoginState(
      user: user,
      error: error
    );
  }
}
