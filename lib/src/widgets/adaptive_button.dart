// lib/src/widgets/adaptive_button.dart

import 'package:flutter/material.dart';
import '../services/accessibility_service.dart';
import '../utils/tap_target_utils.dart';
import 'adaptive_text.dart';
import 'helpers/animated_adaptive_constraint.dart';

/// Base class for adaptive buttons with accessibility features
abstract class _AdaptiveButtonBase extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final String? text;
  final AccessibilityService? accessibilityService;
  final double? customMinTapTarget;
  final EdgeInsetsGeometry? padding;
  final String? semanticLabel;

  const _AdaptiveButtonBase({
    super.key, // Changed: Accept Key
    this.onPressed,
    this.child,
    this.text,
    this.accessibilityService,
    this.customMinTapTarget,
    this.padding,
    this.semanticLabel,
  }) : assert(
         child != null || text != null,
         'Either child or text must be provided',
       );

  AccessibilityService _getService(BuildContext context) {
    return accessibilityService ??
        context
            .findAncestorWidgetOfExactType<AdaptiveTextProvider>()
            ?.accessibilityService ??
        AccessibilityService(); // fallback
  }

  Widget _buildButtonChild(BuildContext context, AccessibilityService service) {
    if (child != null) return child!;

    return AdaptiveText(
      text!,
      accessibilityService: service,
      style: _getTextStyle(context),
      textAlign: TextAlign.center,
    );
  }

  TextStyle? _getTextStyle(BuildContext context);

  Widget _buildButtonWithConstraints({
    required BuildContext context,
    required AccessibilityService service,
    required Widget button,
  }) {
    return AnimatedAdaptiveConstraint(
      key: ObjectKey(
        key ?? text ?? child,
      ), // Added: Pass a key to AnimatedAdaptiveConstraint
      service: service,
      customMinTapTarget: customMinTapTarget,
      customPadding: padding,
      builder: (context, animatedMinSize, animatedPadding) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: animatedMinSize,
            minHeight: animatedMinSize,
          ),
          child: Padding(
            padding: animatedPadding,
            child: Semantics(
              label: semanticLabel,
              button: true,
              enabled: onPressed != null,
              child: button,
            ),
          ),
        );
      },
    );
  }
}

/// An elevated button that adapts to accessibility settings
class AdaptiveElevatedButton extends _AdaptiveButtonBase {
  final ButtonStyle? style;
  final Clip clipBehavior;
  final FocusNode? focusNode;
  final bool autofocus;

  const AdaptiveElevatedButton({
    super.key,
    required super.onPressed,
    super.child,
    super.text,
    this.style,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    super.accessibilityService,
    super.customMinTapTarget,
    super.padding,
    super.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final service = _getService(context);

    final button = ElevatedButton(
      onPressed: onPressed,
      style: _buildAdaptiveStyle(context, service),
      clipBehavior: clipBehavior,
      focusNode: focusNode,
      autofocus: autofocus,
      child: _buildButtonChild(context, service),
    );

    return _buildButtonWithConstraints(
      context: context,
      service: service,
      button: button,
    );
  }

  ButtonStyle _buildAdaptiveStyle(
    BuildContext context,
    AccessibilityService service,
  ) {
    final theme = Theme.of(context);
    final baseStyle =
        style ?? theme.elevatedButtonTheme.style ?? const ButtonStyle();

    return baseStyle.copyWith(
      // Enhanced padding for larger tap targets
      padding: WidgetStateProperty.all(
        padding ??
            TapTargetUtils.getAdaptivePadding(accessibilityService: service),
      ),
      // Minimum size constraints
      minimumSize: WidgetStateProperty.all(
        Size(
          customMinTapTarget ??
              TapTargetUtils.getEffectiveMinTapTargetSize(service),
          customMinTapTarget ??
              TapTargetUtils.getEffectiveMinTapTargetSize(service),
        ),
      ),
      // Enhanced focus and hover effects for better visibility
      elevation: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.focused)) return 8.0;
        if (states.contains(WidgetState.hovered)) return 6.0;
        return baseStyle.elevation?.resolve(states) ?? 2.0;
      }),
    );
  }

  @override
  TextStyle? _getTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = theme.elevatedButtonTheme.style;
    final themedTextStyle = buttonStyle?.textStyle?.resolve(
      const <WidgetState>{},
    );

    if (themedTextStyle?.color != null) {
      return themedTextStyle;
    }

    final foregroundColor = buttonStyle?.foregroundColor?.resolve(
      const <WidgetState>{},
    );
    if (foregroundColor != null) {
      final TextStyle baseStyleToMerge =
          themedTextStyle ?? theme.textTheme.labelLarge ?? const TextStyle();
      return baseStyleToMerge.copyWith(color: foregroundColor);
    }

    return theme.textTheme.labelLarge;
  }
}

