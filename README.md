# Adaptive UI Senior

A comprehensive Flutter package designed to make applications more accessible and user-friendly for senior users and those with accessibility needs.

## Overview

The `adaptive_ui_senior` package provides a collection of widgets, services, and utilities that automatically adapt to user preferences, creating more accessible user interfaces with features like dynamic font scaling, high contrast themes, larger tap targets, and age-based adaptations.

## Features

### 🎯 Core Accessibility Features

- **Dynamic Font Scaling**: Automatically adjusts text size based on user preferences or age
- **High Contrast Themes**: Enhanced color contrast for better visibility
- **Larger Tap Targets**: Configurable minimum touch target sizes for easier interaction
- **Age-Based Adaptation**: Automatic UI adjustments based on user age
- **System Integration**: Respects device accessibility settings when available
- **Smooth Animations**: Animated transitions between accessibility states

### 🧩 Adaptive Widgets

- **AdaptiveText**: Text widgets that respond to font scaling and contrast settings
- **Adaptive Buttons**: Button components that adjust size and contrast automatically
- **AdaptiveScaffold**: Main layout component with built-in accessibility features
- **AccessibilitySettingsPanel**: Complete settings interface for user customization

### 🎨 Theming

- **AdaptiveTheme**: Dynamic theme generation based on accessibility settings
- **HighContrastTheme**: Specialized high-contrast color schemes for light and dark modes

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  adaptive_ui_senior: ^1.0.0
  shared_preferences: ^2.2.3  # Required for settings persistence
```

## Quick Start

### 1. Initialize the Service

```dart
import 'package:adaptive_ui_senior/adaptive_ui_senior.dart';

final AccessibilityService accessibilityService = AccessibilityService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the accessibility service
  await accessibilityService.initialized();
  
  runApp(MyApp());
}
```

### 2. Set Up Adaptive Theming

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: accessibilityService,
      builder: (context, child) {
        return MaterialApp(
          title: 'My Accessible App',
          theme: AdaptiveTheme.getTheme(
            accessibilityService: accessibilityService,
            brightness: Brightness.light,
          ),
          darkTheme: AdaptiveTheme.getTheme(
            accessibilityService: accessibilityService,
            brightness: Brightness.dark,
          ),
          themeMode: accessibilityService.settings.themeMode,
          home: MyHomePage(),
        );
      },
    );
  }
}
```

### 3. Use Adaptive Widgets

```dart
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      accessibilityService: accessibilityService,
      appBar: AdaptiveAppBar(
        title: AdaptiveText('My App'),
        accessibilityService: accessibilityService,
      ),
      body: AdaptiveTextProvider(
        accessibilityService: accessibilityService,
        child: Column(
          children: [
            AdaptiveHeading('Welcome', level: 1),
            AdaptiveBodyText(
              'This text automatically adapts to your accessibility settings.',
            ),
            AdaptiveElevatedButton(
              text: 'Get Started',
              onPressed: () {
                // Handle button press
              },
              accessibilityService: accessibilityService,
            ),
          ],
        ),
      ),
    );
  }
}
```

## Core Components

### AccessibilityService

The central service that manages all accessibility settings and provides persistence.

```dart
// Update settings
await accessibilityService.updateFontScale(1.5);
await accessibilityService.toggleHighContrast();
await accessibilityService.toggleLargerTapTargets();

// Get effective values
double fontScale = accessibilityService.getEffectiveFontScale();
double tapTargetSize = accessibilityService.getEffectiveMinTapTargetSize();
bool useHighContrast = accessibilityService.shouldUseHighContrast();

// Apply presets
await accessibilityService.applySeniorFriendlyDefaults();
await accessibilityService.resetToDefaults();
```

### AccessibilitySettings Model

Configuration object that holds all accessibility preferences:

```dart
const AccessibilitySettings(
  fontScale: 1.3,                    // 130% font scaling
  highContrastMode: true,            // Enable high contrast
  largerTapTargets: true,            // Enable larger touch targets
  minTapTargetSize: 56.0,           // Minimum tap target size in pixels
  useSystemSettings: false,          // Override system settings
  themeMode: ThemeMode.light,        // Theme preference
  age: 65,                          // User age for age-based adaptation
  useAgeBasedAdaptation: true,      // Enable age-based features
)
```

## Adaptive Widgets

### Text Widgets

```dart
// Basic adaptive text
AdaptiveText('Hello World')

// Headings with semantic levels
AdaptiveHeading('Section Title', level: 2)

// Body text optimized for reading
AdaptiveBodyText('Lorem ipsum dolor sit amet...')

// Caption text with enhanced readability
AdaptiveCaption('Image caption or small text')
```

