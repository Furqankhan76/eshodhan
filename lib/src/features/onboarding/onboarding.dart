import 'package:eshodhan/src/features/login/screens/login_screen.dart';
import 'package:eshodhan/src/features/signup/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class OnBoardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color kDarkBlueColor = theme.colorScheme.onSecondary;  // Use the theme's primary color for consistency

    return OnBoardingSlider(
      finishButtonText: 'Register',
      onFinish: () async {
        // Save that onboarding is complete
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('onboarding_complete', true);

        // Navigate to the signup screen and remove all previous screens from the stack
        context.goNamed('signup');  // Navigate using GoRouter's named route for signup
      },

      finishButtonStyle: FinishButtonStyle(
        backgroundColor: kDarkBlueColor,
      ),
      skipTextButton: Text(
        'Skip',
        style: TextStyle(
          fontSize: 16,
          color: kDarkBlueColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Text(
        '',
        style: TextStyle(
          fontSize: 16,
          color: kDarkBlueColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailingFunction: () {
        // Navigate to the login screen and remove all previous screens from the stack
        context.goNamed('signup');  // Navigate using GoRouter's named route for login
      },
      controllerColor: kDarkBlueColor,
      totalPage: 3,
      headerBackgroundColor: theme.scaffoldBackgroundColor, // Use the theme background color
      pageBackgroundColor: theme.scaffoldBackgroundColor, // Use the theme background color
      background: [
        Image.asset('assets/images/vector-1.png', height: 400),
        Image.asset('assets/images/vector-2.png', height: 400),
        Image.asset('assets/images/vector-3.png', height: 400),
      ],
      speed: 1.8,
      pageBodies: [
        _buildPage('On your way...', 'to find the perfect looking Onboarding for your app?', theme),
        _buildPage('You’ve reached your destination.', 'Sliding with animation', theme),
        _buildPage('Start now!', 'Where everything is possible and customize your onboarding.', theme),
      ],
    );
  }

  Widget _buildPage(String title, String subtitle, ThemeData theme) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 480),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.textTheme.headlineMedium?.color,
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
