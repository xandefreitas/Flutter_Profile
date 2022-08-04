// ignore_for_file: constant_identifier_names

enum UserRole { USER, ADMIN }

extension RoleValues on UserRole {
  int get value {
    switch (this) {
      case UserRole.USER:
        return 0;
      case UserRole.ADMIN:
        return 1;
      default:
        return 0;
    }
  }
}
