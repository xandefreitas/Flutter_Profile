import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:flutter_profile/screens/DepositionsScreen/components/deposition_card.dart';
import 'package:flutter_profile/screens/DepositionsScreen/components/new_deposition_button.dart';

import '../../data/depositions_data.dart';
import '../../common/widgets/custom_snackbar.dart';

class DepositionsScreen extends StatefulWidget {
  final FocusNode nameTextFocus;
  final FocusNode relationshipTextFocus;
  final FocusNode depositionTextFocus;
  const DepositionsScreen({
    Key? key,
    required this.nameTextFocus,
    required this.relationshipTextFocus,
    required this.depositionTextFocus,
  }) : super(key: key);

  @override
  State<DepositionsScreen> createState() => _DepositionsScreenState();
}

class _DepositionsScreenState extends State<DepositionsScreen> {
  bool _isWritingDeposition = false;
  bool snackBarIsClosed = true;
  @override
  Widget build(BuildContext context) {
    final depositionsData = DepositionsData;
    return Padding(
      padding: const EdgeInsets.only(top: 128.0, bottom: kIsWeb ? 0 : 64),
      child: Stack(
        alignment: Alignment.center,
        children: [
          snackBarIsClosed
              ? ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * (kIsWeb ? 0.6 : 1.0)),
                  child: ListView.builder(
                    itemCount: depositionsData.length,
                    itemBuilder: (ctx, i) => DepositionCard(
                      deposition: depositionsData[i],
                      isRightSide: isRightSide(i),
                    ),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
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
          if (snackBarIsClosed)
            NewDepositionButton(
              onNewDeposition: onNewDeposition,
              onDepositionSent: onDepositionSent,
              isWritingDeposition: _isWritingDeposition,
              nameTextFocus: widget.nameTextFocus,
              relationshipTextFocus: widget.relationshipTextFocus,
              depositionTextFocus: widget.depositionTextFocus,
            ),
        ],
      ),
    );
  }

  onNewDeposition() {
    setState(() {
      _isWritingDeposition = !_isWritingDeposition;
    });
  }

  onDepositionSent() {
    setState(() {
      _isWritingDeposition = !_isWritingDeposition;
      snackBarIsClosed = !snackBarIsClosed;
    });
    showCustomSnackBar(
      context,
      'Depoimento Enviado!',
      'Muito obrigado por deixar seu depoimento.',
      Icons.check,
      AppColors.snackBarSuccess,
    );
  }

  showCustomSnackBar(BuildContext context, String title, String subtitle, IconData icon, Color? snackBarColor) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: CustomSnackBar(
              title: title,
              subtitle: subtitle,
              icon: icon,
              snackBarColor: snackBarColor,
            ),
            duration: const Duration(seconds: 3),
          ),
        )
        .closed
        .then((value) => setState(() => snackBarIsClosed = !snackBarIsClosed));
  }

  bool isRightSide(int i) => i % 2 == 0;
}
