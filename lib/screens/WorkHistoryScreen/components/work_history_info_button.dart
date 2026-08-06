import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translator/translator.dart';

import '../../../common/bloc/workHistoryBloc/work_history_bloc.dart';
import '../../../common/models/occupation.dart';
import '../../../common/widgets/custom_dialog.dart';
import '../../../core/core.dart';

class WorkHistoryInfoButton extends StatefulWidget {
  final Occupation occupation;
  const WorkHistoryInfoButton({
    required this.occupation,
    super.key,
  });

  @override
  State<WorkHistoryInfoButton> createState() => _WorkHistoryInfoButtonState();
}

class _WorkHistoryInfoButtonState extends State<WorkHistoryInfoButton> {
  late String _translatedDescription = widget.occupation.description;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _translateDescription();
  }

  Future<void> _translateDescription() async {
    final locale = Localizations.localeOf(context);
    if (locale.languageCode == 'en') {
      _translatedDescription = widget.occupation.description;
      return;
    }

    final translationCache = context.read<WorkHistoryBloc>().translationCache;
    final cacheKey = '${widget.occupation.description}_${locale.languageCode}';

    final cached = translationCache[cacheKey];
    if (cached != null) {
      _translatedDescription = cached;
      return;
    }

    final translation = await widget.occupation.description.translate(to: locale.languageCode);
    if (!mounted) return;
    translationCache[cacheKey] = translation.text;
    setState(() {
      _translatedDescription = translation.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(10),
      color: AppColors.workHistoryPrimary.withValues(alpha: 0.8),
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
                    _translatedDescription,
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
                            backgroundColor: AppColors.workHistoryPrimary.withValues(alpha: 0.8),
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
            ).animate().fadeIn(duration: 200.ms, curve: Curves.easeIn),
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
}