/// An outlined button that adapts to accessibility settings
class AdaptiveOutlinedButton extends _AdaptiveButtonBase {
  final ButtonStyle? style;
  final Clip clipBehavior;
  final FocusNode? focusNode;
  final bool autofocus;

  const AdaptiveOutlinedButton({
    super.key,
    required super.onPressed,
    super.child,
    super.text,
    this.style,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    super.accessibilityService,
    super.customMinTapTarget,
    super.padding,
    super.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final service = _getService(context);

    final button = OutlinedButton(
      onPressed: onPressed,
      style: _buildAdaptiveStyle(context, service),
      clipBehavior: clipBehavior,
      focusNode: focusNode,
      autofocus: autofocus,
      child: _buildButtonChild(context, service),
    );

    return _buildButtonWithConstraints(
      context: context,
      service: service,
      button: button,
    );
  }

  ButtonStyle _buildAdaptiveStyle(
    BuildContext context,
    AccessibilityService service,
  ) {
    final theme = Theme.of(context);
    final baseStyle =
        style ?? theme.outlinedButtonTheme.style ?? const ButtonStyle();

    return baseStyle.copyWith(
      // Enhanced padding for larger tap targets
      padding: WidgetStateProperty.all(
        padding ??
            TapTargetUtils.getAdaptivePadding(accessibilityService: service),
      ),
      // Minimum size constraints
      minimumSize: WidgetStateProperty.all(
        Size(
          customMinTapTarget ??
              TapTargetUtils.getEffectiveMinTapTargetSize(service),
          customMinTapTarget ??
              TapTargetUtils.getEffectiveMinTapTargetSize(service),
        ),
      ),
      // Enhanced border for better visibility
      side: WidgetStateProperty.resolveWith((states) {
        final baseSide =
            baseStyle.side?.resolve(states) ??
            BorderSide(color: theme.colorScheme.outline);
        return baseSide.copyWith(
          width: service.shouldUseHighContrast() ? 2.0 : baseSide.width,
        );
      }),
    );
  }

  @override
  TextStyle? _getTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    return theme.outlinedButtonTheme.style?.textStyle?.resolve({}) ??
        theme.textTheme.labelLarge;
  }
}

/// A text button that adapts to accessibility settings
class AdaptiveTextButton extends _AdaptiveButtonBase {
  final ButtonStyle? style;
  final Clip clipBehavior;
  final FocusNode? focusNode;
  final bool autofocus;

  const AdaptiveTextButton({
    super.key,
    required super.onPressed,
    super.child,
    super.text,
    this.style,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    super.accessibilityService,
    super.customMinTapTarget,
    super.padding,
    super.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final service = _getService(context);

    final button = TextButton(
      onPressed: onPressed,
      style: _buildAdaptiveStyle(context, service),
      clipBehavior: clipBehavior,
      focusNode: focusNode,
      autofocus: autofocus,
      child: _buildButtonChild(context, service),
    );

    return _buildButtonWithConstraints(
      context: context,
      service: service,
      button: button,
    );
  }

  ButtonStyle _buildAdaptiveStyle(
    BuildContext context,
    AccessibilityService service,
  ) {
    final theme = Theme.of(context);
    final baseStyle =
        style ?? theme.textButtonTheme.style ?? const ButtonStyle();

    return baseStyle.copyWith(
      padding: WidgetStateProperty.all(
        padding ??
            TapTargetUtils.getAdaptivePadding(accessibilityService: service),
      ),
      minimumSize: WidgetStateProperty.all(
        Size(
          customMinTapTarget ??
              TapTargetUtils.getEffectiveMinTapTargetSize(service),
          customMinTapTarget ??
              TapTargetUtils.getEffectiveMinTapTargetSize(service),
        ),
      ),
      // Enhanced overlay for better feedback
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return theme.colorScheme.primary.withValues(alpha: 0.2);
        }
        if (states.contains(WidgetState.hovered)) {
          return theme.colorScheme.primary.withValues(alpha: 0.1);
        }
        return null;
      }),
    );
  }

  @override
  TextStyle? _getTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    return theme.textButtonTheme.style?.textStyle?.resolve({}) ??
        theme.textTheme.labelLarge;
  }
}

