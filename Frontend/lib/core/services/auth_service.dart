import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  // localhost tunneled via `adb reverse tcp:8000 tcp:8000` (works for both
  // emulator and real device connected via USB debugging)
  static const String _baseUrl = 'http://localhost:8000/api/auth';

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  // ── Token storage ────────────────────────────────────────────────────────
  static Future<void> _saveTokens(
      String access, String refresh) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessKey, access);
    await prefs.setString(_refreshKey, refresh);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessKey);
  }

  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessKey);
    await prefs.remove(_refreshKey);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // ── Auth headers ─────────────────────────────────────────────────────────
  static Future<Map<String, String>> _authHeaders() async {
    final token = await getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ── Signup ────────────────────────────────────────────────────────────────
  /// Returns null on success, or an error message string.
  static Future<String?> signup({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final res = await http
          .post(
            Uri.parse('$_baseUrl/signup/'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email.trim().toLowerCase(),
              'password': password,
              'full_name': fullName.trim(),
            }),
          )
          .timeout(const Duration(seconds: 15));

      final body = jsonDecode(res.body) as Map<String, dynamic>;
      if (res.statusCode == 201) {
        await _saveTokens(body['access'] as String, body['refresh'] as String);
        return null;
      }
      return _extractError(body);
    } catch (e) {
      return 'Cannot connect to server. Check your network.';
    }
  }

  // ── Login ─────────────────────────────────────────────────────────────────
  /// Returns null on success, or an error message string.
  static Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http
          .post(
            Uri.parse('$_baseUrl/login/'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email.trim().toLowerCase(),
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 15));

      final body = jsonDecode(res.body) as Map<String, dynamic>;
      if (res.statusCode == 200) {
        await _saveTokens(body['access'] as String, body['refresh'] as String);
        return null;
      }
      return _extractError(body);
    } catch (e) {
      return 'Cannot connect to server. Check your network.';
    }
  }

  // ── Get profile ───────────────────────────────────────────────────────────
  static Future<UserModel?> getProfile() async {
    try {
      final res = await http
          .get(
            Uri.parse('$_baseUrl/profile/'),
            headers: await _authHeaders(),
          )
          .timeout(const Duration(seconds: 15));

      if (res.statusCode == 200) {
        return UserModel.fromJson(
            jsonDecode(res.body) as Map<String, dynamic>);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // ── Update profile ────────────────────────────────────────────────────────
  /// Returns null on success, or an error message string.
  static Future<String?> updateProfile({required String fullName}) async {
    try {
      final res = await http
          .put(
            Uri.parse('$_baseUrl/profile/'),
            headers: await _authHeaders(),
            body: jsonEncode({'full_name': fullName.trim()}),
          )
          .timeout(const Duration(seconds: 15));

      if (res.statusCode == 200) return null;
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      return _extractError(body);
    } catch (e) {
      return 'Cannot connect to server. Check your network.';
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  static String _extractError(Map<String, dynamic> body) {
    if (body.containsKey('error')) return body['error'] as String;
    // DRF field errors come as { fieldName: ['msg'] }
    final sb = StringBuffer();
    body.forEach((key, value) {
      if (value is List) {
        sb.write('${value.first} ');
      } else {
        sb.write('$value ');
      }
    });
    return sb.toString().trim();
  }
}
