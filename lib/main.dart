import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';
import 'injection_container.dart' as di;

/// Application entry point.
///
/// Initializes environment variables and dependencies, then runs the app.
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file (app handles missing API key errors)
  await dotenv.load().catchError((_) {});

  // Initialize dependency injection
  await di.init();

  // Run the app
  runApp(const NewsApp());
}
