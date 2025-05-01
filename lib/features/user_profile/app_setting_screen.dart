import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qurio/shared/services/settings_service.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {

  // Function to show confirmation dialog for restoring defaults
  Future<void> _showRestoreDefaultsDialog(SettingsService settingsService) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Restore Default Settings?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This will reset all theme, text, and layout settings to their original defaults.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Restore'),
              onPressed: () {
                settingsService.restoreDefaults();
                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings restored to defaults')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access the SettingsService
    final settingsService = Provider.of<SettingsService>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('App Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0), // Add some padding
        children: [
          // --- Theme Mode Setting ---
          ListTile(
            title: const Text('Theme Mode'),
            trailing: DropdownButton<ThemeMode>(
              value: settingsService.themeMode,
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('Default (System)'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark'),
                ),
              ],
              onChanged: (ThemeMode? newThemeMode) {
                if (newThemeMode != null) {
                  settingsService.updateThemeMode(newThemeMode);
                }
              },
            ),
          ),
          const Divider(),

          // --- Text Size Setting ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Text Size', style: theme.textTheme.titleMedium),
          ),
          Slider(
            value: settingsService.fontSize,
            min: 10.0, // Minimum font size
            max: 24.0, // Maximum font size
            divisions: 14, // Number of steps (max - min)
            label: settingsService.fontSize.toStringAsFixed(1),
            onChanged: (double value) {
              settingsService.updateFontSize(value);
            },
          ),
          const Divider(),

          // --- Font Style Setting ---
          ListTile(
            title: const Text('Font Style'),
            trailing: DropdownButton<String>(
              value: settingsService.fontStyle,
              items: settingsService.availableFontStyles
                  .map((String style) => DropdownMenuItem<String>(
                        value: style,
                        // Display font name in its own style for preview
                        child: Text(style, style: GoogleFonts.getFont(style)),
                      ))
                  .toList(),
              onChanged: (String? newStyle) {
                if (newStyle != null) {
                  settingsService.updateFontStyle(newStyle);
                }
              },
            ),
          ),
          const Divider(),

          // --- Layout Options Setting ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Home Screen Layout', style: theme.textTheme.titleMedium),
          ),
          RadioListTile<int>(
            title: const Text('Grid'),
            value: 2,
            groupValue: settingsService.layoutColumns,
            onChanged: (int? value) {
              if (value != null) {
                settingsService.updateLayoutColumns(value);
              }
            },
          ),
          RadioListTile<int>(
            title: const Text('Column'),
            value: 1,
            groupValue: settingsService.layoutColumns,
            onChanged: (int? value) {
              if (value != null) {
                settingsService.updateLayoutColumns(value);
              }
            },
          ),
          const Divider(),

          // --- Language Setting (Placeholder) ---
          const ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            subtitle: Text('Coming soon...'),
            enabled: false, // Disable until implemented
          ),
          const Divider(),

          // --- Restore Defaults Button ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: TextButton(
              onPressed: () => _showRestoreDefaultsDialog(settingsService),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error, // Use error color for emphasis
              ),
              child: const Text('Restore Defaults'),
            ),
          ),
        ],
      ),
    );
  }
}

