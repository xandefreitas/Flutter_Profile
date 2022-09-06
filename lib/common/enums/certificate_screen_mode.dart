// ignore_for_file: constant_identifier_names

enum CertificateScreenMode { ADD, UPDATE }

extension CertificateScreenValues on CertificateScreenMode {
  int get value {
    switch (this) {
      case CertificateScreenMode.ADD:
        return 0;
      case CertificateScreenMode.UPDATE:
        return 1;
      default:
        return 0;
    }
  }
}
