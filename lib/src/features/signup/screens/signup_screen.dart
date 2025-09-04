import 'package:eshodhan/src/features/login/screens/login_screen.dart';
import 'package:eshodhan/src/features/signup/providers/signup_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _toast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 14,
    );
  }

  void _clearFieldsAndUnfocus() {
    _name.clear();
    _email.clear();
    _pass.clear();
    _confirm.clear();
    FocusScope.of(context).unfocus();
  }

  Future<bool> _handlePop() async {
    _clearFieldsAndUnfocus();
    return true; // allow pop
  }

  @override
  Widget build(BuildContext context) {
    final signup = ref.watch(signupControllerProvider);
    final theme = Theme.of(context);
    final kbOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    // listen for error/success
    ref.listen(signupControllerProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        _toast(next.error!);
        ref.read(signupControllerProvider.notifier).clearError();
      }
      if (next.signedUp && next.signedUp != (prev?.signedUp ?? false)) {
        _toast("Account created successfully!");
        _clearFieldsAndUnfocus();
        Navigator.of(context).pop(); // back to login
      }
    });

    return WillPopScope(
      onWillPop: _handlePop,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  // Centered content (match LoginScreen)
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

                            // Title
                            Text(
                              'Sign Up',
                              style: theme.textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 20),

                            // Full name
                            TextField(
                              controller: _name,
                              textAlign: TextAlign.left,
                              style: theme.textTheme.bodyMedium,
                              decoration: InputDecoration(
                                labelText: 'Full name',
                                labelStyle: theme.textTheme.labelLarge,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Email
                            TextField(
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              textAlign: TextAlign.left,
                              style: theme.textTheme.bodyMedium,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: theme.textTheme.labelLarge,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Password
                            TextField(
                              controller: _pass,
                              obscureText: true,
                              textAlign: TextAlign.left,
                              style: theme.textTheme.bodyMedium,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: theme.textTheme.labelLarge,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Confirm password
                            TextField(
                              controller: _confirm,
                              obscureText: true,
                              textAlign: TextAlign.left,
                              style: theme.textTheme.bodyMedium,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                labelStyle: theme.textTheme.labelLarge,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Create account button
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: signup.loading
                                    ? null
                                    : () {
                                        final name = _name.text.trim();
                                        final email = _email.text.trim();
                                        final pass = _pass.text;
                                        final confirm = _confirm.text;

                                        if (name.isEmpty ||
                                            email.isEmpty ||
                                            pass.isEmpty ||
                                            confirm.isEmpty) {
                                          _toast("Please fill all fields");
                                          return;
                                        }
                                        if (pass != confirm) {
                                          _toast("Passwords do not match");
                                          return;
                                        }

                                        ref
                                            .read(signupControllerProvider.notifier)
                                            .signup(
                                              email: email,
                                              password: pass,
                                              confirm: confirm,
                                            );
                                      },
                                child: signup.loading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        'Create account',
                                        style: theme.textTheme.labelLarge?.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Footer pinned at bottom (centered)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Have an account?',
                        style: theme.textTheme.labelMedium,
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          _clearFieldsAndUnfocus();
                         Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                        },
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
      ),
    );
  }
}