/// An icon button that adapts to accessibility settings
class AdaptiveIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final double? iconSize;
  final Color? color;
  final String? tooltip;
  final AccessibilityService? accessibilityService;
  final double? customMinTapTarget;
  final String? semanticLabel;
  final ButtonStyle? style;

  const AdaptiveIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.iconSize,
    this.color,
    this.tooltip,
    this.accessibilityService,
    this.customMinTapTarget,
    this.semanticLabel,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final service =
        accessibilityService ??
        context
            .findAncestorWidgetOfExactType<AdaptiveTextProvider>()
            ?.accessibilityService ??
        AccessibilityService();

    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        final minSize =
            customMinTapTarget ??
            TapTargetUtils.getEffectiveMinTapTargetSize(service);
        final adaptiveIconSize = iconSize ?? (minSize * 0.6);

        return Semantics(
          button: true,
          enabled: onPressed != null,
          label: semanticLabel ?? tooltip,
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon, size: adaptiveIconSize),
            color: color,
            tooltip: tooltip,
            style: _buildAdaptiveStyle(context, service, minSize),
            padding: EdgeInsets.zero,
          ),
        );
      },
    );
  }

  ButtonStyle _buildAdaptiveStyle(
    BuildContext context,
    AccessibilityService service,
    double minSize,
  ) {
    final theme = Theme.of(context);
    final baseStyle =
        style ?? theme.iconButtonTheme.style ?? const ButtonStyle();

    return baseStyle.copyWith(
      minimumSize: WidgetStateProperty.all(Size(minSize, minSize)),
      fixedSize: WidgetStateProperty.all(Size(minSize, minSize)),
      // Enhanced feedback for better usability
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return theme.colorScheme.primary.withValues(alpha: 0.2);
        }
        if (states.contains(WidgetState.hovered)) {
          return theme.colorScheme.primary.withValues(alpha: 0.1);
        }
        return null;
      }),
    );
  }
}

/// A floating action button that adapts to accessibility settings
class AdaptiveFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final IconData? icon;
  final String? tooltip;
  final String? heroTag;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final AccessibilityService? accessibilityService;
  final double? customSize;
  final String? semanticLabel;

  const AdaptiveFloatingActionButton({
    super.key,
    required this.onPressed,
    this.child,
    this.icon,
    this.tooltip,
    this.heroTag,
    this.backgroundColor,
    this.foregroundColor,
    this.accessibilityService,
    this.customSize,
    this.semanticLabel,
  }) : assert(
         child != null || icon != null,
         'Either child or icon must be provided',
       );

  @override
  Widget build(BuildContext context) {
    final service =
        accessibilityService ??
        context
            .findAncestorWidgetOfExactType<AdaptiveTextProvider>()
            ?.accessibilityService ??
        AccessibilityService();

    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        final minSize =
            customSize ??
            (TapTargetUtils.getEffectiveMinTapTargetSize(service) +
                8.0); // Slightly larger than minimum

        final fabChild = child ?? Icon(icon);

        return SizedBox(
          width: minSize,
          height: minSize,
          child: Semantics(
            button: true,
            enabled: onPressed != null,
            label: semanticLabel ?? tooltip,
            child: FloatingActionButton(
              onPressed: onPressed,
              tooltip: tooltip,
              heroTag: heroTag,
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              child: fabChild,
            ),
          ),
        );
      },
    );
  }
}

/// A segmented button that adapts to accessibility settings
class AdaptiveSegmentedButton<T> extends StatelessWidget {
  final Set<T> selected;
  final ValueChanged<Set<T>>? onSelectionChanged;
  final List<ButtonSegment<T>> segments;
  final bool multiSelectionEnabled;
  final bool emptySelectionAllowed;
  final AccessibilityService? accessibilityService;
  final double? customMinTapTarget;

  const AdaptiveSegmentedButton({
    super.key,
    required this.segments,
    required this.selected,
    this.onSelectionChanged,
    this.multiSelectionEnabled = false,
    this.emptySelectionAllowed = false,
    this.accessibilityService,
    this.customMinTapTarget,
  });

  @override
  Widget build(BuildContext context) {
    final service =
        accessibilityService ??
        context
            .findAncestorWidgetOfExactType<AdaptiveTextProvider>()
            ?.accessibilityService ??
        AccessibilityService();

    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        final minSize =
            customMinTapTarget ??
            TapTargetUtils.getEffectiveMinTapTargetSize(service);

        return SegmentedButton<T>(
          segments: segments
              .map(
                (segment) => ButtonSegment<T>(
                  value: segment.value,
                  label: segment.label,
                  icon: segment.icon,
                  tooltip: segment.tooltip,
                  enabled: segment.enabled,
                ),
              )
              .toList(),
          selected: selected,
          onSelectionChanged: onSelectionChanged,
          multiSelectionEnabled: multiSelectionEnabled,
          emptySelectionAllowed: emptySelectionAllowed,
          style: ButtonStyle(
            minimumSize: WidgetStateProperty.all(Size(minSize, minSize)),
            padding: WidgetStateProperty.all(
              TapTargetUtils.getAdaptivePadding(accessibilityService: service),
            ),
          ),
        );
      },
    );
  }
}
