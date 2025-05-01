// lib/screens/check_email_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg
import 'package:qurio/shared/widgets/animated_background.dart'; // Import AnimatedBackground

class CheckEmailScreen extends StatefulWidget {
  final String? email; // Optional: Provided email (e.g., for password reset)
  final String? message; // Optional: Custom message (e.g., for password reset confirmation)

  const CheckEmailScreen({
    super.key,
    this.email,
    this.message,
  });

  @override
  State<CheckEmailScreen> createState() => _CheckEmailScreenState();
}

class _CheckEmailScreenState extends State<CheckEmailScreen> {
  Timer? _verificationTimer;
  Timer? _cooldownTimer;
  bool _isEmailVerified = false;
  bool _isLoading = false;
  int _cooldownSeconds = 60;
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _verificationTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _checkEmailVerification();
    });
    Future.delayed(const Duration(seconds: 1), _checkEmailVerification);
    _sendVerificationEmail(); // Send initial email
  }

  Future<void> _checkEmailVerification() async {
    if (!mounted || _isEmailVerified) return;

    try {
      await _user?.reload();
      final updatedUser = FirebaseAuth.instance.currentUser;

      if (updatedUser?.emailVerified ?? false) {
        setState(() => _isEmailVerified = true);
        _verificationTimer?.cancel();

        await Future.delayed(const Duration(seconds: 2));
        await _user?.reload();

        if ((FirebaseAuth.instance.currentUser?.emailVerified ?? false) && mounted) {
          // Navigate to home or appropriate screen after verification
          Navigator.of(context).pushReplacementNamed('/auth-gate'); // Go via AuthGate
        }
      }
    } catch (e) {
      debugPrint('Verification error: $e');
      // Optionally show a snackbar for persistent errors
    }
  }

  Future<void> _sendVerificationEmail() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _cooldownSeconds = 60;
    });

    try {
      await _user?.sendEmailVerification();
      _startCooldownTimer();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Verification email sent!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send verification email: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _startCooldownTimer() {
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_cooldownSeconds > 0) {
        if (mounted) setState(() => _cooldownSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _verificationTimer?.cancel();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
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
                  if (_isEmailVerified) ...[
                    CircularProgressIndicator(color: colorScheme.primary),
                    const SizedBox(height: 20),
                    Text(
                      'Verification successful! Redirecting...', // Updated text
                      style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
                    ),
                    const SizedBox(height: 40),
                  ] else ...[
                    // Use SVG Logo
                    SvgPicture.asset(
                      'assets/logo.svg',
                      height: 80,
                      colorFilter: ColorFilter.mode(colorScheme.primary, BlendMode.srcIn),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Verify Your Email',
                      style: textTheme.headlineMedium?.copyWith(
                        color: colorScheme.onSurface, // Use theme color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      // Use custom message if provided (for password reset), otherwise default verification message
                      widget.message ?? 'A verification link has been sent to ${widget.email ?? _user?.email ?? 'your email'}. Please check your inbox (and spam folder).',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant), // Use theme color
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        // Style comes from theme
                        onPressed: (_cooldownSeconds > 0 || _isLoading)
                            ? null
                            : _sendVerificationEmail,
                        child: _isLoading
                            ? const SizedBox(
                                height: 24, // Consistent size
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white, // Or use onPrimary
                                ),
                              )
                            : Text(
                          _cooldownSeconds > 0
                              ? 'Resend in $_cooldownSeconds s'
                              : 'RESEND EMAIL',
                          // Style comes from theme
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      child: Text(
                        'Back to Login',
                        style: TextStyle(color: colorScheme.primary), // Use theme color
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
