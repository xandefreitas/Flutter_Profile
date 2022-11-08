import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile/common/bloc/depositionsBloc/depositions_event.dart';
import 'package:flutter_profile/common/models/deposition.dart';
import 'package:flutter_profile/common/widgets/custom_dialog.dart';
import 'package:flutter_profile/data/icons_data.dart';
import '../../../common/bloc/depositionsBloc/depositions_bloc.dart';
import '../../../common/util/relationship_util.dart';
import '../../../core/core.dart';

class DepositionCard extends StatelessWidget {
  final Deposition deposition;
  final bool isRightSide;
  final bool isAdmin;
  final String userId;
  final AppLocalizations text;
  const DepositionCard({
    Key? key,
    required this.deposition,
    required this.isRightSide,
    required this.isAdmin,
    required this.userId,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const iconsData = IconsData;
    onDelete() {
      context.read<DepositionsBloc>().add(DepositionsRemoveEvent(depositionId: deposition.id!));
    }

    return Row(
      mainAxisAlignment: isRightSide ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 256),
                padding: EdgeInsets.only(top: 8.0, right: isRightSide ? 16 : 8, left: isRightSide ? 8 : 16, bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: isRightSide ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      deposition.name,
                      textAlign: isRightSide ? TextAlign.end : TextAlign.start,
                      style: AppTextStyles.textSize12.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.depositionsPrimary,
                      ),
                    ),
                    Text(
                      RelationshipUtil.getRelationshipName(context: context, relationshipCode: deposition.relationship),
                      style: AppTextStyles.textSize12.copyWith(
                        color: AppColors.depositionsPrimary.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      deposition.deposition,
                      style: AppTextStyles.textSize12.copyWith(
                        color: AppColors.black,
                      ),
                      textAlign: isRightSide ? TextAlign.right : TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: isRightSide ? 20 : null,
              left: isRightSide ? null : 20,
              child: Image.asset(
                iconsData[deposition.iconIndex],
              ),
            ),
            if (isAdmin || deposition.uid == userId)
              Positioned(
                top: 24,
                left: isRightSide ? 8 : null,
                right: isRightSide ? null : 8,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => CustomDialog(
                          dialogTitle: text.deleteDepositionDialogTitle,
                          dialogBody: Text(
                            text.deleteDepositionDialogcontent,
                            textAlign: TextAlign.center,
                          ),
                          dialogColor: AppColors.depositionsPrimary,
                          dialogAction: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.snackBarError,
                                ),
                                child: Text(text.deleteDialogCancelButton),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  onDelete();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.depositionsPrimary,
                                ),
                                child: Text(text.deleteDialogConfirmButton),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.delete,
                      size: 24,
                      color: AppColors.snackBarError.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
