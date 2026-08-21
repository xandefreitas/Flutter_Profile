import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../core/core.dart';

/// Live connectivity signal backed by Realtime Database's built-in
/// `.info/connected` special path, used to gate REST-backed writes
/// (Certificates, Work History, Depositions all still write over plain
/// REST/Dio, which has no offline queue) behind a check instead of letting
/// them fail with a raw timeout when offline.
///
/// `.info/connected` was chosen over a device-level connectivity plugin
/// because it answers "can I actually reach Firebase right now" rather than
/// "does the OS report a network interface" — the latter can say "online"
/// behind a captive portal or similar dead connection.
class ConnectivityUtil {
  ConnectivityUtil({Stream<bool>? connectedStream})
    : _connectedStream = (connectedStream ?? _defaultConnectedStream()).asBroadcastStream() {
    _subscription = _connectedStream.listen((connected) => _isConnected = connected);
  }

  static Stream<bool> _defaultConnectedStream() {
    return FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: Consts.databaseUrl)
        .ref('.info/connected')
        .onValue
        .map((event) => event.snapshot.value == true);
  }

  final Stream<bool> _connectedStream;
  late final StreamSubscription<bool> _subscription;

  // Optimistic until the first `.info/connected` event arrives, so a
  // freshly-constructed instance doesn't block writes before it's had a
  // chance to hear from the server.
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  Stream<bool> watchConnected() => _connectedStream;

  void dispose() => _subscription.cancel();
}
