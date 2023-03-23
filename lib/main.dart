import 'package:flutter/material.dart';

import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/onboarding.dart';
import 'screens/user/dashboard_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Checkout',
      theme: ThemeData(
        primaryColor: AppTheme.primCol,
        primaryColorDark: AppTheme.secCol,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: AppTheme.secCol,
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFF788190),
          ),
          bodyMedium: TextStyle(
            fontSize: AppTheme.fontSize,
            color: Color(0xB0011B33),
          ),
        ),
        primarySwatch: Colors.blue,
        fontFamily: 'MTN Brighter Sans',
        scaffoldBackgroundColor: Colors.white,
      ),
      // home: const MyHomePage(title: 'echeckout'),
      routes: {
        '/': (ctx) => const OnboardingScreen(),
        LoginScreen.routeName: (ctx) => const LoginScreen(),
        ForgotPasswordScreen.routeName: (ctx) => const ForgotPasswordScreen(),
        DashboardScreen.routeName: (ctx) => const DashboardScreen(),
        // CreatePinScreen.routeName: (ctx) => const CreatePinScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
