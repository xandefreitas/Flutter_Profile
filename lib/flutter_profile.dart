import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'common/bloc/languageBloc/language_bloc.dart';
import 'common/bloc/languageBloc/language_state.dart';
import 'common/util/app_routes.dart';
import 'common/util/shared_preferences_util.dart';
import 'core/app_colors.dart';
import 'l10n/app_localizations.dart';
import 'l10n/l10n.dart';

class FlutterProfile extends StatefulWidget {
  const FlutterProfile({super.key});

  @override
  State<FlutterProfile> createState() => _FlutterProfileState();
}

class _FlutterProfileState extends State<FlutterProfile> {
  Locale _locale = Locale('en');

  @override
  void initState() {
    SharedPreferencesUtil.getLocale().then((locale) {
      _locale = locale;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LanguageBloc, LanguageState>(
      listener: (context, state) {
        if (state is LanguageUpdatedState) {
          _locale = state.locale;
        }
      },
      builder:
          (context, state) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Profile',
            theme: ThemeData(
              primaryColor: AppColors.profilePrimary,
              appBarTheme: AppBarTheme(foregroundColor: AppColors.white),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    AppColors.profilePrimary,
                  ),
                  foregroundColor: WidgetStateProperty.all(AppColors.white),
                ),
              ),
            ),
            supportedLocales: L10n.all,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            locale: _locale,
            onGenerateRoute: AppRoutes.generateRoute,
          ),
    );
  }
}
