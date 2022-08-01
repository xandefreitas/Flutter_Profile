import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_profile/app_routes.dart';
import 'package:flutter_profile/screens/OnboardingScreen/onboarding_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_profile/screens/login_management.dart';
import 'package:provider/provider.dart';
import 'common/provider/language_provider.dart';
import 'l10n/l10n.dart';
import 'screens/NavigationManagementScreen/navigation_management_screen.dart';

class FlutterProfile extends StatelessWidget {
  final Locale locale;
  const FlutterProfile({Key? key, required this.locale}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LanguageProvider(currentLocale: locale),
      builder: (context, child) {
        final provider = Provider.of<LanguageProvider>(context);
        return MaterialApp(
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
          locale: provider.locale,
          routes: {
            AppRoutes.loginManagement: (context) => const LoginManagement(),
            AppRoutes.onboarding: (context) => const OnboardingScreen(),
            AppRoutes.home: (context) => const NavigationManagementScreen(),
          },
        );
      },
    );
  }
}
