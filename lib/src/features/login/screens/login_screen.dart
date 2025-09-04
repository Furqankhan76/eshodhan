import 'package:eshodhan/src/features/forgotPassword/screens/forgotpassword_screen.dart';
import 'package:eshodhan/src/features/home/screens/home_screen.dart';
import 'package:eshodhan/src/features/login/providers/login_provider.dart';
import 'package:eshodhan/src/features/signup/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _identifier = TextEditingController();
  final _pass = TextEditingController();
  bool _obscurePass = true; // 👈 track password visibility

  @override
  void dispose() {
    _identifier.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _clearFields() {
    _identifier.clear();
    _pass.clear();
    FocusScope.of(context).unfocus(); // Close keyboard
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginControllerProvider);
    final theme = Theme.of(context);
    final kbOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    ref.listen(loginControllerProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        Fluttertoast.showToast(msg: next.error!);
        ref.read(loginControllerProvider.notifier).clearError();
      }
      if (next.loggedIn && next.loggedIn != (prev?.loggedIn ?? false)) {
        Fluttertoast.showToast(msg: "Welcome back!");
       GoRouter.of(context).go('/home');
      }
    });

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard
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

                          // Title
                          Text('Log In', style: theme.textTheme.headlineMedium),
                          const SizedBox(height: 20),

                          // Email
                          TextField(
                            controller: _identifier,
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.text,
                            style: theme.textTheme.bodyMedium,
                            decoration: InputDecoration(
                              labelText: 'Email or username',
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
                            obscureText: _obscurePass,
                            textAlign: TextAlign.left,
                            style: theme.textTheme.bodyMedium,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: theme.textTheme.labelLarge,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePass
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePass = !_obscurePass;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Sign In button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: state.loading
                                  ? null
                                  : () {
                                      final identifier = _identifier.text.trim();
                                      final pass = _pass.text.trim();
                                      if (identifier.isEmpty || pass.isEmpty) {
                                        Fluttertoast.showToast(
                                          msg: "Email & password are required",
                                        );
                                        return;
                                      }
                                      ref
                                          .read(
                                            loginControllerProvider.notifier,
                                          )
                                          .login(identifier, pass);
                                    },
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
                                      'Sign In',
                                      style: theme.textTheme.labelLarge
                                          ?.copyWith(color: Colors.white),
                                    ),
                            ),
                          ),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                _clearFields(); // Clear fields & unfocus before navigating
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.textTheme.bodyMedium?.color
                                      ?.withOpacity(0.6),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don’t have an account?',
                      style: theme.textTheme.labelMedium,
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () async {
                        _clearFields(); // Clear fields & unfocus before navigating
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Sign Up',
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
