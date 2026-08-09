import 'package:equatable/equatable.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

class AccountDeleteEvent extends AccountEvent {}

class AccountVerifyOtpEvent extends AccountEvent {
  final String pin;

  const AccountVerifyOtpEvent({required this.pin});

  @override
  List<Object> get props => [pin];
}
