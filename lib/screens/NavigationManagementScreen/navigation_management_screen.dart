import 'package:flutter/material.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:flutter_profile/screens/NavigationManagementScreen/components/custom_bottom_nav_bar.dart';
import 'package:flutter_profile/screens/ProfileScreen/profile_screen.dart';

import '../../common/enums/nav_bar_items.dart';
import '../ProfileScreen/components/custom_drawer.dart';

class NavigationManagementScreen extends StatefulWidget {
  const NavigationManagementScreen({Key? key}) : super(key: key);

  @override
  State<NavigationManagementScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<NavigationManagementScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final _controller = PageController(initialPage: 0);

  int _index = 0;
  Color tabActiveColor = AppColors.profilePrimary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: changeScreenBySliding,
            children: [
              ProfileScreen(scaffoldKey: _scaffoldKey),
              const Center(
                child: Text('Certificados Placeholder'),
              ),
              const Center(
                child: Text('Experiências Placeholder'),
              ),
              const Center(
                child: Text('Depoimentos Placeholder'),
              ),
            ],
          ),
          CustomBottomNavBar(
            changeScreen: changeScreen,
            index: _index,
            tabActiveColor: tabActiveColor,
          ),
        ],
      ),
    );
  }

  changeScreen(int index, Color activeColor) {
    setState(() {
      _index = index;
      tabActiveColor = activeColor;
      _controller.animateToPage(_index, duration: const Duration(milliseconds: 300), curve: Curves.ease);
    });
  }

  changeScreenBySliding(int index) {
    setState(() {
      _index = index;
      if (index == 0) {
        tabActiveColor = NavBarItems.PROFILE.color;
      }
      if (index == 1) {
        tabActiveColor = NavBarItems.CERTIFICATES.color;
      }
      if (index == 2) {
        tabActiveColor = NavBarItems.EXPERIENCES.color;
      }
      if (index == 3) {
        tabActiveColor = NavBarItems.DEPOSITIONS.color;
      }
    });
  }
}
