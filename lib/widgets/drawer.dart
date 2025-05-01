// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qurio/features/quotes/presentation/screens/saved_quotes_screen.dart';
import 'package:qurio/features/app_info/presentation/screens/about_app_screen.dart'; // Import the new About App screen

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _settingsExpanded = false; // To control settings expansion

  Future<void> logOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Ensure navigation happens safely
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/signup', (Route<dynamic> route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error occurred while logging out: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Drawer(
      backgroundColor: colorScheme.surface, // Use theme surface color
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: colorScheme.primary), // Use theme primary color
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: colorScheme.onPrimary.withValues(alpha: 0.8),
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                  child: user?.photoURL == null
                      ? Icon(Icons.person, size: 40, color: colorScheme.primary) // Icon color matches header bg
                      : null,
                ),
                const SizedBox(height: 10),
                Text(
                  user?.displayName ?? 'No Name',
                  style: textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary),
                ),
                const SizedBox(height: 5),
                Text(
                  user?.email ?? 'No Email',
                  style: textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimary.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ),
          // Use themed ExpansionTile
          Theme(
            data: theme.copyWith(dividerColor: Colors.transparent), // Hide default divider
            child: ExpansionTile(
              leading: Icon(Icons.settings, color: colorScheme.onSurfaceVariant), // Themed icon color
              title: Text('Settings', style: textTheme.titleMedium),
              trailing: Icon(
                _settingsExpanded ? Icons.expand_less : Icons.expand_more,
                color: colorScheme.onSurfaceVariant,
              ),
              onExpansionChanged: (expanded) {
                setState(() {
                  _settingsExpanded = expanded;
                });
              },
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 72), // Indent sub-items
                  // leading: Icon(Icons.color_lens, color: colorScheme.onSurfaceVariant), // Optional sub-icon
                  title: Text('App Settings', style: textTheme.bodyMedium),
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                    Navigator.pushNamed(context, '/appSettings');
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 72), // Indent sub-items
                  // leading: Icon(Icons.lock, color: colorScheme.onSurfaceVariant), // Optional sub-icon
                  title: Text('Privacy & Security', style: textTheme.bodyMedium),
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                    Navigator.pushNamed(context, '/privacySecurity');
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.bookmark_border, color: colorScheme.onSurfaceVariant),
            title: Text('Saved Quotes', style: textTheme.titleMedium),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SavedQuotesScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline, color: colorScheme.onSurfaceVariant),
            title: Text('About App', style: textTheme.titleMedium), // Updated text
            onTap: () {
              Navigator.pop(context); // Close drawer
              // Navigate to About App screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutAppScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.star_border, color: colorScheme.onSurfaceVariant),
            title: Text('Rate Us', style: textTheme.titleMedium),
            onTap: () {
              Navigator.pop(context); // Close drawer
              // Rate Us Functionality - Implement this
            },
          ),
          Divider(color: colorScheme.outline.withValues(alpha: 0.5)), // Themed divider
          ListTile(
            leading: Icon(Icons.exit_to_app, color: colorScheme.error), // Use error color for logout
            title: Text('Log Out', style: textTheme.titleMedium?.copyWith(color: colorScheme.error)),
            onTap: () {
              logOut(context);
            },
          ),
        ],
      ),
    );
  }
}

