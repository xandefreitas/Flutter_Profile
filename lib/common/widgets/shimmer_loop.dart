import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_ui/material_ui.dart';

extension ShimmerLoop on Widget {
  /// Wraps this widget in the app's standard looping shimmer placeholder animation.
  Widget shimmerLoop({
    required List<Color> colors,
    Color? color,
    Duration duration = const Duration(milliseconds: 800),
  }) {
    return animate(onComplete: (controller) => controller.loop())
        .shimmer(duration: duration, color: color, colors: colors);
  }
}
