import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/certificates_webclient.dart';
import '../bloc_error_handling.dart';
import 'certificates_event.dart';
import 'certificates_state.dart';

class CertificatesBloc extends Bloc<CertificatesEvent, CertificatesState> {
  final CertificatesWebClient certificatesWebClient;
  CertificatesBloc({CertificatesWebClient? webClient})
    : certificatesWebClient = webClient ?? CertificatesWebClient(),
      super(CertificatesInitial()) {
    on<CertificatesEvent>(
      (event, emit) => runBlocEvent(
        event: event,
        emit: emit,
        onError: (exception, event) => CertificatesErrorState(exception: exception, event: event),
        action: () async {
          switch (event) {
            case CertificatesFetchEvent():
              emit(CertificatesFetchingState());
              final response = await certificatesWebClient.getCertificates();
              emit(CertificatesFetchedState(certificates: response));
            case CertificatesUpdateEvent():
              emit(CertificatesUpdatingState());
              final certificate = await certificatesWebClient.updateCertificate(event.certificate);
              emit(CertificatesUpdatedState(certificate: certificate));
            case CertificatesAddEvent():
              emit(CertificatesAddingState());
              final certificate = await certificatesWebClient.addCertificate(event.certificate);
              emit(CertificatesAddedState(certificate: certificate));
            case CertificatesRemoveEvent():
              emit(CertificatesRemovingState());
              final certificateId = await certificatesWebClient.removeCertificate(event.certificateId);
              emit(CertificatesRemovedState(certificateId: certificateId));
          }
        },
      ),
    );
  }
}
