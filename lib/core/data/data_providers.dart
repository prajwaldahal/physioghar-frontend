import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';
import 'mock_data_source.dart';

// Supplied with --dart-define=API_BASE_URL=... ; empty means run on mock data.
const apiBaseUrl = String.fromEnvironment('API_BASE_URL');

// Request paths already carry /api/v1, so a base url handed over with the
// prefix on the end would ask the server for it twice.
String apiHost(String value) {
  var host = value.trim();
  while (host.endsWith('/')) {
    host = host.substring(0, host.length - 1);
  }
  const prefix = '/api/v1';
  if (host.endsWith(prefix)) {
    host = host.substring(0, host.length - prefix.length);
  }
  return host;
}

final mockDataSourceProvider = Provider<MockDataSource>(
  (ref) => const MockDataSource(),
);

final apiClientProvider = Provider<ApiClient?>((ref) {
  final host = apiHost(apiBaseUrl);
  return host.isEmpty ? null : ApiClient(host);
});
