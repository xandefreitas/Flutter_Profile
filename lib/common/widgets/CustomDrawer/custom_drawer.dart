import 'package:flutter/material.dart';
import 'package:flutter_profile/common/widgets/CustomDrawer/components/drawer_custom_title.dart';
import 'package:flutter_profile/common/widgets/language_widget.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:flutter_profile/core/app_text_styles.dart';
import 'package:flutter_profile/core/consts.dart';
import 'package:unicons/unicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../util/contact_util.dart';
import '../custom_icon_button.dart';
import 'components/drawer_custom_text_button.dart';

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
                DrawerCustomTextButton(
                  title: text.portugueseLabel,
                  onTap: () {},
                  leading: const Icon(
                    Icons.file_download,
                    color: AppColors.profilePrimary,
                  ),
                ),
                DrawerCustomTextButton(
                  title: text.englishLabel,
                  onTap: () {},
                  leading: const Icon(
                    Icons.file_download,
                    color: AppColors.profilePrimary,
                  ),
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
    );
  }
}
