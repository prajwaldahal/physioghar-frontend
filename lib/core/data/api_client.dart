import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ApiClient {
  const ApiClient(this.baseUrl, {this.client});

  final String baseUrl;
  final http.Client? client;

  static const _timeout = Duration(seconds: 10);

  Future<List<Map<String, dynamic>>> getList(
    String path, {
    Map<String, String>? query,
  }) async {
    final decoded = await _get(path, query);
    if (decoded is! List) {
      throw const ApiException('The server returned an unexpected response.');
    }
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getObject(String path) async {
    final decoded = await _get(path, null);
    if (decoded is! Map<String, dynamic>) {
      throw const ApiException('The server returned an unexpected response.');
    }
    return decoded;
  }

  Future<dynamic> _get(String path, Map<String, String>? query) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
    final sender = client ?? http.Client();
    try {
      final response = await sender.get(uri).timeout(_timeout);
      if (response.statusCode >= 400) {
        throw ApiException(
          'The server replied ${response.statusCode}. Please try again.',
        );
      }
      return jsonDecode(response.body);
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException('Could not reach the server.');
    } finally {
      if (client == null) sender.close();
    }
  }
}
