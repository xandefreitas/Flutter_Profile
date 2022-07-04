import 'package:flutter/material.dart';

class EmploymentHistoryScreen extends StatefulWidget {
  const EmploymentHistoryScreen({Key? key}) : super(key: key);

  @override
  State<EmploymentHistoryScreen> createState() => _EmploymentHistoryScreenState();
}

class _EmploymentHistoryScreenState extends State<EmploymentHistoryScreen> {
  final _controller = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Container(),
        Container(),
        Container(),
      ],
    );
  }
}