### Button Widgets

```dart
// Elevated button with adaptive sizing
AdaptiveElevatedButton(
  text: 'Primary Action',
  onPressed: () {},
  accessibilityService: accessibilityService,
)

// Outlined button
AdaptiveOutlinedButton(
  text: 'Secondary Action',
  onPressed: () {},
  accessibilityService: accessibilityService,
)

// Text button
AdaptiveTextButton(
  text: 'Tertiary Action',
  onPressed: () {},
  accessibilityService: accessibilityService,
)

// Icon button with adaptive sizing
AdaptiveIconButton(
  icon: Icons.favorite,
  onPressed: () {},
  tooltip: 'Add to favorites',
  accessibilityService: accessibilityService,
)

// Floating action button
AdaptiveFloatingActionButton(
  onPressed: () {},
  icon: Icons.add,
  accessibilityService: accessibilityService,
)
```

### Layout Widgets

```dart
// Adaptive scaffold with built-in accessibility features
AdaptiveScaffold(
  accessibilityService: accessibilityService,
  appBar: AdaptiveAppBar(title: AdaptiveText('Title')),
  body: YourContent(),
  bottomNavigationBar: AdaptiveBottomNavigationBar(
    items: [...],
    accessibilityService: accessibilityService,
  ),
)

// Provider for propagating accessibility service
AdaptiveTextProvider(
  accessibilityService: accessibilityService,
  child: YourWidgetTree(),
)
```

### Settings UI

```dart
// Full settings panel
AccessibilitySettingsPanel(
  accessibilityService: accessibilityService,
  showAdvancedOptions: true,
  showPresets: true,
  onSettingsChanged: () {
    // Handle settings changes
  },
)

// Compact settings for embedding
CompactAccessibilitySettings(
  accessibilityService: accessibilityService,
  onSettingsChanged: () {
    // Handle settings changes
  },
)
```

## Utility Classes

### FontScaleUtils

```dart
// Get scaled font size
double scaledSize = FontScaleUtils.getScaledFontSize(
  baseFontSize: 16.0,
  accessibilityService: accessibilityService,
);

// Scale text style
TextStyle scaledStyle = FontScaleUtils.scaleTextStyle(
  baseStyle: Theme.of(context).textTheme.bodyLarge,
  accessibilityService: accessibilityService,
);

// Age-based recommendations
double recommendedScale = FontScaleUtils.getRecommendedScaleForAge(65);
```

### TapTargetUtils

```dart
// Get effective tap target size
double minSize = TapTargetUtils.getEffectiveMinTapTargetSize(
  accessibilityService,
);

// Create adaptive containers
Widget adaptiveContainer = TapTargetUtils.createAdaptiveContainer(
  child: Text('Content'),
  accessibilityService: accessibilityService,
  onTap: () {},
);

// Age-based tap target recommendations
double recommendedSize = TapTargetUtils.getRecommendedTapTargetSize(65);
```

## Age-Based Adaptation

The package includes intelligent age-based adaptations:

```dart
// Enable age-based adaptation
await accessibilityService.updateSettings(
  accessibilityService.settings.copyWith(
    useAgeBasedAdaptation: true,
    age: 65,
  ),
);

// Age-based font scale recommendations:
// Under 50: 1.0x
// 50-64: 1.15x  
// 65-74: 1.3x
// 75+: 1.5x

// Age-based tap target recommendations:
// Under 60: 48px (Material minimum)
// 60+: 56px (Senior-friendly minimum)
```

## Theming

### Adaptive Theme

```dart
// Get theme based on accessibility settings
ThemeData theme = AdaptiveTheme.getTheme(
  accessibilityService: accessibilityService,
  brightness: Brightness.light,
  baseTheme: customTheme, // Optional base theme
);
```

### High Contrast Themes

```dart
// Access pre-built high contrast themes
ThemeData lightHighContrast = HighContrastTheme.lightTheme;
ThemeData darkHighContrast = HighContrastTheme.darkTheme;
```

## Best Practices

