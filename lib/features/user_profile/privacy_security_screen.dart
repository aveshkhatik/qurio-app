import 'package:flutter/material.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});
//ignore
  // ignore: unused_element
  void _changePassword(BuildContext context) {
    // TODO: Implement Change Password Flow using Firebase
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Change Password functionality coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy & Security')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change Password'),
            onTap: (){
              Navigator.pushNamed(context, '/changepasswordscreen');
            },
          ),
          const ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete Account'),
            subtitle: Text('Coming soon...'),
          ),
        ],
      ),
    );
  }
}
