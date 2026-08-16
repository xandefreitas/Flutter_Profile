import 'package:equatable/equatable.dart';
import '../../models/certificate.dart';

import 'certificates_event.dart';

abstract class CertificatesState extends Equatable {
  const CertificatesState();

  @override
  List<Object> get props => [];
}

abstract class CertificatesLoadingState extends CertificatesState {}

class CertificatesInitial extends CertificatesState {}

class CertificatesFetchingState extends CertificatesLoadingState {}

class CertificatesFetchedState extends CertificatesState {
  final List<Certificate> certificates;

  const CertificatesFetchedState({required this.certificates});

  @override
  List<Object> get props => [certificates];
}

class CertificatesAddingState extends CertificatesLoadingState {}

class CertificatesAddedState extends CertificatesState {
  final Certificate certificate;

  const CertificatesAddedState({required this.certificate});

  @override
  List<Object> get props => [certificate];
}

class CertificatesUpdatingState extends CertificatesLoadingState {}

class CertificatesUpdatedState extends CertificatesState {
  final Certificate certificate;

  const CertificatesUpdatedState({required this.certificate});

  @override
  List<Object> get props => [certificate];
}

class CertificatesRemovingState extends CertificatesLoadingState {}

class CertificatesRemovedState extends CertificatesState {
  final String certificateId;

  const CertificatesRemovedState({required this.certificateId});

  @override
  List<Object> get props => [certificateId];
}

class CertificatesErrorState extends CertificatesState {
  final dynamic exception;
  final CertificatesEvent event;

  const CertificatesErrorState({required this.exception, required this.event});

  @override
  List<Object> get props => [exception, event];
}
