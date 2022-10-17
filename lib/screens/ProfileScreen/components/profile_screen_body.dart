import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile/screens/ProfileScreen/components/profile_skills_list.dart';
import '../../../core/core.dart';
import 'profile_language_progress_bar.dart';

class ProfileScreenBody extends StatelessWidget {
  const ProfileScreenBody({
    Key? key,
    required bool languageBarIsVisible,
  })  : _languageBarIsVisible = languageBarIsVisible,
        super(key: key);

  final bool _languageBarIsVisible;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;

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
          const SizedBox(height: 8),
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
          const ProfileSkillsList(),
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
              ProfileLanguageProgressBar(
                languageTitle: text.portugueseLabel,
                languageLevel: 4,
                languageBarisVisible: _languageBarIsVisible,
              ),
              ProfileLanguageProgressBar(
                languageTitle: text.englishLabel,
                languageLevel: 3,
                languageBarisVisible: _languageBarIsVisible,
              ),
              ProfileLanguageProgressBar(
                languageTitle: text.spanishLabel,
                languageLevel: 2,
                languageBarisVisible: _languageBarIsVisible,
              ),
              ProfileLanguageProgressBar(
                languageTitle: text.chineseLabel,
                languageLevel: 1,
                languageBarisVisible: _languageBarIsVisible,
              ),
            ],
          ),
          const SizedBox(height: 88),
        ],
      ),
    );
  }
}
