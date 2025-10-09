import 'package:check_obsity/root.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

bool onboardingShown = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  onboardingShown = prefs.getBool('showHome') ?? false;
  runApp(const CheckObesity());
}
