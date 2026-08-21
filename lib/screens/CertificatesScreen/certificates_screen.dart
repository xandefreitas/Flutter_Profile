import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/bloc/certificatesBloc/certificates_bloc.dart';
import '../../common/bloc/certificatesBloc/certificates_event.dart';
import '../../common/bloc/certificatesBloc/certificates_state.dart';
import '../../common/models/certificate.dart';
import '../../common/util/snackbar_util.dart';
import '../../common/widgets/CustomSnackBar/custom_snackbar.dart';
import '../../l10n/app_localizations.dart';
import 'components/certificate_add_card.dart';
import 'components/certificate_expandable_card.dart';
import 'components/certificate_shimmer_card.dart';

class CertificatesScreen extends StatefulWidget {
  final bool isAdmin;
  const CertificatesScreen({this.isAdmin = false, super.key});

  @override
  State<CertificatesScreen> createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends State<CertificatesScreen> {
  bool isLoading = true;
  List<Certificate> certificatesData = [];

  @override
  void initState() {
    getCertificatesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 128.0, bottom: 72),
        child: BlocConsumer<CertificatesBloc, CertificatesState>(
          listener: (context, state) {
            if (state is CertificatesFetchingState) {
              isLoading = true;
            }
            if (state is CertificatesFetchedState) {
              isLoading = false;
              certificatesData = state.certificates;
              if (certificatesData.isNotEmpty) sortCertificates();
            }
            if (state is CertificatesAddingState) {
              isLoading = true;
            }
            if (state is CertificatesAddedState) {
              // No manual list patch needed: the live subscription from
              // getCertificatesList() already reflects this change once the
              // write lands.
              isLoading = false;
              SnackBarUtil.showCustomSnackBar(
                context: context,
                snackbar: SuccessSnackBar(
                  title: text.snackBarGenericSuccessTitle,
                  subtitle: text.successSnackBarAddedCertificate,
                ),
              );
            }
            if (state is CertificatesUpdatingState) {
              isLoading = true;
            }
            if (state is CertificatesUpdatedState) {
              isLoading = false;
              SnackBarUtil.showCustomSnackBar(
                context: context,
                snackbar: SuccessSnackBar(
                  title: text.snackBarGenericSuccessTitle,
                  subtitle: text.successSnackBarUpdatedCertificate,
                ),
              );
            }
            if (state is CertificatesRemovingState) {
              isLoading = true;
            }
            if (state is CertificatesRemovedState) {
              isLoading = false;
              SnackBarUtil.showCustomSnackBar(
                context: context,
                snackbar: SuccessSnackBar(
                  title: text.snackBarGenericSuccessTitle,
                  subtitle: text.successSnackBarRemovedCertificate,
                ),
              );
            }
            if (state is CertificatesErrorState) {
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
            return SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: isLoading
                  ? ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) => const CertificateShimmerCard(),
                    )
                  : ListView(
                      children: [
                        Visibility(visible: widget.isAdmin, child: CertificateAddCard(addCertificate: addCertificate)),
                        ...certificatesData.reversed.map(
                          (e) => CertificateExpandableCard(
                            certificate: e,
                            isAdmin: widget.isAdmin,
                            updateCertificate: updateCertificate,
                            removeCertificate: removeCertificate,
                          ).animate().fadeIn(),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }

  void sortCertificates() {
    certificatesData.sort((a, b) => a.date.compareTo(b.date));
  }

  void getCertificatesList() {
    context.read<CertificatesBloc>().add(CertificatesFetchEvent());
  }

  void addCertificate(Certificate certificate) {
    context.read<CertificatesBloc>().add(CertificatesAddEvent(certificate: certificate));
  }

  void updateCertificate(Certificate certificate) {
    context.read<CertificatesBloc>().add(CertificatesUpdateEvent(certificate: certificate));
  }

  void removeCertificate(String certificateId) {
    Navigator.pop(context);
    context.read<CertificatesBloc>().add(CertificatesRemoveEvent(certificateId: certificateId));
  }
}
