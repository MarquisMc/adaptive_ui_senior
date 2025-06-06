// lib/src/widgets/adaptive_text.dart

import 'package:flutter/material.dart';
import '../services/accessibility_service.dart';
import '../utils/font_scale_utils.dart';

class AdaptiveText extends StatelessWidget {
  // The text to display
  final String data;

  /// The style to apply to the text
  final TextStyle? style;

  /// How the text should be aligned horizontally
  final TextAlign? textAlign;

  /// Text direction
  final TextDirection? textDirection;

  /// Locale for text
  final Locale? locale;

  /// Whether the text should break at soft line breaks
  final bool? softWrap;

  /// How visual overflow should be handled
  final TextOverflow? overflow;

  /// Maximum number of lines for this text to span
  final int? maxLines;

  /// Minimum number of lines to occupy
  final int? minLines;

  /// Text scale factor
  final double? textScaleFactor;

  /// Semantic label for accessibility
  final String? semanticsLabel;

  /// Widget span to include in the text
  final InlineSpan? textSpan;

  /// Accessibility service instance (optional, will use global if not provided)
  final AccessibilityService? accessibilityService;

  /// Whether to automatically adjust line height for better readability
  final bool autoAdjustLineHeight;

  /// Custom font scale multiplier (multiplies with accessibility settings)
  final double? customScale;

  static const Duration _animationDuration = Duration(milliseconds: 200);
  static const Curve _animationCurve = Curves.linear;

  const AdaptiveText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.minLines,
    this.textScaleFactor,
    this.semanticsLabel,
    this.accessibilityService,
    this.autoAdjustLineHeight = true,
    this.customScale,
  }) : textSpan = null;

  /// Creates an AdaptiveText with rich text content
  const AdaptiveText.rich(
    this.textSpan, {
    super.key,
    this.style,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.minLines,
    this.textScaleFactor,
    this.semanticsLabel,
    this.accessibilityService,
    this.autoAdjustLineHeight = true,
    this.customScale,
  }) : data = '';

  @override
  Widget build(BuildContext context) {
    // Correctly look up AccessibilityService from AdaptiveTextProvider
    final serviceFromProvider = AdaptiveTextProvider.of(
      context,
    )?.accessibilityService;
    final service = accessibilityService ?? serviceFromProvider;

    if (service == null) {
      // Fallback to regular Text if no accessibility service is available
      // Applying style directly without animation
      return _buildTextWidget(
        context,
        style ?? DefaultTextStyle.of(context).style,
      );
    }
    return ListenableBuilder(
      listenable: service,
      builder: (context, child) {
        final initialStyle = style ?? DefaultTextStyle.of(context).style;
        final baseFontSize = initialStyle.fontSize ?? 14.0;
        final targetFontScale = customScale ?? service.getEffectiveFontScale();
        final targetFontSize = baseFontSize * targetFontScale;

        return TweenAnimationBuilder<double>(
          tween: Tween<double>(end: targetFontSize),
          duration: _animationDuration,
          curve: _animationCurve,
          builder:
              (
                BuildContext context,
                double animatedFontSize,
                Widget? builderChild,
              ) {
                TextStyle currentAnimatedStyle = initialStyle.copyWith(
                  fontSize: FontScaleUtils.ensureMinimumFontSize(
                    animatedFontSize,
                  ),
                );

                if (autoAdjustLineHeight) {
                  currentAnimatedStyle = currentAnimatedStyle.copyWith(
                    height: FontScaleUtils.getOptimalLineHeight(
                      currentAnimatedStyle.fontSize!,
                    ),
                  );
                }
                // High contrast color is typically handled by the theme itself when HC mode is active.
                // AdaptiveText primarily focuses on scaling size and line height.
                return _buildTextWidget(context, currentAnimatedStyle);
              },
        );
      },
    );
  }

  /// Builds the text widget with the given style
  Widget _buildTextWidget(BuildContext context, TextStyle? textStyle) {
    final scaler = textScaleFactor != null
        ? TextScaler.linear(textScaleFactor!)
        : MediaQuery.textScalerOf(context);

    if (textSpan != null) {
      return Text.rich(
        textSpan!,
        style: textStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaler: scaler,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
      );
    }

    return Text(
      data,
      style: textStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: scaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
    );
  }

  /// Builds an adapted text style based on accessibility settings
  TextStyle _buildAdaptedStyle(
    BuildContext context,
    AccessibilityService service,
  ) {
    // If 'this.style' (the constructor parameter) is non-null, it's the primary style.
    // Otherwise, use DefaultTextStyle from the context (e.g., SnackBar's contentTextStyle).
    final TextStyle initialStyle = style ?? DefaultTextStyle.of(context).style;

    // Check if the initialStyle (either from constructor or DefaultTextStyle) already has a color.
    final bool initialStyleHasColor = initialStyle.color != null;

    final effectiveFontScale = customScale ?? service.getEffectiveFontScale();
    TextStyle finalStyle = initialStyle.copyWith(
      fontSize: (initialStyle.fontSize ?? 14.0) * effectiveFontScale,
    );

    // Line height adjustment
    if (autoAdjustLineHeight) {
      finalStyle = finalStyle.copyWith(
        height: FontScaleUtils.getOptimalLineHeight(
          (initialStyle.fontSize ?? 14.0) * effectiveFontScale,
        ),
      );
    }

    // High contrast color adjustment
    if (service.shouldUseHighContrast()) {
      // Only apply generic high-contrast text color if the initial style didn't specify one.
      // This allows specific components (like SnackBar) to provide their own themed text colors
      // which should be respected even in high contrast mode.
      if (!initialStyleHasColor) {
        final theme = Theme.of(context);
        // Use onSurface as a general high-contrast text color.
        // This is generally safer than bodyLarge.color for contrasting with various backgrounds.
        final hcTextColor = theme.colorScheme.onSurface;
        finalStyle = finalStyle.copyWith(color: hcTextColor);
      }
      // If initialStyleHasColor is true, we assume that color is appropriate for its context
      // (e.g., SnackBarTheme's contentTextStyle is designed for its background).
    }
    return finalStyle;
  }
}

