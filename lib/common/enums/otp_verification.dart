// ignore_for_file: constant_identifier_names

enum OTPVerification {
  INPUTNUMBER(0),
  AWAITINGCODE(1),
  INPUTNAME(2);

  final int value;
  const OTPVerification(this.value);
}
