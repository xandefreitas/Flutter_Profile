import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/auth_webclient.dart';
import '../bloc_error_handling.dart';
import 'account_event.dart';
import 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final FirebaseAuth auth;
  final AuthWebclient authWebclient;
  AccountBloc({FirebaseAuth? auth, AuthWebclient? webClient})
    : auth = auth ?? FirebaseAuth.instance,
      authWebclient = webClient ?? AuthWebclient(auth: auth ?? FirebaseAuth.instance),
      super(AccountInitial()) {
    on<AccountEvent>(
      (event, emit) => runBlocEvent(
        event: event,
        emit: emit,
        onError: (exception, event) => AccountErrorState(exception: exception, event: event),
        action: () async {
          switch (event) {
            case AccountDeleteEvent():
              emit(AccountSendingCodeState());
              final codeSent = Completer<AccountState>();
              await authWebclient.verifyNumber(
                phoneNumber: this.auth.currentUser!.phoneNumber!,
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
              final user = this.auth.currentUser!;
              await authWebclient.reauthenticate(pin: event.pin);
              await authWebclient.deleteUser(user);
              await this.auth.signOut();
              emit(AccountDeletedState());
          }
        },
      ),
    );
  }
}
