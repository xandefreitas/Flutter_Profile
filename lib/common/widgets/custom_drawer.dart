import 'package:flutter/material.dart';
import 'package:flutter_profile/common/widgets/language_widget.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:flutter_profile/core/app_text_styles.dart';
import 'package:flutter_profile/core/consts.dart';
import 'package:unicons/unicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../util/contact_util.dart';
import 'custom_icon_button.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

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
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset('assets/images/drawer_background.png'),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                drawerTitle(title: text.drawerTitleContactMe),
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
                  padding: const EdgeInsets.only(left: 16.0, top: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      clickableText(
                        title: Consts.phoneNumber,
                        onTap: () {
                          final phoneNumber = Consts.phoneNumber.replaceAll(' ', '');
                          final phoneUrl = 'tel:$phoneNumber';
                          ContactUtil.launchUrl(phoneUrl, context);
                        },
                      ),
                      const SizedBox(height: 16),
                      clickableText(
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
                const SizedBox(height: 16),
                drawerTitle(title: text.drawerTitleDownloadMyCV),
                const SizedBox(height: 8),
                curriculumDownloadItem(text.portugueseLabel),
                curriculumDownloadItem(text.englishLabel),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                  child: Row(
                    children: [
                      const LanguageWidget(),
                      const Spacer(),
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
    );
  }

  GestureDetector clickableText({required String title, required Function onTap}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Text(
        title,
        style: AppTextStyles.textSize16.copyWith(
          color: AppColors.profilePrimary,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Row curriculumDownloadItem(String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomIconButton(
          onTap: () {},
          icon: Icons.file_download,
          iconColor: AppColors.profilePrimary,
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            title,
            style: AppTextStyles.textSize16.copyWith(color: AppColors.profilePrimary),
          ),
        ),
      ],
    );
  }

  Container drawerTitle({String? title}) {
    return Container(
      margin: const EdgeInsets.only(right: 32, top: 24),
      padding: const EdgeInsets.only(left: 16),
      height: 40,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        color: AppColors.profilePrimary,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title ?? '',
          style: AppTextStyles.textSize24.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
