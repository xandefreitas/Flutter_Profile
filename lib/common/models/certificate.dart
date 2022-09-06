import 'dart:convert';

class Certificate {
  String? id;
  String course;
  String institution;
  String description;
  String? imageUrl;
  String credentialUrl;
  String date;

  Certificate({
    this.id,
    required this.course,
    required this.institution,
    required this.description,
    this.imageUrl = '',
    required this.credentialUrl,
    required this.date,
  });

  Certificate copyWith({
    String? id,
    String? course,
    String? institution,
    String? description,
    String? imageUrl,
    String? credentialUrl,
    String? date,
  }) {
    return Certificate(
      id: id ?? this.id,
      course: course ?? this.course,
      institution: institution ?? this.institution,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      credentialUrl: credentialUrl ?? this.credentialUrl,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'course': course,
      'institution': institution,
      'description': description,
      'imageUrl': imageUrl,
      'credentialUrl': credentialUrl,
      'date': date,
    };
  }

  factory Certificate.fromMap(Map<String, dynamic> map) {
    return Certificate(
      id: map['id'],
      course: map['course'] ?? '',
      institution: map['institution'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      credentialUrl: map['credentialUrl'] ?? '',
      date: map['date'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Certificate.fromJson(String source) => Certificate.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Certificate(id: $id, course: $course, institution: $institution, description: $description, imageUrl: $imageUrl, credentialUrl: $credentialUrl, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Certificate &&
        other.id == id &&
        other.course == course &&
        other.institution == institution &&
        other.description == description &&
        other.imageUrl == imageUrl &&
        other.credentialUrl == credentialUrl &&
        other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^ course.hashCode ^ institution.hashCode ^ description.hashCode ^ imageUrl.hashCode ^ credentialUrl.hashCode ^ date.hashCode;
  }
}
