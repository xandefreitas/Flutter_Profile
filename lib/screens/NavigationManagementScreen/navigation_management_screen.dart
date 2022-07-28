import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:flutter_profile/screens/CertificatesScreen/certificates_screen.dart';
import 'package:flutter_profile/screens/NavigationManagementScreen/components/custom_bottom_nav_bar.dart';
import 'package:flutter_profile/screens/NavigationManagementScreen/components/custom_rail_nav_bar.dart';
import 'package:flutter_profile/screens/ProfileScreen/profile_screen.dart';
import 'package:flutter_profile/screens/WorkHistoryScreen/work_history_screen.dart';

import '../../common/enums/nav_bar_items.dart';
import '../../common/widgets/custom_screen.dart';
import '../DepositionsScreen/depositions_screen.dart';
import '../../common/widgets/custom_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NavigationManagementScreen extends StatefulWidget {
  const NavigationManagementScreen({Key? key}) : super(key: key);

  @override
  State<NavigationManagementScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<NavigationManagementScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final _controller = PageController(initialPage: 0);
  final FocusNode _nameTextFocus = FocusNode();
  final FocusNode _relationshipTextFocus = FocusNode();
  final FocusNode _depositionTextFocus = FocusNode();
  late AppLocalizations text;
  int _index = 0;
  Color tabActiveColor = AppColors.profilePrimary;

  @override
  Widget build(BuildContext context) {
    text = AppLocalizations.of(context)!;
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          Padding(
            padding: kIsWeb ? const EdgeInsets.only(left: 120.0) : EdgeInsets.zero,
            child: PageView(
              controller: _controller,
              onPageChanged: changeScreenBySliding,
              children: [
                ProfileScreen(scaffoldKey: _scaffoldKey),
                CustomScreen(
                  tabColor: AppColors.certificatesPrimary,
                  title: text.certificatesTitle,
                  tabIcon: Icons.school,
                  screenBody: const CertificatesScreen(),
                ),
                CustomScreen(
                  tabColor: AppColors.experiencesPrimary,
                  title: text.experienceTitle,
                  tabIcon: Icons.work,
                  screenBody: const WorkHistoryScreen(),
                ),
                CustomScreen(
                  tabColor: AppColors.depositionsPrimary,
                  title: text.depositionsTitle,
                  tabIcon: Icons.comment,
                  screenBody: DepositionsScreen(
                    nameTextFocus: _nameTextFocus,
                    relationshipTextFocus: _relationshipTextFocus,
                    depositionTextFocus: _depositionTextFocus,
                  ),
                ),
              ],
            ),
          ),
          if (!kIsWeb)
            CustomBottomNavBar(
              changeScreen: changeScreen,
              index: _index,
              tabActiveColor: tabActiveColor,
            ),
          if (kIsWeb)
            CustomRailNavBar(
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
      _nameTextFocus.unfocus();
      _relationshipTextFocus.unfocus();
      _depositionTextFocus.unfocus();
    });
  }

  changeScreenBySliding(int index) {
    setState(() {
      _nameTextFocus.unfocus();
      _relationshipTextFocus.unfocus();
      _depositionTextFocus.unfocus();
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
