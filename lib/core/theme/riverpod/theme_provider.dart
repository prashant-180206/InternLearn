import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

@riverpod
class AppTheme extends _$AppTheme {
  
  static const _themeModeCacheKey = 'app_theme_mode';

  @override
  ThemeMode build() {
    unawaited(_restoreTheme());
    return ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (state != mode) {
      state = mode;
    }
    await _persistTheme(mode);
  }

  Future<void> toggleTheme() async {
    final next = switch (state) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
      ThemeMode.system => ThemeMode.light,
    };
    await setThemeMode(next);
  }

  Future<void> _restoreTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final rawTheme = prefs.getString(_themeModeCacheKey);
    if (rawTheme == null) {
      return;
    }

    final restoredMode = _deserialize(rawTheme);
    if (restoredMode != null && restoredMode != state) {
      state = restoredMode;
    }
  }

  Future<void> _persistTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeCacheKey, _serialize(mode));
  }

  String _serialize(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
  }

  ThemeMode? _deserialize(String rawMode) {
    return switch (rawMode) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => null,
    };
  }
}
