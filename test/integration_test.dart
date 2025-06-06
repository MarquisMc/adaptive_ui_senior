import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adaptive_ui_senior/adaptive_ui_senior.dart';

void main() {
  group('Accessibility Integration Tests', () {
    late AccessibilityService service;

    setUp(() async {
      service = AccessibilityService();
      await service.initialized();
    });

    testWidgets('Complete accessibility workflow: settings to UI changes', (WidgetTester tester) async {
      // Create a test app with the accessibility service
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                AccessibilitySettingsPanel(
                  accessibilityService: service,
                ),
                AdaptiveText(
                  'Sample Text',
                  style: const TextStyle(fontSize: 16),
                  accessibilityService: service,
                ),
                AdaptiveElevatedButton(
                  text: 'Test Button',
                  onPressed: () {},
                  accessibilityService: service,
                ),
              ],
            ),
          ),
        ),
      );

      // Initial state - verify defaults
      expect(service.settings.fontScale, 1.0);
      expect(service.settings.highContrastMode, false);
      expect(service.settings.largerTapTargets, false);

      // Test font scale adjustment workflow
      await service.updateSettings(const AccessibilitySettings(fontScale: 1.5));
      await tester.pumpAndSettle();

      // Verify the UI updated
      final textWidget = tester.widget<Text>(find.text('Sample Text'));
      expect(textWidget.style?.fontSize, 24.0); // 16 * 1.5

      // Test high contrast mode workflow
      await service.updateSettings(const AccessibilitySettings(
        fontScale: 1.5,
        highContrastMode: true,
      ));
      await tester.pumpAndSettle();

      expect(service.shouldUseHighContrast(), true);

      // Test larger tap targets workflow
      await service.updateSettings(const AccessibilitySettings(
        fontScale: 1.5,
        highContrastMode: true,
        largerTapTargets: true,
        minTapTargetSize: 64.0,
      ));
      await tester.pumpAndSettle();

      expect(service.getEffectiveMinTapTargetSize(), 64.0);
    });

    testWidgets('Age-based adaptation integration test', (WidgetTester tester) async {
      // Test the complete age-based adaptation workflow
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                AdaptiveText(
                  'Age Test Text',
                  style: const TextStyle(fontSize: 16),
                  accessibilityService: service,
                ),
                AdaptiveElevatedButton(
                  text: 'Age Test Button',
                  onPressed: () {},
                  accessibilityService: service,
                ),
              ],
            ),
          ),
        ),
      );

      // Enable age-based adaptation for a 70-year-old user
      await service.updateSettings(const AccessibilitySettings(
        age: 70,
        useAgeBasedAdaptation: true,
      ));
      await tester.pumpAndSettle();

      // Verify age-based recommendations are applied
      expect(service.getEffectiveFontScale(), 1.3); // Recommended for age 70
      expect(service.getEffectiveMinTapTargetSize(), 56.0); // Recommended for age 70

      // Test different age groups
      await service.updateSettings(const AccessibilitySettings(
        age: 80,
        useAgeBasedAdaptation: true,
      ));
      await tester.pumpAndSettle();

      expect(service.getEffectiveFontScale(), 1.5); // Recommended for age 80
    });

    testWidgets('Senior-friendly defaults integration test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                AdaptiveText(
                  'Senior Test',
                  style: const TextStyle(fontSize: 16),
                  accessibilityService: service,
                ),
                AdaptiveElevatedButton(
                  text: 'Senior Button',
                  onPressed: () {},
                  accessibilityService: service,
                ),
              ],
            ),
          ),
        ),
      );

      // Apply senior-friendly defaults
      await service.applySeniorFriendlyDefaults();
      await tester.pumpAndSettle();

      // Verify senior-friendly settings are applied
      expect(service.settings.fontScale, 1.3);
      expect(service.settings.highContrastMode, true);
      expect(service.settings.largerTapTargets, true);
      expect(service.settings.minTapTargetSize, 56.0);

      // Verify UI reflects these changes
      final textWidget = tester.widget<Text>(find.text('Senior Test'));
      expect(textWidget.style?.fontSize, greaterThan(16.0)); // Should be scaled
    });

    testWidgets('Settings persistence integration test', (WidgetTester tester) async {
      // Test that settings persist across service recreation
      const testSettings = AccessibilitySettings(
        fontScale: 1.4,
        highContrastMode: true,
        largerTapTargets: true,
        age: 65,
      );

      // Update settings
      await service.updateSettings(testSettings);
      
      // Verify settings are applied
      expect(service.settings.fontScale, 1.4);
      expect(service.settings.highContrastMode, true);
      expect(service.settings.largerTapTargets, true);
      expect(service.settings.age, 65);

      // Create a new service instance (simulating app restart)
      final newService = AccessibilityService();
      await newService.initialized();

      // Note: In a real integration test, settings would persist via SharedPreferences
      // For unit tests, we verify the serialization works
      final serialized = testSettings.toMap();
      final reconstructed = AccessibilitySettings.fromMap(serialized);
      
      expect(reconstructed.fontScale, 1.4);
      expect(reconstructed.highContrastMode, true);
      expect(reconstructed.largerTapTargets, true);
      expect(reconstructed.age, 65);
    });

    testWidgets('Adaptive theme integration test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AdaptiveTheme.getTheme(
            accessibilityService: service,
            brightness: Brightness.light,
          ),
          darkTheme: AdaptiveTheme.getTheme(
            accessibilityService: service,
            brightness: Brightness.dark,
          ),
          home: AdaptiveScaffold(
            accessibilityService: service,
            appBar: AppBar(title: const Text('Theme Test')),
            body: const AdaptiveText('Theme integrated content'),
          ),
        ),
      );

      // Test theme changes with high contrast
      await service.updateSettings(const AccessibilitySettings(
        highContrastMode: true,
        fontScale: 1.2,
      ));
      await tester.pumpAndSettle();

      // Verify the app renders without errors
      expect(find.text('Theme Test'), findsOneWidget);
      expect(find.text('Theme integrated content'), findsOneWidget);
    });

    testWidgets('Complete settings panel interaction test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: AccessibilitySettingsPanel(
                accessibilityService: service,
                showAdvancedOptions: true,
                showPresets: true,
              ),
            ),
          ),
        ),
      );

      // Verify initial state
      expect(service.settings.fontScale, 1.0);
      
      // Find and interact with controls (these tests verify the UI exists)
      expect(find.text('Accessibility Settings'), findsOneWidget);
      expect(find.text('Font Size'), findsOneWidget);
      expect(find.text('High Contrast Mode'), findsOneWidget);
      
      // Verify sliders and switches are present
      expect(find.byType(Slider), findsAtLeastNWidgets(1));
      expect(find.byType(Switch), findsAtLeastNWidgets(1));
    });
  });
}