### 1. Always Initialize the Service

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await accessibilityService.initialized();
  runApp(MyApp());
}
```

### 2. Use AdaptiveTextProvider

Wrap your widget tree with `AdaptiveTextProvider` to automatically provide the accessibility service to all adaptive widgets:

```dart
AdaptiveTextProvider(
  accessibilityService: accessibilityService,
  child: MyWidget(),
)
```

### 3. Provide Semantic Labels

```dart
AdaptiveElevatedButton(
  text: 'Save',
  onPressed: () {},
  semanticLabel: 'Save your changes to the document',
  accessibilityService: accessibilityService,
)
```

### 4. Test with Different Settings

Always test your app with various accessibility settings:
- Different font scales (0.8x to 2.0x)
- High contrast mode enabled
- Large tap targets enabled
- Different age-based adaptations

## Package Structure

```
lib/
├── adaptive_ui_senior.dart           # Main export file
├── src/
│   ├── models/
│   │   └── accessibility_settings.dart    # Settings data model
│   ├── services/
│   │   └── accessibility_service.dart     # Core service class
│   ├── themes/
│   │   ├── adaptive_theme.dart            # Dynamic theme management
│   │   └── high_contrast_theme.dart       # High contrast themes
│   ├── utils/
│   │   ├── font_scale_utils.dart          # Font scaling utilities
│   │   └── tap_target_utils.dart          # Tap target utilities
│   └── widgets/
│       ├── adaptive_text.dart             # Text widgets
│       ├── adaptive_button.dart           # Button widgets
│       ├── adaptive_scaffold.dart         # Layout widgets
│       ├── accessibility_settings_panel.dart  # Settings UI
│       └── helpers/
│           └── animated_adaptive_constraint.dart  # Animation helper
```

## API Reference

### Classes

| Class | Description |
|-------|-------------|
| `AccessibilityService` | Central service for managing accessibility settings |
| `AccessibilitySettings` | Model class for accessibility configuration |
| `AdaptiveTheme` | Theme management with accessibility features |
| `HighContrastTheme` | Pre-built high contrast themes |
| `FontScaleUtils` | Utilities for font scaling operations |
| `TapTargetUtils` | Utilities for touch target sizing |

### Widgets

| Widget | Description |
|--------|-------------|
| `AdaptiveText` | Text widget with automatic scaling |
| `AdaptiveHeading` | Semantic heading widget (levels 1-6) |
| `AdaptiveBodyText` | Optimized body text widget |
| `AdaptiveCaption` | Enhanced caption text widget |
| `AdaptiveElevatedButton` | Adaptive elevated button |
| `AdaptiveOutlinedButton` | Adaptive outlined button |
| `AdaptiveTextButton` | Adaptive text button |
| `AdaptiveIconButton` | Adaptive icon button |
| `AdaptiveFloatingActionButton` | Adaptive floating action button |
| `AdaptiveSegmentedButton` | Adaptive segmented button |
| `AdaptiveScaffold` | Scaffold with accessibility features |
| `AdaptiveAppBar` | App bar with adaptive elements |
| `AdaptiveBottomNavigationBar` | Adaptive bottom navigation |
| `AdaptiveDrawer` | Adaptive navigation drawer |
| `AccessibilitySettingsPanel` | Full settings interface |
| `CompactAccessibilitySettings` | Compact settings widget |
| `AdaptiveTextProvider` | Service provider widget |

### Constants and Presets

```dart
// Font scale presets
FontScaleUtils.fontScalePresets = {
  'Small': 0.85,
  'Normal': 1.0,
  'Large': 1.15,
  'Larger': 1.3,
  'Huge': 1.5,
  'Maximum': 2.0,
};

// Tap target presets
TapTargetUtils.tapTargetPresets = {
  'Compact': 44.0,
  'Standard': 48.0,
  'Comfortable': 56.0,
  'Large': 64.0,
  'Extra Large': 72.0,
};

// Material and senior-friendly minimums
TapTargetUtils.materialMinimum = 48.0;
TapTargetUtils.seniorFriendlyMinimum = 56.0;
```

## Example Implementation

The package includes a comprehensive example app that demonstrates all features:

- **Home Tab**: Feature overview with adaptive cards
- **Text Examples**: All text widget variations with live preview
- **Button Examples**: Complete button widget showcase
- **Age Demo**: Interactive age-based adaptation demonstration
- **Settings Tab**: Full settings panel integration

## Dependencies

- **Flutter SDK**: >=3.8.1
- **shared_preferences**: ^2.2.3 (for settings persistence)
- **cupertino_icons**: ^1.0.8 (for iOS-style icons)

## Testing

The package includes basic widget tests. To run tests:

```bash
flutter test
```

## Contributing

When contributing to this package:

1. Follow Flutter/Dart style guidelines
2. Ensure all widgets are properly documented
3. Add appropriate semantic labels for accessibility
4. Test with various accessibility settings
5. Update this README when adding new features

## Changelog

See [CHANGELOG.md](../CHANGELOG.md) for version history and breaking changes.

## License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE) file for details.