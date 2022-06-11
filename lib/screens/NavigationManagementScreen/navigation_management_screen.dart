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

  NavBarIcons _navBarIcons = NavBarIcons.PROFILE;
  Color tabActiveColor = AppColors.profilePrimary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          if (_navBarIcons == NavBarIcons.PROFILE) ProfileScreen(scaffoldKey: _scaffoldKey),
          if (_navBarIcons == NavBarIcons.CERTIFICATES)
            const Center(
              child: Text('Certificados Placeholder'),
            ),
          if (_navBarIcons == NavBarIcons.EXPERIENCES)
            const Center(
              child: Text('Experiências Placeholder'),
            ),
          if (_navBarIcons == NavBarIcons.DEPOSITIONS)
            const Center(
              child: Text('Depoimentos Placeholder'),
            ),
          CustomBottomNavBar(
            changeScreen: changeScreen,
            navBarIcons: _navBarIcons,
            tabActiveColor: tabActiveColor,
          ),
        ],
      ),
    );
  }

  changeScreen(NavBarIcons navBarIcons, Color activeColor) {
    setState(() {
      _navBarIcons = navBarIcons;
      tabActiveColor = activeColor;
    });
  }
}
