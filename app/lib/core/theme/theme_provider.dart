import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final settingsBoxProvider = Provider<Box<String>>((ref) => throw UnimplementedError());

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final box = ref.watch(settingsBoxProvider);
  return ThemeModeNotifier(box);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final Box<String> _box;
  static const String _key = 'theme_mode';

  ThemeModeNotifier(this._box) : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final themeString = _box.get(_key);
    if (themeString == 'light') {
      state = ThemeMode.light;
    } else if (themeString == 'dark') {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.system;
    }
  }

  void setTheme(ThemeMode mode) {
    state = mode;
    if (mode == ThemeMode.light) {
      _box.put(_key, 'light');
    } else if (mode == ThemeMode.dark) {
      _box.put(_key, 'dark');
    } else {
      _box.put(_key, 'system');
    }
  }
}
