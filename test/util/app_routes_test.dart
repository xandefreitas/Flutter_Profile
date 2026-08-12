import 'package:flutter/material.dart';
import 'package:flutter_profile/common/util/app_routes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('routes with no required arguments resolve to a MaterialPageRoute', () {
    expect(AppRoutes.generateRoute(const RouteSettings(name: loginManagementRoute)), isA<MaterialPageRoute>());
    expect(AppRoutes.generateRoute(const RouteSettings(name: navigationManagementRoute)), isA<MaterialPageRoute>());
    expect(AppRoutes.generateRoute(const RouteSettings(name: aboutRoute)), isA<MaterialPageRoute>());
  });

  test('routes requiring a Map of arguments resolve to a MaterialPageRoute when given one', () {
    expect(AppRoutes.generateRoute(RouteSettings(name: onboardingRoute, arguments: {})), isA<MaterialPageRoute>());
    expect(AppRoutes.generateRoute(RouteSettings(name: certificatesFormRoute, arguments: {})), isA<MaterialPageRoute>());
    expect(AppRoutes.generateRoute(RouteSettings(name: workHistoryFormRoute, arguments: {})), isA<MaterialPageRoute>());
    expect(AppRoutes.generateRoute(RouteSettings(name: pdfViewerRoute, arguments: {})), isA<MaterialPageRoute>());
    expect(AppRoutes.generateRoute(RouteSettings(name: legalDocumentRoute, arguments: {})), isA<MaterialPageRoute>());
  });

  test('routes requiring a Map throw when arguments are missing (no defensive handling)', () {
    expect(() => AppRoutes.generateRoute(const RouteSettings(name: onboardingRoute)), throwsA(isA<TypeError>()));
  });

  testWidgets('unknown route falls back to a "no route defined" screen', (tester) async {
    final route = AppRoutes.generateRoute(const RouteSettings(name: '/does-not-exist'));
    expect(route, isA<MaterialPageRoute>());

    // Build the route's widget directly instead of driving a full Navigator,
    // which would also build the '/' (login) route as part of its default
    // initial-route-stack generation and crash on missing Firebase setup.
    await tester.pumpWidget(MaterialApp(home: Builder(builder: (route as MaterialPageRoute).builder)));

    expect(find.text('No route defined for /does-not-exist'), findsOneWidget);
  });
}
