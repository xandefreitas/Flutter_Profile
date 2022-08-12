import 'package:flutter/material.dart';
import 'package:flutter_profile/common/widgets/custom_dialog.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:flutter_profile/core/app_text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomScreen extends StatelessWidget {
  final Color tabColor;
  final String title;
  final IconData tabIcon;
  final Widget screenBody;
  final bool isAdmin;
  const CustomScreen({
    Key? key,
    required this.tabColor,
    required this.title,
    required this.tabIcon,
    required this.screenBody,
    this.isAdmin = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                tabColor.withOpacity(0.8),
                AppColors.white,
                AppColors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            top: 48,
            bottom: 24,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                tabColor.withOpacity(0.8),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                tabIcon,
                size: 40,
                color: AppColors.white,
              ),
              const SizedBox(height: 8),
              Text(
                title.toUpperCase(),
                style: AppTextStyles.textSize24.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        screenBody,
        if (isAdmin)
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => CustomDialog(
                  dialogTitle: title == text.certificatesTitle ? 'Novo Certificado' : 'Nova Experiência',
                  dialogBody: const Text('dialogBody'),
                  dialogColor: tabColor,
                ),
              );
            },
            child: const Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(top: 40.0, right: 16),
                child: Icon(
                  Icons.add_box_rounded,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
