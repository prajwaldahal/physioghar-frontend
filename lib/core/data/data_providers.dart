import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';
import 'mock_data_source.dart';

// Supplied with --dart-define=API_BASE_URL=... ; empty means run on mock data.
const apiBaseUrl = String.fromEnvironment('API_BASE_URL');

final mockDataSourceProvider = Provider<MockDataSource>(
  (ref) => const MockDataSource(),
);

final apiClientProvider = Provider<ApiClient?>(
  (ref) => apiBaseUrl.isEmpty ? null : ApiClient(apiBaseUrl),
);