/// Wraps a widget tree with accessibility service provider
class AdaptiveTextProvider extends InheritedWidget {
  final AccessibilityService accessibilityService;

  const AdaptiveTextProvider({
    super.key,
    required this.accessibilityService,
    required super.child,
  });

  static AdaptiveTextProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AdaptiveTextProvider>();
  }

  @override
  bool updateShouldNotify(AdaptiveTextProvider oldWidget) {
    // Notify if the service instance itself changes, or if its settings change.
    // Since AccessibilityService is a Listenable, widgets listening directly
    // to it will rebuild. This InheritedWidget rebuilds dependents if the
    // service *instance* changes.
    return accessibilityService != oldWidget.accessibilityService;
  }
}

/// Specialized adaptive text widgets for common use cases
/// Large heading text optimized for senior users
class AdaptiveHeading extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final AccessibilityService? accessibilityService;
  final int level; // 1-6 heading levels

  const AdaptiveHeading(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.accessibilityService,
    this.level = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final TextStyle baseStyle;

    switch (level) {
      case 1:
        baseStyle =
            theme.textTheme.displayLarge ??
            const TextStyle(fontSize: 32, fontWeight: FontWeight.bold);
        break;
      case 2:
        baseStyle =
            theme.textTheme.displayMedium ??
            const TextStyle(fontSize: 28, fontWeight: FontWeight.bold);
        break;
      case 3:
        baseStyle =
            theme.textTheme.displaySmall ??
            const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
        break;
      case 4:
        baseStyle =
            theme.textTheme.headlineLarge ??
            const TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
        break;
      case 5:
        baseStyle =
            theme.textTheme.headlineMedium ??
            const TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
        break;
      case 6:
      default:
        baseStyle =
            theme.textTheme.headlineSmall ??
            const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
        break;
    }

    return Semantics(
      header: true,
      child: AdaptiveText(
        text,
        style: style != null ? baseStyle.merge(style) : baseStyle,
        textAlign: textAlign,
        accessibilityService: accessibilityService,
        autoAdjustLineHeight: true,
      ),
    );
  }
}

// Body text optimized for reading
class AdaptiveBodyText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final AccessibilityService? accessibilityService;

  const AdaptiveBodyText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.accessibilityService,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle =
        theme.textTheme.bodyLarge ?? const TextStyle(fontSize: 16);

    return AdaptiveText(
      text,
      style: style != null ? baseStyle.merge(style) : baseStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      accessibilityService: accessibilityService,
      autoAdjustLineHeight: true,
    );
  }
}

/// Caption text with enhanced readability
class AdaptiveCaption extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final AccessibilityService? accessibilityService;

  const AdaptiveCaption(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.accessibilityService,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle =
        theme.textTheme.bodySmall ?? const TextStyle(fontSize: 12);

    return AdaptiveText(
      text,
      style: style != null ? baseStyle.merge(style) : baseStyle,
      textAlign: textAlign,
      accessibilityService: accessibilityService,
      autoAdjustLineHeight: true,
      // Ensure captions don't become too small
      customScale: 1.1,
    );
  }
}
