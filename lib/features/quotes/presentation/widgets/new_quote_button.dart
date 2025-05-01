import 'package:flutter/material.dart';

// New Quote Button Widget
class NewQuoteButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed; // Function to be called on button press
  final List<Color> gradientColors; // Gradient colors to use for the button

  const NewQuoteButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.gradientColors, // Pass gradient colors
  }) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors, // Use the passed gradient colors
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed, // Disable the button when loading
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 2,
          ),
        )
            : const Text(
          'New Quotes',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
