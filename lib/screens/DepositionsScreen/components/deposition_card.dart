import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/bloc/depositionsBloc/depositions_bloc.dart';
import '../../../common/bloc/depositionsBloc/depositions_event.dart';
import '../../../common/models/deposition.dart';
import '../../../common/util/relationship_util.dart';
import '../../../common/util/translation_cache.dart';
import '../../../common/widgets/custom_dialog.dart';
import '../../../common/widgets/custom_dialog_confirm_actions.dart';
import '../../../core/core.dart';
import '../../../data/icons_data.dart';
import '../../../l10n/app_localizations.dart';

class DepositionCard extends StatefulWidget {
  final Deposition deposition;
  final bool isRightSide;
  final bool isAdmin;
  final String userId;
  final AppLocalizations text;
  const DepositionCard({
    required this.deposition,
    required this.isRightSide,
    required this.isAdmin,
    required this.userId,
    required this.text,
    super.key,
  });

  @override
  State<DepositionCard> createState() => _DepositionCardState();
}

class _DepositionCardState extends State<DepositionCard> {
  final iconsData = IconsData;
  String _translatedDeposition = '';

  @override
  void initState() {
    _translatedDeposition = widget.deposition.deposition;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _translateDeposition();
  }

  @override
  void didUpdateWidget(covariant DepositionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The card keeps the same key (the deposition's id) across an update,
    // so Flutter reuses this State instead of re-running initState —
    // retranslate explicitly, or the old text keeps showing.
    if (oldWidget.deposition.deposition != widget.deposition.deposition) {
      _translatedDeposition = widget.deposition.deposition;
      _translateDeposition();
    }
  }

  Future<void> _translateDeposition() async {
    final locale = Localizations.localeOf(context);
    final translated = await TranslationCache.instance.translate(
      text: widget.deposition.deposition,
      targetLanguageCode: locale.languageCode,
      cacheKeyPrefix: widget.deposition.deposition,
    );
    if (!mounted) return;
    setState(() {
      _translatedDeposition = translated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.isRightSide ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 256),
                padding: EdgeInsets.only(top: 8.0, right: widget.isRightSide ? 16 : 8, left: widget.isRightSide ? 8 : 16, bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: widget.isRightSide ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.deposition.name.trim().isEmpty || widget.deposition.isAnonymous ? widget.text.anonymousNameDeposition : widget.deposition.name,
                      textAlign: widget.isRightSide ? TextAlign.end : TextAlign.start,
                      style: AppTextStyles.textSize12.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.depositionsPrimary,
                      ),
                    ),
                    Text(
                      RelationshipUtil.getRelationshipName(context: context, relationshipCode: widget.deposition.relationship),
                      style: AppTextStyles.textSize12.copyWith(
                        color: AppColors.depositionsPrimary.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _translatedDeposition,
                      style: AppTextStyles.textSize12.copyWith(
                        color: AppColors.black,
                      ),
                      textAlign: widget.isRightSide ? TextAlign.right : TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: widget.isRightSide ? 20 : null,
              left: widget.isRightSide ? null : 20,
              child: Image.asset(
                iconsData[widget.deposition.iconIndex],
              ),
            ),
            Visibility(
              visible: widget.isAdmin || widget.deposition.uid == widget.userId,
              child: Positioned(
                top: 24,
                left: widget.isRightSide ? 8 : null,
                right: widget.isRightSide ? null : 8,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => CustomDialog(
                          dialogTitle: widget.text.deleteDepositionDialogTitle,
                          dialogBody: Text(
                            widget.text.deleteDepositionDialogcontent,
                            textAlign: TextAlign.center,
                          ),
                          dialogColor: AppColors.depositionsPrimary,
                          dialogAction: CustomDialogConfirmActions(
                            confirmColor: AppColors.depositionsPrimary,
                            cancelLabel: widget.text.deleteDialogCancelButton,
                            confirmLabel: widget.text.deleteDialogConfirmButton,
                            onConfirm: onDelete,
                          ),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.delete,
                      size: 24,
                      color: AppColors.snackBarError.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void onDelete() {
    context.read<DepositionsBloc>().add(DepositionsRemoveEvent(depositionId: widget.deposition.id!));
  }
}
