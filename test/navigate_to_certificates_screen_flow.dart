import 'package:flutter/material.dart';
import 'package:flutter_profile/common/widgets/custom_screen.dart';
import 'package:flutter_profile/screens/NavigationManagementScreen/navigation_management_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Should navigate to certificates screen on drag', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: NavigationManagementScreen(),
      ),
    );
    final pageView = find.byType(PageView);
    await tester.drag(pageView, const Offset(-500, 0));
    await tester.pumpAndSettle();
    final customScreen = find.byType(CustomScreen);
    expect(customScreen, findsOneWidget);
    final certificatesScreen = find.byIcon(Icons.school);
    expect(certificatesScreen, findsNWidgets(2));
  });
}
