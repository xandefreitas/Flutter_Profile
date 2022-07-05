import 'dart:convert';

class Occupation {
  final String role;
  final String sinceDate;
  final String untilDate;
  final String description;
  final int occupationType;
  Occupation({
    required this.role,
    required this.sinceDate,
    required this.untilDate,
    required this.description,
    required this.occupationType,
  });

  Occupation copyWith({
    String? role,
    String? sinceDate,
    String? untilDate,
    String? description,
    int? occupationType,
  }) {
    return Occupation(
      role: role ?? this.role,
      sinceDate: sinceDate ?? this.sinceDate,
      untilDate: untilDate ?? this.untilDate,
      description: description ?? this.description,
      occupationType: occupationType ?? this.occupationType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'sinceDate': sinceDate,
      'untilDate': untilDate,
      'description': description,
      'occupationType': occupationType,
    };
  }

  factory Occupation.fromMap(Map<String, dynamic> map) {
    return Occupation(
      role: map['role'] ?? '',
      sinceDate: map['sinceDate'] ?? '',
      untilDate: map['untilDate'] ?? '',
      description: map['description'] ?? '',
      occupationType: map['occupationType']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Occupation.fromJson(String source) => Occupation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Occupation(role: $role, sinceDate: $sinceDate, untilDate: $untilDate, description: $description, occupationType: $occupationType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Occupation &&
        other.role == role &&
        other.sinceDate == sinceDate &&
        other.untilDate == untilDate &&
        other.description == description &&
        other.occupationType == occupationType;
  }

  @override
  int get hashCode {
    return role.hashCode ^ sinceDate.hashCode ^ untilDate.hashCode ^ description.hashCode ^ occupationType.hashCode;
  }
}
