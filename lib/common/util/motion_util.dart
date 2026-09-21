import 'package:flutter/material.dart';

/// Whether the OS "reduce motion" accessibility setting is on, so repeating
/// animations (a looping shake, a looping Lottie) can be skipped for users
/// who've asked the system not to show them.
abstract class MotionUtil {
  static bool reduceMotion(BuildContext context) =>
      MediaQuery.of(context).disableAnimations;
}
