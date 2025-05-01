import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart'; // Changed from cupertino
import 'package:provider/provider.dart';
import 'package:qurio/app.dart';
import 'package:qurio/shared/services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Create and load settings service
  final settingsService = SettingsService();
  await settingsService.loadSettings();

  runApp(
    ChangeNotifierProvider(
      create: (_) => settingsService,
      child: const QuoteApp(),
    ),
  );
}

