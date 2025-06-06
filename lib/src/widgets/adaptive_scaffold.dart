// lib/src/widgets/adaptive_scaffold.dart

import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../services/accessibility_service.dart';
import '../utils/font_scale_utils.dart';
import '../utils/tap_target_utils.dart';
import 'adaptive_text.dart';
import 'adaptive_button.dart';

/// A scaffold that adapts to accessibility settings for senior users
class AdaptiveScaffold extends StatelessWidget {
  /// The primary content of the scaffold
  final Widget? body;

  /// The app bar of the scaffold
  final PreferredSizeWidget? appBar;

  /// A floating action button
  final Widget? floatingActionButton;

  /// Position of the floating action button
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Persistent bottom sheet
  final Widget? persistentFooterButtons;

  /// Bottom navigation bar
  final Widget? bottomNavigationBar;

  /// Navigation drawer
  final Widget? drawer;

  /// End drawer
  final Widget? endDrawer;

  /// Background color
  final Color? backgroundColor;

  /// Whether to resize body when keyboard appears
  final bool? resizeToAvoidBottomInset;

  /// Whether the body should extend behind the app bar
  final bool extendBodyBehindAppBar;

  /// Whether the body should extend behind the bottom bar
  final bool extendBody;

  /// Drawer drag start behavior
  final DragStartBehavior drawerDragStartBehavior;

  /// Accessibility service instance
  final AccessibilityService? accessibilityService;

  /// Whether to apply adaptive padding to the body
  final bool adaptiveBodyPadding;

  /// Whether to enhance focus indicators
  final bool enhancedFocusIndicators;

  const AdaptiveScaffold({
    super.key,
    this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.persistentFooterButtons,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.extendBodyBehindAppBar = false,
    this.extendBody = false,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.accessibilityService,
    this.adaptiveBodyPadding = true,
    this.enhancedFocusIndicators = true,
  });

  @override
  Widget build(BuildContext context) {
    final service = accessibilityService ?? AccessibilityService();

    return AdaptiveTextProvider(
      accessibilityService: service,
      child: ListenableBuilder(
        listenable: service,
        builder: (context, _) {
          return Scaffold(
            appBar: appBar != null
                ? _buildAdaptiveAppBar(context, service)
                : null,
            body: _buildAdaptiveBody(context, service),
            floatingActionButton: _buildAdaptiveFAB(context, service),
            floatingActionButtonLocation: floatingActionButtonLocation,
            persistentFooterButtons: _buildAdaptiveFooterButtons(
              context,
              service,
            ),
            bottomNavigationBar: _buildAdaptiveBottomNav(context, service),
            drawer: _buildAdaptiveDrawer(context, service),
            endDrawer: _buildAdaptiveEndDrawer(context, service),
            backgroundColor: backgroundColor,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            extendBodyBehindAppBar: extendBodyBehindAppBar,
            extendBody: extendBody,
            drawerDragStartBehavior: drawerDragStartBehavior,
          );
        },
      ),
    );
  }

  /// Builds an adaptive app bar with enhanced accessibility
  PreferredSizeWidget? _buildAdaptiveAppBar(
    BuildContext context,
    AccessibilityService service,
  ) {
    if (appBar == null) return null;

    // If it's already an AdaptiveAppBar, return as-is
    if (appBar is AdaptiveAppBar) return appBar;

    // For standard AppBar, wrap with enhanced accessibility
    if (appBar is AppBar) {
      final originalAppBar = appBar as AppBar;
      return AdaptiveAppBar(
        title: originalAppBar.title,
        leading: originalAppBar.leading,
        actions: originalAppBar.actions,
        backgroundColor: originalAppBar.backgroundColor,
        foregroundColor: originalAppBar.foregroundColor,
        elevation: originalAppBar.elevation,
        centerTitle: originalAppBar.centerTitle,
        accessibilityService: service,
      );
    }

    return appBar;
  }

  /// Builds adaptive body with optional padding
  Widget? _buildAdaptiveBody(
    BuildContext context,
    AccessibilityService service,
  ) {
    if (body == null) return null;

    if (!adaptiveBodyPadding) return body;

    final spacing = TapTargetUtils.getOptimalSpacing(service);
    return Padding(padding: EdgeInsets.all(spacing), child: body);
  }

