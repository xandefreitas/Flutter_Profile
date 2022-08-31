import 'package:flutter/material.dart';
import 'package:flutter_profile/common/models/certificate.dart';
import 'package:flutter_profile/core/app_text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../common/util/contact_util.dart';
import '../../../core/app_colors.dart';

class CertificateExpandableCard extends StatefulWidget {
  final Certificate certificate;
  const CertificateExpandableCard({
    required this.certificate,
    Key? key,
  }) : super(key: key);

  @override
  State<CertificateExpandableCard> createState() => _CertificateExpandableCardState();
}

class _CertificateExpandableCardState extends State<CertificateExpandableCard> {
  bool _isExpanded = false;
  late AppLocalizations text;

  @override
  Widget build(BuildContext context) {
    text = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AnimatedContainer(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
        height: _isExpanded ? 208 : 104,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.certificatesPrimary.withOpacity(0.8),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.white,
                  ),
                  child: FadeInImage(
                    image: NetworkImage(widget.certificate.imageUrl),
                    imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/certification_placeholder.png',
                      fit: BoxFit.cover,
                    ),
                    fit: BoxFit.scaleDown,
                    placeholder: const AssetImage('assets/images/certification_placeholder.png'),
                    placeholderFit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${text.certificateCardCourseLabel} ${widget.certificate.course}',
                      style: AppTextStyles.textSize16.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${text.certificateCardInstitutionLabel} ${widget.certificate.institution}',
                      style: AppTextStyles.textWhite.copyWith(
                        color: AppColors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(
                  Icons.delete,
                  color: AppColors.white,
                ),
              ],
            ),
            const SizedBox(height: 16),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
              height: _isExpanded ? 88 : 0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(8),
              child: Text(
                widget.certificate.description,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.textSize12,
              ),
            ),
            const SizedBox(height: 8),
            if (_isExpanded)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.certificate.date,
                      style: AppTextStyles.textWhite,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => launchCertificateUrl(widget.certificate.credentialUrl),
                      child: Text(
                        text.certificateCardCredentialLinkLabel,
                        style: AppTextStyles.textWhite.copyWith(decoration: TextDecoration.underline),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => launchCertificateUrl(widget.certificate.credentialUrl),
                      child: const Icon(
                        Icons.north_east,
                        size: 14,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            GestureDetector(
              onTap: (() => setState(() {
                    _isExpanded = !_isExpanded;
                  })),
              child: Icon(
                _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  launchCertificateUrl(String url) {
    ContactUtil.launchUrl(url, context);
  }
}
