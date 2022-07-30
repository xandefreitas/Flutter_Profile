import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';

class LanguageProvider extends ChangeNotifier {
  Locale currentLocale;
  LanguageProvider({required this.currentLocale});

  Locale get locale => currentLocale;

  void setLocale(Locale _locale) {
    if (!L10n.all.contains(_locale)) return;
    currentLocale = _locale;
    notifyListeners();
  }
}
