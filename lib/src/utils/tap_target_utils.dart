// lib/src/utils/tap_target_utils.dart

import 'package:flutter/material.dart';
import '../services/accessibility_service.dart';

/// Utilities for handling tap target sizing in adaptive UI
class TapTargetUtils {
  /// Material Design minimum tap target size
  static const double materialMinimum = 48.0;

  /// Recommended minimum for senior users
  static const double seniorFriendlyMinimum = 56.0;

  /// Maximum reasonable tap target size
  static const double maximumSize = 80.0;

  /// Predefined tap target size options
  static const Map<String, double> tapTargetPresets = {
    'Compact': 44.0,
    'Standard': 48.0,
    'Comfortable': 56.0,
    'Large': 64.0,
    'Extra Large': 72.0,
  };

  /// Gets a slightly larger tap target size, potentially stepping up to the next preset.
  /// Used for determining container heights that need to be comfortably larger than the tap target.
  static double getSteppedUpTapTargetSize(double currentSize) {
    final sortedValues = tapTargetPresets.values.toList()..sort();

    // Find the smallest preset that is strictly larger than currentSize
    for (final presetValue in sortedValues) {
      if (presetValue > currentSize) {
        return presetValue;
      }
    }

    // If currentSize is >= the largest preset, or no preset is strictly larger,
    // increase currentSize by a 15% factor.
    return currentSize * 1.15;
  }

  /// Gets the effective minimum tap target size based on accessibility settings
  static double getEffectiveMinTapTargetSize(
    AccessibilityService accessibilityService,
  ) {
    return accessibilityService.getEffectiveMinTapTargetSize();
  }

  /// Ensures a widget meets minimum tap target requirements
  static Widget ensureMinimumTapTarget({
    required Widget child,
    required AccessibilityService accessibilityService,
    double? customMinSize,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
  }) {
    return ListenableBuilder(
      listenable: accessibilityService,
      builder: (context, _) {
        final minSize =
            customMinSize ?? getEffectiveMinTapTargetSize(accessibilityService);

        Widget result = child;

        // Wrap with GestureDetector if onTap is provided
        if (onTap != null) {
          result = GestureDetector(onTap: onTap, child: result);
        }

        // Ensure minimum size constraints
        result = ConstrainedBox(
          constraints: BoxConstraints(minWidth: minSize, minHeight: minSize),
          child: result,
        );

        // Add padding if specified
        if (padding != null) {
          result = Padding(padding: padding, child: result);
        }

        return result;
      },
    );
  }

  /// Creates an adaptive container with proper tap target sizing
  static Widget createAdaptiveContainer({
    required Widget child,
    required AccessibilityService accessibilityService,
    VoidCallback? onTap,
    Color? color,
    BorderRadius? borderRadius,
    Border? border,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? customMinSize,
  }) {
    return ListenableBuilder(
      listenable: accessibilityService,
      builder: (context, _) {
        final minSize =
            customMinSize ?? getEffectiveMinTapTargetSize(accessibilityService);

        Widget container = Container(
          constraints: BoxConstraints(minWidth: minSize, minHeight: minSize),
          padding: padding,
          margin: margin,
          decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius,
            border: border,
          ),
          child: child,
        );

        if (onTap != null) {
          container = GestureDetector(onTap: onTap, child: container);
        }

        return container;
      },
    );
  }

  /// Calculates optimal spacing between tap targets
  static double getOptimalSpacing(AccessibilityService accessibilityService) {
    final minSize = getEffectiveMinTapTargetSize(accessibilityService);
    return minSize * 0.125; // 12.5% of tap target size as spacing
  }

  /// Creates adaptive padding for tap targets
  static EdgeInsetsGeometry getAdaptivePadding({
    required AccessibilityService accessibilityService,
    double horizontalFactor = 0.25,
    double verticalFactor = 0.25,
  }) {
    final minSize = getEffectiveMinTapTargetSize(accessibilityService);
    return EdgeInsets.symmetric(
      horizontal: minSize * horizontalFactor,
      vertical: minSize * verticalFactor,
    );
  }

  /// Gets a readable description for a tap target size
  static String getTapTargetSizeDescription(double size) {
    for (final entry in tapTargetPresets.entries) {
      if ((entry.value - size).abs() < 1.0) {
        return entry.key;
      }
    }
    return '${size.round()}px';
  }

  /// Validates tap target size
  static double validateTapTargetSize(double size) {
    if (size < materialMinimum) return materialMinimum;
    if (size > maximumSize) return maximumSize;
    return size;
  }

  /// Creates an adaptive IconButton with proper sizing
  static Widget createAdaptiveIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required AccessibilityService accessibilityService,
    String? tooltip,
    Color? color,
    double? iconSize,
  }) {
    return ListenableBuilder(
      listenable: accessibilityService,
      builder: (context, _) {
        final minSize = getEffectiveMinTapTargetSize(accessibilityService);
        final adaptiveIconSize = iconSize ?? (minSize * 0.6);

        return SizedBox(
          width: minSize,
          height: minSize,
          child: IconButton(
            icon: Icon(icon, size: adaptiveIconSize),
            onPressed: onPressed,
            tooltip: tooltip,
            color: color,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: minSize, minHeight: minSize),
          ),
        );
      },
    );
  }

  /// Creates adaptive spacing between widgets
  static Widget createAdaptiveSpacing({
    required AccessibilityService accessibilityService,
    Axis direction = Axis.vertical,
    double factor = 1.0,
  }) {
    return ListenableBuilder(
      listenable: accessibilityService,
      builder: (context, _) {
        final spacing = getOptimalSpacing(accessibilityService) * factor;

        return direction == Axis.vertical
            ? SizedBox(height: spacing)
            : SizedBox(width: spacing);
      },
    );
  }

  // get recommended tap target size based on age group
  static double getRecommendedTapTargetSize(int ageGroup) {
    if (ageGroup >= 60) {
      return seniorFriendlyMinimum;
    } else if (ageGroup >= 10) {
      return materialMinimum;
    } else {
      return materialMinimum * 0.8; // Slightly smaller for children
    }
  }

  /// Wraps a widget with adaptive touch feedback
  static Widget wrapWithTouchFeedback({
    required Widget child,
    required VoidCallback onTap,
    required AccessibilityService accessibilityService,
    Color? splashColor,
    Color? highlightColor,
    BorderRadius? borderRadius,
  }) {
    return ListenableBuilder(
      listenable: accessibilityService,
      builder: (context, _) {
        final minSize = getEffectiveMinTapTargetSize(accessibilityService);

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: splashColor,
            highlightColor: highlightColor,
            borderRadius: borderRadius,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: minSize,
                minHeight: minSize,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
