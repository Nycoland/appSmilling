import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_smilling/services/api/config/api_config.dart';
import 'package:app_smilling/models/clinica.dart';
import 'package:app_smilling/services/api/auth_service.dart';

class ClinicaService {
  static Future<Map<String, String>> _getHeaders() async {
    return await AuthService.getAuthHeaders();
  }

  static Future<List<Clinica>> getClinicas() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/clinicas'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        
        
        final List<dynamic> clinicasJson = decoded is List ? decoded : decoded['data'] ?? [];
        
        return clinicasJson.map((json) => Clinica.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Sessão expirada. Por favor, faça login novamente.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Erro ao carregar clínicas');
      }
    } catch (e) {
      throw Exception('Erro ao carregar clínicas: ${e.toString()}');
    }
  }

  static Future<Clinica> getClinica(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/clinicas/$id'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return Clinica.fromJson(decoded is Map ? decoded : decoded['data']);
      } else if (response.statusCode == 404) {
        throw Exception('Clínica não encontrada');
      } else if (response.statusCode == 401) {
        throw Exception('Sessão expirada. Por favor, faça login novamente.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Erro ao carregar clínica');
      }
    } catch (e) {
      throw Exception('Erro ao carregar clínica: ${e.toString()}');
    }
  }

  static Future<Clinica> createClinica(Map<String, dynamic> clinicaData) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/clinicas'),
        headers: await _getHeaders(),
        body: json.encode(clinicaData),
      );

      if (response.statusCode == 201) {
        final decoded = json.decode(response.body);
        return Clinica.fromJson(decoded is Map ? decoded : decoded['data']);
      } else if (response.statusCode == 422) {
        final errors = json.decode(response.body)['errors'];
        throw Exception(_parseValidationErrors(errors));
      } else if (response.statusCode == 401) {
        throw Exception('Sessão expirada. Por favor, faça login novamente.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Erro ao criar clínica');
      }
    } catch (e) {
      throw Exception('Erro ao criar clínica: ${e.toString()}');
    }
  }

  static Future<Clinica> updateClinica(int id, Map<String, dynamic> clinicaData) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/clinicas/$id'),
        headers: await _getHeaders(),
        body: json.encode(clinicaData),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return Clinica.fromJson(decoded is Map ? decoded : decoded['data']);
      } else if (response.statusCode == 404) {
        throw Exception('Clínica não encontrada');
      } else if (response.statusCode == 422) {
        final errors = json.decode(response.body)['errors'];
        throw Exception(_parseValidationErrors(errors));
      } else if (response.statusCode == 401) {
        throw Exception('Sessão expirada. Por favor, faça login novamente.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Erro ao atualizar clínica');
      }
    } catch (e) {
      throw Exception('Erro ao atualizar clínica: ${e.toString()}');
    }
  }

  static Future<bool> deleteClinica(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/clinicas/$id'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 404) {
        throw Exception('Clínica não encontrada');
      } else if (response.statusCode == 401) {
        throw Exception('Sessão expirada. Por favor, faça login novamente.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Erro ao deletar clínica');
      }
    } catch (e) {
      throw Exception('Erro ao deletar clínica: ${e.toString()}');
    }
  }

  static String _parseValidationErrors(Map<String, dynamic> errors) {
    if (errors == null) return 'Erro de validação';
    
    final errorList = errors.entries.map((entry) {
      return '${entry.key}: ${entry.value.join(', ')}';
    }).toList();

    return errorList.join('\n');
  }
}