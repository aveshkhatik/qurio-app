import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:qurio/shared/services/settings_service.dart'; // Import SettingsService

// --- Light Theme Colors ---
const Color primaryColorLight = Color(0xFF13837D); // Dark Aqua
const Color secondaryColorLight = Color(0xFF5CD7D0); // Light Aqua
const Color backgroundColorLight = Color(0xFFF5F5F5); // Light Grey
const Color cardBackgroundColorLight = Colors.white;
const Color textColorLight = Color(0xFF333333); // Dark Grey for text
const Color secondaryTextColorLight = Color(0xFF757575); // Medium Grey for subtitles/authors
const Color accentColorLight = Color(0xFFFFB74D); // Amber accent for buttons/highlights

// --- Dark Theme Colors ---
const Color primaryColorDark = Color(0xFF26A69A); // Teal 400 - Brighter for dark mode primary
const Color secondaryColorDark = Color(0xFF4DB6AC); // Teal 300 - Lighter teal
const Color backgroundColorDark = Color(0xFF121212); // Standard dark background
const Color cardBackgroundColorDark = Color(0xFF1E1E1E); // Slightly lighter dark for cards/surfaces
const Color textColorDark = Color(0xFFE0E0E0); // Light grey for text
const Color secondaryTextColorDark = Color(0xFFBDBDBD); // Medium grey for subtitles/authors
const Color accentColorDark = Color(0xFFFFB74D); // Keep Amber accent
const Color errorColorDark = Color(0xFFCF6679); // Standard dark error color

// --- Base Text Style for the main theme (Uses default font 'Lato') ---
TextStyle _baseThemeTextStyle(Color color) => GoogleFonts.lato(
      color: color,
    );

// --- Default TextTheme Function (Does NOT use SettingsService for font/size) ---
// Creates a TextTheme using the default font style ('Lato') and fixed base size (e.g., 14)
TextTheme _defaultAppTextTheme(Color textColor, Color secondaryTextColor) {
  final baseStyle = _baseThemeTextStyle(textColor);
  const double baseSize = 14.0; // Use a fixed base size for the default theme

  // Define text styles relative to the fixed base size
  return TextTheme(
    displayLarge: baseStyle.copyWith(fontSize: baseSize * 2.5, fontWeight: FontWeight.bold),
    displayMedium: baseStyle.copyWith(fontSize: baseSize * 2.0, fontWeight: FontWeight.bold),
    displaySmall: baseStyle.copyWith(fontSize: baseSize * 1.8, fontWeight: FontWeight.bold),
    headlineLarge: baseStyle.copyWith(fontSize: baseSize * 1.6, fontWeight: FontWeight.bold),
    headlineMedium: baseStyle.copyWith(fontSize: baseSize * 1.4, fontWeight: FontWeight.bold),
    headlineSmall: baseStyle.copyWith(fontSize: baseSize * 1.2, fontWeight: FontWeight.bold),
    titleLarge: baseStyle.copyWith(fontSize: baseSize * 1.1, fontWeight: FontWeight.w500),
    titleMedium: baseStyle.copyWith(fontSize: baseSize * 1.0, fontWeight: FontWeight.w500, letterSpacing: 0.15),
    titleSmall: baseStyle.copyWith(fontSize: baseSize * 0.9, fontWeight: FontWeight.w500, letterSpacing: 0.1),
    bodyLarge: baseStyle.copyWith(fontSize: baseSize * 1.0, fontWeight: FontWeight.normal, height: 1.5),
    bodyMedium: baseStyle.copyWith(fontSize: baseSize * 0.9, fontWeight: FontWeight.normal, letterSpacing: 0.25, height: 1.4),
    bodySmall: baseStyle.copyWith(fontSize: baseSize * 0.8, fontWeight: FontWeight.normal, letterSpacing: 0.4),
    labelLarge: baseStyle.copyWith(fontSize: baseSize * 0.9, fontWeight: FontWeight.w500, letterSpacing: 1.25),
    labelMedium: baseStyle.copyWith(fontSize: baseSize * 0.8, fontWeight: FontWeight.w500, letterSpacing: 1.5),
    labelSmall: baseStyle.copyWith(fontSize: baseSize * 0.75, fontWeight: FontWeight.w500, letterSpacing: 1.5),
  ).apply(bodyColor: textColor, displayColor: textColor);
}

// --- Quote Specific Text Styles --- (Dynamic based on context/theme/settings)
// These functions WILL use SettingsService for font size and style
TextStyle quoteTextStyle(BuildContext context) {
  // Use listen: true here if QuoteCard rebuilds on settings change, or ensure parent does.
  // If QuoteCard itself doesn't listen, the theme change in MaterialApp will trigger rebuild.
  final settingsService = Provider.of<SettingsService>(context);
  final theme = Theme.of(context);
  try {
    return GoogleFonts.getFont(
      settingsService.fontStyle, // Use selected font style
      fontSize: settingsService.fontSize, // Use selected font size
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.italic,
      color: theme.colorScheme.onSurface, // Use theme color
      height: 1.4,
    );
  } catch (e) {    // Fallback specifically for quote text if custom font fails
    return GoogleFonts.playfairDisplay(
      fontSize: settingsService.fontSize, // Still use selected size
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.italic,
      color: theme.colorScheme.onSurface,
      height: 1.4,
    );
  }
}

