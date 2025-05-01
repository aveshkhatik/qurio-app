import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qurio/features/auth/presentation/change_password_screen.dart';
import 'package:qurio/features/auth/presentation/check_email_screen.dart';
import 'package:qurio/features/quotes/presentation/screens/home_screen.dart';
import 'package:qurio/features/auth/presentation/login_screen.dart';
import 'package:qurio/features/auth/presentation/sign_up_screen.dart';
import 'package:qurio/features/auth/presentation/splash_screen.dart';
import 'package:qurio/features/auth/presentation/auth_gate.dart';
import 'package:qurio/features/user_profile/app_setting_screen.dart';
import 'package:qurio/features/user_profile/privacy_security_screen.dart';
import 'package:qurio/shared/services/settings_service.dart'; // Import SettingsService
import 'package:qurio/shared/theme/theme.dart'; // Import theme functions

class QuoteApp extends StatelessWidget {
  const QuoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Consume the SettingsService to rebuild MaterialApp when settings change
    return Consumer<SettingsService>(
      builder: (context, settingsService, child) {
        return MaterialApp(
          title: "Qurio", // Updated title
          debugShowCheckedModeBanner: false,
          // Use the dynamic theme builders which depend on context (for Provider)
          theme: buildLightTheme(context),
          darkTheme: buildDarkTheme(context),
          themeMode: settingsService.themeMode, // Set theme mode based on service
          home: const SplashScreen(),
          routes: {
            '/signup': (context) => const SignUpScreen(),
            '/home': (context) => const HomeScreen(),
            '/check-email': (context) => const CheckEmailScreen(),
            '/auth-gate': (context) => const AuthGate(),
            '/login': (context) => const LoginScreen(),
            '/appSettings': (context) => const AppSettingsScreen(),
            '/privacySecurity': (context) => const PrivacySecurityScreen(),
            '/changepasswordscreen': (context) => const ChangePasswordScreen(),
          },
        );
      },
    );
  }
}

