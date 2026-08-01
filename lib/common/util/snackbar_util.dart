import 'package:flutter/material.dart';

abstract class SnackBarUtil {
  static void showCustomSnackBar({required BuildContext context, required SnackBar snackbar}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
