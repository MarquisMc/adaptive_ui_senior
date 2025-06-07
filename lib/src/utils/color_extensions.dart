import 'package:flutter/material.dart';

/// Extension on [Color] to modify individual channel values.
/// Primarily used for adjusting the alpha channel while preserving
/// the other color components.
extension ColorChannelExtension on Color {
  /// Returns a copy of this color with the provided channel values replaced.
  ///
  /// The [alpha] parameter expects a normalized value in the range 0.0 - 1.0.
  /// Any value outside this range will be clamped.
  Color withValues({double? alpha, int? red, int? green, int? blue}) {
    final int a = ((alpha ?? this.alpha / 255).clamp(0.0, 1.0) * 255).round();
    return Color.fromARGB(a, red ?? this.red, green ?? this.green, blue ?? this.blue);
  }
}
