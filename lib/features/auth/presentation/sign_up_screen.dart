// lib/screens/sign_up_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg
import 'package:qurio/features/auth/presentation/check_email_screen.dart';
import 'package:qurio/shared/widgets/animated_background.dart'; // Import AnimatedBackground

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _signUp() async {
    if (!mounted || !_formKey.currentState!.validate()) return;

    if (passwordController.text != confirmPasswordController.text) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Passwords don't match"),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Send verification email
      await userCredential.user?.sendEmailVerification();

      // Update display name
      await userCredential.user?.updateDisplayName(fullNameController.text.trim());

      if (!mounted) return;
      // Navigate to CheckEmailScreen after successful signup and verification email sent
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CheckEmailScreen()),
      );

    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String errorMessage = "Sign up failed. Please try again."; // Default message
      // Check for specific error codes
      if (e.code == 'email-already-in-use') {
        errorMessage = "This email address is already registered. Please log in or use a different email.";
      } else if (e.code == 'weak-password') {
        errorMessage = "The password provided is too weak.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "The email address is not valid.";
      } else {
        errorMessage = e.message ?? errorMessage; // Use Firebase message if available
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
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
                  // Logo/Header - Use SVG Logo
                  SvgPicture.asset(
                    'assets/logo.svg',
                    height: 80, // Adjust size as needed
                    colorFilter: ColorFilter.mode(colorScheme.primary, BlendMode.srcIn),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Create Account",
                    style: textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onSurface, // Use theme color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Form Card
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: colorScheme.surface.withValues(alpha: 0.85), // Slightly transparent card
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Full Name Field
                            TextFormField(
                              controller: fullNameController,
                              decoration: InputDecoration(
                                labelText: "Full Name",
                                prefixIcon: Icon(Icons.person, color: colorScheme.primary),
                                // Using theme's input decoration
                              ),
                              textCapitalization: TextCapitalization.words,
                              validator: (value) =>
                              value != null && value.isNotEmpty ? null : "Enter your name",
                            ),
                            const SizedBox(height: 16),

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
                              value != null && value.contains("@") ? null : "Enter valid email",
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
                                  onPressed: () => setState(
                                          () => _obscurePassword = !_obscurePassword),
                                ),
                                // Using theme's input decoration
                              ),
                              obscureText: _obscurePassword,
                              validator: (value) => value != null && value.length >= 6
                                  ? null
                                  : "Minimum 6 characters",
                            ),
                            const SizedBox(height: 16),

                            // Confirm Password Field
                            TextFormField(
                              controller: confirmPasswordController,
                              decoration: InputDecoration(
                                labelText: "Confirm Password",
                                prefixIcon: Icon(Icons.lock_outline, color: colorScheme.primary),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: colorScheme.primary,
                                  ),
                                  onPressed: () => setState(() =>
                                  _obscureConfirmPassword = !_obscureConfirmPassword),
                                ),
                                // Using theme's input decoration
                              ),
                              obscureText: _obscureConfirmPassword,
                              validator: (value) => value == passwordController.text
                                  ? null
                                  : "Passwords do not match", // Improved validation message
                            ),
                            const SizedBox(height: 24),

                            // Sign Up Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                // Style comes from theme
                                onPressed: isLoading ? null : _signUp,
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
                                    : const Text(
                                  "SIGN UP",
                                  // Style comes from theme
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Login Redirect
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(
                          color: colorScheme.onSurface, // Use theme color
                        ),
                        children: [
                          TextSpan(
                            text: "Login",
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

// --- Keep commented out code for reference if needed ---
// import 'package:flutter/material.dart';
// import 'package:qurio/features/auth/domain/repository.dart'; // <-- adjust path as needed
// import 'package:firebase_auth/firebase_auth.dart';
//
//
// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});
//
//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }
//
// class _SignUpScreenState extends State<SignUpScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();
//
//   bool isLoading = false;
//
//   void signUp() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => isLoading = true);
//
//       try {
//         await AuthService().signUpWithEmail(
//           email: emailController.text.trim(),
//           password: passwordController.text.trim(),
//           name: nameController.text.trim(),
//         );
//
//         // Check if the widget is still mounted before navigating
//         if (!mounted) return;
//
//         // Navigate to check email screen
//         Navigator.pushReplacementNamed(context, '/check-email');
//       } on FirebaseAuthException catch (e) {
//         if (!mounted) return;
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(e.message ?? "Error occurred")),
//         );
//       } finally {
//         if (mounted) {
//           setState(() => isLoading = false);
//         }
//       }
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Sign Up")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: nameController,
//                 decoration: const InputDecoration(labelText: "Full Name"),
//                 validator: (value) => value!.isEmpty ? "Enter your name" : null,
//               ),
//               TextFormField(
//                 controller: emailController,
//                 decoration: const InputDecoration(labelText: "Email"),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) => value!.contains("@") ? null : "Enter a valid email",
//               ),
//               TextFormField(
//                 controller: passwordController,
//                 decoration: const InputDecoration(labelText: "Password"),
//                 obscureText: true,
//                 validator: (value) =>
//                 value != null && value.length >= 6 ? null : "Minimum 6 characters",
//               ),
//               TextFormField(
//                 controller: confirmPasswordController,
//                 decoration: const InputDecoration(labelText: "Confirm Password"),
//                 obscureText: true,
//                 validator: (value) =>
//                 value == passwordController.text ? null : "Passwords do not match",
//               ),
//               const SizedBox(height: 20),
//               isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : ElevatedButton(
//                 onPressed: signUp,
//                 child: const Text("Sign Up"),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pushReplacementNamed(context, '/login');
//                 },
//                 child: const Text("Already have an account? Log in"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
