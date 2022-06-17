import 'dart:convert';

class Deposition {
  String name;
  String relationship;
  String deposition;
  int iconIndex;
  Deposition({
    required this.name,
    required this.relationship,
    required this.deposition,
    required this.iconIndex,
  });

  Deposition copyWith({
    String? name,
    String? relationship,
    String? deposition,
    int? iconIndex,
  }) {
    return Deposition(
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      deposition: deposition ?? this.deposition,
      iconIndex: iconIndex ?? this.iconIndex,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'relationship': relationship,
      'deposition': deposition,
      'iconIndex': iconIndex,
    };
  }

  factory Deposition.fromMap(Map<String, dynamic> map) {
    return Deposition(
      name: map['name'] ?? '',
      relationship: map['relationship'] ?? '',
      deposition: map['deposition'] ?? '',
      iconIndex: map['iconIndex']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Deposition.fromJson(String source) => Deposition.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Deposition(name: $name, relationship: $relationship, deposition: $deposition, iconIndex: $iconIndex)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Deposition &&
        other.name == name &&
        other.relationship == relationship &&
        other.deposition == deposition &&
        other.iconIndex == iconIndex;
  }

  @override
  int get hashCode {
    return name.hashCode ^ relationship.hashCode ^ deposition.hashCode ^ iconIndex.hashCode;
  }
}
