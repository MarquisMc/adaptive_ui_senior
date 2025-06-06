// lib/src/widgets/accessibility_settings_panel.dart

import 'package:flutter/material.dart';
import '../services/accessibility_service.dart';
import '../utils/font_scale_utils.dart';
import '../utils/tap_target_utils.dart';
import 'adaptive_text.dart';
import 'adaptive_button.dart';
import 'adaptive_scaffold.dart';

/// A comprehensive settings panel for accessibility options
class AccessibilitySettingsPanel extends StatefulWidget {
  /// The accessibility service to manage settings
  final AccessibilityService accessibilityService;

  /// Whether to show advanced options
  final bool showAdvancedOptions;

  /// Custom title for the panel
  final String? title;

  /// Callback when settings are changed
  final VoidCallback? onSettingsChanged;

  /// Whether to show the reset button
  final bool showResetButton;

  /// Whether to show preset buttons
  final bool showPresets;

  const AccessibilitySettingsPanel({
    super.key,
    required this.accessibilityService,
    this.showAdvancedOptions = true,
    this.title,
    this.onSettingsChanged,
    this.showResetButton = true,
    this.showPresets = true,
  });

  @override
  State<AccessibilitySettingsPanel> createState() =>
      _AccessibilitySettingsPanelState();
}

