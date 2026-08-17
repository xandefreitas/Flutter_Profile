import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'skill.dart';

class Occupation {
  String role;
  String startDate;
  String endDate;
  String description;
  bool isCurrentOccupation;
  List<Skill>? occupationSkills;
  Occupation({
    required this.role,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.isCurrentOccupation,
    this.occupationSkills,
  });

  Occupation copyWith({
    String? role,
    String? startDate,
    String? endDate,
    String? description,
    bool? isCurrentOccupation,
    List<Skill>? occupationSkills,
  }) {
    return Occupation(
      role: role ?? this.role,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      isCurrentOccupation: isCurrentOccupation ?? this.isCurrentOccupation,
      occupationSkills: occupationSkills ?? this.occupationSkills,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
      'isCurrentOccupation': isCurrentOccupation,
      'occupationSkills': occupationSkills?.map((x) => x.toMap()).toList(),
    };
  }

  factory Occupation.fromMap(Map<String, dynamic> map) {
    return Occupation(
      role: map['role'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      description: map['descriptionEn'] ?? map['description'] ?? '',
      isCurrentOccupation: map['isCurrentOccupation'] ?? false,
      occupationSkills:
          map['occupationSkills'] != null
              ? List<Skill>.from(
                (map['occupationSkills'] as List).map(
                  (x) => Skill.fromMap(x as Map<String, dynamic>),
                ),
              )
              : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Occupation.fromJson(String source) =>
      Occupation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Occupation(role: $role, startDate: $startDate, endDate: $endDate, description: $description, isCurrentOccupation: $isCurrentOccupation, occupationSkills: $occupationSkills)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Occupation &&
        other.role == role &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.description == description &&
        other.isCurrentOccupation == isCurrentOccupation &&
        listEquals(other.occupationSkills, occupationSkills);
  }

  @override
  int get hashCode {
    return role.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        description.hashCode ^
        isCurrentOccupation.hashCode ^
        occupationSkills.hashCode;
  }
}
