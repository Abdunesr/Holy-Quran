// providers/settings_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  String _edition = 'en.asad';
  bool _isDarkMode = false;
  bool _useArabicQuran = false; // New setting

  String get edition => _edition;
  bool get isDarkMode => _isDarkMode;
  bool get useArabicQuran => _useArabicQuran; // Getter

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _edition = prefs.getString('edition') ?? 'en.asad';
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _useArabicQuran =
        prefs.getBool('useArabicQuran') ?? false; // Load Arabic setting
    notifyListeners();
  }

  Future<void> setEdition(String newEdition) async {
    _edition = newEdition;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('edition', newEdition);
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  // New method to toggle Arabic Quran setting
  Future<void> toggleUseArabicQuran() async {
    _useArabicQuran = !_useArabicQuran;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useArabicQuran', _useArabicQuran);
    notifyListeners();
  }
}