TextStyle authorTextStyle(BuildContext context) {
  final settingsService = Provider.of<SettingsService>(context);
  final theme = Theme.of(context);
  try {
    // Use the same font style as the quote for consistency, but smaller/different weight
    return GoogleFonts.getFont(
      settingsService.fontStyle,
      fontSize: (settingsService.fontSize * 0.75).clamp(10, 16), // Relative size, clamped
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      color: theme.colorScheme.onSurfaceVariant, // Use theme color (often secondary text)
    );
  } catch (e) {
    return GoogleFonts.robotoMono(
      fontSize: (settingsService.fontSize * 0.75).clamp(10, 16),
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      color: theme.colorScheme.onSurfaceVariant,
    );
  }
}

// --- Function to build ThemeData dynamically ---
// Uses the _defaultAppTextTheme which is NOT affected by font/size settings
ThemeData buildLightTheme(BuildContext context) {
  // Use the default text theme, not dependent on SettingsService here
  final textTheme = _defaultAppTextTheme(textColorLight, secondaryTextColorLight);
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColorLight,
    scaffoldBackgroundColor: backgroundColorLight,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primaryColorLight,
      onPrimary: Colors.white,
      secondary: secondaryColorLight,
      onSecondary: Colors.black,
      error: Colors.redAccent,
      onError: Colors.white,
      surface: cardBackgroundColorLight,
      onSurface: textColorLight,
      surfaceContainerHighest: backgroundColorLight,
      onSurfaceVariant: secondaryTextColorLight,
      outline: Colors.grey,
    ),
    textTheme: textTheme, // Use the default text theme
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColorLight,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: textTheme.titleLarge?.copyWith(color: Colors.white),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: cardBackgroundColorLight,
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColorLight,
        foregroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: textTheme.labelLarge?.copyWith(color: Colors.black87),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColorLight,
        textStyle: textTheme.labelLarge,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColorLight, width: 2.0),
      ),
      labelStyle: textTheme.bodyMedium?.copyWith(color: secondaryTextColorLight),
      hintStyle: textTheme.bodyMedium?.copyWith(color: secondaryTextColorLight),
      fillColor: cardBackgroundColorLight,
      filled: true,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: backgroundColorLight,
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade300,
      thickness: 1,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryColorLight,
      inactiveTrackColor: primaryColorLight.withValues(alpha: 0.3),
      thumbColor: primaryColorLight,
      overlayColor: primaryColorLight.withValues(alpha: 0.2),
    ),
     radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColorLight; // Color when selected
        }
        return secondaryTextColorLight; // Color when not selected
      }),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
         fillColor: cardBackgroundColorLight,
         filled: true,
         border: OutlineInputBorder(
           borderRadius: BorderRadius.circular(8),
           borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
         ),
         enabledBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(8),
           borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
         ),
      )
    )
  );
}

ThemeData buildDarkTheme(BuildContext context) {
  // Use the default text theme, not dependent on SettingsService here
  final textTheme = _defaultAppTextTheme(textColorDark, secondaryTextColorDark);
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColorDark,
    scaffoldBackgroundColor: backgroundColorDark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: primaryColorDark,
      onPrimary: Colors.black,
      secondary: secondaryColorDark,
      onSecondary: Colors.black,
      error: errorColorDark,
      onError: Colors.black,
      surface: cardBackgroundColorDark,
      onSurface: textColorDark,
      surfaceContainerHighest: Color(0xFF303030),
      onSurfaceVariant: secondaryTextColorDark,
      outline: Color(0xFF505050),
    ),
    textTheme: textTheme, // Use the default text theme
    appBarTheme: AppBarTheme(
      backgroundColor: cardBackgroundColorDark,
      foregroundColor: textColorDark,
      elevation: 0,
      titleTextStyle: textTheme.titleLarge?.copyWith(color: textColorDark),
      iconTheme: const IconThemeData(color: textColorDark),
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: cardBackgroundColorDark,
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColorDark,
        foregroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: textTheme.labelLarge?.copyWith(color: Colors.black87),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: secondaryColorDark,
        textStyle: textTheme.labelLarge,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF505050), width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF505050), width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: secondaryColorDark, width: 2.0),
      ),
      labelStyle: textTheme.bodyMedium?.copyWith(color: secondaryTextColorDark),
      hintStyle: textTheme.bodyMedium?.copyWith(color: secondaryTextColorDark),
      fillColor: cardBackgroundColorDark,
      filled: true,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: cardBackgroundColorDark,
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade700,
      thickness: 1,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: secondaryColorDark,
      inactiveTrackColor: secondaryColorDark.withValues(alpha: 0.3),
      thumbColor: secondaryColorDark,
      overlayColor: secondaryColorDark.withValues(alpha: 0.2),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return secondaryColorDark; // Color when selected
        }
        return secondaryTextColorDark; // Color when not selected
      }),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
         fillColor: cardBackgroundColorDark,
         filled: true,
         border: OutlineInputBorder(
           borderRadius: BorderRadius.circular(8),
           borderSide: const BorderSide(color: Color(0xFF505050), width: 1.0),
         ),
         enabledBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(8),
           borderSide: const BorderSide(color: Color(0xFF505050), width: 1.0),
         ),
      )
    )
  );
}

// Helper to get gradient colors based on theme (Unchanged)
List<Color> getGradientColors(BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  if (isDarkMode) {
    return [
      primaryColorDark.withValues(alpha: 0.8),
      secondaryColorDark.withValues(alpha: 0.6),
      cardBackgroundColorDark.withValues(alpha: 0.7),
      primaryColorDark.withValues(alpha: 0.7),
    ];
  } else {
    return [
      primaryColorLight.withValues(alpha: 0.9),
      secondaryColorLight.withValues(alpha: 0.7),
      accentColorLight.withValues(alpha: 0.5),
      primaryColorLight.withValues(alpha: 0.8),
    ];
  }
}

