import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_smilling/models/clinica.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  static Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/login');
    final response = await http.post(
      url,
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      return true;
    }
    return false;
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }

  static Future<http.Response> getProtectedData() async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/protected');
    return await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
  }

  static Future<List<Clinica>> fetchClinicas() async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/clinicas');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((item) => Clinica.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao carregar clínicas');
    }
  }
}
