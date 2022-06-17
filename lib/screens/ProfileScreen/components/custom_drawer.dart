import 'package:flutter/material.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:flutter_profile/core/app_text_styles.dart';
import 'package:unicons/unicons.dart';

import '../../../common/widgets/custom_button_widget.dart';
import 'drawer_title.dart';

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
            const DrawerTitle(title: 'Entre em Contato'),
            Row(
              children: [
                CustomIconButton(
                  onTap: () {},
                  icon: const Icon(
                    UniconsLine.linkedin,
                    size: 40,
                    color: AppColors.linkedin,
                  ),
                ),
                CustomIconButton(
                  onTap: () {},
                  icon: const Icon(
                    UniconsLine.github,
                    size: 40,
                    color: AppColors.black,
                  ),
                ),
                CustomIconButton(
                  onTap: () {},
                  icon: const Icon(
                    UniconsLine.whatsapp_alt,
                    size: 40,
                    color: AppColors.whatsapp,
                  ),
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
                    style: AppTextStyles.textMediumWhite16.copyWith(color: AppColors.profilePrimary),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'alexandrefreitas.dev@gmail.com',
                    style: AppTextStyles.textMediumWhite16.copyWith(color: AppColors.profilePrimary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const DrawerTitle(title: 'Baixe meu Currículo'),
            const SizedBox(height: 8),
            curriculumDownloadItem('Português'),
            curriculumDownloadItem('English'),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(left: 16.0, bottom: 16),
              child: Text(
                'Obrigado!',
                style: AppTextStyles.textMediumWhite24.copyWith(
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
          icon: const Icon(
            Icons.file_download,
            size: 32,
            color: AppColors.profilePrimary,
          ),
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            title,
            style: AppTextStyles.textRegular16,
          ),
        ),
      ],
    );
  }
}
