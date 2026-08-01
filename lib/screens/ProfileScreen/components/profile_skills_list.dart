import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/api/auth_webclient.dart';
import '../../../common/bloc/skillsBloc/skills_bloc.dart';
import '../../../common/bloc/skillsBloc/skills_event.dart';
import '../../../common/bloc/skillsBloc/skills_state.dart';
import '../../../common/models/skill.dart';
import '../../../common/util/snackbar_util.dart';
import '../../../common/widgets/CustomSnackBar/custom_snackbar.dart';
import '../../../core/core.dart';
import '../../../l10n/app_localizations.dart';
import 'profile_skills_add_chip.dart';
import 'profile_skills_custom_chip.dart';

class ProfileSkillsList extends StatefulWidget {
  const ProfileSkillsList({super.key});

  @override
  State<ProfileSkillsList> createState() => _ProfileSkillsListState();
}

class _ProfileSkillsListState extends State<ProfileSkillsList> {
  List<Skill> skills = [];
  bool _isLoading = false;
  bool _isAdmin = false;

  @override
  void initState() {
    getSkillsList();
    getUserRole();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return BlocConsumer<SkillsBloc, SkillsState>(
      listener: (context, state) {
        switch (state) {
          case SkillsFetchingState():
            _isLoading = true;
          case SkillsFetchedState():
            skills = state.skills;
            if (skills.isNotEmpty) sortSkills();
            _isLoading = false;
          case SkillsAddingState():
            _isLoading = true;
          case SkillsAddedState():
            getSkillsList();
          case SkillsRemovingState():
            _isLoading = true;
          case SkillsRemovedState():
            getSkillsList();
          case SkillsErrorState():
            _isLoading = false;
            SnackBarUtil.showCustomSnackBar(
              context: context,
              snackbar: ErrorSnackBar(
                title: text.snackBarGenericErrorTitle,
                subtitle: state.exception.toString(),
              ),
            );
        }
      },
      builder: (context, state) {
        return ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 200),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.profilePrimary),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...skills.map(
                      (e) => (e == skills.first)
                          ? ProfileSkillsCustomChip(
                              skill: e,
                              isAdmin: _isAdmin,
                              sortSkills: sortSkills,
                            )
                              .animate(
                                onPlay: (controller) => controller.repeat(reverse: true),
                              )
                              .scaleXY(end: 1.05, duration: 600.ms)
                          : ProfileSkillsCustomChip(
                              skill: e,
                              isAdmin: _isAdmin,
                              sortSkills: sortSkills,
                            ),
                    ),
                    Visibility(visible: _isAdmin, child: const ProfileSkillsAddChip()),
                  ],
                ).animate().fadeIn(),
        );
      },
    );
  }

  void getSkillsList() {
    context.read<SkillsBloc>().add(SkillsFetchEvent());
  }

  Future<void> getUserRole() async {
    _isAdmin = await AuthWebclient.getUserRole();
  }

  void sortSkills() {
    skills.sort((a, b) => a.title.compareTo(b.title));
  }
}
