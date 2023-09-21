import 'dart:convert';

import 'package:flutter/foundation.dart';

class PersonalData {
  String email;
  String phoneNumberBR;
  String phoneNumberSE;
  String linkedinUrl;
  String gitHubUrl;
  List<String> aboutMeTexts;

  PersonalData({
    this.email = '',
    this.phoneNumberBR = '',
    this.phoneNumberSE = '',
    this.linkedinUrl = '',
    this.gitHubUrl = '',
    this.aboutMeTexts = const ['', '', ''],
  });

  PersonalData copyWith({
    String? email,
    String? phoneNumberBR,
    String? phoneNumberSE,
    String? whatsAppNumber,
    String? linkedinUrl,
    String? gitHubUrl,
    List<String>? aboutMeTexts,
  }) {
    return PersonalData(
      email: email ?? this.email,
      phoneNumberBR: phoneNumberBR ?? this.phoneNumberBR,
      phoneNumberSE: phoneNumberSE ?? this.phoneNumberSE,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      gitHubUrl: gitHubUrl ?? this.gitHubUrl,
      aboutMeTexts: aboutMeTexts ?? this.aboutMeTexts,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'phoneNumberBR': phoneNumberBR,
      'phoneNumberSE': phoneNumberSE,
      'linkedinUrl': linkedinUrl,
      'gitHubUrl': gitHubUrl,
      'aboutMeTexts': aboutMeTexts.map((x) => x).toList(),
    };
  }

  factory PersonalData.fromMap(Map<String, dynamic> map) {
    return PersonalData(
      email: map['email'] ?? '',
      phoneNumberBR: map['phoneNumberBR'] ?? '',
      phoneNumberSE: map['phoneNumberSE'] ?? '',
      linkedinUrl: map['linkedinUrl'] ?? '',
      gitHubUrl: map['gitHubUrl'] ?? '',
      aboutMeTexts: List<String>.from(map['aboutMeTexts']?.map((x) => x)),
    );
  }

  String toJson() => json.encode(toMap());

  factory PersonalData.fromJson(String source) => PersonalData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PersonalData(email: $email, phoneNumberBR: $phoneNumberBR, phoneNumberSE: $phoneNumberSE, linkedinUrl: $linkedinUrl, gitHubUrl: $gitHubUrl, aboutMeTexts:$aboutMeTexts)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PersonalData &&
        other.email == email &&
        other.phoneNumberBR == phoneNumberBR &&
        other.phoneNumberSE == phoneNumberSE &&
        other.linkedinUrl == linkedinUrl &&
        other.gitHubUrl == gitHubUrl &&
        listEquals(other.aboutMeTexts, aboutMeTexts);
  }

  @override
  int get hashCode {
    return email.hashCode ^ phoneNumberBR.hashCode ^ phoneNumberSE.hashCode ^ linkedinUrl.hashCode ^ gitHubUrl.hashCode ^ aboutMeTexts.hashCode;
  }
}
