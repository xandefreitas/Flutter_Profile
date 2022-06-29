import 'package:flutter/material.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:flutter_profile/core/app_text_styles.dart';
import 'package:unicons/unicons.dart';

import 'custom_icon_button.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            drawerTitle(title: 'Entre em Contato'),
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
            drawerTitle(title: 'Baixe meu Currículo'),
            const SizedBox(height: 8),
            curriculumDownloadItem('Português'),
            curriculumDownloadItem('English'),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 16),
              child: Text(
                'Obrigado!',
                style: AppTextStyles.textSize24.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.profilePrimary,
                ),
              ),
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
