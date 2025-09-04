import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eshodhan/src/features/signup/services/signup_service.dart';

class SignupState {
  final bool loading;
  final String? error;
  final bool signedUp;

  const SignupState({
    this.loading = false,
    this.error,
    this.signedUp = false,
  });

  SignupState copyWith({bool? loading, String? error, bool? signedUp}) {
    return SignupState(
      loading: loading ?? this.loading,
      error: error,
      signedUp: signedUp ?? this.signedUp,
    );
  }
}

class SignupController extends StateNotifier<SignupState> {
  SignupController() : super(const SignupState());

  Future<void> signup({
    required String name,
    required String email,
    required String password,
    required String confirm,
  }) async {
    // Validation
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      state = state.copyWith(error: 'All fields are required');
      return;
    }
    if (!email.contains('@')) {
      state = state.copyWith(error: 'Enter a valid email');
      return;
    }
    if (password.length < 4) {
      state = state.copyWith(error: 'Password must be at least 4 characters');
      return;
    }
    if (password != confirm) {
      state = state.copyWith(error: 'Passwords do not match');
      return;
    }

    state = state.copyWith(loading: true, error: null);

    try {
      // Call the service to register + auto-login
      await SignupService.registerAndLogin(
        name: name,
        email: email,
        password: password,
      );
      
      state = state.copyWith(loading: false, signedUp: true);
    } catch (err) {
      state = state.copyWith(
        loading: false, 
        error: err.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  void clearError() => state = state.copyWith(error: null);
}

final signupControllerProvider =
    StateNotifierProvider<SignupController, SignupState>((ref) {
  return SignupController();
});
