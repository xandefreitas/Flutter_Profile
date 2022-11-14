import 'dart:convert';

class Certificate {
  String? id;
  String? imageUrl;
  String course;
  String institution;
  String description;
  String descriptionEn;
  String credentialUrl;
  String date;
  String duration;

  Certificate({
    this.id,
    this.imageUrl = '',
    required this.course,
    required this.institution,
    required this.description,
    required this.descriptionEn,
    required this.credentialUrl,
    required this.date,
    required this.duration,
  });

  Certificate copyWith({
    String? id,
    String? imageUrl,
    String? course,
    String? institution,
    String? description,
    String? descriptionEn,
    String? credentialUrl,
    String? date,
    String? duration,
  }) {
    return Certificate(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      course: course ?? this.course,
      institution: institution ?? this.institution,
      description: description ?? this.description,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      credentialUrl: credentialUrl ?? this.credentialUrl,
      date: date ?? this.date,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'course': course,
      'institution': institution,
      'description': description,
      'descriptionEn': descriptionEn,
      'credentialUrl': credentialUrl,
      'date': date,
      'duration': duration,
    };
  }

  factory Certificate.fromMap(Map<String, dynamic> map) {
    return Certificate(
      id: map['id'],
      imageUrl: map['imageUrl'],
      course: map['course'] ?? '',
      institution: map['institution'] ?? '',
      description: map['description'] ?? '',
      descriptionEn: map['descriptionEn'] ?? '',
      credentialUrl: map['credentialUrl'] ?? '',
      date: map['date'] ?? '',
      duration: map['duration'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Certificate.fromJson(String source) => Certificate.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Certificate(id: $id, imageUrl: $imageUrl, course: $course, institution: $institution, description: $description, descriptionEn: $descriptionEn, credentialUrl: $credentialUrl, date: $date, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Certificate &&
        other.id == id &&
        other.imageUrl == imageUrl &&
        other.course == course &&
        other.institution == institution &&
        other.description == description &&
        other.descriptionEn == descriptionEn &&
        other.credentialUrl == credentialUrl &&
        other.date == date &&
        other.duration == duration;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        imageUrl.hashCode ^
        course.hashCode ^
        institution.hashCode ^
        description.hashCode ^
        descriptionEn.hashCode ^
        credentialUrl.hashCode ^
        date.hashCode ^
        duration.hashCode;
  }
}
