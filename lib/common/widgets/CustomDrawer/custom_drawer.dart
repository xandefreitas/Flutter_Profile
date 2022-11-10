import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile/common/widgets/CustomDrawer/components/drawer_custom_title.dart';
import 'package:flutter_profile/common/widgets/language_widget.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:flutter_profile/core/app_text_styles.dart';
import 'package:flutter_profile/core/consts.dart';
import 'package:unicons/unicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../util/app_routes.dart';
import '../../util/contact_util.dart';
import '../../util/resume_util.dart';
import '../custom_icon_button.dart';
import 'components/drawer_custom_text_button.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late Future<ListResult> futureResumes;
  @override
  void initState() {
    futureResumes = FirebaseStorage.instance.ref('/resumes').listAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
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
                  DrawerCustomTitle(title: text.drawerTitleContactMe),
                  Row(
                    children: [
                      CustomIconButton(
                        onTap: () {
                          ContactUtil.launchUrl(Consts.linkedinUrl, context);
                        },
                        icon: UniconsLine.linkedin,
                        iconColor: AppColors.linkedinBlue,
                      ),
                      CustomIconButton(
                        onTap: () {
                          ContactUtil.launchUrl(Consts.gitHubUrl, context);
                        },
                        icon: UniconsLine.github,
                        iconColor: AppColors.black,
                      ),
                      CustomIconButton(
                        onTap: () {
                          final phoneNumber = Consts.phoneNumber.replaceAll(' ', '');
                          final whatsAppUrl = 'https://wa.me/$phoneNumber?text=${Uri.encodeFull(text.urlMessage)}';
                          ContactUtil.launchUrl(whatsAppUrl, context);
                        },
                        icon: UniconsLine.whatsapp_alt,
                        iconColor: AppColors.whatsappGreen,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DrawerCustomTextButton(
                          title: Consts.phoneNumber,
                          onTap: () {
                            final phoneNumber = Consts.phoneNumber.replaceAll(' ', '');
                            final phoneUrl = 'tel:$phoneNumber';
                            ContactUtil.launchUrl(phoneUrl, context);
                          },
                        ),
                        DrawerCustomTextButton(
                          title: Consts.emailAddress,
                          onTap: () {
                            final mailUrl =
                                'mailto:${Consts.emailAddress}?subject=${Uri.encodeFull('ProfileApp')}&body=${Uri.encodeFull(text.urlMessage)}';
                            ContactUtil.launchUrl(mailUrl, context);
                          },
                        ),
                      ],
                    ),
                  ),
                  DrawerCustomTitle(title: text.drawerTitleDownloadMyCV),
                  FutureBuilder<ListResult>(
                    future: futureResumes,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final resumes = snapshot.data!.items;
                        return Column(
                          children: [
                            ...resumes.map(
                              (e) => DrawerCustomTextButton(
                                title: e.name,
                                onTap: () {
                                  ResumeUtil.openResume('resumes/${e.name}')?.then((file) {
                                    if (file == null) return;
                                    Navigator.pushNamed(
                                      context,
                                      pdfViewerRoute,
                                      arguments: {"file": file, "title": e.name},
                                    );
                                  });
                                },
                                leading: const Icon(
                                  Icons.file_download,
                                  color: AppColors.profilePrimary,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else {
                        return const Padding(
                          padding: EdgeInsets.only(top: 24.0, left: 16, right: 40),
                          child: LinearProgressIndicator(
                            color: AppColors.profilePrimary,
                            backgroundColor: AppColors.lightGrey,
                          ),
                        );
                      }
                    },
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const LanguageWidget(),
                        Text(
                          text.drawerThanksMessage,
                          style: AppTextStyles.textSize24.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.profilePrimary,
                          ),
                        ),
                      ],
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
