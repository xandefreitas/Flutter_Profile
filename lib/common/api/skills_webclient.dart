import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/skill.dart';
import '../network/dio_base.dart';

class SkillsWebClient {
  SkillsWebClient({Dio? dio, FirebaseAuth? auth}) : _dio = dio ?? DioBase.getDio(), _auth = auth ?? FirebaseAuth.instance;

  final Dio _dio;
  final FirebaseAuth _auth;
  final List<Skill> _skills = [];
  String? _idToken = '';

  Future<List<Skill>> getSkills() async {
    _idToken = await _auth.currentUser!.getIdToken();
    _skills.clear();
    final response = await _dio.get<Map<String, dynamic>>('skills.json');
    final skillsRecommendedResponse = await _dio.get<Map>('userRecommended/${_auth.currentUser!.uid}.json?auth=$_idToken');
    response.data?.forEach((id, data) {
      final isRecommended = skillsRecommendedResponse.data?[id] ?? false;
      _skills.add(Skill(id: id, title: (data as Map)['title'], likesQuantity: data['likesQuantity'], isRecommended: isRecommended));
    });
    return _skills;
  }

  Future<String> addNewSkill(String title) async {
    final response = await _dio.post('skills.json?auth=$_idToken', data: Skill(title: title).toJson());
    return response.statusMessage ?? '';
  }

  Future<String> removeSkill(String skillId) async {
    final response = await _dio.delete('skills/$skillId.json?auth=$_idToken');
    return response.statusMessage ?? '';
  }

  Future<String> recommendSkill(String userId, Skill skill) async {
    skill.isRecommended = !skill.isRecommended;
    final response = await _dio.put('userRecommended/$userId/${skill.id}.json?auth=$_idToken', data: jsonEncode(skill.isRecommended));
    if (response.statusCode! >= 400) {
      skill.isRecommended = !skill.isRecommended;
    }
    skill.isRecommended ? skill.likesQuantity++ : skill.likesQuantity--;
    await updateSkill(skill);
    return response.statusMessage ?? '';
  }

  Future<String> updateSkill(Skill skill) async {
    final response = await _dio.put(
      'skills/${skill.id}.json?auth=$_idToken',
      data: Skill(title: skill.title, likesQuantity: skill.likesQuantity).toJson(),
    );
    return response.statusMessage ?? '';
  }
}
