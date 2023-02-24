import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile/common/bloc/depositionsBloc/depositions_bloc.dart';
import 'package:flutter_profile/common/bloc/depositionsBloc/depositions_event.dart';
import 'package:flutter_profile/common/models/deposition.dart';
import 'package:flutter_profile/common/widgets/custom_dialog.dart';
import 'package:flutter_profile/core/app_text_styles.dart';
import 'package:flutter_profile/data/icons_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/app_colors.dart';
import 'deposition_relationship_dropdown.dart';

class DepositionAddButton extends StatefulWidget {
  final FocusNode nameTextFocus;
  final FocusNode depositionTextFocus;
  final Function() onNewDeposition;
  final bool isWritingDeposition;
  final List<Deposition> depositionsData;
  const DepositionAddButton({
    Key? key,
    required this.onNewDeposition,
    required this.isWritingDeposition,
    required this.nameTextFocus,
    required this.depositionTextFocus,
    required this.depositionsData,
  }) : super(key: key);

  @override
  State<DepositionAddButton> createState() => _DepositionAddButtonState();
}

class _DepositionAddButtonState extends State<DepositionAddButton> {
  final nameTextController = TextEditingController();
  final depositionTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  late AppLocalizations text;
  FirebaseAuth auth = FirebaseAuth.instance;
  int iconIndexSelected = 0;
  int relationshipValue = 0;

  @override
  void initState() {
    nameTextController.text = auth.currentUser!.displayName ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const iconsData = IconsData;
    text = AppLocalizations.of(context)!;
    return Align(
      alignment: kIsWeb ? Alignment.bottomCenter : Alignment.bottomRight,
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
              border: widget.isWritingDeposition ? Border.all(color: AppColors.white, width: 2) : null,
            ),
            height: widget.isWritingDeposition ? 272 : 40,
            width: widget.isWritingDeposition
                ? kIsWeb
                    ? 344
                    : 288
                : 40,
            child: widget.isWritingDeposition
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 52,
                              child: Scrollbar(
                                thumbVisibility: true,
                                trackVisibility: true,
                                interactive: true,
                                controller: _scrollController,
                                radius: const Radius.circular(10),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: ListView.builder(
                                    controller: _scrollController,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: iconsData.length,
                                    itemBuilder: (context, i) => Padding(
                                      padding: const EdgeInsets.only(right: 24),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            iconIndexSelected = i;
                                          });
                                        },
                                        child: Container(
                                          width: 48,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white.withOpacity(iconIndexSelected == i ? 0.8 : 0.2),
                                          ),
                                          child: Image.asset(iconsData[i]),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              focusNode: widget.nameTextFocus,
                              style: AppTextStyles.textSize12,
                              textCapitalization: TextCapitalization.words,
                              controller: nameTextController,
                              decoration: InputDecoration(
                                hintText: text.depositionButtonNameHint,
                                isDense: true,
                                filled: true,
                                contentPadding: const EdgeInsets.all(8),
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            DepositionRelationshipDropdown(
                              relationshipValue: relationshipValue,
                              onChanged: (value) {
                                relationshipValue = value;
                              },
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 84,
                              child: TextFormField(
                                maxLines: 3,
                                maxLength: 140,
                                focusNode: widget.depositionTextFocus,
                                style: AppTextStyles.textSize12,
                                controller: depositionTextController,
                                decoration: InputDecoration(
                                  hintText: text.depositionButtonDepositionHint,
                                  isDense: true,
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.all(8),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 32,
                                width: 72,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 2,
                                    color: AppColors.depositionsPrimary.withOpacity(0.6),
                                  ),
                                  color: AppColors.white,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    validateDeposition();
                                  },
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.only(left: 8),
                                    physics: const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          text.depositionButtonSendButton,
                                          maxLines: 1,
                                          style: AppTextStyles.textSize12.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.depositionsPrimary,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(
                                          Icons.send,
                                          size: 16,
                                          color: AppColors.depositionsPrimary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      depositionTextController.clear();
                      widget.onNewDeposition();
                    },
                    child: const Icon(
                      Icons.edit,
                      color: AppColors.white,
                    ),
                  ).animate(
                    onPlay: (controller) {
                      if (!widget.isWritingDeposition) controller.loop(count: 8, reverse: true);
                    },
                  ).shake(hz: 4, delay: 300.ms, duration: 400.ms),
          ),
        ),
      ),
    );
  }

  void validateDeposition() {
    if (_formKey.currentState!.validate()) {
      final Deposition deposition = Deposition(
        uid: auth.currentUser!.uid,
        iconIndex: iconIndexSelected,
        name: nameTextController.text.isEmpty ? auth.currentUser!.displayName ?? text.anonymousNameDeposition : nameTextController.text,
        relationship: relationshipValue,
        deposition: depositionTextController.text,
      );
      userDepositionVerification(deposition);
    }
  }

  userDepositionVerification(Deposition deposition) {
    if (hasAlreadyWritenADeposition) {
      final Deposition existingDeposition = widget.depositionsData.where((element) => element.uid == auth.currentUser!.uid).first;
      deposition.id = existingDeposition.id;
      showDialog(
        context: context,
        builder: ((context) => CustomDialog(
              dialogTitle: text.existingDepositionDialogTitle,
              dialogBody: Text(
                text.existingDepositionDialogContent,
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
                    child: Text(
                      text.existingDepositionDialogCancelButton,
                      style: const TextStyle(
                        color: AppColors.snackBarError,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.depositionsPrimary),
                    onPressed: () {
                      Navigator.pop(context);
                      updateDeposition(deposition);
                    },
                    child: Text(text.existingDepositionDialogUpdateButton),
                  ),
                ],
              ),
            )),
      );
    } else {
      sendDeposition(deposition);
    }
  }

  bool get hasAlreadyWritenADeposition => widget.depositionsData.any((element) => element.uid == auth.currentUser!.uid);

  updateDeposition(Deposition updatedDeposition) {
    context.read<DepositionsBloc>().add(DepositionsUpdateEvent(deposition: updatedDeposition));
  }

  sendDeposition(Deposition newDeposition) {
    context.read<DepositionsBloc>().add(DepositionsAddEvent(deposition: newDeposition));
  }
}
