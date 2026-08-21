import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/certificates_webclient.dart';
import '../../models/certificate.dart';
import '../../util/connectivity_util.dart';
import '../../util/error_util.dart';
import 'certificates_event.dart';
import 'certificates_state.dart';

class CertificatesBloc extends Bloc<CertificatesEvent, CertificatesState> {
  final CertificatesWebClient certificatesWebClient;
  final ConnectivityUtil connectivityUtil;

  /// Guards against subscribing to [CertificatesWebClient.watchCertificates]
  /// more than once: several widgets dispatch [CertificatesFetchEvent]
  /// against this same shared bloc instance, but only one live subscription
  /// should run.
  bool _isWatchingCertificates = false;

  CertificatesBloc({CertificatesWebClient? webClient, ConnectivityUtil? connectivityUtil})
    : certificatesWebClient = webClient ?? CertificatesWebClient(),
      connectivityUtil = connectivityUtil ?? ConnectivityUtil(),
      super(CertificatesInitial()) {
    on<CertificatesFetchEvent>(_onFetch);
    on<CertificatesAddEvent>(_onAdd);
    on<CertificatesUpdateEvent>(_onUpdate);
    on<CertificatesRemoveEvent>(_onRemove);
  }

  Future<void> _onFetch(CertificatesFetchEvent event, Emitter<CertificatesState> emit) async {
    if (_isWatchingCertificates) return;
    _isWatchingCertificates = true;
    emit(CertificatesFetchingState());
    await emit.forEach<List<Certificate>>(
      certificatesWebClient.watchCertificates(),
      onData: (certificates) => CertificatesFetchedState(certificates: certificates),
      onError: (error, stackTrace) {
        _isWatchingCertificates = false;
        return CertificatesErrorState(exception: ErrorUtil.validateException(error), event: event);
      },
    );
  }

  Future<void> _onAdd(CertificatesAddEvent event, Emitter<CertificatesState> emit) async {
    // Writes still go over plain REST/Dio (no offline queue), so check the
    // connectivity signal up front instead of letting the call hang or fail
    // with a raw timeout.
    if (!connectivityUtil.isConnected) {
      emit(CertificatesErrorState(exception: ErrorUtil.offlineMessage, event: event));
      return;
    }
    emit(CertificatesAddingState());
    try {
      final certificate = await certificatesWebClient.addCertificate(event.certificate);
      emit(CertificatesAddedState(certificate: certificate));
    } catch (e) {
      emit(CertificatesErrorState(exception: ErrorUtil.validateException(e), event: event));
    }
  }

  Future<void> _onUpdate(CertificatesUpdateEvent event, Emitter<CertificatesState> emit) async {
    if (!connectivityUtil.isConnected) {
      emit(CertificatesErrorState(exception: ErrorUtil.offlineMessage, event: event));
      return;
    }
    emit(CertificatesUpdatingState());
    try {
      final certificate = await certificatesWebClient.updateCertificate(event.certificate);
      emit(CertificatesUpdatedState(certificate: certificate));
    } catch (e) {
      emit(CertificatesErrorState(exception: ErrorUtil.validateException(e), event: event));
    }
  }

  Future<void> _onRemove(CertificatesRemoveEvent event, Emitter<CertificatesState> emit) async {
    if (!connectivityUtil.isConnected) {
      emit(CertificatesErrorState(exception: ErrorUtil.offlineMessage, event: event));
      return;
    }
    emit(CertificatesRemovingState());
    try {
      final certificateId = await certificatesWebClient.removeCertificate(event.certificateId);
      emit(CertificatesRemovedState(certificateId: certificateId));
    } catch (e) {
      emit(CertificatesErrorState(exception: ErrorUtil.validateException(e), event: event));
    }
  }
}
