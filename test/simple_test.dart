import 'package:flutter_test/flutter_test.dart';
import 'package:adaptive_ui_senior/adaptive_ui_senior.dart';

void main() {
  group('Simple Tests', () {
    test('AccessibilitySettings should create with defaults', () {
      const settings = AccessibilitySettings();
      expect(settings.fontScale, 1.0);
      expect(settings.highContrastMode, false);
    });

    test('AccessibilityService should initialize', () async {
      final service = AccessibilityService();
      await service.initialized();
      expect(service.settings.fontScale, 1.0);
    });

    test('FontScaleUtils should calculate scaled size', () {
      final service = AccessibilityService();
      final scaled = FontScaleUtils.getScaledFontSize(
        baseFontSize: 16.0,
        accessibilityService: service,
      );
      expect(scaled, 16.0); // Should be 16 * 1.0 = 16
    });
  });
}