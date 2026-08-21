import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../common/bloc/depositionsBloc/depositions_bloc.dart';
import '../../common/bloc/depositionsBloc/depositions_event.dart';
import '../../common/bloc/depositionsBloc/depositions_state.dart';
import '../../common/models/deposition.dart';
import '../../common/util/snackbar_util.dart';
import '../../common/widgets/CustomSnackBar/custom_snackbar.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../l10n/app_localizations.dart';
import 'components/deposition_add_button.dart';
import 'components/deposition_card.dart';
import 'components/deposition_shimmer_card.dart';

class DepositionsScreen extends StatefulWidget {
  final FocusNode nameTextFocus;
  final FocusNode relationshipTextFocus;
  final FocusNode depositionTextFocus;
  final bool isAdmin;
  const DepositionsScreen({
    required this.nameTextFocus,
    required this.relationshipTextFocus,
    required this.depositionTextFocus,
    super.key,
    this.isAdmin = false,
  });

  @override
  State<DepositionsScreen> createState() => _DepositionsScreenState();
}

class _DepositionsScreenState extends State<DepositionsScreen> {
  bool _isWritingDeposition = false;
  bool _isLoading = true;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<Deposition> depositionsData = [];
  @override
  void initState() {
    getDepositionsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 128.0, bottom: 72),
        child: BlocConsumer<DepositionsBloc, DepositionsState>(
          listener: (context, state) {
            if (state is DepositionsFetchingState) {
              _isWritingDeposition = false;
              _isLoading = true;
            }
            if (state is DepositionsFetchedState) {
              depositionsData = state.depositions;
              _isLoading = false;
            }
            if (state is DepositionsAddingState) {
              _isLoading = true;
            }
            if (state is DepositionsAddedState) {
              // No manual list patch needed: the live subscription from
              // getDepositionsList() already reflects this change once the
              // write lands.
              _isWritingDeposition = false;
              _isLoading = false;
              SnackBarUtil.showCustomSnackBar(
                context: context,
                snackbar: SuccessSnackBar(
                  title: text.snackBarGenericSuccessTitle,
                  subtitle: text.successSnackBarDepositionAddedMessage,
                ),
              );
            }
            if (state is DepositionsUpdatingState) {
              _isLoading = true;
            }
            if (state is DepositionsUpdatedState) {
              _isWritingDeposition = false;
              _isLoading = false;
              SnackBarUtil.showCustomSnackBar(
                context: context,
                snackbar: SuccessSnackBar(
                  title: text.snackBarGenericSuccessTitle,
                  subtitle: text.successSnackBarDepositionUpdatedMessage,
                ),
              );
            }
            if (state is DepositionsRemovingState) {
              _isLoading = true;
            }
            if (state is DepositionsRemovedState) {
              _isLoading = false;
              SnackBarUtil.showCustomSnackBar(
                context: context,
                snackbar: SuccessSnackBar(
                  title: text.snackBarGenericSuccessTitle,
                  subtitle: text.successSnackBarDepositionRemovedMessage,
                ),
              );
            }
            if (state is DepositionsErrorState) {
              SnackBarUtil.showCustomSnackBar(
                context: context,
                snackbar: ErrorSnackBar(
                  title: text.snackBarGenericErrorTitle,
                  subtitle: state.exception.toString(),
                ),
              );
            }
          },
          builder: (context, state) {
            return Stack(
              alignment: Alignment.center,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width,
                  ),
                  child: Visibility(
                    visible: !_isLoading,
                    replacement: ListView.builder(
                      itemCount: 4,
                      itemBuilder:
                          (ctx, i) => DepositionShimmerCard(
                            isRightSide: isRightSide(i),
                          ),
                    ),
                    child: ListView.builder(
                      itemCount: depositionsData.length,
                      itemBuilder:
                          (ctx, i) => Animate(
                            key: ValueKey(depositionsData[i].id ?? i),
                            effects: [
                              const FadeEffect(),
                              MoveEffect(
                                begin: Offset(isRightSide(i) ? 320 : -320, 0),
                                duration: 300.ms,
                              ),
                            ],
                            child: DepositionCard(
                              userId: auth.currentUser!.uid,
                              isAdmin: widget.isAdmin,
                              deposition: depositionsData[i],
                              isRightSide: isRightSide(i),
                              text: text,
                            ),
                          ),
                    ),
                  ),
                ),
                Offstage(
                  offstage: depositionsData.isNotEmpty || _isLoading,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/no_comments.json',
                        height: 120,
                      ),
                      const SizedBox(height: 16),
                      Text.rich(
                        TextSpan(
                          text: text.depositionScreenEmptyMessage,
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  '\n${text.depositionScreenEmptySecondaryMessage}',
                              style: AppTextStyles.textSize12.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        style: AppTextStyles.textSize16.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Offstage(
                  offstage: !_isWritingDeposition,
                  child: GestureDetector(
                    onTap: () => onNewDeposition(),
                    child: Container(
                      height: MediaQuery.sizeOf(context).height,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.depositionsPrimary.withValues(alpha: 0.2),
                            AppColors.depositionsPrimary.withValues(alpha: 0.2),
                            AppColors.white.withValues(alpha: 0.2),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Offstage(
                  offstage: _isLoading,
                  child: DepositionAddButton(
                    onNewDeposition: onNewDeposition,
                    isWritingDeposition: _isWritingDeposition,
                    nameTextFocus: widget.nameTextFocus,
                    depositionTextFocus: widget.depositionTextFocus,
                    depositionsData: depositionsData,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void onNewDeposition() {
    setState(() {
      _isWritingDeposition = !_isWritingDeposition;
    });
  }

  void getDepositionsList() {
    context.read<DepositionsBloc>().add(DepositionsFetchEvent());
  }

  bool isRightSide(int i) => i % 2 == 0;
}
