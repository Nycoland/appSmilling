import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_smilling/services/api/config/api_config.dart';
import 'package:app_smilling/models/doenca.dart';
import 'package:app_smilling/services/api/auth_service.dart';

class DoencaService {
  static Future<Map<String, String>> _getHeaders() async {
    return await AuthService.getAuthHeaders();
  }

  static Future<List<Doenca>> getDoencas() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/doencas'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        
        
        final List<dynamic> doencasJson = decoded is List ? decoded : decoded['data'] ?? [];
        
        return doencasJson.map((json) => Doenca.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Sessão expirada. Por favor, faça login novamente.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Erro ao carregar doenças');
      }
    } catch (e) {
      throw Exception('Erro ao carregar doenças: ${e.toString()}');
    }
  }

  static Future<Doenca> getDoenca(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/doencas/$id'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return Doenca.fromJson(decoded is Map ? decoded : decoded['data']);
      } else if (response.statusCode == 404) {
        throw Exception('Doença não encontrada');
      } else if (response.statusCode == 401) {
        throw Exception('Sessão expirada. Por favor, faça login novamente.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Erro ao carregar doença');
      }
    } catch (e) {
      throw Exception('Erro ao carregar doença: ${e.toString()}');
    }
  }

  static Future<Doenca> createDoenca(Map<String, dynamic> doencaData) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/doencas'),
        headers: await _getHeaders(),
        body: json.encode(doencaData),
      );

      if (response.statusCode == 201) {
        final decoded = json.decode(response.body);
        return Doenca.fromJson(decoded is Map ? decoded : decoded['data']);
      } else if (response.statusCode == 422) {
        final errors = json.decode(response.body)['errors'];
        throw Exception(_parseValidationErrors(errors));
      } else if (response.statusCode == 401) {
        throw Exception('Sessão expirada. Por favor, faça login novamente.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Erro ao criar doença');
      }
    } catch (e) {
      throw Exception('Erro ao criar doença: ${e.toString()}');
    }
  }

  static Future<Doenca> updateDoenca(int id, Map<String, dynamic> doencaData) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/doencas/$id'),
        headers: await _getHeaders(),
        body: json.encode(doencaData),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return Doenca.fromJson(decoded is Map ? decoded : decoded['data']);
      } else if (response.statusCode == 404) {
        throw Exception('Doença não encontrada');
      } else if (response.statusCode == 422) {
        final errors = json.decode(response.body)['errors'];
        throw Exception(_parseValidationErrors(errors));
      } else if (response.statusCode == 401) {
        throw Exception('Sessão expirada. Por favor, faça login novamente.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Erro ao atualizar doença');
      }
    } catch (e) {
      throw Exception('Erro ao atualizar doença: ${e.toString()}');
    }
  }

  static Future<bool> deleteDoenca(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/doencas/$id'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 404) {
        throw Exception('Doença não encontrada');
      } else if (response.statusCode == 401) {
        throw Exception('Sessão expirada. Por favor, faça login novamente.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Erro ao deletar doença');
      }
    } catch (e) {
      throw Exception('Erro ao deletar doença: ${e.toString()}');
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