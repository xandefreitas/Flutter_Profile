import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile/common/bloc/depositionsBloc/depositions_bloc.dart';
import 'package:flutter_profile/common/bloc/depositionsBloc/depositions_event.dart';
import 'package:flutter_profile/common/models/deposition.dart';
import 'package:flutter_profile/common/widgets/custom_dialog.dart';
import 'package:flutter_profile/core/app_text_styles.dart';
import 'package:flutter_profile/data/icons_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_profile/data/relationships_data.dart';
import '../../../core/app_colors.dart';

class DepositionAddButton extends StatefulWidget {
  final FocusNode nameTextFocus;
  final FocusNode relationshipTextFocus;
  final FocusNode depositionTextFocus;
  final Function() onNewDeposition;
  final bool isWritingDeposition;
  final List<Deposition> depositionsData;
  const DepositionAddButton({
    Key? key,
    required this.onNewDeposition,
    required this.isWritingDeposition,
    required this.nameTextFocus,
    required this.relationshipTextFocus,
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
  final List<String> _relationshipItems = RelationshipsData;
  late AppLocalizations text;
  FirebaseAuth auth = FirebaseAuth.instance;
  int iconIndexSelected = 0;
  String relationshipValue = '';

  @override
  void initState() {
    nameTextController.text = auth.currentUser!.displayName ?? '';
    relationshipValue = _relationshipItems.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const _iconsData = IconsData;
    text = AppLocalizations.of(context)!;
    return Align(
      alignment: kIsWeb ? Alignment.bottomCenter : Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 16),
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: AppColors.depositionsPrimary,
              borderRadius: BorderRadius.circular(10),
              border: widget.isWritingDeposition ? Border.all(color: AppColors.white, width: 2) : null,
            ),
            height: widget.isWritingDeposition ? 296 : 40,
            width: widget.isWritingDeposition
                ? kIsWeb
                    ? 344
                    : 272
                : 40,
            child: widget.isWritingDeposition
                ? SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 48,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _iconsData.length,
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
                                      child: Image.asset(_iconsData[i]),
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
                            DropdownButtonFormField(
                              isDense: true,
                              isExpanded: true,
                              elevation: 0,
                              borderRadius: BorderRadius.circular(10),
                              value: relationshipValue,
                              focusNode: widget.relationshipTextFocus,
                              style: AppTextStyles.textSize12.copyWith(color: AppColors.black),
                              decoration: InputDecoration(
                                hintText: text.depositionButtonRelationshipHint,
                                isDense: true,
                                filled: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                                hintStyle: AppTextStyles.textSize12.copyWith(color: AppColors.black.withOpacity(0.5)),
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              items: _relationshipItems
                                  .map(
                                    (e) => DropdownMenuItem<String>(
                                      value: e,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(e),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                relationshipValue = value as String;
                              },
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 112,
                              child: TextFormField(
                                maxLines: 5,
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
                  ),
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
