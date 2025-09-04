// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

// defining colors
const COLOR_PRIMARY = Color(0XFFFEF11D);
const COLOR_ACCENT = Color(0XFFDCECFF);
const COLOR_SECONDARY = Color(0XFFFE2D17);

// Elevated Button theme
ElevatedButtonThemeData getElevatedButtonThemeData({required bool isDark}) {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsetsDirectional.symmetric(vertical: 15, horizontal: 40),
      elevation: 0.2,
      backgroundColor: COLOR_SECONDARY,
      foregroundColor: Colors.black,
    ),
  );
}

// Text Theme
TextTheme getTextTheme({required bool isDark}) {
  final base = isDark ? Colors.white : Colors.black;
  return TextTheme(
    headlineMedium: TextStyle(fontWeight: FontWeight.bold, color: base),
    bodyMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: base),
    bodyLarge: const TextStyle(fontWeight: FontWeight.bold),
    labelLarge: TextStyle(color: base, fontSize: 16),
    labelMedium: TextStyle(color: base.withOpacity(0.7), fontSize: 16),
    labelSmall: TextStyle(color: base, fontSize: 13),
  );
}

// Text selection theme (cursor + selection highlight)
TextSelectionThemeData getSelectionTheme({required bool isDark}) {
  final base = isDark ? Colors.white : Colors.black;
  return TextSelectionThemeData(
    cursorColor: base,
    selectionColor: base.withOpacity(0.25),
    selectionHandleColor: base,
  );
}

// Input field theme (TextFields)
InputDecorationTheme getInputTheme({required bool isDark}) {
  final base = isDark ? Colors.white : Colors.black;
  return InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: base.withOpacity(0.5)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: base.withOpacity(0.5)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: base, width: 1.5),
    ),
    labelStyle: TextStyle(color: base.withOpacity(0.8), fontWeight: FontWeight.w600),
    floatingLabelStyle: TextStyle(color: base, fontWeight: FontWeight.w600),
    hintStyle: TextStyle(color: base.withOpacity(0.5)),
  );
}

// Pinput themes (for OTP / PIN input fields)
PinTheme getDefaultPinTheme(BuildContext context) {
  return PinTheme(
    width: 50,
    height: 50,
    textStyle: getTextTheme(isDark: Theme.of(context).brightness == Brightness.dark).bodyMedium!,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: COLOR_PRIMARY, width: 1),
    ),
    padding: const EdgeInsets.all(8),
  );
}

PinTheme getSubmittedPinTheme(BuildContext context) {
  return getDefaultPinTheme(context).copyDecorationWith(
    border: Border.all(width: 1),
    color: COLOR_PRIMARY.withOpacity(0.2),
  );
}

// AppBar Theme
const AppBarTheme appBarTheme = AppBarTheme(
  backgroundColor: Colors.white,
  surfaceTintColor: Colors.white,
);

// TextButton Theme
TextButtonThemeData textButtonThemeData = TextButtonThemeData(
  style: TextButton.styleFrom(foregroundColor: Colors.black),
);

// Popup Menu Theme
const PopupMenuThemeData popupMenuTheme = PopupMenuThemeData(
  surfaceTintColor: Colors.white,
);

// Floating Button Theme
const FloatingActionButtonThemeData floatingButtonTheme =
    FloatingActionButtonThemeData(
  backgroundColor: COLOR_PRIMARY,
  foregroundColor: Colors.white,
);

// Light Theme
var lightThemeData = ThemeData(
  colorScheme: const ColorScheme.light(
    error: Colors.red,
    onSecondary: COLOR_SECONDARY,
    primary: COLOR_PRIMARY,
  ),
  primaryColor: COLOR_PRIMARY,
  brightness: Brightness.light,
  scaffoldBackgroundColor: COLOR_ACCENT,
  useMaterial3: true,
  textTheme: getTextTheme(isDark: false),
  elevatedButtonTheme: getElevatedButtonThemeData(isDark: false),
  inputDecorationTheme: getInputTheme(isDark: false),
  textSelectionTheme: getSelectionTheme(isDark: false),
  textButtonTheme: textButtonThemeData,
  appBarTheme: appBarTheme,
  popupMenuTheme: popupMenuTheme,
  floatingActionButtonTheme: floatingButtonTheme,
);

// Dark Theme
var darkThemeData = ThemeData(
  colorScheme: const ColorScheme.dark(
    error: Colors.red,
    onSecondary: COLOR_SECONDARY,
    primary: Colors.white,
  ),
  primaryColor: COLOR_PRIMARY,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  useMaterial3: true,
  textTheme: getTextTheme(isDark: true),
  elevatedButtonTheme: getElevatedButtonThemeData(isDark: true),
  inputDecorationTheme: getInputTheme(isDark: true),
  textSelectionTheme: getSelectionTheme(isDark: true),
  textButtonTheme: textButtonThemeData,
  appBarTheme: appBarTheme,
  popupMenuTheme: popupMenuTheme,
  floatingActionButtonTheme: floatingButtonTheme,
);
