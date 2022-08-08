import 'dart:convert';

class Skill {
  String title;
  String? id;
  int likesQuantity;
  bool isRecommended;
  Skill({
    required this.title,
    this.id,
    this.likesQuantity = 0,
    this.isRecommended = false,
  });

  Skill copyWith({
    String? id,
    String? title,
    int? likesQuantity,
    bool? isRecommended,
  }) {
    return Skill(
      id: id ?? this.id,
      title: title ?? this.title,
      likesQuantity: likesQuantity ?? this.likesQuantity,
      isRecommended: isRecommended ?? this.isRecommended,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'likesQuantity': likesQuantity,
      'isRecommended': isRecommended,
    };
  }

  factory Skill.fromMap(Map<String, dynamic> map) {
    return Skill(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      likesQuantity: map['likesQuantity'] ?? '',
      isRecommended: map['isRecommended'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Skill.fromJson(String source) => Skill.fromMap(json.decode(source));

  @override
  String toString() => 'Skill(id: $id, title: $title, likesQuantity: $likesQuantity, isRecommended: $isRecommended)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Skill && other.id == id && other.title == title && other.likesQuantity == likesQuantity && other.isRecommended == isRecommended;
  }

  @override
  int get hashCode => title.hashCode ^ likesQuantity.hashCode ^ isRecommended.hashCode;
}
