
import 'package:eshodhan/src/utils/router/routes.dart';
import 'package:eshodhan/src/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: lightThemeData,     // 👈 from theme.dart
      darkTheme: darkThemeData,  // 👈 from theme.dart
      themeMode: ThemeMode.system, // 👈 respects device mode
      routerConfig: appRouter,
    );
  }
}
