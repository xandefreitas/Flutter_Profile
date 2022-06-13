import 'package:flutter/material.dart';
import 'package:flutter_profile/screens/NavigationManagementScreen/navigation_management_screen.dart';

void main() {
  runApp(const FlutterProfile());
}

class FlutterProfile extends StatelessWidget {
  const FlutterProfile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Profile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NavigationManagementScreen(),
    );
  }
}
