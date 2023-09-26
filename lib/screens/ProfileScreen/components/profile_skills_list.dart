import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile/common/api/auth_webclient.dart';
import 'package:flutter_profile/common/bloc/skillsBloc/skills_bloc.dart';
import 'package:flutter_profile/common/bloc/skillsBloc/skills_event.dart';
import 'package:flutter_profile/screens/ProfileScreen/components/profile_skills_add_chip.dart';
import 'package:flutter_profile/screens/ProfileScreen/components/profile_skills_custom_chip.dart';
import '../../../common/bloc/skillsBloc/skills_state.dart';
import '../../../common/models/skill.dart';
import '../../../common/util/snackbar_util.dart';
import '../../../common/widgets/CustomSnackBar/custom_snackbar.dart';
import '../../../core/core.dart';

class ProfileSkillsList extends StatefulWidget {
  const ProfileSkillsList({Key? key}) : super(key: key);

  @override
  State<ProfileSkillsList> createState() => _ProfileSkillsListState();
}

class _ProfileSkillsListState extends State<ProfileSkillsList> {
  List<Skill> skills = [];
  bool _isLoading = false;
  bool _isAdmin = false;
  late AppLocalizations text;

  @override
  void initState() {
    getSkillsList();
    getUserRole();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    text = AppLocalizations.of(context)!;
    return BlocConsumer<SkillsBloc, SkillsState>(
      listener: (context, state) {
        if (state is SkillsFetchingState) {
          _isLoading = true;
        }
        if (state is SkillsFetchedState) {
          skills = state.skills;
          if (skills.isNotEmpty) sortSkills();
          _isLoading = false;
        }
        if (state is SkillsAddingState) {
          _isLoading = true;
        }
        if (state is SkillsAddedState) {
          getSkillsList();
        }
        if (state is SkillsRemovingState) {
          _isLoading = true;
        }
        if (state is SkillsRemovedState) {
          getSkillsList();
        }
        if (state is SkillsErrorState) {
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
                    ...skills.map((e) => (e == skills.first)
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
                          )),
                    Visibility(visible: _isAdmin, child: const ProfileSkillsAddChip()),
                  ],
                ).animate().fadeIn(),
        );
      },
    );
  }

  getSkillsList() {
    context.read<SkillsBloc>().add(SkillsFetchEvent());
  }

  getUserRole() async {
    _isAdmin = await AuthWebclient.getUserRole();
  }

  sortSkills() {
    skills.sort((a, b) => a.title.compareTo(b.title));
  }
}
