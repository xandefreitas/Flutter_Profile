import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile/common/util/snackbar_util.dart';
import 'package:flutter_profile/common/widgets/CustomSnackBar/custom_snackbar.dart';
import '../../common/bloc/certificatesBloc/certificates_bloc.dart';
import '../../common/bloc/certificatesBloc/certificates_event.dart';
import '../../common/bloc/certificatesBloc/certificates_state.dart';
import '../../common/models/certificate.dart';
import 'components/certificate_add_card.dart';
import 'components/certificate_expandable_card.dart';
import 'components/certificate_shimmer_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CertificatesScreen extends StatefulWidget {
  final bool isAdmin;
  const CertificatesScreen({this.isAdmin = false, Key? key}) : super(key: key);

  @override
  State<CertificatesScreen> createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends State<CertificatesScreen> {
  bool isLoading = true;
  List<Certificate> certificatesData = [];
  late AppLocalizations text;

  @override
  void initState() {
    getCertificatesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    text = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 128.0, bottom: kIsWeb ? 0 : 64),
      child: BlocConsumer<CertificatesBloc, CertificatesState>(
        listener: (context, state) {
          if (state is CertificatesFetchingState) {
            isLoading = true;
          }
          if (state is CertificatesFetchedState) {
            isLoading = false;
            certificatesData = state.certificates;
          }
          if (state is CertificatesAddingState) {
            isLoading = true;
          }
          if (state is CertificatesAddedState) {
            getCertificatesList();
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
            getCertificatesList();
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
            getCertificatesList();
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
            height: MediaQuery.of(context).size.height,
            child: isLoading
                ? ListView.builder(
                    itemCount: 4,
                    itemBuilder: ((context, index) => const CertificateShimmerCard()),
                  )
                : ListView(
                    children: [
                      ...certificatesData.map(
                        (e) => CertificateExpandableCard(
                          certificate: e,
                          isAdmin: widget.isAdmin,
                          updateCertificate: updateCertificate,
                          removeCertificate: removeCertificate,
                        ),
                      ),
                      if (widget.isAdmin) CertificateAddCard(addCertificate: addCertificate),
                    ],
                  ),
          );
        },
      ),
    );
  }

  getCertificatesList() {
    context.read<CertificatesBloc>().add(CertificatesFetchEvent());
  }

  addCertificate(Certificate certificate) {
    context.read<CertificatesBloc>().add(CertificatesAddEvent(certificate: certificate));
  }

  updateCertificate(Certificate certificate) {
    context.read<CertificatesBloc>().add(CertificatesUpdateEvent(certificate: certificate));
  }

  removeCertificate(String certificateId) {
    context.read<CertificatesBloc>().add(CertificatesRemoveEvent(certificateId: certificateId));
  }
}
