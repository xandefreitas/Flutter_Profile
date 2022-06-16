import 'package:flutter/material.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:flutter_profile/screens/CertificatesScreen/certificates_screen.dart';
import 'package:flutter_profile/screens/NavigationManagementScreen/components/custom_bottom_nav_bar.dart';
import 'package:flutter_profile/screens/ProfileScreen/profile_screen.dart';

import '../../common/enums/nav_bar_items.dart';
import '../../common/widgets/custom_screen.dart';
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
              const CustomScreen(
                tabColor: AppColors.certificatesPrimary,
                title: 'Certificados',
                tabIcon: Icons.school,
                screenBody: CertificatesScreen(),
              ),
              CustomScreen(
                tabColor: AppColors.experiencesPrimary,
                title: 'Experiência',
                tabIcon: Icons.work,
                screenBody: Container(),
              ),
              CustomScreen(
                tabColor: AppColors.depositionsPrimary,
                title: 'Depoimentos',
                tabIcon: Icons.comment,
                screenBody: Container(),
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
      _controller.jumpToPage(index);
    });
  }

  changeScreenBySliding(int index) {
    setState(() {
      _index = index;
      if (index == NavBarItems.PROFILE.index) {
        tabActiveColor = NavBarItems.PROFILE.color;
      }
      if (index == NavBarItems.CERTIFICATES.index) {
        tabActiveColor = NavBarItems.CERTIFICATES.color;
      }
      if (index == NavBarItems.EXPERIENCES.index) {
        tabActiveColor = NavBarItems.EXPERIENCES.color;
      }
      if (index == NavBarItems.DEPOSITIONS.index) {
        tabActiveColor = NavBarItems.DEPOSITIONS.color;
      }
    });
  }
}
