import 'package:eshodhan/src/features/home/screens/home_screen.dart';
import 'package:eshodhan/src/features/login/screens/login_screen.dart';
import 'package:eshodhan/src/features/onboarding/onboarding.dart';
import 'package:eshodhan/src/features/signup/screens/signup_screen.dart';
import 'package:eshodhan/src/utils/helpers/auth_helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

// Custom transition for routing
CustomTransitionPage buildPageWithFade({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 150),
    transitionsBuilder: (context, animation, _, child) => FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
      child: child,
    ),
  );
}

/// App router with GoRouter and onboarding check
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  redirect: (context, state) async {
    print('🚀 Router redirect triggered');
    print('📋 Current state name: ${state.name}');
    print('📍 Current path: ${state.uri.path}');
    
    // Check if user has a token (is logged in)
    final isLoggedIn = await AuthHelper.isUserLoggedIn();
    print('🔐 User logged in: $isLoggedIn');
    
    if (isLoggedIn && state.name != 'home') {
      print('✅ User is logged in, redirecting to /home');
      return '/home';
    }
    
    // If not logged in, check if onboarding is completed
    final prefs = await SharedPreferences.getInstance();
    final isOnboardingCompleted = prefs.getBool('onboarding_complete') ?? false;
    print('📖 Onboarding completed: $isOnboardingCompleted');
    
    if (!isLoggedIn) {
      if (isOnboardingCompleted && state.name != 'signup') {
        print('➡️ Onboarding completed, redirecting to /signup');
        return '/signup'; // CHANGED FROM '/login' TO '/signup'
      } else if (!isOnboardingCompleted && state.name != 'onboarding') {
        print('➡️ Onboarding not completed, redirecting to /onboarding');
        return '/onboarding';
      }
    }
    
    print('⏭️ No redirect needed, staying on current route');
    return null;
  },
  routes: [
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      pageBuilder: (context, state) {
        print('🎬 Building Onboarding screen');
        return buildPageWithFade(state: state, child: OnBoardingScreen());
      },
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      pageBuilder: (context, state) {
        print('🎬 Building Login screen');
        return buildPageWithFade(state: state, child: const LoginScreen());
      },
    ),
    GoRoute(
      path: '/signup',
      name: 'signup',
      pageBuilder: (context, state) {
        print('🎬 Building Signup screen');
        return buildPageWithFade(state: state, child: const SignupScreen());
      },
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      pageBuilder: (context, state) {
        print('🎬 Building Home screen');
        return buildPageWithFade(state: state, child: const HomeScreen());
      },
    ),
  ],
);

// Function to check if onboarding is completed
Future<bool> _isOnboardingCompleted() async {
  final prefs = await SharedPreferences.getInstance();
  final isCompleted = prefs.getBool('onboarding_complete') ?? false;
  print('📋 Onboarding check: $isCompleted');
  return isCompleted;
}

// Helper function to debug auth status
void debugAuthStatus() async {
  print('🛠️ Debugging auth status...');
  final isLoggedIn = await AuthHelper.isUserLoggedIn();
  print('🔐 User logged in: $isLoggedIn');
  
  if (isLoggedIn) {
    final authDetails = await AuthHelper.getAuthDetails();
    print('👤 User display name: ${authDetails?.userDisplayName}');
    print('📧 User email: ${authDetails?.userEmail}');
    print('🔑 Token exists: ${authDetails?.token != null}');
  }
  
  final prefs = await SharedPreferences.getInstance();
  final onboardingStatus = prefs.getBool('onboarding_complete') ?? false;
  print('📖 Onboarding completed: $onboardingStatus');
}