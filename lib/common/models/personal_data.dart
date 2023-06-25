import 'dart:convert';

class PersonalData {
  String email;
  String phoneNumberBR;
  String phoneNumberSE;
  String linkedinUrl;
  String gitHubUrl;

  PersonalData({
    this.email = '',
    this.phoneNumberBR = '',
    this.phoneNumberSE = '',
    this.linkedinUrl = '',
    this.gitHubUrl = '',
  });

  PersonalData copyWith({
    String? email,
    String? phoneNumberBR,
    String? phoneNumberSE,
    String? whatsAppNumber,
    String? linkedinUrl,
    String? gitHubUrl,
  }) {
    return PersonalData(
      email: email ?? this.email,
      phoneNumberBR: phoneNumberBR ?? this.phoneNumberBR,
      phoneNumberSE: phoneNumberSE ?? this.phoneNumberSE,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      gitHubUrl: gitHubUrl ?? this.gitHubUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'phoneNumberBR': phoneNumberBR,
      'phoneNumberSE': phoneNumberSE,
      'linkedinUrl': linkedinUrl,
      'gitHubUrl': gitHubUrl,
    };
  }

  factory PersonalData.fromMap(Map<String, dynamic> map) {
    return PersonalData(
      email: map['email'] ?? '',
      phoneNumberBR: map['phoneNumberBR'] ?? '',
      phoneNumberSE: map['phoneNumberSE'] ?? '',
      linkedinUrl: map['linkedinUrl'] ?? '',
      gitHubUrl: map['gitHubUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PersonalData.fromJson(String source) => PersonalData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PersonalData(email: $email, phoneNumberBR: $phoneNumberBR, phoneNumberSE: $phoneNumberSE, linkedinUrl: $linkedinUrl, gitHubUrl: $gitHubUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PersonalData &&
        other.email == email &&
        other.phoneNumberBR == phoneNumberBR &&
        other.phoneNumberSE == phoneNumberSE &&
        other.linkedinUrl == linkedinUrl &&
        other.gitHubUrl == gitHubUrl;
  }

  @override
  int get hashCode {
    return email.hashCode ^ phoneNumberBR.hashCode ^ phoneNumberSE.hashCode ^ linkedinUrl.hashCode ^ gitHubUrl.hashCode;
  }
}
