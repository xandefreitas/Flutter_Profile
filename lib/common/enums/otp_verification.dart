// ignore_for_file: constant_identifier_names

enum OTPVerification { INPUTNUMBER, AWAITINGCODE, INPUTNAME }

extension StatusValues on OTPVerification {
  int get index {
    switch (this) {
      case OTPVerification.INPUTNUMBER:
        return 0;
      case OTPVerification.AWAITINGCODE:
        return 1;
      case OTPVerification.INPUTNAME:
        return 2;
      default:
        return 0;
    }
  }
}
