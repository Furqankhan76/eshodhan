import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _email = TextEditingController();
  bool _loading = false;

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
    if (email.isEmpty) {
      Fluttertoast.showToast(msg: "Email is required");
      return;
    }
    if (!email.contains('@') || !email.contains('.')) {
      Fluttertoast.showToast(msg: "Please enter a valid email");
      return;
    }

    setState(() => _loading = true);

    // TODO: replace with your API call (Dio, etc.)
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    setState(() => _loading = false);

    Fluttertoast.showToast(msg: "Reset link sent to $email");
    _clearAndPop(); // pop after sending
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final kbOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // tap outside closes keyboard
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                // Centered content
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
                          Text('Forgot Password', style: theme.textTheme.headlineMedium),
                          const SizedBox(height: 10),

                          // Helper text
                          Text(
                            "We’ll send a reset link to your email. Enter your account email below.",
                            style: theme.textTheme.labelMedium,
                          ),
                          const SizedBox(height: 20),

                          // Email
                          TextField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.left,
                            style: theme.textTheme.bodyMedium,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: theme.textTheme.labelLarge,
                              hintText: 'name@example.com',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Send button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _sendLink,
                              child: _loading
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
                                      style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
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
                      onTap: _clearAndPop, // back to login + clear and unfocus
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
