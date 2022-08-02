import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile/common/util/shared_preferences_util.dart';
import 'package:flutter_profile/flutter_profile.dart';

import 'common/bloc/languageBloc/language_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Locale locale = await SharedPreferencesUtil.getLocale();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) => runApp(
      BlocProvider(
        create: ((context) => LanguageBloc()),
        child: FlutterProfile(locale: locale),
      ),
    ),
  );
}
