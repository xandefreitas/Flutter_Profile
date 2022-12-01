import 'package:flutter/material.dart';
import 'package:flutter_profile/common/models/occupation.dart';
import 'package:flutter_profile/common/widgets/custom_dialog.dart';
import 'package:flutter_profile/core/core.dart';

class WorkHistoryInfoButton extends StatefulWidget {
  final Occupation occupation;
  const WorkHistoryInfoButton({
    Key? key,
    required this.occupation,
  }) : super(key: key);

  @override
  State<WorkHistoryInfoButton> createState() => _WorkHistoryInfoButtonState();
}

class _WorkHistoryInfoButtonState extends State<WorkHistoryInfoButton> {
  String languageCode = 'pt';

  @override
  Widget build(BuildContext context) {
    _getLocale();
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(10),
      color: AppColors.workHistoryPrimary.withOpacity(0.8),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (ctx) => CustomDialog(
              dialogColor: AppColors.workHistoryPrimary,
              dialogTitle: widget.occupation.role,
              dialogBody: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languageCode == 'pt' ? widget.occupation.description : widget.occupation.descriptionEn,
                    textAlign: TextAlign.justify,
                  ),
                  const Divider(),
                  if (widget.occupation.occupationSkills != null)
                    Wrap(
                      spacing: 4,
                      runSpacing: 2,
                      children: [
                        ...widget.occupation.occupationSkills!.map(
                          (e) => Chip(
                            visualDensity: VisualDensity.compact,
                            backgroundColor: AppColors.workHistoryPrimary.withOpacity(0.8),
                            label: Text(
                              e.title,
                              style: AppTextStyles.textWhite.copyWith(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Ink(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Icon(
              Icons.read_more_outlined,
              color: AppColors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  void _getLocale() {
    final locale = Localizations.localeOf(context);
    languageCode = locale.languageCode;
    super.didChangeDependencies();
  }
}
