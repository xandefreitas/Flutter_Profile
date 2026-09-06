import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:material_ui/material_ui.dart' as mui;

import 'common/bloc/languageBloc/language_bloc.dart';
import 'common/bloc/languageBloc/language_state.dart';
import 'common/util/app_routes.dart';
import 'common/util/shared_preferences_util.dart';
import 'core/app_colors.dart';
import 'l10n/app_localizations.dart';
import 'l10n/l10n.dart';

class FlutterProfile extends StatefulWidget {
  final RouteFactory? onGenerateRoute;
  const FlutterProfile({super.key, this.onGenerateRoute});

  @override
  State<FlutterProfile> createState() => _FlutterProfileState();
}

class _FlutterProfileState extends State<FlutterProfile> {
  Locale _locale = Locale('en');

  @override
  void initState() {
    SharedPreferencesUtil.getLocale().then((locale) {
      if (!mounted) return;
      setState(() {
        _locale = locale;
      });
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
      builder: (context, state) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Profile',
        theme: ThemeData(
          primaryColor: AppColors.profilePrimary,
          scaffoldBackgroundColor: AppColors.white,
          appBarTheme: AppBarTheme(
            foregroundColor: AppColors.white,
            backgroundColor: AppColors.white,
          ),
          drawerTheme: DrawerThemeData(backgroundColor: AppColors.white),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                AppColors.profilePrimary,
              ),
              foregroundColor: WidgetStateProperty.all(AppColors.white),
              overlayColor: WidgetStateProperty.all(
                AppColors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          dialogTheme: DialogThemeData(backgroundColor: AppColors.white),
          inputDecorationTheme: const InputDecorationTheme(
            labelStyle: TextStyle(color: AppColors.profilePrimary),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.profilePrimary),
            ),
          ),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: AppColors.profilePrimary,
          ),
        ),
        supportedLocales: L10n.all,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          // phone_form_field's internals moved to material_ui, which defines
          // its own MaterialLocalizations type distinct from the legacy one
          // above; both delegates are needed side by side.
          mui.GlobalMaterialLocalizations.delegate,
        ],
        locale: _locale,
        onGenerateRoute: widget.onGenerateRoute ?? AppRoutes.generateRoute,
      ),
    );
  }
}
