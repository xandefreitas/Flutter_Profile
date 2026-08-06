import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/certificates_webclient.dart';
import '../../util/error_util.dart';
import 'certificates_event.dart';
import 'certificates_state.dart';

class CertificatesBloc extends Bloc<CertificatesEvent, CertificatesState> {
  final CertificatesWebClient certificatesWebClient;
  final Map<String, String> translationCache = {};
  CertificatesBloc() : certificatesWebClient = CertificatesWebClient(), super(CertificatesInitial()) {
    on<CertificatesEvent>((event, emit) async {
      try {
        switch (event) {
          case CertificatesFetchEvent():
            emit(CertificatesFetchingState());
            final response = await certificatesWebClient.getCertificates();
            emit(CertificatesFetchedState(certificates: response));
          case CertificatesUpdateEvent():
            emit(CertificatesUpdatingState());
            final response = await certificatesWebClient.updateCertificate(event.certificate);
            emit(CertificatesUpdatedState(response: response));
          case CertificatesAddEvent():
            emit(CertificatesAddingState());
            final response = await certificatesWebClient.addCertificate(event.certificate);
            emit(CertificatesAddedState(response: response));
          case CertificatesRemoveEvent():
            emit(CertificatesRemovingState());
            final response = await certificatesWebClient.removeCertificate(event.certificateId);
            emit(CertificatesRemovedState(response: response));
        }
      } catch (e) {
        emit(CertificatesErrorState(exception: ErrorUtil.validateException(e), event: event));
      }
    });
  }
}
