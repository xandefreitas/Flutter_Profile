import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dio_base.dart';

/// Generic Firebase Realtime Database REST client for a single `/<resource>` node.
///
/// [fromMap] parses a single child node's value into [T] (a node's `id` lives
/// in its key, not its value, so [fromMap] doesn't need to know it).
/// [toWriteMap] serializes [T] into the body written on create/update, with
/// `id` stripped since it's addressed via the URL path rather than the body.
/// [withId] returns a copy of [T] with its `id` set to the given value.
class RestCrudWebClient<T> {
  RestCrudWebClient({
    required this.resourcePath,
    required this.fromMap,
    required this.toWriteMap,
    required this.withId,
    Dio? dio,
    FirebaseAuth? auth,
  }) : _dio = dio ?? DioBase.getDio(),
       _auth = auth ?? FirebaseAuth.instance;

  final String resourcePath;
  final T Function(Map<String, dynamic> data) fromMap;
  final Map<String, dynamic> Function(T item) toWriteMap;
  final T Function(T item, String? id) withId;

  final Dio _dio;
  final FirebaseAuth _auth;

  Future<List<T>> getAll() async {
    final response = await _dio.get<Map<String, dynamic>>('$resourcePath.json');
    final data = response.data ?? {};
    return [for (final entry in data.entries) withId(fromMap(entry.value as Map<String, dynamic>), entry.key)];
  }

  Future<T> add(T item) async {
    final idToken = await _auth.currentUser?.getIdToken();
    final response = await _dio.post<Map<String, dynamic>>('$resourcePath.json?auth=$idToken', data: jsonEncode(toWriteMap(item)));
    return withId(item, response.data?['name'] as String?);
  }

  Future<T> update(String id, T item) async {
    final idToken = await _auth.currentUser?.getIdToken();
    await _dio.put('$resourcePath/$id.json?auth=$idToken', data: jsonEncode(toWriteMap(item)));
    return item;
  }

  Future<String> remove(String id) async {
    final idToken = await _auth.currentUser?.getIdToken();
    await _dio.delete('$resourcePath/$id.json?auth=$idToken');
    return id;
  }
}
