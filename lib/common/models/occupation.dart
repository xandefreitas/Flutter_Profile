import 'dart:convert';

class Occupation {
  String role;
  String startDate;
  String endDate;
  String description;
  Occupation({
    required this.role,
    required this.startDate,
    required this.endDate,
    required this.description,
  });

  Occupation copyWith({
    String? role,
    String? startDate,
    String? endDate,
    String? description,
  }) {
    return Occupation(
      role: role ?? this.role,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
    };
  }

  factory Occupation.fromMap(Map<String, dynamic> map) {
    return Occupation(
      role: map['role'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Occupation.fromJson(String source) => Occupation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Occupation(role: $role, startDate: $startDate, endDate: $endDate, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Occupation && other.role == role && other.startDate == startDate && other.endDate == endDate && other.description == description;
  }

  @override
  int get hashCode {
    return role.hashCode ^ startDate.hashCode ^ endDate.hashCode ^ description.hashCode;
  }
}
