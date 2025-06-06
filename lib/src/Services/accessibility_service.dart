// lib/src/services/accessibility_service.dart

import 'dart:convert';
import 'package:adaptive_ui_senior/adaptive_ui_senior.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing accessibility settings persistence and system integration
class AccessibilityService extends ChangeNotifier {
  static const String _settingsKey = 'adaptive_ui_senior_settings';

  AccessibilitySettings _settings = const AccessibilitySettings();
  SharedPreferences? _prefs;
  bool _initialized = false;

  /// Current accessibility settings
  AccessibilitySettings get settings => _settings;

  /// Initializes the service and loads saves settings
  Future<void> initialized() async {
    if (_initialized) return;

    try {
      _prefs = await SharedPreferences.getInstance();
      await _loadSettings();
      _initialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('AccessibilityService initialization failed: $e');
      _initialized = true;
    }
  }

  /// Updates accessibility settings and persists them
  Future<void> updateSettings(AccessibilitySettings newSettings) async {
    if (_settings == newSettings) return;

    _settings = newSettings;
    // If age-based adaptation is turned off, clear the age.
    if (!newSettings.useAgeBasedAdaptation && newSettings.age != null) {
      _settings = _settings.copyWith(age: null);
    }

    await _saveSettings();
    notifyListeners();
  }

  /// Updates a specific setting value
  Future<void> updateFontScale(double scale) async {
    await updateSettings(_settings.copyWith(fontScale: scale));
  }

  /// Toggles Larger tap targets
  Future<void> toggleLargerTapTargets() async {
    final newLargerTapTargetsState = !_settings.largerTapTargets;
    AccessibilitySettings newSettings = _settings.copyWith(
      largerTapTargets: newLargerTapTargetsState,
    );

    if (newLargerTapTargetsState) {
      // Enabling larger tap targets.
      // If the current minTapTargetSize is less than the senior-friendly minimum,
      // update it to the senior-friendly minimum.
      // Otherwise, keep the user's potentially larger custom size.
      if (newSettings.minTapTargetSize < TapTargetUtils.seniorFriendlyMinimum) {
        newSettings = newSettings.copyWith(
          minTapTargetSize: TapTargetUtils.seniorFriendlyMinimum,
        );
      }
    }
    // No explicit change to minTapTargetSize needed when disabling,
    // as getEffectiveMinTapTargetSize() will return TapTargetUtils.materialMinimum.
    // The stored _settings.minTapTargetSize is preserved.

    await updateSettings(newSettings);
  }

  /// Toggles high contrast mode
  Future<void> toggleHighContrast() async {
    await updateSettings(
      _settings.copyWith(highContrastMode: !_settings.highContrastMode),
    );
  }

  /// Updates minimum tap target size
  Future<void> updateMinTapTargetSize(double size) async {
    await updateSettings(_settings.copyWith(minTapTargetSize: size));
  }

  /// Toggles use of system accessibility settings
  Future<void> toggleUseSystemSettings() async {
    await updateSettings(
      _settings.copyWith(useSystemSettings: !_settings.useSystemSettings),
    );
  }

  /// Updates the application theme mode
  Future<void> updateThemeMode(ThemeMode newThemeMode) async {
    await updateSettings(_settings.copyWith(themeMode: newThemeMode));
  }

  /// Updates the user's age for age-based adaptation.
  /// This will only take effect if useAgeBasedAdaptation is true.
  Future<void> updateAge(int? age) async {
    await updateSettings(_settings.copyWith(age: age));
  }

  /// Toggles the use of age-based adaptation.
  Future<void> toggleUseAgeBasedAdaptation() async {
    final newUseAgeBasedAdaptationState = !_settings.useAgeBasedAdaptation;
    AccessibilitySettings newSettings = _settings.copyWith(
      useAgeBasedAdaptation: newUseAgeBasedAdaptationState,
    );
    // If turning off age-based adaptation, also clear the stored age.
    if (!newUseAgeBasedAdaptationState) {
      newSettings = newSettings.copyWith(age: null);
    }
    await updateSettings(newSettings);
  }

  /// Applies senior-friendly defaults
  Future<void> applySeniorFriendlyDefaults() async {
    await updateSettings(AccessibilitySettings.seniorFriendly);
  }

  /// Resets settings to defaults
  Future<void> resetToDefaults() async {
    await updateSettings(const AccessibilitySettings());
  }

  /// Gets the effective font scale considering system settings
  double getEffectiveFontScale() {
    if (_settings.useAgeBasedAdaptation && _settings.age != null) {
      return FontScaleUtils.getRecommendedScaleForAge(_settings.age!);
    }
    if (_settings.useSystemSettings) {
      /// comeback to this later
      // In a real implementation, you would get the system text scale factor
      // For now, we'll return the configured scale
      return _settings.fontScale;
    }
    return _settings.fontScale;
  }

  /// Gets the effective minimum tap target size
  double getEffectiveMinTapTargetSize() {
    if (_settings.useAgeBasedAdaptation && _settings.age != null) {
      return TapTargetUtils.getRecommendedTapTargetSize(_settings.age!);
    }
    if (_settings.largerTapTargets) {
      return _settings.minTapTargetSize;
    }
    return TapTargetUtils.materialMinimum; // Use constant for default
  }

  /// Checks if high contrast should be used (considering system settings)
  bool shouldUseHighContrast() {
    if (_settings.useSystemSettings) {
      /// might not work comeback to this later
      /// check system high constrast settings
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }
    return _settings.highContrastMode;
  }

  /// Loads settings from SharedPreferences
  Future<void> _loadSettings() async {
    try {
      final settingsJson = _prefs?.getString(_settingsKey);
      if (settingsJson != null) {
        final settingsMap = jsonDecode(settingsJson) as Map<String, dynamic>;
        _settings = AccessibilitySettings.fromMap(settingsMap);
      } else {
        _settings =
            const AccessibilitySettings(); // Ensure defaults if no saved settings
      }
    } catch (e) {
      debugPrint('Failed to load accessibility settings: $e');
      _settings = const AccessibilitySettings(); // Reset to defaults on error
    }
  }

  /// Saves settings to SharedPreferences
  Future<void> _saveSettings() async {
    try {
      final settingsJson = jsonEncode(_settings.toMap());
      await _prefs?.setString(_settingsKey, settingsJson);
    } catch (e) {
      debugPrint('Failed to save accessibility settings: $e');
    }
  }

  /// Global instance of the accessibility service
  /// Initialize this in your app's main() function
  ///final AccessibilityService accessibilityService = AccessibilityService();
}
