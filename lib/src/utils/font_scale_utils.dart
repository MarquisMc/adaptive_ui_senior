// lib/src/utils/font_scale_utils.dart

import 'package:flutter/material.dart';
import '../services/accessibility_service.dart';

class FontScaleUtils {
  // Predefined font scale options suitable for senior users
  static const Map<String, double> fontScalePresets = {
    'Small': 0.85,
    'Normal': 1.0,
    'Large': 1.15,
    'Larger': 1.3,
    'Huge': 1.5,
    'Maximum': 2.0,
  };

  // Gets the scaled font size based on accessbility settings
  static double getScaledFontSize({
    required double baseFontSize,
    required AccessibilityService accessibilityService,
  }) {
    final scale = accessibilityService.getEffectiveFontScale();
    return baseFontSize * scale;
  }

  // Creates a scaled text style
  static TextStyle? scaleTextStyle({
    TextStyle? baseStyle,
    required AccessibilityService accessibilityService,
    double? customScale,
  }) {
    if (baseStyle == null) return null;

    final scale = customScale ?? accessibilityService.getEffectiveFontScale();
    return baseStyle.copyWith(fontSize: (baseStyle.fontSize ?? 14) * scale);
  }

  /// Gets a readable description for a font scale value
  static String getFontScaleDescription(double scale) {
    for (final entry in fontScalePresets.entries) {
      if ((entry.value - scale).abs() < 0.01) {
        return entry.key;
      }
    }

    // Return percentage for custom scales
    final percentage = (scale * 100).round();
    return '$percentage%';
  }

  /// Ensures minimum readable font size
  static double ensureMinimumFontSize(
    double fontSize, {
    double minimum = 12.0,
  }) {
    return fontSize < minimum ? minimum : fontSize;
  }

  /// Calculates optimal line height based on font size
  static double getOptimalLineHeight(double fontSize) {
    if (fontSize <= 12) return 1.4;
    if (fontSize <= 16) return 1.5;
    if (fontSize <= 20) return 1.6;
    return 1.7;
  }

  /// Gets the text scale from MediaQuery if available
  static double getSystemTextScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaler.scale(1.0);
  }

  /// Combines custom scale with system scale factor
  static double getCombinedScale({
    required BuildContext context,
    required double customScale,
    bool respectSystemScale = true,
  }) {
    if (!respectSystemScale) return customScale;

    final systemScale = getSystemTextScaleFactor(context);
    return customScale * systemScale;
  }

  /// Creates a widget that responds to font scale changes
  static Widget buildResponsiveText({
    required String text,
    required AccessibilityService accessibilityService,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool softWrap = true,
  }) {
    return ListenableBuilder(
      listenable: accessibilityService,
      builder: (context, child) {
        final scaledStyle = scaleTextStyle(
          baseStyle: style ?? Theme.of(context).textTheme.bodyMedium,
          accessibilityService: accessibilityService,
        );

        return Text(
          text,
          style: scaledStyle,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          softWrap: softWrap,
        );
      },
    );
  }

  /// Validates font scale value
  static double validateFontScale(double scale) {
    const minScale = 0.5;
    const maxScale = 3.0;

    if (scale < minScale) return minScale;
    if (scale > maxScale) return maxScale;
    return scale;
  }

  /// Gets recommended font scale based on age group
  static double getRecommendedScaleForAge(int age) {
    if (age < 50) return 1.0;
    if (age < 65) return 1.15;
    if (age < 75) return 1.3;
    return 1.5;
  }

  /// Calculates comfortable reading distance in logical pixels
  static double getComfortableReadingDistance(double fontSize) {
    // Based on typography research for comfortable reading
    return fontSize * 0.5; // Space between lines
  }
}
