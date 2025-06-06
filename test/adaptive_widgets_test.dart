import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adaptive_ui_senior/adaptive_ui_senior.dart';

void main() {
  group('AdaptiveText Widget Tests', () {
    late AccessibilityService service;

    setUp(() async {
      service = AccessibilityService();
      await service.initialized();
    });

    testWidgets('should render with default scaling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdaptiveText(
              'Test Text',
              accessibilityService: service,
            ),
          ),
        ),
      );

      expect(find.text('Test Text'), findsOneWidget);
    });

    testWidgets('should scale text size when font scale is increased', (WidgetTester tester) async {
      await service.updateSettings(const AccessibilitySettings(fontScale: 1.5));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdaptiveText(
              'Test Text',
              style: const TextStyle(fontSize: 16),
              accessibilityService: service,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style?.fontSize, 24.0); // 16 * 1.5
    });

    testWidgets('should apply high contrast colors when enabled', (WidgetTester tester) async {
      await service.updateSettings(const AccessibilitySettings(highContrastMode: true));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdaptiveText(
              'Test Text',
              accessibilityService: service,
            ),
          ),
        ),
      );

      expect(find.text('Test Text'), findsOneWidget);
    });
  });

  group('AdaptiveElevatedButton Widget Tests', () {
    late AccessibilityService service;

    setUp(() async {
      service = AccessibilityService();
      await service.initialized();
    });

    testWidgets('should render button with text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdaptiveElevatedButton(
              text: 'Click Me',
              onPressed: () {},
              accessibilityService: service,
            ),
          ),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should apply larger tap targets when enabled', (WidgetTester tester) async {
      await service.updateSettings(const AccessibilitySettings(
        largerTapTargets: true,
        minTapTargetSize: 64.0,
      ));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdaptiveElevatedButton(
              text: 'Click Me',
              onPressed: () {},
              accessibilityService: service,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.style?.minimumSize?.resolve({}), const Size(64.0, 64.0));
    });

    testWidgets('should handle button press', (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdaptiveElevatedButton(
              text: 'Click Me',
              onPressed: () {
                wasPressed = true;
              },
              accessibilityService: service,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      expect(wasPressed, true);
    });

    testWidgets('should be disabled when onPressed is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdaptiveElevatedButton(
              text: 'Disabled',
              onPressed: null,
              accessibilityService: service,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, null);
    });
  });

  group('AdaptiveScaffold Widget Tests', () {
    late AccessibilityService service;

    setUp(() async {
      service = AccessibilityService();
      await service.initialized();
    });

    testWidgets('should render scaffold with basic properties', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AdaptiveScaffold(
            accessibilityService: service,
            appBar: AppBar(title: const Text('Test App')),
            body: const Text('Body Content'),
          ),
        ),
      );

      expect(find.text('Test App'), findsOneWidget);
      expect(find.text('Body Content'), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should apply adaptive theme', (WidgetTester tester) async {
      await service.updateSettings(const AccessibilitySettings(highContrastMode: true));

      await tester.pumpWidget(
        MaterialApp(
          home: AdaptiveScaffold(
            accessibilityService: service,
            body: const Text('Content'),
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });

  group('AccessibilitySettingsPanel Widget Tests', () {
    late AccessibilityService service;

    setUp(() async {
      service = AccessibilityService();
      await service.initialized();
    });

    testWidgets('should render settings panel', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccessibilitySettingsPanel(
              accessibilityService: service,
            ),
          ),
        ),
      );

      expect(find.text('Accessibility Settings'), findsOneWidget);
    });

    testWidgets('should show font scale slider', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccessibilitySettingsPanel(
              accessibilityService: service,
            ),
          ),
        ),
      );

      expect(find.text('Font Size'), findsOneWidget);
      expect(find.byType(Slider), findsAtLeastNWidgets(1));
    });

    testWidgets('should show high contrast toggle', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccessibilitySettingsPanel(
              accessibilityService: service,
            ),
          ),
        ),
      );

      expect(find.text('High Contrast Mode'), findsOneWidget);
      expect(find.byType(Switch), findsAtLeastNWidgets(1));
    });

    testWidgets('should update font scale when slider changes', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccessibilitySettingsPanel(
              accessibilityService: service,
            ),
          ),
        ),
      );

      final slider = find.byType(Slider).first;
      await tester.drag(slider, const Offset(50, 0));
      await tester.pumpAndSettle();

      // Font scale should have changed from 1.0
      expect(service.settings.fontScale, isNot(1.0));
    });

    testWidgets('should toggle high contrast when switch is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccessibilitySettingsPanel(
              accessibilityService: service,
            ),
          ),
        ),
      );

      expect(service.settings.highContrastMode, false);

      final switchFinder = find.byType(Switch).first;
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      expect(service.settings.highContrastMode, true);
    });
  });

  group('AdaptiveTheme Tests', () {
    late AccessibilityService service;

    setUp(() async {
      service = AccessibilityService();
      await service.initialized();
    });

    test('should generate light theme by default', () {
      final theme = AdaptiveTheme.getTheme(
        accessibilityService: service,
        brightness: Brightness.light,
      );

      expect(theme.brightness, Brightness.light);
    });

    test('should generate dark theme when requested', () {
      final theme = AdaptiveTheme.getTheme(
        accessibilityService: service,
        brightness: Brightness.dark,
      );

      expect(theme.brightness, Brightness.dark);
    });

    test('should apply high contrast theme when enabled', () async {
      await service.updateSettings(const AccessibilitySettings(highContrastMode: true));

      final theme = AdaptiveTheme.getTheme(
        accessibilityService: service,
        brightness: Brightness.light,
      );

      // High contrast theme should be applied
      expect(theme.primaryColor, isNot(const Color(0xFF2196F3))); // Default Material blue
    });

    test('should scale text theme based on font scale', () async {
      await service.updateSettings(const AccessibilitySettings(fontScale: 1.5));

      final theme = AdaptiveTheme.getTheme(
        accessibilityService: service,
        brightness: Brightness.light,
      );

      final bodyLarge = theme.textTheme.bodyLarge;
      expect(bodyLarge?.fontSize, greaterThan(16.0)); // Should be scaled up
    });
  });
}