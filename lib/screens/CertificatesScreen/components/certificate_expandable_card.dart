import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common/api/certificates_webclient.dart';
import '../../../common/enums/certificate_screen_mode.dart';
import '../../../common/models/certificate.dart';
import '../../../common/util/app_routes.dart';
import '../../../common/util/contact_util.dart';
import '../../../common/util/translation_cache.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';

class CertificateExpandableCard extends StatefulWidget {
  final Certificate certificate;
  final bool isAdmin;
  final Function(Certificate) updateCertificate;
  final Function(String) removeCertificate;
  const CertificateExpandableCard({
    required this.certificate,
    required this.isAdmin,
    required this.updateCertificate,
    required this.removeCertificate,
    super.key,
  });

  @override
  State<CertificateExpandableCard> createState() =>
      _CertificateExpandableCardState();
}

class _CertificateExpandableCardState extends State<CertificateExpandableCard> {
  bool _isExpanded = false;
  late String _translatedDescription = widget.certificate.description;
  late final Future<int?>? _imageValidationFuture =
      CertificatesWebClient.validateImageUrl(widget.certificate.imageUrl ?? '');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _translateDescription();
  }

  Future<void> _translateDescription() async {
    final locale = Localizations.localeOf(context);
    if (locale.languageCode == 'en') {
      _translatedDescription = widget.certificate.description;
      return;
    }

    final translated = await TranslationCache.instance.translate(
      text: widget.certificate.description,
      targetLanguageCode: locale.languageCode,
      cacheKeyPrefix: widget.certificate.description,
    );
    if (!mounted) return;
    setState(() {
      _translatedDescription = translated;
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap:
            () => setState(() {
              _isExpanded = !_isExpanded;
            }),
        child: AnimatedContainer(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
          height: _isExpanded ? 208 : 104,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColors.certificatesPrimary.withValues(alpha: 0.8),
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
                    child: FutureBuilder(
                      future: _imageValidationFuture,
                      builder: (context, snapshot) {
                        return snapshot.hasError
                            ? Image.asset(
                              'assets/images/certification_placeholder.png',
                              fit: BoxFit.cover,
                            )
                            : CachedNetworkImage(
                              imageUrl: widget.certificate.imageUrl ?? '',
                              errorWidget:
                                  (context, url, error) => Image.asset(
                                    'assets/images/certification_placeholder.png',
                                    fit: BoxFit.cover,
                                  ),
                              fit: BoxFit.cover,
                              placeholder:
                                  (context, url) => Image.asset(
                                    'assets/images/certification_placeholder.png',
                                    fit: BoxFit.cover,
                                  ),
                            );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${text.certificateCardCourseLabel} ${widget.certificate.course}',
                          style: AppTextStyles.textSize16.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${text.certificateCardInstitutionLabel} ${widget.certificate.institution}',
                          style: AppTextStyles.textWhite.copyWith(
                            color: AppColors.white.withValues(alpha: 0.8),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: widget.isAdmin,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          certificatesFormRoute,
                          arguments: {
                            'certificate': widget.certificate,
                            'title': text.certificateFormScreenTitleUpdate,
                            'updateCertificate': widget.updateCertificate,
                            'removeCertificate': widget.removeCertificate,
                            'screenMode': CertificateScreenMode.UPDATE.value,
                          },
                        );
                      },
                      child: const Icon(
                        Icons.edit,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !_isExpanded && !widget.isAdmin,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 12,
                          color: AppColors.white,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          widget.certificate.duration.isEmpty
                              ? '-'
                              : '${widget.certificate.duration}h',
                          style: AppTextStyles.textWhite.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                height: _isExpanded ? 88 : 0,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Text(
                  _translatedDescription,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.textSize12.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Visibility(
                visible: _isExpanded,
                child: Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.today_outlined,
                        size: 14,
                        color: AppColors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat(
                          'dd/MM/yy',
                        ).format(DateTime.parse(widget.certificate.date)),
                        style: AppTextStyles.textWhite,
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.schedule,
                        size: 14,
                        color: AppColors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.certificate.duration.isEmpty
                            ? '-'
                            : '${widget.certificate.duration}h',
                        style: AppTextStyles.textWhite,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap:
                            () => launchCertificateUrl(
                              widget.certificate.credentialUrl,
                              text,
                            ),
                        child: Row(
                          children: [
                            Text(
                              text.certificateCardCredentialLinkLabel,
                              style: AppTextStyles.textWhite.copyWith(
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.white,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.north_east,
                              size: 14,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Icon(
                _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: AppColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void launchCertificateUrl(String url, AppLocalizations text) {
    ContactUtil(context: context, text: text).launchUrl(url);
  }
}
