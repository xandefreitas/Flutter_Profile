import 'package:flutter/material.dart';
import 'package:flutter_profile/screens/CertificatesScreen/certificates_form_screen.dart';

import '../../screens/NavigationManagementScreen/navigation_management_screen.dart';
import '../../screens/OnboardingScreen/onboarding_screen.dart';
import 'login_management.dart';

const String loginManagementRoute = '/';
const String onboardingRoute = '/onboarding';
const String navigationManagementRoute = '/home';
const String certificatesFormRoute = 'certificatesForm';
const String workHistoryFormRoute = 'workHistoryForm';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginManagementRoute:
        return MaterialPageRoute(builder: (_) => LoginManagement());
      case onboardingRoute:
        final arguments = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => OnboardingScreen(
            initialPage: arguments["page"],
          ),
        );
      case navigationManagementRoute:
        return MaterialPageRoute(builder: (_) => const NavigationManagementScreenContainer());
      case certificatesFormRoute:
        final arguments = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => CertificatesFormScreen(
            certificate: arguments["certificate"],
            title: arguments["title"],
            screenMode: arguments["screenMode"],
            addCertificate: arguments["addCertificate"],
            updateCertificate: arguments["updateCertificate"],
            removeCertificate: arguments["removeCertificate"],
          ),
        );
      case workHistoryFormRoute:
        return MaterialPageRoute(builder: (_) => const Scaffold());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
