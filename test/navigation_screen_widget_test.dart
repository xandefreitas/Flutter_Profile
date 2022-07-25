import 'package:flutter/material.dart';
import 'package:flutter_profile/screens/NavigationManagementScreen/navigation_management_screen.dart';
import 'package:flutter_profile/screens/ProfileScreen/profile_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Should display Page view when opened', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: NavigationManagementScreen()),
    );
    final pageView = find.byWidgetPredicate((widget) => widget is PageView);
    expect(pageView, findsOneWidget);
  });
  testWidgets('Should display profile screen when opened', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: NavigationManagementScreen()),
    );
    final profileScreen = find.byType(ProfileScreen);
    expect(profileScreen, findsOneWidget);
  });
  testWidgets('Should display images when opened', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: NavigationManagementScreen()),
    );
    final mainImage = find.byType(Image);
    expect(mainImage, findsWidgets);
  });
}
