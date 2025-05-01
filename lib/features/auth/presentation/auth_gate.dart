// lib/screens/auth_gate.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qurio/features/auth/presentation/check_email_screen.dart'; // Import CheckEmailScreen
import '../../quotes/presentation/screens/home_screen.dart';
import 'sign_up_screen.dart'; // Assuming LoginScreen might be needed later or SignUp is the entry

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          final user = snapshot.data!;
          // Check if email is verified
          if (user.emailVerified) {
            return const HomeScreen(); // ✅ User is logged in and verified
          } else {
            // User exists but email is not verified, show verification screen
            return const CheckEmailScreen(); 
          }
        } else {
          // User is not logged in, show signup/login screen
          // Consider adding logic to show LoginScreen if preferred over SignUpScreen initially
          return const SignUpScreen(); // ⛔ User not logged in
        }
      },
    );
  }
}
