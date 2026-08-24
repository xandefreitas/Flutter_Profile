import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../common/models/deposition.dart';
import '../../../common/widgets/page_input_theme.dart';
import '../../../core/app_colors.dart';
import 'deposition_add_form.dart';

class DepositionAddButton extends StatefulWidget {
  final FocusNode nameTextFocus;
  final FocusNode depositionTextFocus;
  final Function() onNewDeposition;
  final bool isWritingDeposition;
  final List<Deposition> depositionsData;
  final FirebaseAuth? auth;
  const DepositionAddButton({
    required this.onNewDeposition,
    required this.isWritingDeposition,
    required this.nameTextFocus,
    required this.depositionTextFocus,
    required this.depositionsData,
    this.auth,
    super.key,
  });

  @override
  State<DepositionAddButton> createState() => _DepositionAddButtonState();
}

class _DepositionAddButtonState extends State<DepositionAddButton> {
  final depositionTextController = TextEditingController();

  late FirebaseAuth auth;
  int iconIndexSelected = 0;
  int relationshipValue = 0;

  @override
  void initState() {
    auth = widget.auth ?? FirebaseAuth.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageInputTheme(
      color: AppColors.depositionsPrimary,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0, right: 16),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(15),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: AppColors.depositionsPrimary,
                borderRadius: BorderRadius.circular(15),
                border:
                    widget.isWritingDeposition
                        ? Border.all(color: AppColors.white, width: 2)
                        : null,
              ),
              height: widget.isWritingDeposition ? 280 : 40,
              width: widget.isWritingDeposition ? 288 : 40,
              child:
                  widget.isWritingDeposition
                      ? DepositionAddForm(
                        nameTextFocus: widget.nameTextFocus,
                        depositionTextFocus: widget.depositionTextFocus,
                        depositionTextController: depositionTextController,
                        iconIndexSelected: iconIndexSelected,
                        onIconSelected: (i) {
                          setState(() {
                            iconIndexSelected = i;
                          });
                        },
                        relationshipValue: relationshipValue,
                        onRelationshipChanged: (value) {
                          setState(() {
                            relationshipValue = value;
                          });
                        },
                        existingDeposition: _existingDeposition,
                        auth: widget.auth,
                      )
                      : InkWell(
                            onTap: () {
                              final existing = _existingDeposition;
                              setState(() {
                                if (existing != null) {
                                  depositionTextController.text =
                                      existing.deposition;
                                  relationshipValue = existing.relationship;
                                  iconIndexSelected = existing.iconIndex;
                                } else {
                                  depositionTextController.clear();
                                  relationshipValue = 0;
                                  iconIndexSelected = 0;
                                }
                              });
                              widget.onNewDeposition();
                            },
                            child: const Icon(
                              Icons.edit,
                              color: AppColors.white,
                            ),
                          )
                          .animate(
                            onPlay: (controller) {
                              if (!widget.isWritingDeposition) {
                                controller.loop(count: 8, reverse: true);
                              }
                            },
                          )
                          .shake(hz: 4, delay: 300.ms, duration: 400.ms),
            ),
          ),
        ),
      ),
    );
  }

  Deposition? get _existingDeposition {
    for (final deposition in widget.depositionsData) {
      if (deposition.uid == auth.currentUser?.uid) return deposition;
    }
    return null;
  }
}
