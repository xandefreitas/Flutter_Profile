import 'package:equatable/equatable.dart';
import 'package:flutter_profile/common/models/certificate.dart';

abstract class CertificatesEvent extends Equatable {
  const CertificatesEvent();

  @override
  List<Object> get props => [];
}

class CertificatesFetchEvent extends CertificatesEvent {}

class CertificatesUpdateEvent extends CertificatesEvent {
  final Certificate certificate;

  const CertificatesUpdateEvent({required this.certificate});

  @override
  List<Object> get props => [certificate];
}

class CertificatesAddEvent extends CertificatesEvent {
  final Certificate certificate;

  const CertificatesAddEvent({required this.certificate});

  @override
  List<Object> get props => [certificate];
}

class CertificatesRemoveEvent extends CertificatesEvent {
  final String certificateId;

  const CertificatesRemoveEvent({required this.certificateId});

  @override
  List<Object> get props => [certificateId];
}
