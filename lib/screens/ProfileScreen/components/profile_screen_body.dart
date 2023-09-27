import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_profile/screens/ProfileScreen/components/profile_skills_list.dart';
import '../../../common/widgets/custom_magnifier.dart';
import '../../../core/core.dart';
import 'profile_language_progress_bar.dart';

class ProfileScreenBody extends StatefulWidget {
  final List<String> aboutMeText;
  const ProfileScreenBody({
    Key? key,
    required this.aboutMeText,
  }) : super(key: key);

  @override
  State<ProfileScreenBody> createState() => _ProfileScreenBodyState();
}

class _ProfileScreenBodyState extends State<ProfileScreenBody> {
  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 160.0 : 16.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text.aboutMeProfileLabel,
            style: AppTextStyles.textSize16.copyWith(
              color: AppColors.profilePrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          CustomMagnifier(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 16.0, bottom: 24.0),
              child: Text(
                widget.aboutMeText[_getLocale()],
                style: AppTextStyles.textWhite.copyWith(color: AppColors.profilePrimary),
              ),
            ),
          ).animate().fadeIn(duration: 800.ms),
          Text(
            text.skillsProfileLabel,
            style: AppTextStyles.textSize16.copyWith(
              color: AppColors.profilePrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16.0, bottom: 24.0),
            child: ProfileSkillsList(),
          ),
          Text(
            text.languagesProfileLabel,
            style: AppTextStyles.textSize16.copyWith(
              color: AppColors.profilePrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 64.0),
            child: Column(
              children: [
                ProfileLanguageProgressBar(
                  languageTitle: text.portugueseLabel,
                  languageLevel: 4,
                ),
                ProfileLanguageProgressBar(
                  languageTitle: text.englishLabel,
                  languageLevel: 3,
                ),
                ProfileLanguageProgressBar(
                  languageTitle: text.spanishLabel,
                  languageLevel: 2,
                ),
                ProfileLanguageProgressBar(
                  languageTitle: text.swedishLabel,
                  languageLevel: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _getLocale() {
    final locale = Localizations.localeOf(context);
    var code = switch (locale.languageCode) {
      'pt' => 0,
      'en' => 1,
      'sv' => 2,
      _ => 0,
    };

    super.didChangeDependencies();
    return code;
  }
}
