import 'dart:convert';

class Skill {
  String title;
  String likesQuantity;
  bool isRecommended;
  Skill({
    required this.title,
    required this.likesQuantity,
    required this.isRecommended,
  });

  Skill copyWith({
    String? title,
    String? likesQuantity,
    bool? isRecommended,
  }) {
    return Skill(
      title: title ?? this.title,
      likesQuantity: likesQuantity ?? this.likesQuantity,
      isRecommended: isRecommended ?? this.isRecommended,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'likesQuantity': likesQuantity,
      'isRecommended': isRecommended,
    };
  }

  factory Skill.fromMap(Map<String, dynamic> map) {
    return Skill(
      title: map['title'] ?? '',
      likesQuantity: map['likesQuantity'] ?? '',
      isRecommended: map['isRecommended'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Skill.fromJson(String source) => Skill.fromMap(json.decode(source));

  @override
  String toString() => 'Skill(title: $title, likesQuantity: $likesQuantity, isRecommended: $isRecommended)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Skill && other.title == title && other.likesQuantity == likesQuantity && other.isRecommended == isRecommended;
  }

  @override
  int get hashCode => title.hashCode ^ likesQuantity.hashCode ^ isRecommended.hashCode;
}
