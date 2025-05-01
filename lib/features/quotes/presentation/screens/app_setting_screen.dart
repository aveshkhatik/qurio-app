import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Assuming Provider is used for state management
import 'package:qurio/shared/services/settings_service.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  // Local state for font size input if using a text field
  late TextEditingController _fontSizeController;

  @override
  void initState() {
    super.initState();
    // Initialize controller later using Provider data
    _fontSizeController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize font size controller with current value from service
    // Ensure this runs after initState and when dependencies change
    final settingsService = Provider.of<SettingsService>(context, listen: false);
    _fontSizeController.text = settingsService.fontSize.toStringAsFixed(1);
  }

  @override
  void dispose() {
    _fontSizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use Consumer to listen to changes in SettingsService
    return Consumer<SettingsService>(builder: (context, settingsService, child) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;

      return Scaffold(
        appBar: AppBar(title: const Text('App Settings')),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          children: [
            // --- Theme Setting ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text('Appearance', style: theme.textTheme.titleLarge?.copyWith(color: colorScheme.primary)),
            ),
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: Text(settingsService.themeMode == ThemeMode.system ? 'System Default' : (settingsService.themeMode == ThemeMode.dark ? 'On' : 'Off')),
              value: settingsService.themeMode == ThemeMode.dark,
              // Use a three-way toggle or separate options for System/Light/Dark if needed
              // This simple toggle just switches between Light and Dark for now
              onChanged: (val) {
                settingsService.updateThemeMode(val ? ThemeMode.dark : ThemeMode.light);
              },
              secondary: Icon(settingsService.themeMode == ThemeMode.dark ? Icons.dark_mode_outlined : Icons.light_mode_outlined),
            ),
            const Divider(),

            // --- Font Settings ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text('Text & Layout', style: theme.textTheme.titleLarge?.copyWith(color: colorScheme.primary)),
            ),
            ListTile(
              leading: const Icon(Icons.font_download_outlined),
              title: const Text('Font Style'),
              trailing: DropdownButton<String>(
                value: settingsService.fontStyle,
                underline: Container(), // Remove default underline
                items: settingsService.availableFontStyles
                    .map((String font) => DropdownMenuItem<String>(
                          value: font,
                          child: Text(font, style: theme.textTheme.bodyMedium),
                        ))
                    .toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    settingsService.updateFontStyle(newValue);
                  }
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.format_size_outlined),
              title: const Text('Base Font Size'),
              subtitle: const Text('Affects standard text elements'),
              trailing: SizedBox(
                width: 100, // Constrain width of the text field
                child: TextField(
                  controller: _fontSizeController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onSubmitted: (value) {
                    final newSize = double.tryParse(value);
                    if (newSize != null && newSize > 6 && newSize < 30) { // Basic validation
                      settingsService.updateFontSize(newSize);
                    } else {
                      // Reset text field if input is invalid
                      _fontSizeController.text = settingsService.fontSize.toStringAsFixed(1);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid size. Please enter a number between 7 and 29.')),
                      );
                    }
                  },
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.view_column_outlined),
              title: const Text("Quote Layout"),
              subtitle: const Text("Number of columns on home screen"),
              trailing: SegmentedButton<int>(
                segments: const <ButtonSegment<int>>[
                  ButtonSegment<int>(value: 1, label: Text("1"), icon: Icon(Icons.looks_one_outlined)),
                  ButtonSegment<int>(value: 2, label: Text("2"), icon: Icon(Icons.looks_two_outlined)),
                ],
                selected: <int>{settingsService.layoutColumns},
                onSelectionChanged: (Set<int> newSelection) {
                  settingsService.updateLayoutColumns(newSelection.first);
                },
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor: colorScheme.primary.withValues(alpha: 0.2),
                  selectedForegroundColor: colorScheme.primary,
                ),
              ),
            ),

            const Divider(),

            // --- Other Settings ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text('Other', style: theme.textTheme.titleLarge?.copyWith(color: colorScheme.primary)),
            ),
            const ListTile(
              leading: Icon(Icons.language_outlined),
              title: Text('Language'),
              subtitle: Text('English (Coming soon...)'),
              enabled: false,
            ),
          ],
        ),
      );
    });
  }
}

