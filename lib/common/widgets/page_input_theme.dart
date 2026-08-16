import 'package:flutter/material.dart';

/// Overrides the ambient input styling (label, focus border, cursor) so form
/// inputs under [child] use [color] as their accent instead of the app-wide
/// default set in the root [ThemeData.inputDecorationTheme].
class PageInputTheme extends StatelessWidget {
  final Color color;
  final Widget child;
  const PageInputTheme({required this.color, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: color),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: color),
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(cursorColor: color),
      ),
      child: child,
    );
  }
}
