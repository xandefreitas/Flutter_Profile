import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:flutter_profile/common/models/occupation.dart';

class Company {
  String? id;
  String name;
  List<Occupation> occupations;
  Company({
    this.id,
    required this.name,
    required this.occupations,
  });

  Company copyWith({
    String? id,
    String? name,
    List<Occupation>? occupations,
  }) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      occupations: occupations ?? this.occupations,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'occupations': occupations.map((x) => x.toMap()).toList(),
    };
  }

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      id: map['id'],
      name: map['name'] ?? '',
      occupations: List<Occupation>.from(map['occupations']?.map((x) => Occupation.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Company.fromJson(String source) => Company.fromMap(json.decode(source));

  @override
  String toString() => 'Company(id: $id, name: $name, occupations: $occupations)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Company && other.id == id && other.name == name && listEquals(other.occupations, occupations);
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ occupations.hashCode;
}
