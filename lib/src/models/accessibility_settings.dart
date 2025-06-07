// lib/src/models/accessibility_settings.dart

import 'package:flutter/material.dart';

/// Represents the accessibility settings configuration for senior users
class AccessibilitySettings {
  /// font scale multiplier (1.0 = normal, 1.5 = 150% Larger, etc.)
  final double fontScale;

  /// Whether high contrast mode is enabled
  final bool highContrastMode;

  /// Whether larger tap targets are enabled
  final bool largerTapTargets;

  /// Minimum tap target size (in logical pixels)
  final double minTapTargetSize;

  /// Whether to use system accessiblility settings when available
  final bool useSystemSettings;

  /// The theme mode for the application (light, dark, or system)
  final ThemeMode themeMode;

  /// User's age, for age-based adaptation
  final int? age;

  /// Whether to enable age-based adaptation for font size and tap targets
  final bool useAgeBasedAdaptation;

  const AccessibilitySettings({
    this.fontScale = 1.0,
    this.highContrastMode = false,
    this.largerTapTargets = false,
    this.minTapTargetSize = 48.0,
    this.useSystemSettings = true,
    this.themeMode = ThemeMode.system,
    this.age,
    this.useAgeBasedAdaptation = false,
  });

  /// Creates a copy of this settings object with updated values
  static const Object _sentinel = Object();

  AccessibilitySettings copyWith({
    double? fontScale,
    bool? highContrastMode,
    bool? largerTapTargets,
    double? minTapTargetSize,
    bool? useSystemSettings,
    ThemeMode? themeMode,
    Object? age = _sentinel,
    bool? useAgeBasedAdaptation,
  }) {
    return AccessibilitySettings(
      fontScale: fontScale ?? this.fontScale,
      highContrastMode: highContrastMode ?? this.highContrastMode,
      largerTapTargets: largerTapTargets ?? this.largerTapTargets,
      minTapTargetSize: minTapTargetSize ?? this.minTapTargetSize,
      useSystemSettings: useSystemSettings ?? this.useSystemSettings,
      themeMode: themeMode ?? this.themeMode,
      age: identical(age, _sentinel) ? this.age : age as int?,
      useAgeBasedAdaptation:
          useAgeBasedAdaptation ?? this.useAgeBasedAdaptation,
    );
  }

  /// Converts the settings to a Map for storage
  Map<String, dynamic> toMap() {
    return {
      'fontScale': fontScale,
      'highContrastMode': highContrastMode,
      'largerTapTargets': largerTapTargets,
      'minTapTargetSize': minTapTargetSize,
      'useSystemSettings': useSystemSettings,
      'themeMode': themeMode.index, // Store ThemeMode as int
      'age': age,
      'useAgeBasedAdaptation': useAgeBasedAdaptation,
    };
  }

  /// Creates settings from a Map(for loading from storage)
  factory AccessibilitySettings.fromMap(Map<String, dynamic> map) {
    return AccessibilitySettings(
      fontScale: (map['fontScale'] as num?)?.toDouble() ?? 1.0, // Corrected key
      highContrastMode: map['highContrastMode'] as bool? ?? false,
      largerTapTargets: map['largerTapTargets'] as bool? ?? false,
      minTapTargetSize: (map['minTapTargetSize'] as num?)?.toDouble() ?? 48.0,
      useSystemSettings: map['useSystemSettings'] as bool? ?? true,
      themeMode: map['themeMode'] != null
          ? ThemeMode.values[map['themeMode'] as int]
          : ThemeMode.system, // Load ThemeMode from int
      age: map['age'] as int?,
      useAgeBasedAdaptation: map['useAgeBasedAdaptation'] as bool? ?? false,
    );
  }

  /// Default settings optimized for senior users
  static const AccessibilitySettings seniorFriendly = AccessibilitySettings(
    fontScale: 1.3, // 130% larger font
    highContrastMode: true,
    largerTapTargets: true,
    minTapTargetSize: 56.0,
    useSystemSettings: false,
    themeMode: ThemeMode
        .light, // light Or system, depending on preference for senior default
    age: null, // Age is not part of the seniorFriendly preset by default
    useAgeBasedAdaptation:
        false, // Age-based adaptation is off by default for this preset
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AccessibilitySettings &&
        other.fontScale == fontScale &&
        other.highContrastMode == highContrastMode &&
        other.largerTapTargets == largerTapTargets &&
        other.minTapTargetSize == minTapTargetSize &&
        other.useSystemSettings == useSystemSettings &&
        other.themeMode == themeMode &&
        other.age == age &&
        other.useAgeBasedAdaptation == useAgeBasedAdaptation;
  }

  @override
  int get hashCode {
    return Object.hash(
      fontScale,
      highContrastMode,
      largerTapTargets,
      minTapTargetSize,
      useSystemSettings,
      themeMode,
      age,
      useAgeBasedAdaptation,
    );
  }

  @override
  String toString() {
    return 'AccessibilitySettings('
        'fontScale: $fontScale, '
        'highContrastMode: $highContrastMode, '
        'largerTapTargets: $largerTapTargets, '
        'minTapTargetSize: $minTapTargetSize, '
        'useSystemSettings: $useSystemSettings, '
        'themeMode: $themeMode, '
        'age: $age, '
        'useAgeBasedAdaptation: $useAgeBasedAdaptation)';
  }
}
