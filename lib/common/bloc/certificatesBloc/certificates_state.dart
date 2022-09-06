import 'package:equatable/equatable.dart';
import 'package:flutter_profile/common/models/certificate.dart';

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
  final String response;

  const CertificatesAddedState({required this.response});

  @override
  List<Object> get props => [response];
}

class CertificatesUpdatingState extends CertificatesLoadingState {}

class CertificatesUpdatedState extends CertificatesState {
  final String response;

  const CertificatesUpdatedState({required this.response});

  @override
  List<Object> get props => [response];
}

class CertificatesRemovingState extends CertificatesLoadingState {}

class CertificatesRemovedState extends CertificatesState {
  final String response;

  const CertificatesRemovedState({required this.response});

  @override
  List<Object> get props => [response];
}

class CertificatesErrorState extends CertificatesState {
  final dynamic exception;
  final CertificatesEvent event;

  const CertificatesErrorState({required this.exception, required this.event});

  @override
  List<Object> get props => [exception, event];
}
