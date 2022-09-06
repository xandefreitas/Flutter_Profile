import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:flutter_profile/core/app_text_styles.dart';
import 'package:flutter_profile/screens/DepositionsScreen/components/deposition_card.dart';
import 'package:flutter_profile/screens/DepositionsScreen/components/deposition_add_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../common/bloc/depositionsBloc/depositions_bloc.dart';
import '../../common/bloc/depositionsBloc/depositions_event.dart';
import '../../common/bloc/depositionsBloc/depositions_state.dart';
import '../../common/models/deposition.dart';
import '../../common/widgets/custom_snackbar.dart';
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
  bool isLoading = true;
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
    return Padding(
      padding: const EdgeInsets.only(top: 128.0, bottom: kIsWeb ? 0 : 64),
      child: BlocConsumer<DepositionsBloc, DepositionsState>(
        listener: (context, state) {
          if (state is DepositionsFetchingState) {
            _isWritingDeposition = false;
            isLoading = true;
          }
          if (state is DepositionsFetchedState) {
            depositionsData = state.depositions;
            isLoading = false;
          }
          if (state is DepositionsAddingState) {
            isLoading = true;
          }
          if (state is DepositionsAddedState) {
            _isWritingDeposition = false;
            isLoading = false;
            showCustomSnackBar(context);
            getDepositionsList();
          }
          if (state is DepositionsUpdatingState) {
            isLoading = true;
          }
          if (state is DepositionsUpdatedState) {
            _isWritingDeposition = false;
            isLoading = false;
            getDepositionsList();
          }
          if (state is DepositionsRemovingState) {
            isLoading = true;
          }
          if (state is DepositionsRemovedState) {
            isLoading = false;
            getDepositionsList();
          }
          if (state is DepositionsErrorState) {}
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: (() async {
              getDepositionsList();
            }),
            child: Stack(
              alignment: Alignment.center,
              children: [
                isLoading
                    ? ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * (kIsWeb ? 0.6 : 1.0)),
                        child: ListView.builder(
                          itemCount: 5,
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
                          ),
                        ),
                      ),
                if (depositionsData.isEmpty && !isLoading)
                  Text(
                    'Ainda não há depoimentos por aqui!\nPor que você não escreve algo?',
                    style: AppTextStyles.textSize16.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                if (_isWritingDeposition)
                  GestureDetector(
                    onTap: () => onNewDeposition(),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: AppColors.depositionsPrimary.withOpacity(0.4),
                    ),
                  ),
                if (!isLoading && !auth.currentUser!.isAnonymous)
                  DepositionAddButton(
                    onNewDeposition: onNewDeposition,
                    isWritingDeposition: _isWritingDeposition,
                    nameTextFocus: widget.nameTextFocus,
                    relationshipTextFocus: widget.relationshipTextFocus,
                    depositionTextFocus: widget.depositionTextFocus,
                    depositionsData: depositionsData,
                  ),
              ],
            ),
          );
        },
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

  showCustomSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SuccessSnackBar(
            title: text.successSnackBarDepositionTitle,
            subtitle: text.successSnackBarDepositionMessage,
          ),
        )
        .closed
        .then((value) {});
  }

  bool isRightSide(int i) => i % 2 == 0;
}
