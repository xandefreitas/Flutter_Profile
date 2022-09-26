import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile/common/api/auth_webclient.dart';
import 'package:flutter_profile/common/bloc/skillsBloc/skills_bloc.dart';
import 'package:flutter_profile/common/bloc/skillsBloc/skills_event.dart';
import 'package:flutter_profile/common/widgets/custom_dialog.dart';
import 'package:flutter_profile/screens/ProfileScreen/components/profile_skills_custom_chip.dart';
import '../../../common/bloc/skillsBloc/skills_state.dart';
import '../../../common/models/skill.dart';
import '../../../core/core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          sortSkills();
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
          showDialog(
            context: context,
            builder: (_) => CustomDialog(
              dialogTitle: text.errorStateDialogTitle,
              dialogBody: Text(
                state.exception,
                textAlign: TextAlign.center,
              ),
              dialogColor: AppColors.snackBarError,
              dialogAction: GestureDetector(
                onTap: () {
                  getSkillsList();
                  Navigator.pop(context);
                },
                child: Text(
                  text.errorStateDialogRetryButton,
                  style: const TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...skills.map((e) => ProfileSkillsCustomChip(
                        skill: e,
                        isAdmin: _isAdmin,
                        sortSkills: sortSkills,
                      )),
                  if (_isAdmin) addSkillButton(),
                ],
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
    skills.sort((a, b) => b.likesQuantity.compareTo(a.likesQuantity));
  }

  addSkillButton() {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (ctx) {
          final skillTitlecontroller = TextEditingController();
          return CustomDialog(
            dialogTitle: text.skillsAddDialogTitle,
            dialogBody: TextFormField(controller: skillTitlecontroller),
            dialogAction: TextButton(
              onPressed: () {
                context.read<SkillsBloc>().add(SkillsAddEvent(skillTitle: skillTitlecontroller.text));
                Navigator.pop(context);
              },
              child: Text(text.skillsAddDialogAddButton),
            ),
            dialogColor: AppColors.profilePrimary,
          );
        },
      ),
      child: Chip(
        backgroundColor: AppColors.snackBarSuccess.withOpacity(0.8),
        elevation: 2,
        label: Text(
          '+',
          style: AppTextStyles.textSize24.copyWith(color: AppColors.white),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
