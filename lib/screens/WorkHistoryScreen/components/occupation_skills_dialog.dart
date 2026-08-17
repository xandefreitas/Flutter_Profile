import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/bloc/skillsBloc/skills_bloc.dart';
import '../../../common/bloc/skillsBloc/skills_state.dart';
import '../../../common/models/occupation.dart';
import '../../../common/models/skill.dart';
import '../../../common/widgets/custom_dialog.dart';
import '../../../core/core.dart';
import '../../../l10n/app_localizations.dart';

class OccupationSkillsDialog extends StatefulWidget {
  final Color primaryColor;
  final Function(Occupation) manageOccupation;
  final Occupation occupation;

  const OccupationSkillsDialog({
    required this.primaryColor,
    required this.manageOccupation,
    required this.occupation,
    super.key,
  });

  @override
  State<OccupationSkillsDialog> createState() => _SkillsDialogState();
}

class _SkillsDialogState extends State<OccupationSkillsDialog> {
  bool _isLoading = false;
  List<Skill> skills = [];
  List<Skill> occupationSkills = [];
  @override
  void initState() {
    occupationSkills.addAll(widget.occupation.occupationSkills ?? []);
    final currentState = context.read<SkillsBloc>().state;
    if (currentState is SkillsFetchedState) {
      skills = currentState.skills;
    } else {
      _isLoading = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return CustomDialog(
          dialogColor: widget.primaryColor,
          dialogTitle: widget.occupation.role,
          dialogBody: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 200),
            child:
                _isLoading
                    ? Center(
                      child: CircularProgressIndicator(
                        color: widget.primaryColor,
                      ),
                    )
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 2,
                          children:
                              skills
                                  .map(
                                    (e) => GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          !occupationSkills.any(
                                                (element) =>
                                                    element.title == e.title,
                                              )
                                              ? occupationSkills.add(e)
                                              : occupationSkills.removeWhere(
                                                (skill) =>
                                                    skill.title == e.title,
                                              );
                                        });
                                      },
                                      child: Chip(
                                        backgroundColor: widget.primaryColor
                                            .withValues(
                                              alpha:
                                                  !occupationSkills.any(
                                                        (element) =>
                                                            element.title ==
                                                            e.title,
                                                      )
                                                      ? 0.2
                                                      : 0.8,
                                            ),
                                        label: Text(
                                          e.title,
                                          style: AppTextStyles.textWhite
                                              .copyWith(
                                                color:
                                                    !occupationSkills.any(
                                                          (element) =>
                                                              element.title ==
                                                              e.title,
                                                        )
                                                        ? widget.primaryColor
                                                            .withValues(
                                                              alpha: 0.4,
                                                            )
                                                        : null,
                                              ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                        const Divider(),
                      ],
                    ),
          ),
          dialogAction: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.primaryColor,
            ),
            onPressed: () {
              occupationSkills.sort((a, b) => a.title.compareTo(b.title));
              widget.occupation.occupationSkills = occupationSkills;
              widget.manageOccupation(widget.occupation);
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context)!.workHistoryFormUpdateButton,
            ),
          ),
        );
      },
    );
  }
}
