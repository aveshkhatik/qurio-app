// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg
import 'package:qurio/shared/widgets/animated_background.dart'; // Import AnimatedBackground
import 'package:qurio/features/auth/presentation/check_email_screen.dart'; // Import CheckEmailScreen for password reset

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool _obscurePassword = true;

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        if (!mounted) return;
        // Navigate to AuthGate which handles redirection based on auth state
        Navigator.of(context, rootNavigator: true).pushReplacementNamed('/auth-gate');
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        String errorMessage = "An error occurred. Please try again.";
        // Provide more specific error messages
        if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
          errorMessage = "Incorrect email or password. Please try again.";
        } else if (e.code == 'invalid-email') {
          errorMessage = "The email address is not valid.";
        } else if (e.code == 'user-disabled') {
          errorMessage = "This user account has been disabled.";
        } else {
          errorMessage = e.message ?? errorMessage; // Use Firebase message if available
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } finally {
        if (mounted) {
          setState(() => isLoading = false);
        }
      }
    }
  }

  // Forgot Password Handler
  Future<void> _handleForgotPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please enter a valid email address first."),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      // Navigate to CheckEmailScreen with a specific message for password reset
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckEmailScreen(
            email: email,
            message: "A password reset link has been sent to your email. Please check your inbox (and spam folder).",
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String errorMessage = "Failed to send password reset email.";
      if (e.code == 'user-not-found') {
        errorMessage = "No user found with this email address.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "The email address is not valid.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      // Use Stack to layer background and content
      body: Stack(
        children: [
          // Animated background layer
          const AnimatedBackground(),

          // Content layer
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo/Header Section - Use SVG Logo
                  SvgPicture.asset(
                    'assets/logo.svg',
                    height: 80, // Adjust size as needed
                    colorFilter: ColorFilter.mode(colorScheme.primary, BlendMode.srcIn),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Welcome Back",
                    style: textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onSurface, // Use theme color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Form Section
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: colorScheme.surface.withValues(alpha: 0.85), // Slightly transparent card
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Email Field
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: "Email",
                                prefixIcon: Icon(Icons.email, color: colorScheme.primary),
                                // Using theme's input decoration
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) =>
                              value != null && value.contains("@") ? null : "Enter a valid email",
                            ),
                            const SizedBox(height: 16),

                            // Password Field
                            TextFormField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: "Password",
                                prefixIcon: Icon(Icons.lock, color: colorScheme.primary),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: colorScheme.primary,
                                  ),
                                  onPressed: () => setState(() =>
                                  _obscurePassword = !_obscurePassword),
                                ),
                                // Using theme's input decoration
                              ),
                              obscureText: _obscurePassword,
                              validator: (value) =>
                              value != null && value.length >= 6
                                  ? null
                                  : "Minimum 6 characters",
                            ),
                            const SizedBox(),
                            // Forgot Password Button
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: isLoading ? null : _handleForgotPassword,
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(color: colorScheme.primary),
                                ),
                              ),
                            ),
                            const SizedBox(),
                            // Login Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                // Style comes from theme
                                onPressed: isLoading ? null : login,
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
                                    : const Text(
                                  "LOGIN",
                                  // Style comes from theme
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Footer Section
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/signup'),
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                            color: colorScheme.onSurface), // Use theme color
                        children: [
                          TextSpan(
                            text: "Sign Up",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              color: colorScheme.primary, // Use theme color
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

