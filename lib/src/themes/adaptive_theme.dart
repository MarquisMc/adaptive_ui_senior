// lib/src/themes/adaptive_theme.dart

import 'package:flutter/material.dart';
import '../services/accessibility_service.dart';
import 'high_contrast_theme.dart';

/// Manages adaptive theming based on accessibility settings
class AdaptiveTheme {
  /// Gets the appropriate theme based on accessibility settings and brightness
  static ThemeData getTheme({
    required AccessibilityService accessibilityService,
    required Brightness brightness,
    ThemeData? baseTheme,
  }) {
    final settings = accessibilityService.settings;

    // start with high contrast theme if enabled, otherwise use base theme
    ThemeData theme = settings.highContrastMode
        ? _getHighContrastTheme(brightness)
        : baseTheme ?? _getDefaultTheme(brightness);

    // Apply font scaling
    if (settings.fontScale != 1.0) {
      theme = _applyFontScaling(theme, settings.fontScale);
    }
    return theme;
  }

  /// Gets the high contrast theme for the specified brightness
  static ThemeData _getHighContrastTheme(Brightness brightness) {
    return brightness == Brightness.dark
        ? HighContrastTheme.darkTheme
        : HighContrastTheme.lightTheme;
  }

  /// Gets the default theme for the specified brightness
  static ThemeData _getDefaultTheme(Brightness brightness) {
    return brightness == Brightness.light
        ? ThemeData(
            useMaterial3: true,
            brightness: brightness,
            textTheme: _buildSeniorFriendlyTextTheme(brightness),
          )
        : ThemeData(
            useMaterial3: true,
            brightness: brightness,
            textTheme: _buildSeniorFriendlyTextTheme(brightness),
          );
  }

  // Applies font scaling to the theme
  static ThemeData _applyFontScaling(ThemeData theme, double scale) {
    return theme.copyWith(
      textTheme: _scaleTextTheme(theme.textTheme, scale),
      primaryTextTheme: _scaleTextTheme(theme.primaryTextTheme, scale),
    );
  }

  static TextTheme _scaleTextTheme(TextTheme textTheme, double scale) {
    return TextTheme(
      displayLarge: _scaleTextStyle(textTheme.displayLarge, scale),
      displayMedium: _scaleTextStyle(textTheme.displayMedium, scale),
      displaySmall: _scaleTextStyle(textTheme.displaySmall, scale),
      headlineLarge: _scaleTextStyle(textTheme.headlineLarge, scale),
      headlineMedium: _scaleTextStyle(textTheme.headlineMedium, scale),
      headlineSmall: _scaleTextStyle(textTheme.headlineSmall, scale),
      titleLarge: _scaleTextStyle(textTheme.titleLarge, scale),
      titleMedium: _scaleTextStyle(textTheme.titleMedium, scale),
      titleSmall: _scaleTextStyle(textTheme.titleSmall, scale),
      bodyLarge: _scaleTextStyle(textTheme.bodyLarge, scale),
      bodyMedium: _scaleTextStyle(textTheme.bodyMedium, scale),
      bodySmall: _scaleTextStyle(textTheme.bodySmall, scale),
      labelLarge: _scaleTextStyle(textTheme.labelLarge, scale),
      labelMedium: _scaleTextStyle(textTheme.labelMedium, scale),
      labelSmall: _scaleTextStyle(textTheme.labelSmall, scale),
    );
  }

  // Scales a single text style
  static TextStyle? _scaleTextStyle(TextStyle? style, double scale) {
    if (style == null) return null;
    return style.copyWith(fontSize: (style.fontSize ?? 14) * scale);
  }

  // Builds a senior-friendly text theme with better spacing and contrast
  static TextTheme _buildSeniorFriendlyTextTheme(Brightness brightness) {
    final baseColor = brightness == Brightness.light
        ? Colors.black87
        : Colors.white;

    return TextTheme(
      displayLarge: TextStyle(
        color: baseColor,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 1.2,
        letterSpacing: 0.5,
      ),
      displayMedium: TextStyle(
        color: baseColor,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        height: 1.2,
        letterSpacing: 0.3,
      ),
      displaySmall: TextStyle(
        color: baseColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        height: 1.3,
        letterSpacing: 0.2,
      ),
      headlineLarge: TextStyle(
        color: baseColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0.2,
      ),
      headlineMedium: TextStyle(
        color: baseColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0.1,
      ),
      headlineSmall: TextStyle(
        color: baseColor,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 0.1,
      ),
      titleLarge: TextStyle(
        color: baseColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.1,
      ),
      titleMedium: TextStyle(
        color: baseColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.1,
      ),
      titleSmall: TextStyle(
        color: baseColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.5,
        letterSpacing: 0.1,
      ),
      bodyLarge: TextStyle(
        color: baseColor,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        height: 1.6,
        letterSpacing: 0.1,
      ),
      bodyMedium: TextStyle(
        color: baseColor,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        height: 1.6,
        letterSpacing: 0.1,
      ),
      bodySmall: TextStyle(
        color: baseColor,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        height: 1.6,
        letterSpacing: 0.1,
      ),
      labelLarge: TextStyle(
        color: baseColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        color: baseColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.1,
      ),
      labelSmall: TextStyle(
        color: baseColor,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.1,
      ),
    );
  }
}
