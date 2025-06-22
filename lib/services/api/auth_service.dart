import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_smilling/services/api/config/api_config.dart';

class AuthService {
  static const String _tokenKey = 'authToken';
  static const String _userKey = 'user';

  static Future<dynamic> register({
    required String name,
    required String lastName,
    required int age,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/register');
    try {
      final response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {
          'name': name,
          'last_name': lastName,
          'age': age.toString(),
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        final responseData = json.decode(response.body);
        if (response.statusCode == 422) {
          if (responseData['errors']?['email'] != null) {
            return responseData['errors']['email'][0];
          }
        }
        return 'Erro ao cadastrar. Tente novamente.';
      }
    } catch (e) {
      return e.toString();
    }
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/login');
    try {
      final response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password},
      );

      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200) {
        await _saveAuthData(responseData['token'], responseData['user']);
        return {'success': true, 'user': responseData['user']};
      } else {
        String errorMessage = 'Credenciais inválidas';
        if (responseData['message'] != null) {
          errorMessage = responseData['message'];
        } else if (responseData['error'] != null) {
          errorMessage = responseData['error'];
        }
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: ${e.toString()}'};
    }
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    if (token == null) return false;
    
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/check-token'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<void> logout() async {
    final token = await getToken();
    if (token != null) {
      final url = Uri.parse('${ApiConfig.baseUrl}/logout');
      await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
    }
    await _clearAuthData();
  }

  static Future<void> _saveAuthData(String token, dynamic user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, json.encode(user));
  }

  static Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);
    return userString != null ? json.decode(userString) : null;
  }

  static Future<int?> getUserId() async {
    final user = await getUser();
    return user?['id'] as int?;
  }

  static Future<bool> isAuthenticated() async {
    try {
      final token = await getToken();
      if (token == null) return false;

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/check-token'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<http.Response> getProtectedData() async {
    final headers = await getAuthHeaders();
    return await http.get(
      Uri.parse('${ApiConfig.baseUrl}/email'),
      headers: headers,
    );
  }
}