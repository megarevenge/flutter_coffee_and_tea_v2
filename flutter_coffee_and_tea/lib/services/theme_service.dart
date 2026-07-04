import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A simple singleton service that holds the app-wide [ThemeMode] in a
/// [ValueNotifier]. Any widget can listen to [themeNotifier] and will
/// automatically rebuild when the theme changes.
class ThemeService {
  ThemeService._();

  /// The single source of truth for the current [ThemeMode].
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.system);

  /// Call this once at app start (before [runApp]) to restore the saved theme.
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('themeSetting') ?? 'system';
    themeNotifier.value = _toThemeMode(saved);
  }

  /// Persists [setting] and updates [themeNotifier] so the UI rebuilds.
  static Future<void> updateTheme(String setting) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeSetting', setting);
    themeNotifier.value = _toThemeMode(setting);
  }

  /// Returns the saved setting string (e.g. to restore radio-button state).
  static Future<String> getSavedSetting() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('themeSetting') ?? 'system';
  }

  static ThemeMode _toThemeMode(String setting) {
    switch (setting) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }
}
