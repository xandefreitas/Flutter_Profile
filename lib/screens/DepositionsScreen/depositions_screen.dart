import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:flutter_profile/core/app_text_styles.dart';
import 'package:flutter_profile/screens/DepositionsScreen/components/deposition_card.dart';
import 'package:flutter_profile/screens/DepositionsScreen/components/deposition_add_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import '../../common/bloc/depositionsBloc/depositions_bloc.dart';
import '../../common/bloc/depositionsBloc/depositions_event.dart';
import '../../common/bloc/depositionsBloc/depositions_state.dart';
import '../../common/models/deposition.dart';
import '../../common/util/snackbar_util.dart';
import '../../common/widgets/CustomSnackBar/custom_snackbar.dart';
import 'components/deposition_shimmer_card.dart';

class DepositionsScreen extends StatefulWidget {
  final FocusNode nameTextFocus;
  final FocusNode relationshipTextFocus;
  final FocusNode depositionTextFocus;
  final bool isAdmin;
  const DepositionsScreen({
    Key? key,
    required this.nameTextFocus,
    required this.relationshipTextFocus,
    required this.depositionTextFocus,
    this.isAdmin = false,
  }) : super(key: key);

  @override
  State<DepositionsScreen> createState() => _DepositionsScreenState();
}

class _DepositionsScreenState extends State<DepositionsScreen> {
  bool _isWritingDeposition = false;
  bool _isLoading = true;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<Deposition> depositionsData = [];
  late AppLocalizations text;
  @override
  void initState() {
    getDepositionsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    text = AppLocalizations.of(context)!;
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 128.0, bottom: kIsWeb ? 0 : 72),
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
              getDepositionsList();
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
              getDepositionsList();
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
              getDepositionsList();
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
                _isLoading
                    ? ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * (kIsWeb ? 0.6 : 1.0)),
                        child: ListView.builder(
                          itemCount: 4,
                          itemBuilder: (ctx, i) => DepositionShimmerCard(
                            isRightSide: isRightSide(i),
                          ),
                        ),
                      )
                    : ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * (kIsWeb ? 0.6 : 1.0)),
                        child: ListView.builder(
                          itemCount: depositionsData.length,
                          itemBuilder: (ctx, i) => Animate(
                            effects: [
                              const FadeEffect(),
                              MoveEffect(begin: Offset(isRightSide(i) ? 320 : -320, 0), duration: 300.ms),
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
                Visibility(
                  visible: depositionsData.isEmpty && !_isLoading,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/lottie/no_comments.json', height: 120),
                      const SizedBox(height: 16),
                      Text.rich(
                        TextSpan(
                          text: text.depositionScreenEmptyMessage,
                          children: <TextSpan>[
                            TextSpan(
                              text: '\n${text.depositionScreenEmptySecondaryMessage}',
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
                Visibility(
                  visible: _isWritingDeposition,
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
                            AppColors.depositionsPrimary.withOpacity(0.2),
                            AppColors.depositionsPrimary.withOpacity(0.2),
                            AppColors.white.withOpacity(0.2),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !_isLoading,
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

  onNewDeposition() {
    setState(() {
      _isWritingDeposition = !_isWritingDeposition;
    });
  }

  getDepositionsList() {
    context.read<DepositionsBloc>().add(DepositionsFetchEvent());
  }

  bool isRightSide(int i) => i % 2 == 0;
}
