# Contributing to Adaptive UI Senior

Thank you for your interest in contributing to the Adaptive UI Senior Flutter package! This package helps developers create more accessible and senior-friendly user interfaces.

## 🎯 Project Mission

Our mission is to make Flutter applications more accessible and user-friendly for senior users and those with accessibility needs through:
- Dynamic font scaling
- High contrast themes  
- Larger tap targets
- Age-based UI adaptations
- Seamless system integration

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Pull Request Process](#pull-request-process)
- [Issue Reporting](#issue-reporting)
- [Architecture Overview](#architecture-overview)

## 📜 Code of Conduct

This project follows the [Flutter Community Code of Conduct](https://github.com/flutter/flutter/blob/master/CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK >= 3.8.1
- Dart SDK >= 3.0.0
- Git

### Development Setup

1. **Fork and Clone**
   ```bash
   git clone https://github.com/your-username/adaptive_ui_senior.git
   cd adaptive_ui_senior
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run Tests**
   ```bash
   flutter test
   # For coverage report
   flutter test --coverage
   ```

4. **Run Static Analysis**
   ```bash
   flutter analyze
   dart format --set-exit-if-changed .
   ```

5. **Run Example App** (if available)
   ```bash
   cd example
   flutter run
   ```

## 🎨 Coding Standards

### Dart Style Guide

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format` for automatic formatting
- Maximum line length: 80 characters
- Use trailing commas for better diffs

### Code Organization

```
lib/
├── adaptive_ui_senior.dart          # Main export file
└── src/
    ├── models/                      # Data models
    │   └── accessibility_settings.dart
    ├── services/                    # Business logic
    │   └── accessibility_service.dart
    ├── themes/                      # Theme management
    │   ├── adaptive_theme.dart
    │   └── high_contrast_theme.dart
    ├── utils/                       # Utility functions
    │   ├── font_scale_utils.dart
    │   └── tap_target_utils.dart
    └── widgets/                     # UI components
        ├── adaptive_text.dart
        ├── adaptive_button.dart
        ├── adaptive_scaffold.dart
        ├── accessibility_settings_panel.dart
        └── helpers/
            └── animated_adaptive_constraint.dart
```

### Documentation Standards

- **All public APIs** must have comprehensive documentation
- **Use dartdoc comments** with `///` for public members
- **Include usage examples** in documentation
- **Document parameters** and return values
- **Add `@since` tags** for new features

Example:
```dart
/// Creates an adaptive text widget that scales based on accessibility settings.
///
/// The [text] parameter is required and contains the text to display.
/// The [accessibilityService] parameter provides the current accessibility
/// configuration for scaling and theming.
///
/// Example usage:
/// ```dart
/// AdaptiveText(
///   'Hello World',
///   accessibilityService: myAccessibilityService,
///   style: TextStyle(fontSize: 16),
/// )
/// ```
///
/// @since 1.0.0
class AdaptiveText extends StatelessWidget {
  // ...
}
```

### Naming Conventions

- **Classes**: PascalCase (`AdaptiveText`, `AccessibilityService`)
- **Variables/Functions**: camelCase (`fontScale`, `updateSettings`)
- **Constants**: camelCase (`seniorFriendlyMinimum`)
- **Files**: snake_case (`adaptive_text.dart`, `font_scale_utils.dart`)

## 🧪 Testing Guidelines

### Test Structure

- **Unit Tests**: `test/` directory
- **Widget Tests**: `test/` directory  
- **Integration Tests**: `test/integration_test.dart`

### Test Categories

1. **Unit Tests** - Test individual functions and classes
   ```dart
   test('should calculate scaled font size correctly', () {
     // Test implementation
   });
   ```

2. **Widget Tests** - Test UI components
   ```dart
   testWidgets('should render with default scaling', (WidgetTester tester) async {
     // Widget test implementation
   });
   ```

3. **Integration Tests** - Test complete workflows
   ```dart
   testWidgets('Complete accessibility workflow', (WidgetTester tester) async {
     // Integration test implementation
   });
   ```

### Test Requirements

- **Minimum 90% code coverage** for new features
- **Test all public APIs**
- **Test edge cases and error conditions**
- **Use descriptive test names**
- **Group related tests** using `group()`

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart

# Run tests matching pattern
flutter test --name "AccessibilityService"
```

## 🔄 Pull Request Process

### Before Submitting

1. **Create an issue** for discussion (for non-trivial changes)
2. **Fork the repository** and create a feature branch
3. **Write tests** for your changes
4. **Update documentation** as needed
5. **Run all tests** and ensure they pass
6. **Run static analysis** and fix any issues

### Branch Naming

- `feature/description` - New features
- `fix/description` - Bug fixes  
- `docs/description` - Documentation updates
- `refactor/description` - Code refactoring

### Commit Messages

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
type(scope): description

feat(widgets): add AdaptiveIconButton widget
fix(service): resolve settings persistence issue
docs(readme): update installation instructions
test(utils): add tests for TapTargetUtils
```

### PR Template

When submitting a PR, include:

- **Description** of changes
- **Issue reference** (if applicable)
- **Testing details** 
- **Breaking changes** (if any)
- **Screenshots** (for UI changes)

## 🐛 Issue Reporting

### Bug Reports

Include:
- **Flutter/Dart version**
- **Package version**
- **Device information**
- **Steps to reproduce**
- **Expected vs actual behavior**
- **Code sample** (minimal reproduction)
- **Error logs/stack traces**

### Feature Requests

Include:
- **Use case description**
- **Proposed solution**
- **Alternative solutions considered**
- **Impact on existing features**

## 🏗️ Architecture Overview

### Core Components

1. **AccessibilitySettings** - Immutable configuration model
2. **AccessibilityService** - Central state management with persistence
3. **Adaptive Widgets** - UI components that respond to settings
4. **Theme System** - Dynamic theme generation
5. **Utility Classes** - Helper functions for calculations

### Design Principles

- **Accessibility First** - All features prioritize accessibility
- **Performance** - Efficient updates and minimal rebuilds
- **Flexibility** - Configurable and extensible APIs
- **Consistency** - Uniform behavior across components
- **Age-Inclusive** - Special consideration for senior users

### State Management

The package uses a simple but effective state management pattern:

```
AccessibilityService (ChangeNotifier)
    ↓ (notifies)
Adaptive Widgets (listen to changes)
    ↓ (rebuild)
Updated UI (reflects new settings)
```

## 🎯 Contribution Areas

We welcome contributions in these areas:

### High Priority
- **Bug fixes** and performance improvements
- **Additional adaptive widgets** (form inputs, navigation, etc.)
- **Better system integration** (platform-specific accessibility APIs)
- **Improved test coverage**

### Medium Priority  
- **Localization support**
- **Additional themes** (beyond high contrast)
- **Animation improvements**
- **Documentation enhancements**

### Low Priority
- **Developer tooling**
- **Example applications**
- **Performance benchmarks**

## 🤝 Getting Help

- **GitHub Issues** - For bugs and feature requests
- **GitHub Discussions** - For questions and community chat
- **Flutter Community** - For general Flutter development help

## 📝 License

By contributing to this project, you agree that your contributions will be licensed under the MIT License.

---

Thank you for helping make Flutter applications more accessible for everyone! 🎉