import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'common/bloc/languageBloc/language_bloc.dart';
import 'common/bloc/skillsBloc/skills_bloc.dart';
import 'common/util/default_firebase_options.dart';
import 'flutter_profile.dart';

Future<void> _firebaseMessagingBackgroundHandler(_) async =>
    Firebase.initializeApp();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) => runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LanguageBloc()),
          BlocProvider(create: (context) => SkillsBloc()),
        ],
        child: FlutterProfile(),
      ),
    ),
  );
}
