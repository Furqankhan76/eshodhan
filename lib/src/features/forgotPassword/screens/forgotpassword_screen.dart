import 'package:eshodhan/src/features/forgotPassword/providers/forgotpassword_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends ConsumerState<ForgotPasswordScreen> {
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _clearAndPop() {
    _email.clear();
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }

  Future<void> _sendLink() async {
    final email = _email.text.trim();
    await ref
        .read(forgotPasswordControllerProvider.notifier)
        .sendResetLink(email);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final kbOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    final state = ref.watch(forgotPasswordControllerProvider);

    // Show toast & go back if success
    ref.listen<ForgotPasswordState>(forgotPasswordControllerProvider,
        (previous, next) {
      if (next.success && previous?.success == false) {
        Fluttertoast.showToast(msg: "Password reset email sent");
        _clearAndPop();
      }
      if (next.error != null && previous?.error != next.error) {
        Fluttertoast.showToast(msg: next.error!);
      }
    });

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!kbOpen) ...[
                            Center(
                              child: SizedBox(
                                height: 160,
                                child: Image.asset(
                                  "assets/images/app_icon.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          Text('Forgot Password',
                              style: theme.textTheme.headlineMedium),
                          const SizedBox(height: 10),
                          Text(
                            "We’ll send a reset link to your email. Enter your account email below.",
                            style: theme.textTheme.labelMedium,
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'name@example.com',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: state.loading ? null : _sendLink,
                              child: state.loading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'Send reset password link',
                                      style: theme.textTheme.labelLarge
                                          ?.copyWith(color: Colors.white),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Have an account?',
                        style: theme.textTheme.labelMedium),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: _clearAndPop,
                      child: Text(
                        'Log In',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.textTheme.bodyMedium?.color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
