import 'package:flutter/material.dart';
import 'package:flutter_profile/common/util/shared_preferences_util.dart';
import 'package:flutter_profile/flutter_profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Locale locale = await SharedPreferencesUtil.getLocale();
  runApp(FlutterProfile(locale: locale));
}
