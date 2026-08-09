import 'package:equatable/equatable.dart';

import 'account_event.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object> get props => [];
}

abstract class AccountLoadingState extends AccountState {}

class AccountInitial extends AccountState {}

class AccountSendingCodeState extends AccountLoadingState {}

class AccountCodeSentState extends AccountState {}

class AccountVerifyingOtpState extends AccountLoadingState {}

class AccountDeletedState extends AccountState {}

class AccountErrorState extends AccountState {
  final dynamic exception;
  final AccountEvent event;

  const AccountErrorState({required this.exception, required this.event});

  @override
  List<Object> get props => [exception, event];
}
