import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:flutter_profile/common/models/occupation.dart';

class Company {
  final String name;
  final List<Occupation> occupations;
  Company({
    required this.name,
    required this.occupations,
  });

  Company copyWith({
    String? name,
    List<Occupation>? occupations,
  }) {
    return Company(
      name: name ?? this.name,
      occupations: occupations ?? this.occupations,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'occupations': occupations.map((x) => x.toMap()).toList(),
    };
  }

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      name: map['name'] ?? '',
      occupations: List<Occupation>.from(map['occupations']?.map((x) => Occupation.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Company.fromJson(String source) => Company.fromMap(json.decode(source));

  @override
  String toString() => 'Company(name: $name, occupations: $occupations)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Company && other.name == name && listEquals(other.occupations, occupations);
  }

  @override
  int get hashCode => name.hashCode ^ occupations.hashCode;
}
