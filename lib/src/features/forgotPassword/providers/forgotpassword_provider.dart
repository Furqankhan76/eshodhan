import 'package:eshodhan/src/features/forgotPassword/services/forgotpassword_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordState {
  final bool loading;
  final String? error;
  final bool success;

  const ForgotPasswordState({
    this.loading = false,
    this.error,
    this.success = false,
  });

  ForgotPasswordState copyWith({
    bool? loading,
    String? error,
    bool? success,
  }) {
    return ForgotPasswordState(
      loading: loading ?? this.loading,
      error: error,
      success: success ?? this.success,
    );
  }
}

class ForgotPasswordController extends StateNotifier<ForgotPasswordState> {
  ForgotPasswordController() : super(const ForgotPasswordState());

  Future<void> sendResetLink(String email) async {
    if (email.isEmpty) {
      state = state.copyWith(error: "Email is required");
      return;
    }
    if (!email.contains('@') || !email.contains('.')) {
      state = state.copyWith(error: "Please enter a valid email");
      return;
    }

    state = state.copyWith(loading: true, error: null, success: false);

    try {
      final msg = await ForgotPasswordService.sendResetLink(email);
      state = state.copyWith(loading: false, success: true);
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: e.toString(),
        success: false,
      );
    }
  }

  void clearError() => state = state.copyWith(error: null);
}

final forgotPasswordControllerProvider =
    StateNotifierProvider<ForgotPasswordController, ForgotPasswordState>(
  (ref) => ForgotPasswordController(),
);