  /// Builds adaptive floating action button
  Widget? _buildAdaptiveFAB(
    BuildContext context,
    AccessibilityService service,
  ) {
    if (floatingActionButton == null) return null;

    // If it's already adaptive, return as-is
    if (floatingActionButton is AdaptiveFloatingActionButton) {
      return floatingActionButton;
    }

    return floatingActionButton;
  }

  /// Builds adaptive footer buttons
  List<Widget>? _buildAdaptiveFooterButtons(
    BuildContext context,
    AccessibilityService service,
  ) {
    if (persistentFooterButtons == null) return null;

    // This should be a list of buttons, but we can't modify it directly
    // Users should use AdaptiveButton widgets in their footer buttons
    return [persistentFooterButtons!];
  }

  /// Builds adaptive bottom navigation bar
  Widget? _buildAdaptiveBottomNav(
    BuildContext context,
    AccessibilityService service,
  ) {
    if (bottomNavigationBar == null) return null;

    // If it's already adaptive, return as-is
    if (bottomNavigationBar is AdaptiveBottomNavigationBar) {
      return bottomNavigationBar;
    }

    return bottomNavigationBar;
  }

  /// Builds adaptive drawer
  Widget? _buildAdaptiveDrawer(
    BuildContext context,
    AccessibilityService service,
  ) {
    if (drawer == null) return null;

    // If it's already adaptive, return as-is
    if (drawer is AdaptiveDrawer) return drawer;

    return drawer;
  }

  /// Builds adaptive end drawer
  Widget? _buildAdaptiveEndDrawer(
    BuildContext context,
    AccessibilityService service,
  ) {
    if (endDrawer == null) return null;

    // If it's already adaptive, return as-is
    if (endDrawer is AdaptiveDrawer) return endDrawer;

    return endDrawer;
  }
}

/// An adaptive app bar with enhanced accessibility features
class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool? centerTitle;
  final AccessibilityService? accessibilityService;
  final double? customHeight;

  const AdaptiveAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.centerTitle,
    this.accessibilityService,
    this.customHeight,
  });

  @override
  Widget build(BuildContext context) {
    final service = accessibilityService ?? AccessibilityService();

    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        return AppBar(
          title: title,
          leading: leading,
          actions: _buildAdaptiveActions(context, service),
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: elevation,
          centerTitle:
              centerTitle ?? true, // Center titles for better readability
          toolbarHeight: customHeight ?? _getAdaptiveHeight(service),
        );
      },
    );
  }

  /// Builds adaptive action buttons
  List<Widget>? _buildAdaptiveActions(
    BuildContext context,
    AccessibilityService service,
  ) {
    if (actions == null) return null;

    return actions!.map((action) {
      // If it's already an adaptive button, return as-is
      if (action is AdaptiveIconButton || action is AdaptiveTextButton) {
        return action;
      }

      // Add spacing between actions for easier tapping
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: TapTargetUtils.getOptimalSpacing(service) / 2,
        ),
        child: action,
      );
    }).toList();
  }

  /// Gets adaptive app bar height
  double _getAdaptiveHeight(AccessibilityService service) {
    final baseHeight = kToolbarHeight;
    final minTapTarget = TapTargetUtils.getEffectiveMinTapTargetSize(service);
    return minTapTarget > baseHeight ? minTapTarget : baseHeight;
  }

  @override
  Size get preferredSize => Size.fromHeight(customHeight ?? kToolbarHeight);
}

/// An adaptive bottom navigation bar with enhanced accessibility
class AdaptiveBottomNavigationBar extends StatelessWidget {
  final List<BottomNavigationBarItem> items;
  final ValueChanged<int>? onTap;
  final int currentIndex;
  final BottomNavigationBarType? type;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final AccessibilityService? accessibilityService;

  const AdaptiveBottomNavigationBar({
    super.key,
    required this.items,
    this.onTap,
    this.currentIndex = 0,
    this.type,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.accessibilityService,
  });

