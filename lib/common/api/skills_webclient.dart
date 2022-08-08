import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_profile/common/models/skill.dart';

import '../../core/consts.dart';

class SkillsWebClient {
  final Dio _dio = Dio()
    ..options.baseUrl = Consts.databaseUrl
    ..options.connectTimeout = 20000;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Skill> skills = [];

  Future<List<Skill>> getSkills() async {
    skills.clear();
    final response = await _dio.get('skills.json');
    if (response.data == null) return [];
    final skillsRecommendedResponse = await _dio.get('userRecommended/${auth.currentUser!.uid}.json');
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

  Future<void> addNewSkill(String title) async {
    final response = await _dio.post('skills.json', data: Skill(title: title).toJson());
  }

  removeSkill(String skillId) async {
    final response = await _dio.delete('skills/$skillId.json');
  }

  Future<void> recommendSkill(String userId, Skill skill) async {
    skill.isRecommended = !skill.isRecommended;
    final response = await _dio
        .put(
      'userRecommended/$userId/${skill.id}.json',
      data: jsonEncode(skill.isRecommended),
    )
        .then((value) async {
      if (value.statusCode! >= 400) {
        skill.isRecommended = !skill.isRecommended;
      }
      skill.isRecommended ? skill.likesQuantity++ : skill.likesQuantity--;
      updateSkill(skill);
    });
  }

  updateSkill(Skill skill) async {
    await _dio.put(
      'skills/${skill.id}.json',
      data: Skill(title: skill.title, likesQuantity: skill.likesQuantity).toJson(),
    );
  }
}
