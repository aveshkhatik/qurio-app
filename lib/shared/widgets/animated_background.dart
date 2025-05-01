import 'package:flutter/material.dart';
import 'package:qurio/shared/theme/theme.dart'; // Import theme helper

/// A widget that displays a fluidly animated gradient background using theme colors.
/// Accepts an optional [duration] to control the animation speed.
class AnimatedBackground extends StatefulWidget {
  final Duration duration;

  const AnimatedBackground({
    super.key,
    this.duration = const Duration(seconds: 20), // Default duration
  });

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedBackgroundState createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _topLeftAlignmentAnimation;
  late Animation<Alignment> _bottomRightAlignmentAnimation;

  // Gradient colors will now be fetched dynamically in the build method
  // final List<Color> _gradientColors = [...]; // Removed hardcoded colors

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    // Alignment animations remain the same
    _topLeftAlignmentAnimation = TweenSequence<Alignment>(
      [
        TweenSequenceItem(
          tween: AlignmentTween(begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1.0,
        ),
        TweenSequenceItem(
          tween: AlignmentTween(begin: Alignment.topRight, end: Alignment.centerRight),
          weight: 1.0,
        ),
        TweenSequenceItem(
          tween: AlignmentTween(begin: Alignment.centerRight, end: Alignment.bottomRight),
          weight: 1.0,
        ),
        TweenSequenceItem(
          tween: AlignmentTween(begin: Alignment.bottomRight, end: Alignment.bottomCenter),
          weight: 1.0,
        ),
        TweenSequenceItem(
          tween: AlignmentTween(begin: Alignment.bottomCenter, end: Alignment.bottomLeft),
          weight: 1.0,
        ),
        TweenSequenceItem(
          tween: AlignmentTween(begin: Alignment.bottomLeft, end: Alignment.centerLeft),
          weight: 1.0,
        ),
        TweenSequenceItem(
          tween: AlignmentTween(begin: Alignment.centerLeft, end: Alignment.topLeft),
          weight: 1.0,
        ),
      ],
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));

    _bottomRightAlignmentAnimation = TweenSequence<Alignment>(
      [
        TweenSequenceItem(
          tween: AlignmentTween(begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 1.0,
        ),
        TweenSequenceItem(
          tween: AlignmentTween(begin: Alignment.bottomLeft, end: Alignment.centerLeft),
          weight: 1.0,
        ),
        TweenSequenceItem(
          tween: AlignmentTween(begin: Alignment.centerLeft, end: Alignment.topLeft),
          weight: 1.0,
        ),
        TweenSequenceItem(
          tween: AlignmentTween(begin: Alignment.topLeft, end: Alignment.topCenter),
          weight: 1.0,
        ),
        TweenSequenceItem(
          tween: AlignmentTween(begin: Alignment.topCenter, end: Alignment.topRight),
          weight: 1.0,
        ),
        TweenSequenceItem(
          tween: AlignmentTween(begin: Alignment.topRight, end: Alignment.centerRight),
          weight: 1.0,
        ),
        TweenSequenceItem(
          tween: AlignmentTween(begin: Alignment.centerRight, end: Alignment.bottomRight),
          weight: 1.0,
        ),
      ],
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get gradient colors based on the current theme brightness
    final List<Color> currentGradientColors = getGradientColors(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: _topLeftAlignmentAnimation.value,
              end: _bottomRightAlignmentAnimation.value,
              colors: currentGradientColors, // Use theme-aware colors
            ),
          ),
        );
      },
    );
  }
}