class _AccessibilitySettingsPanelState
    extends State<AccessibilitySettingsPanel> {
  late AccessibilityService _service;

  @override
  void initState() {
    super.initState();
    _service = widget.accessibilityService;
    _service.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _service.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    setState(() {});
    widget.onSettingsChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      accessibilityService: _service,
      appBar: AdaptiveAppBar(
        title: AdaptiveText(
          widget.title ?? 'Accessibility Settings',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        accessibilityService: _service,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(TapTargetUtils.getOptimalSpacing(_service)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.showPresets) ...[
              _buildPresetsSection(),
              _buildSectionDivider(),
            ],
            _buildFontScaleSection(),
            _buildSectionDivider(),
            _buildHighContrastSection(),
            _buildSectionDivider(),
            _buildTapTargetSection(),
            _buildSectionDivider(),
            _buildThemeModeSection(),
            if (widget.showAdvancedOptions) ...[
              _buildSectionDivider(),
              _buildAdvancedSection(),
            ],
            if (widget.showResetButton) ...[
              _buildSectionDivider(),
              _buildResetSection(),
            ],
            // Add extra space at bottom for easier scrolling
            SizedBox(height: TapTargetUtils.getOptimalSpacing(_service) * 2),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetsSection() {
    return _buildSection(
      title: 'Quick Settings',
      child: Column(
        children: [
          AdaptiveText(
            'Choose a preset configuration optimized for your needs.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: TapTargetUtils.getOptimalSpacing(_service)),
          Wrap(
            spacing: TapTargetUtils.getOptimalSpacing(_service),
            runSpacing: TapTargetUtils.getOptimalSpacing(_service) / 2,
            children: [
              AdaptiveElevatedButton(
                text: 'Senior Friendly',
                onPressed: () => _service.applySeniorFriendlyDefaults(),
                accessibilityService: _service,
                semanticLabel:
                    'Apply senior-friendly settings with larger text and buttons',
              ),
              AdaptiveOutlinedButton(
                text: 'Standard',
                onPressed: () => _service.resetToDefaults(),
                accessibilityService: _service,
                semanticLabel: 'Reset to standard accessibility settings',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFontScaleSection() {
    final currentScale = _service.settings.fontScale;

    return _buildSection(
      title: 'Text Size',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdaptiveText(
            'Current: ${FontScaleUtils.getFontScaleDescription(currentScale)}',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: TapTargetUtils.getOptimalSpacing(_service)),

          // Font scale slider
          Row(
            children: [
              AdaptiveText(
                'Small',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Expanded(
                child: Slider(
                  value: currentScale,
                  min: 0.8,
                  max: 2.0,
                  divisions: 12,
                  label: FontScaleUtils.getFontScaleDescription(currentScale),
                  onChanged: (value) => _service.updateFontScale(value),
                ),
              ),
              AdaptiveText(
                'Large',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),

          SizedBox(height: TapTargetUtils.getOptimalSpacing(_service)),

          // Preset buttons
          Wrap(
            spacing: TapTargetUtils.getOptimalSpacing(_service) / 2,
            runSpacing: TapTargetUtils.getOptimalSpacing(_service) / 2,
            children: FontScaleUtils.fontScalePresets.entries.map((entry) {
              final isSelected = (currentScale - entry.value).abs() < 0.01;
              return isSelected
                  ? AdaptiveElevatedButton(
                      text: entry.key,
                      onPressed: () => _service.updateFontScale(entry.value),
                      accessibilityService: _service,
                    )
                  : AdaptiveOutlinedButton(
                      text: entry.key,
                      onPressed: () => _service.updateFontScale(entry.value),
                      accessibilityService: _service,
                    );
            }).toList(),
          ),

          SizedBox(height: TapTargetUtils.getOptimalSpacing(_service)),

          // Preview text
          Card(
            child: Padding(
              padding: EdgeInsets.all(
                TapTargetUtils.getOptimalSpacing(_service),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdaptiveText(
                    'Preview Text',
                    style: Theme.of(context).textTheme.titleMedium,
                    accessibilityService: _service,
                  ),
                  SizedBox(
                    height: TapTargetUtils.getOptimalSpacing(_service) / 2,
                  ),
                  AdaptiveText(
                    'This is how text will appear with your current settings. You can adjust the size using the controls above.',
                    accessibilityService: _service,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighContrastSection() {
    return _buildSection(
      title: 'High Contrast',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdaptiveText(
                      'Enhanced Contrast',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    AdaptiveText(
                      'Improves text and interface visibility with stronger color contrasts.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Switch(
                value: _service.settings.highContrastMode,
                onChanged: (_) => _service.toggleHighContrast(),
              ),
            ],
          ),

          if (_service.settings.highContrastMode) ...[
            SizedBox(height: TapTargetUtils.getOptimalSpacing(_service)),
            Card(
              color: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: EdgeInsets.all(
                  TapTargetUtils.getOptimalSpacing(_service),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    SizedBox(
                      width: TapTargetUtils.getOptimalSpacing(_service) / 2,
                    ),
                    Expanded(
                      child: AdaptiveText(
                        'High contrast mode is active. The app appearance has changed to improve visibility.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        accessibilityService: _service,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTapTargetSection() {
    final currentSize = _service.settings.minTapTargetSize;

    return _buildSection(
      title: 'Button & Touch Size',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdaptiveText(
                      'Larger Touch Targets',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    AdaptiveText(
                      'Makes buttons and interactive elements easier to tap.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Switch(
                value: _service.settings.largerTapTargets,
                onChanged: (_) => _service.toggleLargerTapTargets(),
              ),
            ],
          ),

          if (_service.settings.largerTapTargets) ...[
            SizedBox(height: TapTargetUtils.getOptimalSpacing(_service)),

            AdaptiveText(
              'Minimum Size: ${TapTargetUtils.getTapTargetSizeDescription(currentSize)}',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            ),

            SizedBox(height: TapTargetUtils.getOptimalSpacing(_service) / 2),

            Slider(
              value: currentSize,
              min: 44.0,
              max: 80.0,
              divisions: 9,
              label: TapTargetUtils.getTapTargetSizeDescription(currentSize),
              onChanged: (value) => _service.updateMinTapTargetSize(value),
            ),

            SizedBox(height: TapTargetUtils.getOptimalSpacing(_service)),

            // Preset buttons
            Wrap(
              spacing: TapTargetUtils.getOptimalSpacing(_service) / 2,
              runSpacing: TapTargetUtils.getOptimalSpacing(_service) / 2,
              children: TapTargetUtils.tapTargetPresets.entries.map((entry) {
                final isSelected = (currentSize - entry.value).abs() < 1.0;
                return isSelected
                    ? AdaptiveElevatedButton(
                        text: entry.key,
                        onPressed: () =>
                            _service.updateMinTapTargetSize(entry.value),
                        accessibilityService: _service,
                      )
                    : AdaptiveOutlinedButton(
                        text: entry.key,
                        onPressed: () =>
                            _service.updateMinTapTargetSize(entry.value),
                        accessibilityService: _service,
                      );
              }).toList(),
            ),

            SizedBox(height: TapTargetUtils.getOptimalSpacing(_service)),

            // Preview buttons
            Card(
              child: Padding(
                padding: EdgeInsets.all(
                  TapTargetUtils.getOptimalSpacing(_service),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdaptiveText(
                      'Button Preview',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(
                      height: TapTargetUtils.getOptimalSpacing(_service) / 2,
                    ),
                    Wrap(
                      spacing: TapTargetUtils.getOptimalSpacing(_service) / 2,
                      runSpacing:
                          TapTargetUtils.getOptimalSpacing(_service) / 2,
                      children: [
                        AdaptiveElevatedButton(
                          text: 'Sample Button',
                          onPressed: () {},
                          accessibilityService: _service,
                        ),
                        AdaptiveIconButton(
                          icon: Icons.favorite,
                          onPressed: () {},
                          accessibilityService: _service,
                          tooltip: 'Sample Icon Button',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildThemeModeSection() {
    final currentThemeMode = _service.settings.themeMode;
    return _buildSection(
      title: 'Appearance',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdaptiveText(
            'Choose your preferred app theme.',
            style: Theme.of(context).textTheme.bodyMedium,
            accessibilityService: _service,
          ),
          SizedBox(height: TapTargetUtils.getOptimalSpacing(_service)),
          SegmentedButton<ThemeMode>(
            segments: const <ButtonSegment<ThemeMode>>[
              ButtonSegment<ThemeMode>(
                value: ThemeMode.light,
                label: Text('Light'),
                icon: Icon(Icons.light_mode),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.dark,
                label: Text('Dark'),
                icon: Icon(Icons.dark_mode),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.system,
                label: Text('System'),
                icon: Icon(Icons.brightness_auto),
              ),
            ],
            selected: <ThemeMode>{currentThemeMode},
            onSelectionChanged: (Set<ThemeMode> newSelection) {
              _service.updateThemeMode(newSelection.first);
            },
            style: ButtonStyle(
              // Ensure tap targets are respected for SegmentedButton segments
              minimumSize: WidgetStateProperty.all(
                Size(
                  0, // Width will be determined by content
                  TapTargetUtils.getEffectiveMinTapTargetSize(_service),
                ),
              ),
              padding: WidgetStateProperty.all(
                EdgeInsets.symmetric(
                  horizontal: TapTargetUtils.getOptimalSpacing(_service) / 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSection() {
    return _buildSection(
      title: 'Advanced Options',
      child: Column(
        children: [
          ListTile(
            title: AdaptiveText(
              'Use System Settings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: AdaptiveText(
              'Automatically adapt to your device\'s accessibility settings when available.',
            ),
            trailing: Switch(
              value: _service.settings.useSystemSettings,
              onChanged: (_) => _service.toggleUseSystemSettings(),
            ),
            contentPadding: EdgeInsets.zero,
            isThreeLine: true,
          ),

          SizedBox(height: TapTargetUtils.getOptimalSpacing(_service)),

          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: EdgeInsets.all(
                TapTargetUtils.getOptimalSpacing(_service),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline),
                      SizedBox(
                        width: TapTargetUtils.getOptimalSpacing(_service) / 2,
                      ),
                      AdaptiveText(
                        'Current Settings Summary',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: TapTargetUtils.getOptimalSpacing(_service) / 2,
                  ),
                  _buildSettingsSummary(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSummary() {
    final settings = _service.settings;
    String themeModeDescription;
    switch (settings.themeMode) {
      case ThemeMode.light:
        themeModeDescription = "Light";
        break;
      case ThemeMode.dark:
        themeModeDescription = "Dark";
        break;
      case ThemeMode.system:
        themeModeDescription = "System";
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdaptiveText(
          '• Font Scale: ${FontScaleUtils.getFontScaleDescription(settings.fontScale)}',
        ),
        AdaptiveText(
          '• High Contrast: ${settings.highContrastMode ? "Enabled" : "Disabled"}',
        ),
        AdaptiveText(
          '• Larger Tap Targets: ${settings.largerTapTargets ? "Enabled" : "Disabled"}',
        ),
        if (settings.largerTapTargets)
          AdaptiveText(
            '• Min Tap Size: ${TapTargetUtils.getTapTargetSizeDescription(settings.minTapTargetSize)}',
            accessibilityService: _service,
          ),
        AdaptiveText(
          '• Theme Mode: $themeModeDescription',
          accessibilityService: _service,
        ),
        AdaptiveText(
          '• System Settings: ${settings.useSystemSettings ? "Enabled" : "Disabled"}',
        ),
      ],
    );
  }

  Widget _buildResetSection() {
    return _buildSection(
      title: 'Reset Settings',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdaptiveText(
            'Reset all accessibility settings to their default values.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: TapTargetUtils.getOptimalSpacing(_service)),
          Wrap(
            spacing: TapTargetUtils.getOptimalSpacing(_service),
            runSpacing: TapTargetUtils.getOptimalSpacing(_service) / 2,
            children: [
              AdaptiveElevatedButton(
                text: 'Reset to Defaults',
                onPressed: () => _showResetConfirmDialog(),
                accessibilityService: _service,
                semanticLabel:
                    'Reset all accessibility settings to default values',
              ),
              AdaptiveOutlinedButton(
                text: 'Senior Friendly',
                onPressed: () => _service.applySeniorFriendlyDefaults(),
                accessibilityService: _service,
                semanticLabel: 'Apply senior-friendly default settings',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdaptiveHeading(title, level: 3, accessibilityService: _service),
        SizedBox(height: TapTargetUtils.getOptimalSpacing(_service)),
        child,
      ],
    );
  }

  Widget _buildSectionDivider() {
    return Column(
      children: [
        SizedBox(height: TapTargetUtils.getOptimalSpacing(_service) * 1.5),
        Divider(height: 1),
        SizedBox(height: TapTargetUtils.getOptimalSpacing(_service) * 1.5),
      ],
    );
  }

  void _showResetConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: AdaptiveText(
            'Reset Settings?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: AdaptiveText(
            'This will reset all accessibility settings to their default values. This action cannot be undone.',
          ),
          actions: [
            AdaptiveTextButton(
              text: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
              accessibilityService: _service,
            ),
            AdaptiveElevatedButton(
              text: 'Reset',
              onPressed: () {
                _service.resetToDefaults();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: AdaptiveText(
                      'Settings have been reset to defaults',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              accessibilityService: _service,
            ),
          ],
        );
      },
    );
  }
}

/// A simplified accessibility settings widget for embedding in other screens
class CompactAccessibilitySettings extends StatelessWidget {
  final AccessibilityService accessibilityService;
  final VoidCallback? onSettingsChanged;

  const CompactAccessibilitySettings({
    super.key,
    required this.accessibilityService,
    this.onSettingsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: accessibilityService,
      builder: (context, _) {
        return Card(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(
                TapTargetUtils.getOptimalSpacing(accessibilityService),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdaptiveText(
                    'Accessibility',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(
                    height: TapTargetUtils.getOptimalSpacing(
                      accessibilityService,
                    ),
                  ),

                  _buildCompactSetting(
                    context: context,
                    title: 'Large Text',
                    value: accessibilityService.settings.fontScale > 1.0,
                    onChanged: (value) {
                      accessibilityService.updateFontScale(value ? 1.3 : 1.0);
                      onSettingsChanged?.call();
                    },
                  ),

                  _buildCompactSetting(
                    context: context,
                    title: 'High Contrast',
                    value: accessibilityService.settings.highContrastMode,
                    onChanged: (value) {
                      accessibilityService.toggleHighContrast();
                      onSettingsChanged?.call();
                    },
                  ),

                  _buildCompactSetting(
                    context: context,
                    title: 'Large Buttons',
                    value: accessibilityService.settings.largerTapTargets,
                    onChanged: (value) {
                      accessibilityService.toggleLargerTapTargets();
                      onSettingsChanged?.call();
                    },
                  ),

                  // Simple Theme Toggle for Compact View (Optional)
                  // For more options, users should go to full settings.
                  _buildCompactSetting(
                    context: context,
                    title: 'Dark Mode',
                    value:
                        accessibilityService.settings.themeMode ==
                        ThemeMode.dark,
                    onChanged: (value) {
                      accessibilityService.updateThemeMode(
                        value ? ThemeMode.dark : ThemeMode.light,
                      );
                      onSettingsChanged?.call();
                    },
                    // If you want to show current system state, this needs more logic
                    // For simplicity, this toggle just switches between light/dark
                  ),

                  SizedBox(
                    height: TapTargetUtils.getOptimalSpacing(
                      accessibilityService,
                    ),
                  ),

                  AdaptiveTextButton(
                    text: 'More Settings...',
                    onPressed: () => _showFullSettings(context),
                    accessibilityService: accessibilityService,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompactSetting({
    required BuildContext context,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    Widget? trailing, // Allow custom trailing widget
  }) {
    return Row(
      children: [
        Expanded(
          child: AdaptiveText(
            title,
            accessibilityService: accessibilityService,
          ),
        ),
        trailing ?? Switch(value: value, onChanged: onChanged),
      ],
    );
  }

  void _showFullSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AccessibilitySettingsPanel(
          accessibilityService: accessibilityService,
          onSettingsChanged: onSettingsChanged,
        ),
      ),
    );
  }
}
