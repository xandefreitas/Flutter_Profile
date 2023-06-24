import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_profile/common/models/personal_data.dart';
import 'package:flutter_profile/common/widgets/CustomDrawer/components/drawer_custom_title.dart';
import 'package:flutter_profile/common/widgets/language_widget.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:unicons/unicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../util/app_routes.dart';
import '../../util/contact_util.dart';
import '../../util/resume_util.dart';
import '../custom_icon_button.dart';
import 'components/drawer_custom_text_button.dart';
import 'components/drawer_logout_button.dart';

class CustomDrawer extends StatefulWidget {
  final PersonalData personalData;
  final List<Reference> resumesList;
  const CustomDrawer({
    Key? key,
    required this.resumesList,
    required this.personalData,
  }) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late PersonalData personalData;
  @override
  void initState() {
    personalData = widget.personalData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final ContactUtil contact = ContactUtil(context: context, text: text);
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 48.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset('assets/images/drawer_background.png'),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DrawerCustomTitle(title: text.drawerTitleContactMe)
                      .animate()
                      .moveX(
                        begin: -320,
                        delay: 100.ms,
                        duration: 300.ms,
                        curve: Curves.easeInOutCubic,
                      )
                      .fadeIn(),
                  Row(
                    children: [
                      CustomIconButton(
                        onTap: () {
                          contact.launchUrl(personalData.linkedinUrl);
                        },
                        icon: UniconsLine.linkedin,
                        iconColor: AppColors.linkedinBlue,
                      ),
                      CustomIconButton(
                        onTap: () {
                          contact.launchUrl(personalData.gitHubUrl);
                        },
                        icon: UniconsLine.github,
                        iconColor: AppColors.black,
                      ),
                      CustomIconButton(
                        onTap: () {
                          contact.launchWhatsApp(personalData.phoneNumberBR);
                        },
                        icon: UniconsLine.whatsapp_alt,
                        iconColor: AppColors.whatsappGreen,
                      ),
                    ],
                  ).animate().fadeIn(delay: 200.ms, duration: 300.ms),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DrawerCustomTextButton(
                          leading: const Padding(
                            padding: EdgeInsets.only(right: 4.0),
                            child: Icon(
                              Icons.phone,
                              color: AppColors.profilePrimary,
                            ),
                          ),
                          title: text.drawerCallBrazilButton,
                          onTap: () {
                            contact.launchPhone(personalData.phoneNumberBR);
                          },
                        ),
                        DrawerCustomTextButton(
                          leading: const Padding(
                            padding: EdgeInsets.only(right: 4.0),
                            child: Icon(
                              Icons.phone,
                              color: AppColors.profilePrimary,
                            ),
                          ),
                          title: text.drawerCallSwedenButton,
                          onTap: () {
                            contact.launchPhone(personalData.phoneNumberSE);
                          },
                        ),
                        DrawerCustomTextButton(
                          leading: const Padding(
                            padding: EdgeInsets.only(right: 4.0),
                            child: Icon(
                              Icons.mail_rounded,
                              color: AppColors.profilePrimary,
                            ),
                          ),
                          title: text.drawerEmailButton,
                          onTap: () {
                            contact.launchMail(personalData.email);
                          },
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 300.ms, duration: 300.ms),
                  DrawerCustomTitle(title: text.drawerTitleDownloadMyCV)
                      .animate()
                      .moveX(
                        begin: -320,
                        delay: 400.ms,
                        duration: 300.ms,
                        curve: Curves.easeInOutCubic,
                      )
                      .fadeIn(),
                  Column(
                    children: [
                      ...widget.resumesList.map(
                        (e) => FutureBuilder(
                          future: ResumeUtil.openResume('resumes/${e.name}'),
                          builder: (context, snapshot) {
                            return DrawerCustomTextButton(
                              title: e.name,
                              onTap: () {
                                if (snapshot.hasData) {
                                  Navigator.pushNamed(
                                    context,
                                    pdfViewerRoute,
                                    arguments: {"file": snapshot.data as File, "title": e.name},
                                  );
                                }
                              },
                              leading: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: snapshot.connectionState == ConnectionState.waiting
                                    ? Container(
                                        padding: const EdgeInsets.all(4),
                                        width: 24,
                                        height: 24,
                                        child: const CircularProgressIndicator(
                                          color: AppColors.profilePrimary,
                                        ),
                                      )
                                    : Icon(
                                        snapshot.hasData ? Icons.file_download : Icons.error,
                                        color: AppColors.profilePrimary,
                                      ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 500.ms, duration: 300.ms),
                  DrawerCustomTitle(title: text.drawerTitleLanguage)
                      .animate()
                      .moveX(
                        begin: -320,
                        delay: 600.ms,
                        duration: 300.ms,
                        curve: Curves.easeInOutCubic,
                      )
                      .fadeIn(),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, top: 16),
                    child: LanguageWidget(),
                  ).animate().fadeIn(delay: 700.ms, duration: 300.ms),
                  const Spacer(),
                  Visibility(
                    visible: !FirebaseAuth.instance.currentUser!.isAnonymous,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 16),
                      child: const DrawerLogoutButton().animate().fadeIn(delay: 800.ms, duration: 300.ms),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
