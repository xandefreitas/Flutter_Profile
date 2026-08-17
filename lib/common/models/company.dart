import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'occupation.dart';

class Company {
  String? id;
  String name;
  String? websiteUrl;
  List<Occupation> occupations;
  Company({
    required this.name,
    required this.occupations,
    this.id,
    this.websiteUrl,
  });

  Company copyWith({
    String? id,
    String? name,
    String? websiteUrl,
    List<Occupation>? occupations,
  }) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      occupations: occupations ?? this.occupations,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'websiteUrl': websiteUrl,
      'occupations': occupations.map((x) => x.toMap()).toList(),
    };
  }

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      id: map['id'],
      name: map['name'] ?? '',
      websiteUrl: map['websiteUrl'],
      occupations: List<Occupation>.from(((map['occupations'] ?? []) as List).map((x) => Occupation.fromMap(x as Map<String, dynamic>))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Company.fromJson(String source) => Company.fromMap(json.decode(source));

  @override
  String toString() => 'Company(id: $id, name: $name, websiteUrl: $websiteUrl, occupations: $occupations)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Company && other.id == id && other.name == name && other.websiteUrl == websiteUrl && listEquals(other.occupations, occupations);
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ websiteUrl.hashCode ^ occupations.hashCode;
}
