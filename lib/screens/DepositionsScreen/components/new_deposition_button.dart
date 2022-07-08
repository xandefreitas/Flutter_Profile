import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile/common/models/deposition.dart';
import 'package:flutter_profile/core/app_text_styles.dart';
import 'package:flutter_profile/data/icons_data.dart';

import '../../../core/app_colors.dart';

class NewDepositionButton extends StatefulWidget {
  final FocusNode nameTextFocus;
  final FocusNode relationshipTextFocus;
  final FocusNode depositionTextFocus;
  final Function() onNewDeposition;
  final Function() onDepositionSent;
  final bool isWritingDeposition;
  const NewDepositionButton({
    Key? key,
    required this.onNewDeposition,
    required this.onDepositionSent,
    required this.isWritingDeposition,
    required this.nameTextFocus,
    required this.relationshipTextFocus,
    required this.depositionTextFocus,
  }) : super(key: key);

  @override
  State<NewDepositionButton> createState() => _NewDepositionButtonState();
}

class _NewDepositionButtonState extends State<NewDepositionButton> {
  final nameTextController = TextEditingController();
  final relationshipTextController = TextEditingController();
  final depositionTextController = TextEditingController();
  int iconIndexSelected = 0;

  @override
  void initState() {
    nameTextController.text = 'Alexandre Gazar Libório de Freitas';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const _iconsData = IconsData;
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
                                hintText: 'Nome do Usuário Logado Preenchido',
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
                            TextFormField(
                              focusNode: widget.relationshipTextFocus,
                              style: AppTextStyles.textSize12,
                              controller: relationshipTextController,
                              decoration: InputDecoration(
                                hintText: 'Relação',
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
                            SizedBox(
                              height: 112,
                              child: TextFormField(
                                maxLines: 5,
                                maxLength: 140,
                                focusNode: widget.depositionTextFocus,
                                style: AppTextStyles.textSize12,
                                controller: depositionTextController,
                                decoration: InputDecoration(
                                  hintText: 'Escreva algo sobre mim ou sobre meu app!',
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
                                    Deposition(
                                      iconIndex: iconIndexSelected,
                                      name: nameTextController.text,
                                      relationship: relationshipTextController.text,
                                      deposition: depositionTextController.text,
                                    );
                                    widget.onDepositionSent();
                                  },
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.only(left: 8),
                                    physics: const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Enviar',
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
                      relationshipTextController.clear();
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
}
