import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Keys for SharedPreferences
const String _themeModeKey = 'themeMode';
const String _fontSizeKey = 'fontSize';
const String _fontStyleKey = 'fontStyle';
const String _layoutColumnsKey = 'layoutColumns';

// Default values
const ThemeMode _defaultThemeMode = ThemeMode.system;
const double _defaultFontSize = 14.0;
const String _defaultFontStyle = 'Playfair Display';
const int _defaultLayoutColumns = 2; // Grid layout default

class SettingsService with ChangeNotifier {
  late SharedPreferences _prefs;

  ThemeMode _themeMode = _defaultThemeMode;
  double _fontSize = _defaultFontSize;
  String _fontStyle = _defaultFontStyle;
  int _layoutColumns = _defaultLayoutColumns;

  ThemeMode get themeMode => _themeMode;
  double get fontSize => _fontSize;
  String get fontStyle => _fontStyle;
  int get layoutColumns => _layoutColumns;

  // Available font styles (match with GoogleFonts or custom fonts)
  final List<String> availableFontStyles = [
    'Playfair Display', // Default
    'Roboto',
    'Open Sans',
    'Montserrat',
    'Lato', // Used for quotes
    'Roboto Mono', // Used for authors
    // Add more Google Fonts names here
  ];

  Future<void> loadSettings() async {
    _prefs = await SharedPreferences.getInstance();

    // Load Theme Mode
    final themeString = _prefs.getString(_themeModeKey) ?? _defaultThemeMode.toString();
    _themeMode = ThemeMode.values.firstWhere(
      (e) => e.toString() == themeString,
      orElse: () => _defaultThemeMode,
    );

    // Load Font Size
    _fontSize = _prefs.getDouble(_fontSizeKey) ?? _defaultFontSize;

    // Load Font Style
    _fontStyle = _prefs.getString(_fontStyleKey) ?? _defaultFontStyle;
    if (!availableFontStyles.contains(_fontStyle)) {
      _fontStyle = _defaultFontStyle; // Reset to default if invalid
    }

    // Load Layout Columns
    _layoutColumns = _prefs.getInt(_layoutColumnsKey) ?? _defaultLayoutColumns;
    if (_layoutColumns != 1 && _layoutColumns != 2) {
      _layoutColumns = _defaultLayoutColumns; // Ensure valid value
    }

    notifyListeners(); // Notify listeners after loading
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null || newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;
    notifyListeners();

    await _prefs.setString(_themeModeKey, _themeMode.toString());
  }

  Future<void> updateFontSize(double newSize) async {
    if (newSize <= 0 || newSize == _fontSize) return; // Add validation

    _fontSize = newSize;
    notifyListeners();

    await _prefs.setDouble(_fontSizeKey, _fontSize);
  }

  Future<void> updateFontStyle(String newStyle) async {
    if (!availableFontStyles.contains(newStyle) || newStyle == _fontStyle) return;

    _fontStyle = newStyle;
    notifyListeners();

    await _prefs.setString(_fontStyleKey, _fontStyle);
  }

  Future<void> updateLayoutColumns(int newColumns) async {
    if ((newColumns != 1 && newColumns != 2) || newColumns == _layoutColumns) return;

    _layoutColumns = newColumns;
    notifyListeners();

    await _prefs.setInt(_layoutColumnsKey, _layoutColumns);
  }

  // Method to restore all settings to default
  Future<void> restoreDefaults() async {
    _themeMode = _defaultThemeMode;
    _fontSize = _defaultFontSize;
    _fontStyle = _defaultFontStyle;
    _layoutColumns = _defaultLayoutColumns;

    // Clear saved preferences
    await _prefs.remove(_themeModeKey);
    await _prefs.remove(_fontSizeKey);
    await _prefs.remove(_fontStyleKey);
    await _prefs.remove(_layoutColumnsKey);

    notifyListeners(); // Notify listeners about the changes
  }
}

