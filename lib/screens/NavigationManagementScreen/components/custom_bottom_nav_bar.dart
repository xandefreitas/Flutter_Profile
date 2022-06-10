import 'package:flutter/material.dart';
import 'package:flutter_profile/core/app_colors.dart';

import '../../../common/enums/nav_bar_items.dart';

class CustomBottomNavBar extends StatefulWidget {
  final Function(NavBarIcons, Color) changeScreen;
  final NavBarIcons navBarIcons;
  final Color tabActiveColor;
  const CustomBottomNavBar({
    Key? key,
    required this.changeScreen,
    required this.navBarIcons,
    required this.tabActiveColor,
  }) : super(key: key);

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.tabActiveColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.changeScreen(NavBarIcons.PROFILE, AppColors.profilePrimary);
                });
              },
              child: widget.navBarIcons == NavBarIcons.PROFILE
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      width: 160,
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: widget.tabActiveColor.withOpacity(0.8),
                                ),
                              ),
                              const Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Perfil',
                            style: TextStyle(
                              color: widget.tabActiveColor.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: Color(0xffAEAEAE),
                      ),
                    ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.changeScreen(NavBarIcons.CERTIFICATES, AppColors.certificatesPrimary);
                });
              },
              child: widget.navBarIcons == NavBarIcons.CERTIFICATES
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      width: 160,
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: widget.tabActiveColor.withOpacity(0.8),
                                ),
                              ),
                              const Icon(
                                Icons.school,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Certificados',
                            style: TextStyle(
                              color: widget.tabActiveColor.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.school_outlined,
                        color: Color(0xffAEAEAE),
                      ),
                    ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.changeScreen(NavBarIcons.EXPERIENCES, AppColors.experiencesPrimary);
                });
              },
              child: widget.navBarIcons == NavBarIcons.EXPERIENCES
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      width: 160,
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: widget.tabActiveColor.withOpacity(0.8),
                                ),
                              ),
                              const Icon(
                                Icons.work,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Experiência',
                            style: TextStyle(
                              color: widget.tabActiveColor.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.work_outline,
                        color: Color(0xffAEAEAE),
                      ),
                    ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.changeScreen(NavBarIcons.DEPOSITIONS, AppColors.depositionsPrimary);
                });
              },
              child: widget.navBarIcons == NavBarIcons.DEPOSITIONS
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      width: 160,
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: widget.tabActiveColor.withOpacity(0.8),
                                ),
                              ),
                              const Icon(
                                Icons.comment,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Depoimentos',
                            style: TextStyle(
                              color: widget.tabActiveColor.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.comment_outlined,
                        color: Color(0xffAEAEAE),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
