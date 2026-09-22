import 'package:dio/dio.dart';

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient(String baseUrl, {Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: _timeout,
              receiveTimeout: _timeout,
              sendTimeout: _timeout,
              contentType: Headers.jsonContentType,
              // Let non-2xx responses through so the reason can be read out.
              validateStatus: (_) => true,
            ),
          );

  final Dio _dio;

  static const _timeout = Duration(seconds: 10);

  Future<List<Map<String, dynamic>>> getList(
    String path, {
    Map<String, String>? query,
  }) async {
    final data = await _send('GET', path, query: query);
    if (data is! List) {
      throw const ApiException('The server returned an unexpected response.');
    }
    return data.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getObject(String path) async =>
      _expectObject(await _send('GET', path));

  Future<Map<String, dynamic>> postObject(String path, {Object? body}) async =>
      _expectObject(await _send('POST', path, body: body));

  Future<Map<String, dynamic>> putObject(String path, {Object? body}) async =>
      _expectObject(await _send('PUT', path, body: body));

  Future<void> post(String path) => _send('POST', path);

  Future<dynamic> _send(
    String method,
    String path, {
    Object? body,
    Map<String, String>? query,
  }) async {
    try {
      final response = await _dio.request<dynamic>(
        path,
        data: body,
        queryParameters: query,
        options: Options(method: method),
      );
      final status = response.statusCode ?? 0;
      if (status >= 400) throw ApiException(_reasonFrom(response, status));
      return response.data;
    } on ApiException {
      rethrow;
    } on DioException catch (e) {
      throw ApiException(
        e.type == DioExceptionType.connectionError
            ? 'Could not reach the server.'
            : 'The request failed. Please try again.',
      );
    }
  }

  Map<String, dynamic> _expectObject(dynamic data) {
    if (data is! Map<String, dynamic>) {
      if (data == null || (data is String && data.isEmpty)) return const {};
      throw const ApiException('The server returned an unexpected response.');
    }
    return data;
  }

  // The API puts a readable reason in "detail" when it refuses an action.
  String _reasonFrom(Response<dynamic> response, int status) {
    final data = response.data;
    if (data is Map && data['detail'] is String) {
      return data['detail'] as String;
    }
    return 'The server replied $status. Please try again.';
  }
}
