// lib/src/themes/high_contrast_theme.dart

import 'package:flutter/material.dart';

/// Provides high contrast theme configurations optimized for senior users
class HighContrastTheme {
  /// High contrast light theme with enhanced readability
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // High contrast color scheme
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF000000), // pure Black
        onPrimary: Color(0xFFFFFFFF), // pure White
        secondary: Color(0xFF0066CC), // High contrast blue
        onSecondary: Color(0xFFFFFFFF), // Pure white
        surface: Color(0xFFFFFFFF), // Pure white
        onSurface: Color(0xFF000000), // Pure black
        error: Color(0xFFCC0000), // High contrast red
        onError: Color(0xFFFFFFFF), // Pure white
        outline: Color(0xFF000000), // Pure black for borders
        shadow: Color(0xFF000000), // Pure black shadows
      ),

      // Enhanced text theme for better readability
      textTheme: _buildHighContrastTextTheme(Brightness.light),

      // Button themes with high contrast
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.disabled)) {
              return const Color(
                0xFF000000,
              ).withValues(alpha: .24); // Faded black background
            }
            return const Color(0xFF000000); // Normal black
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.disabled)) {
              return const Color(
                0xFFFFFFFF,
              ).withValues(alpha: .60); // More visible white text
            }
            return const Color(0xFFFFFFFF); // Normal white
          }),
          elevation: WidgetStateProperty.resolveWith<double?>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.disabled)) return 0.0;
            return 4.0;
          }),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          shape: WidgetStateProperty.resolveWith<OutlinedBorder?>((
            Set<WidgetState> states,
          ) {
            Color borderColor = const Color(0xFF000000);
            if (states.contains(WidgetState.disabled)) {
              borderColor = const Color(
                0xFF000000,
              ).withValues(alpha: .38); // Faded border
            }
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: borderColor, width: 2),
            );
          }),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF000000),
          backgroundColor: const Color(0xFFFFFFFF),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          side: const BorderSide(color: Color(0xFF000000), width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF000000),
        foregroundColor: Color(0xFFFFFFFF),
        elevation: 4,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Card theme with high contrast borders
      cardTheme: CardThemeData(
        color: const Color(0xFFFFFFFF),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFF000000), width: 2),
        ),
      ),

      // Input decoration theme for better visibility
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF000000), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF000000), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF0066CC), width: 3),
        ),
        filled: true,
        fillColor: Color(0xFFFFFFFF),
      ),
      // Switch theme for high contrast visibility
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            // Switch is ON
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.focused)) {
              return Colors
                  .grey[200]; // Lighter grey thumb for ON-hovered/focused
            }
            return const Color(0xFFFFFFFF); // White thumb for ON
          } else {
            // Switch is OFF
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.focused)) {
              return Colors
                  .grey[100]; // Very light grey thumb for OFF-hovered/focused
            }
            return Colors.grey[50]; // Off-white thumb for OFF
          }
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            // Switch is ON
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.focused)) {
              return const Color(
                0xFF222222,
              ); // Slightly lighter black track for ON-hovered/focused
            }
            return const Color(0xFF000000); // Black track for ON
          } else {
            // Switch is OFF
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.focused)) {
              return Colors
                  .grey[500]; // Darker grey track for OFF-hovered/focused
            }
            return Colors.grey[400]; // Medium grey track for OFF
          }
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return const Color(
              0xFF333333,
            ); // Darker outline for focused/hovered states
          }
          return const Color(0xFF000000); // Black outline
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return const Color(0xFFFFFFFF).withValues(alpha: .08);
          }
          if (states.contains(WidgetState.focused)) {
            return const Color(0xFFFFFFFF).withValues(alpha: .12);
          }
          return null;
        }),
      ),
    );
  }

  /// High contrast dark theme with enhanced readability
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // High contrast dark color scheme
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFFFFFFF), // Pure white
        onPrimary: Color(0xFF000000), // Pure black
        secondary: Color(0xFF66B3FF), // Light blue for contrast
        onSecondary: Color(0xFF000000), // Pure black
        surface: Color(0xFF000000), // Pure black
        onSurface: Color(0xFFFFFFFF), // Pure white
        error: Color(0xFFFF6666), // Light red for visibility
        onError: Color(0xFF000000), // Pure black
        outline: Color(0xFFFFFFFF), // Pure white for borders
        shadow: Color(0xFFFFFFFF), // White shadows
      ),

      // Enhanced text theme for better readability
      textTheme: _buildHighContrastTextTheme(Brightness.dark),

      // Button themes with high contrast
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.disabled)) {
              return const Color(
                0xFFFFFFFF,
              ).withValues(alpha: .24); // Faded white background
            }
            return const Color(0xFFFFFFFF); // Normal white
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.disabled)) {
              return const Color(
                0xFF000000,
              ).withValues(alpha: .60); // More visible black text
            }
            return const Color(0xFF000000); // Normal black
          }),
          overlayColor: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.hovered)) {
              return const Color(
                0xFF000000,
              ).withValues(alpha: .12); // Black overlay for hover
            }
            if (states.contains(WidgetState.pressed)) {
              return const Color(
                0xFF000000,
              ).withValues(alpha: .20); // Darker black overlay for press
            }
            return null;
          }),
          elevation: WidgetStateProperty.resolveWith<double?>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.disabled)) return 0.0;
            return 4.0;
          }),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          shape: WidgetStateProperty.resolveWith<OutlinedBorder?>((
            Set<WidgetState> states,
          ) {
            Color borderColor = const Color(0xFFFFFFFF);
            if (states.contains(WidgetState.disabled)) {
              borderColor = const Color(
                0xFFFFFFFF,
              ).withValues(alpha: .38); // Faded border
            }
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: borderColor, width: 2),
            );
          }),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.disabled)) {
              return const Color(0xFFFFFFFF).withValues(alpha: .38);
            }
            return const Color(0xFFFFFFFF);
          }),
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            // For OutlinedButton, background is typically transparent unless specified
            // Here, we maintain the black background for consistency in this high contrast theme
            if (states.contains(WidgetState.disabled)) {
              return const Color(0xFF000000).withValues(alpha: .12);
            }
            return const Color(0xFF000000);
          }),
          overlayColor: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.hovered)) {
              return const Color(
                0xFFFFFFFF,
              ).withValues(alpha: .12); // White overlay for hover
            }
            if (states.contains(WidgetState.pressed)) {
              return const Color(
                0xFFFFFFFF,
              ).withValues(alpha: .20); // Brighter white overlay for press
            }
            return null;
          }),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          side: WidgetStateProperty.resolveWith<BorderSide?>((
            Set<WidgetState> states,
          ) {
            Color borderColor = const Color(0xFFFFFFFF);
            if (states.contains(WidgetState.disabled)) {
              borderColor = const Color(0xFFFFFFFF).withValues(alpha: .38);
            }
            return BorderSide(color: borderColor, width: 2);
          }),
          shape: WidgetStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),

      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFFFFFF),
        foregroundColor: Color(0xFF000000),
        elevation: 4,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFF000000),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Card theme with high contrast borders
      cardTheme: CardThemeData(
        color: const Color(0xFF000000),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFFFFFFFF), width: 2),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFFFFFFF), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFFFFFFF), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF66B3FF), width: 3),
        ),
        filled: true,
        fillColor: Color(0xFF000000),
      ),
      // Switch theme for high contrast visibility
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            // Switch is ON
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.focused)) {
              return Colors
                  .grey[800]; // Darker grey thumb for ON-hovered/focused
            }
            return const Color(0xFF000000); // Black thumb for ON
          } else {
            // Switch is OFF
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.focused)) {
              return Colors
                  .grey[900]; // Very dark grey thumb for OFF-hovered/focused
            }
            return const Color(
              0xFF111111,
            ); // Very dark (almost black) thumb for OFF
          }
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            // Switch is ON
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.focused)) {
              return const Color(
                0xFFEEEEEE,
              ); // Slightly darker white track for ON-hovered/focused
            }
            return const Color(0xFFFFFFFF); // White track for ON
          } else {
            // Switch is OFF
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.focused)) {
              return Colors
                  .grey[600]; // Lighter grey track for OFF-hovered/focused
            }
            return Colors.grey[700]; // Dark grey track for OFF
          }
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return const Color(
              0xFFDDDDDD,
            ); // Lighter outline for focused/hovered states
          }
          return const Color(0xFFFFFFFF); // White outline
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return const Color(0xFF000000).withValues(alpha: 0.08);
          }
          if (states.contains(WidgetState.focused)) {
            return const Color(0xFF000000).withValues(alpha: 0.12);
          }
          return null;
        }),
      ),

      // ListTile theme for high contrast visibility
      listTileTheme: ListTileThemeData(
        iconColor: const Color(0xFFFFFFFF), // Ensure icons are white
        textColor: const Color(0xFFFFFFFF), // Ensure text is white
        selectedTileColor: const Color(
          0xFFFFFFFF,
        ).withValues(alpha: .20), // Light white selection
      ),
      // Set the global hover color for better visibility in dark high contrast
      hoverColor: const Color(
        0xFFFFFFFF,
      ).withValues(alpha: .12), // More visible white hover
    );
  }

  /// Builds a high contrast text theme for better readability
  static TextTheme _buildHighContrastTextTheme(Brightness brightness) {
    final textColor = brightness == Brightness.light
        ? const Color(0xFF000000)
        : const Color(0xFFFFFFFF);

    return TextTheme(
      displayLarge: TextStyle(
        color: textColor,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
      displayMedium: TextStyle(
        color: textColor,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
      displaySmall: TextStyle(
        color: textColor,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        height: 1.3,
      ),
      headlineLarge: TextStyle(
        color: textColor,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        height: 1.3,
      ),
      headlineMedium: TextStyle(
        color: textColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      headlineSmall: TextStyle(
        color: textColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      titleLarge: TextStyle(
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      titleMedium: TextStyle(
        color: textColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      titleSmall: TextStyle(
        color: textColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
      bodyLarge: TextStyle(
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        color: textColor,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        color: textColor,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        height: 1.5,
      ),
      labelLarge: TextStyle(
        color: textColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      labelMedium: TextStyle(
        color: textColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      labelSmall: TextStyle(
        color: textColor,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
    );
  }
}
