import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_profile/common/util/app_routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'common/bloc/languageBloc/language_bloc.dart';
import 'common/bloc/languageBloc/language_state.dart';
import 'l10n/l10n.dart';

class FlutterProfile extends StatefulWidget {
  final Locale locale;
  const FlutterProfile({Key? key, required this.locale}) : super(key: key);

  @override
  State<FlutterProfile> createState() => _FlutterProfileState();
}

class _FlutterProfileState extends State<FlutterProfile> {
  late Locale _locale;

  @override
  void initState() {
    _locale = widget.locale;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LanguageBloc, LanguageState>(
      listener: (context, state) {
        if (state is LanguageUpdatedState) {
          setState(() {
            _locale = state.locale;
          });
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Profile',
        theme: ThemeData(
          primarySwatch: Colors.blue,
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
