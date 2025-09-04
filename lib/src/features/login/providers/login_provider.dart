import 'package:eshodhan/src/features/login/services/loginservice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eshodhan/src/features/login/models/loginresponse.dart';

class LoginState {
  final bool loading;
  final String? error;
  final bool loggedIn;

  const LoginState({this.loading = false, this.error, this.loggedIn = false});

  LoginState copyWith({bool? loading, String? error, bool? loggedIn}) {
    return LoginState(
      loading: loading ?? this.loading,
      error: error,
      loggedIn: loggedIn ?? this.loggedIn,
    );
  }
}

class LoginController extends StateNotifier<LoginState> {
  LoginController() : super(const LoginState());

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      state = state.copyWith(error: 'Email & password are required');
      return;
    }
    state = state.copyWith(loading: true, error: null);

    try {
      // 🔥 call your API here
      final LoginResponseModel response = await loginUser(email, password);

      if (response.token!.isNotEmpty) {
        // success
        state = state.copyWith(loading: false, loggedIn: true);
      } else {
        state = state.copyWith(
          loading: false,
          error: 'Invalid credentials',
        );
      }
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: e.toString(),
      );
    }
  }

  void clearError() => state = state.copyWith(error: null);
}

final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>(
  (ref) => LoginController(),
);
