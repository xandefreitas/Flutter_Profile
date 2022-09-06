import 'dart:convert';

class Deposition {
  String? id;
  String uid;
  String name;
  String deposition;
  int relationship;
  int iconIndex;
  Deposition({
    this.id,
    required this.uid,
    required this.name,
    required this.relationship,
    required this.deposition,
    required this.iconIndex,
  }) : assert(iconIndex < 12);

  Deposition copyWith({
    String? id,
    String? uid,
    String? name,
    String? deposition,
    int? relationship,
    int? iconIndex,
  }) {
    return Deposition(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      deposition: deposition ?? this.deposition,
      iconIndex: iconIndex ?? this.iconIndex,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'relationship': relationship,
      'deposition': deposition,
      'iconIndex': iconIndex,
    };
  }

  factory Deposition.fromMap(Map<String, dynamic> map) {
    return Deposition(
      id: map['id'],
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      relationship: map['relationship']?.toInt() ?? 0,
      deposition: map['deposition'] ?? '',
      iconIndex: map['iconIndex']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Deposition.fromJson(String source) => Deposition.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Deposition(id: $id, uid: $uid, name: $name, relationship: $relationship, deposition: $deposition, iconIndex: $iconIndex)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Deposition &&
        other.id == id &&
        other.uid == uid &&
        other.name == name &&
        other.relationship == relationship &&
        other.deposition == deposition &&
        other.iconIndex == iconIndex;
  }

  @override
  int get hashCode {
    return id.hashCode ^ uid.hashCode ^ name.hashCode ^ relationship.hashCode ^ deposition.hashCode ^ iconIndex.hashCode;
  }
}
