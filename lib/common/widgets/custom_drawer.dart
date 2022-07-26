import 'package:flutter/material.dart';
import 'package:flutter_profile/common/widgets/language_widget.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:flutter_profile/core/app_text_styles.dart';
import 'package:unicons/unicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'custom_icon_button.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                drawerTitle(title: AppLocalizations.of(context)!.drawerTitleContactMe),
                Row(
                  children: [
                    CustomIconButton(
                      onTap: () {},
                      icon: UniconsLine.linkedin,
                      iconColor: AppColors.linkedinBlue,
                    ),
                    CustomIconButton(
                      onTap: () {},
                      icon: UniconsLine.github,
                      iconColor: AppColors.black,
                    ),
                    CustomIconButton(
                      onTap: () {},
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
                      Text(
                        '+55 (71) 99711-0012',
                        style: AppTextStyles.textSize16.copyWith(
                          color: AppColors.profilePrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'alexandrefreitas.dev@gmail.com',
                        style: AppTextStyles.textSize16.copyWith(
                          color: AppColors.profilePrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                drawerTitle(title: AppLocalizations.of(context)!.drawerTitleDownloadMyCV),
                const SizedBox(height: 8),
                curriculumDownloadItem(AppLocalizations.of(context)!.curriculumPortugueseText),
                curriculumDownloadItem(AppLocalizations.of(context)!.curriculumEnglishText),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                  child: Row(
                    children: [
                      const LanguageWidget(),
                      const Spacer(),
                      Text(
                        AppLocalizations.of(context)!.drawerThanksMessage,
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