  @override
  Widget build(BuildContext context) {
    final service = accessibilityService ?? AccessibilityService();

    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        final currentMinTapTarget = TapTargetUtils.getEffectiveMinTapTargetSize(
          service,
        );
        final selectedScaledFontSize = _getSelectedFontSize(service);

        // Calculate icon height
        final iconHeight = currentMinTapTarget * 0.4;

        // Calculate text height for one line
        final textPainter = TextPainter(
          text: TextSpan(
            text:
                'Tg', // Sample text to measure, content doesn't matter for height
            style: TextStyle(fontSize: selectedScaledFontSize),
          ),
          textDirection: TextDirection.ltr, // Or use Directionality.of(context)
        );
        textPainter.layout();
        final oneLineTextHeight = textPainter.height;

        // Assume labels might wrap to two lines at maximum font sizes
        final maxExpectedTextHeight = oneLineTextHeight * 2.0;

        // Standard spacing between icon and label in BottomNavigationBar
        const double spacingBetweenIconAndLabel = 8.0;

        // Calculate dynamic internal padding (top + bottom) for the BNB
        // Based on default BNB padding scaling with optimal spacing
        // Increased multiplier from 2.0 to 4.0 to provide more vertical space
        final internalVerticalPadding =
            TapTargetUtils.getOptimalSpacing(service) * 4.0;

        // Calculate the total required inner height
        final requiredInnerHeight =
            iconHeight +
            spacingBetweenIconAndLabel +
            maxExpectedTextHeight +
            internalVerticalPadding;

        // Ensure the final height is at least kBottomNavigationBarHeight
        final calculatedHeight = math.max(
          kBottomNavigationBarHeight, // Default minimum height (56.0)
          requiredInnerHeight,
        );

        return SizedBox(
          height: calculatedHeight, // Extra padding for comfortable tapping
          child: BottomNavigationBar(
            items: _buildAdaptiveItems(context, service),
            onTap: onTap,
            currentIndex: currentIndex,
            type: type ?? BottomNavigationBarType.fixed,
            backgroundColor: backgroundColor,
            selectedItemColor: selectedItemColor,
            unselectedItemColor: unselectedItemColor,
            selectedFontSize: _getSelectedFontSize(service),
            unselectedFontSize: _getUnselectedFontSize(service),
          ),
        );
      },
    );
  }

  /// Builds adaptive navigation items
  List<BottomNavigationBarItem> _buildAdaptiveItems(
    BuildContext context,
    AccessibilityService service,
  ) {
    return items.map((item) {
      return BottomNavigationBarItem(
        icon: _buildAdaptiveIcon(item.icon, service),
        activeIcon: _buildAdaptiveIcon(
          item.activeIcon,
          service,
        ), // Ensure activeIcon is also handled
        label: item.label,
        backgroundColor: item.backgroundColor,
        tooltip: item.tooltip,
      );
    }).toList();
  }

  /// Builds adaptive icon with proper sizing
  Widget _buildAdaptiveIcon(Widget icon, AccessibilityService service) {
    final minTapTarget = TapTargetUtils.getEffectiveMinTapTargetSize(service);
    final iconSize = minTapTarget * 0.4; // 40% of tap target

    if (icon is Icon) {
      return Icon(icon.icon, size: iconSize, color: icon.color);
    }

    return SizedBox(width: iconSize, height: iconSize, child: icon);
  }

  double _getSelectedFontSize(AccessibilityService service) {
    // Ensure FontScaleUtils is accessible or use direct calculation
    return FontScaleUtils.getScaledFontSize(
      baseFontSize: 14.0,
      accessibilityService: service,
    );
  }

  double _getUnselectedFontSize(AccessibilityService service) {
    // Ensure FontScaleUtils is accessible or use direct calculation
    return FontScaleUtils.getScaledFontSize(
      baseFontSize: 12.0,
      accessibilityService: service,
    );
  }
}

/// An adaptive drawer with enhanced accessibility
class AdaptiveDrawer extends StatelessWidget {
  final Widget? child;
  final Color? backgroundColor;
  final double? elevation;
  final String? semanticLabel;
  final AccessibilityService? accessibilityService;

  const AdaptiveDrawer({
    super.key,
    this.child,
    this.backgroundColor,
    this.elevation,
    this.semanticLabel,
    this.accessibilityService,
  });

  @override
  Widget build(BuildContext context) {
    final service = accessibilityService ?? AccessibilityService();

    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        final spacing = TapTargetUtils.getOptimalSpacing(service);

        return Drawer(
          backgroundColor: backgroundColor,
          elevation: elevation,
          semanticLabel: semanticLabel,
          child: child != null
              ? Padding(padding: EdgeInsets.all(spacing), child: child)
              : null,
        );
      },
    );
  }
}
