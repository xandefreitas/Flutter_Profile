import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/auth_webclient.dart';
import '../../util/error_util.dart';
import 'account_event.dart';
import 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AuthWebclient authWebclient;
  AccountBloc()
    : authWebclient = AuthWebclient(auth: FirebaseAuth.instance),
      super(AccountInitial()) {
    on<AccountEvent>((event, emit) async {
      try {
        switch (event) {
          case AccountDeleteEvent():
            emit(AccountSendingCodeState());
            final codeSent = Completer<AccountState>();
            await authWebclient.verifyNumber(
              phoneNumber: FirebaseAuth.instance.currentUser!.phoneNumber!,
              timeoutDuration: 60,
              whenVerified: () => codeSent.complete(AccountCodeSentState()),
              onError:
                  (errorTitle, message) => codeSent.complete(
                    AccountErrorState(exception: message, event: event),
                  ),
            );
            emit(await codeSent.future);
          case AccountVerifyOtpEvent():
            emit(AccountVerifyingOtpState());
            final user = FirebaseAuth.instance.currentUser!;
            await authWebclient.reauthenticate(pin: event.pin);
            await authWebclient.deleteUser(user);
            await FirebaseAuth.instance.signOut();
            emit(AccountDeletedState());
        }
      } catch (e) {
        emit(
          AccountErrorState(
            exception: ErrorUtil.validateException(e),
            event: event,
          ),
        );
      }
    });
  }
}
