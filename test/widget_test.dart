import 'package:flutter_test/flutter_test.dart';
import 'package:adaptive_ui_senior/adaptive_ui_senior.dart';

void main() {
  group('AccessibilitySettings Tests', () {
    test('should create default settings', () {
      const settings = AccessibilitySettings();
      
      expect(settings.fontScale, 1.0);
      expect(settings.highContrastMode, false);
      expect(settings.largerTapTargets, false);
      expect(settings.minTapTargetSize, 48.0);
      expect(settings.useSystemSettings, true);
      expect(settings.useAgeBasedAdaptation, false);
    });

    test('should create custom settings', () {
      const settings = AccessibilitySettings(
        fontScale: 1.5,
        highContrastMode: true,
        largerTapTargets: true,
        minTapTargetSize: 56.0,
        useSystemSettings: false,
        age: 65,
        useAgeBasedAdaptation: true,
      );
      
      expect(settings.fontScale, 1.5);
      expect(settings.highContrastMode, true);
      expect(settings.largerTapTargets, true);
      expect(settings.minTapTargetSize, 56.0);
      expect(settings.useSystemSettings, false);
      expect(settings.age, 65);
      expect(settings.useAgeBasedAdaptation, true);
    });

    test('should copy settings with changes', () {
      const originalSettings = AccessibilitySettings(fontScale: 1.0);
      
      final newSettings = originalSettings.copyWith(fontScale: 1.5);
      
      expect(originalSettings.fontScale, 1.0);
      expect(newSettings.fontScale, 1.5);
    });

    test('should serialize to and from Map', () {
      const settings = AccessibilitySettings(
        fontScale: 1.3,
        highContrastMode: true,
        age: 70,
      );
      
      final map = settings.toMap();
      final reconstructed = AccessibilitySettings.fromMap(map);
      
      expect(reconstructed.fontScale, settings.fontScale);
      expect(reconstructed.highContrastMode, settings.highContrastMode);
      expect(reconstructed.age, settings.age);
    });
  });

  group('FontScaleUtils Tests', () {
    late AccessibilityService mockService;

    setUp(() async {
      mockService = AccessibilityService();
      await mockService.initialized();
    });

    test('should calculate scaled font size correctly', () async {
      await mockService.updateSettings(const AccessibilitySettings(fontScale: 1.5));
      
      final scaledSize = FontScaleUtils.getScaledFontSize(
        baseFontSize: 16.0,
        accessibilityService: mockService,
      );
      
      expect(scaledSize, 24.0); // 16 * 1.5
    });

    test('should get age-based font scale recommendations', () {
      expect(FontScaleUtils.getRecommendedScaleForAge(40), 1.0);
      expect(FontScaleUtils.getRecommendedScaleForAge(55), 1.15);
      expect(FontScaleUtils.getRecommendedScaleForAge(70), 1.3);
      expect(FontScaleUtils.getRecommendedScaleForAge(80), 1.5);
    });

    test('should clamp font scale to valid range', () async {
      await mockService.updateSettings(const AccessibilitySettings(fontScale: 3.0));
      
      final scaledSize = FontScaleUtils.getScaledFontSize(
        baseFontSize: 16.0,
        accessibilityService: mockService,
      );
      
      // Should be clamped to maximum of 2.0
      expect(scaledSize, 32.0); // 16 * 2.0
    });
  });

  group('TapTargetUtils Tests', () {
    late AccessibilityService mockService;

    setUp(() async {
      mockService = AccessibilityService();
      await mockService.initialized();
    });

    test('should return effective tap target size', () async {
      await mockService.updateSettings(const AccessibilitySettings(
        largerTapTargets: true,
        minTapTargetSize: 56.0,
      ));
      
      final effectiveSize = TapTargetUtils.getEffectiveMinTapTargetSize(mockService);
      
      expect(effectiveSize, 56.0);
    });

    test('should return Material minimum when larger targets disabled', () async {
      await mockService.updateSettings(const AccessibilitySettings(
        largerTapTargets: false,
      ));
      
      final effectiveSize = TapTargetUtils.getEffectiveMinTapTargetSize(mockService);
      
      expect(effectiveSize, 48.0);
    });

    test('should get age-based tap target recommendations', () {
      expect(TapTargetUtils.getRecommendedTapTargetSize(50), 48.0);
      expect(TapTargetUtils.getRecommendedTapTargetSize(65), 56.0);
      expect(TapTargetUtils.getRecommendedTapTargetSize(75), 56.0);
    });
  });

  group('AccessibilityService Tests', () {
    late AccessibilityService service;

    setUp(() async {
      service = AccessibilityService();
      await service.initialized();
    });

    test('should initialize with default settings', () {
      expect(service.settings.fontScale, 1.0);
      expect(service.settings.highContrastMode, false);
      expect(service.settings.largerTapTargets, false);
    });

    test('should update font scale', () async {
      await service.updateFontScale(1.5);
      
      expect(service.settings.fontScale, 1.5);
    });

    test('should toggle high contrast', () async {
      expect(service.settings.highContrastMode, false);
      
      await service.toggleHighContrast();
      expect(service.settings.highContrastMode, true);
      
      await service.toggleHighContrast();
      expect(service.settings.highContrastMode, false);
    });

    test('should toggle larger tap targets', () async {
      expect(service.settings.largerTapTargets, false);
      
      await service.toggleLargerTapTargets();
      expect(service.settings.largerTapTargets, true);
      
      await service.toggleLargerTapTargets();
      expect(service.settings.largerTapTargets, false);
    });

    test('should apply senior-friendly defaults', () async {
      await service.applySeniorFriendlyDefaults();
      
      expect(service.settings.fontScale, 1.3);
      expect(service.settings.largerTapTargets, true);
      expect(service.settings.minTapTargetSize, 56.0);
    });

    test('should reset to defaults', () async {
      // First modify settings
      await service.updateFontScale(2.0);
      await service.toggleHighContrast();
      
      // Then reset
      await service.resetToDefaults();
      
      expect(service.settings.fontScale, 1.0);
      expect(service.settings.highContrastMode, false);
      expect(service.settings.largerTapTargets, false);
    });

    test('should get effective font scale', () async {
      await service.updateSettings(const AccessibilitySettings(fontScale: 1.5));
      
      expect(service.getEffectiveFontScale(), 1.5);
    });

    test('should determine high contrast usage', () async {
      await service.updateSettings(const AccessibilitySettings(highContrastMode: true));
      
      expect(service.shouldUseHighContrast(), true);
    });

    test('should get effective tap target size', () async {
      await service.updateSettings(const AccessibilitySettings(
        largerTapTargets: true,
        minTapTargetSize: 64.0,
      ));
      
      expect(service.getEffectiveMinTapTargetSize(), 64.0);
    });

    test('should use age-based adaptations when enabled', () async {
      await service.updateSettings(const AccessibilitySettings(
        age: 70,
        useAgeBasedAdaptation: true,
      ));
      
      // Should return age-based values when age-based adaptation is enabled
      expect(service.getEffectiveFontScale(), 1.3); // Recommended for age 70
      expect(service.getEffectiveMinTapTargetSize(), 56.0); // Recommended for age 70
    });
  });
}