import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionManager {
  SessionManager._();

  static final SessionManager instance = SessionManager._();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const _tokenKey = 'auth_token';
  static const _userKey = 'user';

  Future<void> saveSession({
    required String token,
    required Map<String, dynamic> user,
  }) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(
      key: _userKey,
      value: jsonEncode(user),
    );
  }

  Future<void> updateUser(Map<String, dynamic> user) async {
    await _storage.write(
      key: _userKey,
      value: jsonEncode(user),
    );
  }

  Future<String?> getToken() {
    return _storage.read(key: _tokenKey);
  }

  Future<Map<String, dynamic>?> getUser() async {
    final data = await _storage.read(key: _userKey);

    if (data == null) return null;

    return jsonDecode(data) as Map<String, dynamic>;
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }
}