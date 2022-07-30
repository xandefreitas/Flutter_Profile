import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/core.dart';
import '../../../data/skills_data.dart';
import 'language_progress_bar.dart';
import 'skills_custom_chip.dart';

class ProfileScreenBody extends StatelessWidget {
  const ProfileScreenBody({
    Key? key,
    required this.isLogged,
    required bool languageBarIsVisible,
  })  : _languageBarIsVisible = languageBarIsVisible,
        super(key: key);

  final bool isLogged;
  final bool _languageBarIsVisible;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final skills = SkillsData;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 160 : 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            text.aboutMeProfileLabel,
            style: AppTextStyles.textSize16.copyWith(
              color: AppColors.profilePrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            child: Text(
              text.aboutMeDescription,
              style: AppTextStyles.textWhite.copyWith(color: AppColors.profilePrimary),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            text.skillsProfileLabel,
            style: AppTextStyles.textSize16.copyWith(
              color: AppColors.profilePrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((e) => SkillsCustomChip(skill: e, isLogged: isLogged)).toList(),
          ),
          const SizedBox(height: 24),
          Text(
            text.languagesProfileLabel,
            style: AppTextStyles.textSize16.copyWith(
              color: AppColors.profilePrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              LanguageProgressBar(
                languageTitle: text.portugueseLabel,
                languageLevel: 4,
                languageBarisVisible: _languageBarIsVisible,
              ),
              LanguageProgressBar(
                languageTitle: text.englishLabel,
                languageLevel: 3,
                languageBarisVisible: _languageBarIsVisible,
              ),
              LanguageProgressBar(
                languageTitle: text.spanishLabel,
                languageLevel: 2,
                languageBarisVisible: _languageBarIsVisible,
              ),
              LanguageProgressBar(
                languageTitle: text.chineseLabel,
                languageLevel: 1,
                languageBarisVisible: _languageBarIsVisible,
              ),
            ],
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
