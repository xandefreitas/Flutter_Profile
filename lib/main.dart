import 'package:flutter/material.dart';

void main() {
  runApp(const FlutterProfile());
}

class FlutterProfile extends StatelessWidget {
  const FlutterProfile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Profile'),
        ),
      ),
    );
  }
}
