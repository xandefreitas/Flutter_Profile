import 'package:flutter/material.dart';
import 'package:flutter_profile/core/app_text_styles.dart';
import 'package:flutter_profile/data/icons_data.dart';

import '../../../core/app_colors.dart';

class NewDepositionButton extends StatefulWidget {
  final FocusNode textFocus;
  final Function() onNewDeposition;
  final bool isWritingDeposition;
  const NewDepositionButton({
    Key? key,
    required this.onNewDeposition,
    required this.isWritingDeposition,
    required this.textFocus,
  }) : super(key: key);

  @override
  State<NewDepositionButton> createState() => _NewDepositionButtonState();
}

class _NewDepositionButtonState extends State<NewDepositionButton> {
  int iconIndexSelected = 0;
  @override
  Widget build(BuildContext context) {
    const _iconsData = IconsData;
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
            width: widget.isWritingDeposition ? 272 : 40,
            child: widget.isWritingDeposition
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      child: SingleChildScrollView(
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
                              focusNode: widget.textFocus,
                              style: AppTextStyles.textNormal12,
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
                              style: AppTextStyles.textNormal12,
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
                            TextFormField(
                              maxLines: 4,
                              maxLength: 140,
                              style: AppTextStyles.textNormal12,
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
                            const SizedBox(height: 8),
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
                                    // widget.onNewDeposition();
                                  },
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.only(left: 8),
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Enviar',
                                          maxLines: 1,
                                          style: AppTextStyles.textNormal12.copyWith(
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
