import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qurio/shared/widgets/animated_background.dart';
import 'package:qurio/widgets/custom_appbar.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // Use the modified CustomAppBar
      appBar: CustomAppBar(
        showLogo: false, // Don't show the default logo/title
        titleWidget: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Use the same SVG icon as the home screen app bar
            SvgPicture.asset(
              'assets/logo.svg', // Assuming this is the correct path for the quote icon
              height: 30,
              colorFilter: ColorFilter.mode(colorScheme.primary, BlendMode.srcIn),
            ),
            const SizedBox(width: 8),
            Text(
              "About Qurio",
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Add the animated background (using default speed)
          const AnimatedBackground(),

          // Content Area
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                // App Description Content
                Text(
                  "Welcome to Qurio!",
                  style: theme.textTheme.headlineMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  "Dive into a world of wisdom and inspiration. Qurio brings you a curated collection of insightful quotes from brilliant minds across history and the present day.",
                  style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  "Our Purpose:",
                  style: theme.textTheme.titleLarge?.copyWith(color: Colors.white70.withValues(alpha: 10.0), fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  "In a fast-paced world, Qurio offers moments of reflection and motivation. Whether you seek guidance, a spark of creativity, or simply a beautiful thought to brighten your day, Qurio is your companion.",
                  style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant, height: 1.4),
                ),
                const SizedBox(height: 16),
                Text(
                  "Explore, save your favorites, and share the wisdom with others. Let the power of words inspire your journey.",
                  style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant, height: 1.4),
                ),
                const SizedBox(height: 32),
                Center(
                  child: SvgPicture.asset(
                    'assets/logo.svg',
                    height: 60,
                    colorFilter: ColorFilter.mode(colorScheme.primary.withValues(alpha: 0.8), BlendMode.srcIn),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Happy exploring!",
                  style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70.withValues(alpha: 10.0)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

