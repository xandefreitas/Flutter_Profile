import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
            return RefreshIndicator(
              onRefresh: () async {
                getDepositionsList();
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _isLoading
                      ? ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * (kIsWeb ? 0.6 : 1.0)),
                          child: ListView.builder(
                            itemCount: 4,
                            itemBuilder: (ctx, i) => DepositionShimmerCard(
                              isRightSide: isRightSide(i),
                            ),
                          ),
                        )
                      : ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * (kIsWeb ? 0.6 : 1.0)),
                          child: ListView.builder(
                            itemCount: depositionsData.length,
                            itemBuilder: (ctx, i) => DepositionCard(
                              userId: auth.currentUser!.uid,
                              isAdmin: widget.isAdmin,
                              deposition: depositionsData[i],
                              isRightSide: isRightSide(i),
                              text: text,
                            ),
                          ),
                        ),
                  if (depositionsData.isEmpty && !_isLoading)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/lottie/no_comments.json', height: 120),
                        const SizedBox(height: 16),
                        Text(
                          text.depositionScreenEmptyMessage,
                          style: AppTextStyles.textSize16.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  if (_isWritingDeposition)
                    GestureDetector(
                      onTap: () => onNewDeposition(),
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
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
                  if (!_isLoading && !auth.currentUser!.isAnonymous)
                    DepositionAddButton(
                      onNewDeposition: onNewDeposition,
                      isWritingDeposition: _isWritingDeposition,
                      nameTextFocus: widget.nameTextFocus,
                      depositionTextFocus: widget.depositionTextFocus,
                      depositionsData: depositionsData,
                    ),
                ],
              ),
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
