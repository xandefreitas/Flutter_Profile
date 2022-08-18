import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_profile/common/models/skill.dart';
import 'package:flutter_profile/common/network/dio_base.dart';
import '../network/validate_response.dart';

class SkillsWebClient {
  final Dio _dio = DioBase.getDio();
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Skill> skills = [];
  String idToken = '';

  Future<List<Skill>> getSkills() async {
    idToken = await auth.currentUser!.getIdToken();
    skills.clear();
    final response = await _dio.get('skills.json');
    validateResponse(response);
    final skillsRecommendedResponse = await _dio.get('userRecommended/${auth.currentUser!.uid}.json?auth=$idToken');
    validateResponse(skillsRecommendedResponse);
    response.data.forEach(
      (id, data) {
        final isRecommended = skillsRecommendedResponse.data?[id] ?? false;
        skills.add(
          Skill(
            id: id,
            title: data['title'],
            likesQuantity: data['likesQuantity'],
            isRecommended: isRecommended,
          ),
        );
      },
    );
    return skills;
  }

  Future<String> addNewSkill(String title) async {
    final response = await _dio.post('skills.json?auth=$idToken', data: Skill(title: title).toJson());
    validateResponse(response);
    return response.statusMessage ?? '';
  }

  Future<String> removeSkill(String skillId) async {
    final response = await _dio.delete('skills/$skillId.json?auth=$idToken');
    validateResponse(response);
    return response.statusMessage ?? '';
  }

  Future<String> recommendSkill(String userId, Skill skill) async {
    skill.isRecommended = !skill.isRecommended;
    final response = await _dio.put(
      'userRecommended/$userId/${skill.id}.json?auth=$idToken',
      data: jsonEncode(skill.isRecommended),
    );
    if (response.statusCode! >= 400) {
      skill.isRecommended = !skill.isRecommended;
    }
    skill.isRecommended ? skill.likesQuantity++ : skill.likesQuantity--;
    validateResponse(response);
    updateSkill(skill);
    return response.statusMessage ?? '';
  }

  Future<String> updateSkill(Skill skill) async {
    final response = await _dio.put(
      'skills/${skill.id}.json?auth=$idToken',
      data: Skill(title: skill.title, likesQuantity: skill.likesQuantity).toJson(),
    );
    validateResponse(response);
    return response.statusMessage ?? '';
  }
}
