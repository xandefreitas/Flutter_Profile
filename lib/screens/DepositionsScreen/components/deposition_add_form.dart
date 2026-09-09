import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/bloc/depositionsBloc/depositions_bloc.dart';
import '../../../common/bloc/depositionsBloc/depositions_event.dart';
import '../../../common/models/deposition.dart';
import '../../../common/util/analytics_util.dart';
import '../../../common/widgets/custom_dialog.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../../../data/icons_data.dart';
import '../../../l10n/app_localizations.dart';
import 'deposition_relationship_dropdown.dart';

class DepositionAddForm extends StatefulWidget {
  final FocusNode nameTextFocus;
  final FocusNode depositionTextFocus;
  final TextEditingController depositionTextController;
  final int iconIndexSelected;
  final ValueChanged<int> onIconSelected;
  final int relationshipValue;
  final ValueChanged<int> onRelationshipChanged;
  final Deposition? existingDeposition;
  final FirebaseAuth? auth;

  const DepositionAddForm({
    required this.nameTextFocus,
    required this.depositionTextFocus,
    required this.depositionTextController,
    required this.iconIndexSelected,
    required this.onIconSelected,
    required this.relationshipValue,
    required this.onRelationshipChanged,
    required this.existingDeposition,
    this.auth,
    super.key,
  });

  @override
  State<DepositionAddForm> createState() => _DepositionAddFormState();
}

class _DepositionAddFormState extends State<DepositionAddForm> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameTextController = TextEditingController();
  late FirebaseAuth auth;

  @override
  void initState() {
    auth = widget.auth ?? FirebaseAuth.instance;
    _nameTextController.text = auth.currentUser?.displayName ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const iconsData = IconsData;
    final text = AppLocalizations.of(context)!;
    return SingleChildScrollView(
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
                  scrollbarOrientation: ScrollbarOrientation.top,
                  controller: _scrollController,
                  radius: const Radius.circular(25),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: iconsData.length,
                      itemBuilder:
                          (context, i) => Padding(
                            padding: const EdgeInsets.only(right: 24),
                            child: InkWell(
                              onTap: () => widget.onIconSelected(i),
                              child: Container(
                                width: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white.withValues(
                                    alpha: widget.iconIndexSelected == i ? 0.8 : 0.2,
                                  ),
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
                controller: _nameTextController,
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
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              DepositionRelationshipDropdown(
                relationshipValue: widget.relationshipValue,
                onChanged: widget.onRelationshipChanged,
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 88,
                child: TextFormField(
                  maxLines: 3,
                  maxLength: 140,
                  focusNode: widget.depositionTextFocus,
                  style: AppTextStyles.textSize12,
                  controller: widget.depositionTextController,
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
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 2,
                      color: AppColors.depositionsPrimary.withValues(alpha: 0.6),
                    ),
                    color: AppColors.white,
                  ),
                  child: InkWell(
                    onTap: () => validateDeposition(text),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
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
    );
  }

  void validateDeposition(AppLocalizations text) {
    if (_formKey.currentState!.validate()) {
      final Deposition deposition = Deposition(
        uid: auth.currentUser?.uid ?? '',
        iconIndex: widget.iconIndexSelected,
        name:
            _nameTextController.text.isEmpty
                ? auth.currentUser?.displayName ?? text.anonymousNameDeposition
                : _nameTextController.text,
        relationship: widget.relationshipValue,
        deposition: widget.depositionTextController.text,
        isAnonymous: auth.currentUser?.isAnonymous ?? true,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
      userDepositionVerification(deposition, text);
    }
  }

  void userDepositionVerification(
    Deposition deposition,
    AppLocalizations text,
  ) {
    final existingDeposition = widget.existingDeposition;
    if (existingDeposition != null) {
      deposition.id = existingDeposition.id;
      showDialog(
        context: context,
        builder:
            (context) => CustomDialog(
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
                      style: const TextStyle(color: AppColors.snackBarError),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.depositionsPrimary,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      updateDeposition(deposition);
                    },
                    child: Text(text.existingDepositionDialogUpdateButton),
                  ),
                ],
              ),
            ),
      );
    } else {
      sendDeposition(deposition);
    }
  }

  void updateDeposition(Deposition updatedDeposition) {
    context.read<DepositionsBloc>().add(
      DepositionsUpdateEvent(deposition: updatedDeposition),
    );
    AnalyticsUtil.logDepositionEdited();
  }

  void sendDeposition(Deposition newDeposition) {
    context.read<DepositionsBloc>().add(
      DepositionsAddEvent(deposition: newDeposition),
    );
    AnalyticsUtil.logDepositionAdded();
  }
}
