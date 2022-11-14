import 'dart:convert';

class Occupation {
  String role;
  String startDate;
  String endDate;
  String description;
  String descriptionEn;
  bool isCurrentOccupation;
  Occupation({
    required this.role,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.descriptionEn,
    required this.isCurrentOccupation,
  });

  Occupation copyWith({
    String? role,
    String? startDate,
    String? endDate,
    String? description,
    String? descriptionEn,
    bool? isCurrentOccupation,
  }) {
    return Occupation(
      role: role ?? this.role,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      isCurrentOccupation: isCurrentOccupation ?? this.isCurrentOccupation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
      'descriptionEn': descriptionEn,
      'isCurrentOccupation': isCurrentOccupation,
    };
  }

  factory Occupation.fromMap(Map<String, dynamic> map) {
    return Occupation(
      role: map['role'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      description: map['description'] ?? '',
      descriptionEn: map['descriptionEn'] ?? '',
      isCurrentOccupation: map['isCurrentOccupation'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Occupation.fromJson(String source) => Occupation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Occupation(role: $role, startDate: $startDate, endDate: $endDate, description: $description, descriptionEn: $descriptionEn, isCurrentOccupation: $isCurrentOccupation)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Occupation &&
        other.role == role &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.description == description &&
        other.descriptionEn == descriptionEn &&
        other.isCurrentOccupation == isCurrentOccupation;
  }

  @override
  int get hashCode {
    return role.hashCode ^ startDate.hashCode ^ endDate.hashCode ^ description.hashCode ^ descriptionEn.hashCode ^ isCurrentOccupation.hashCode;
  }
}
