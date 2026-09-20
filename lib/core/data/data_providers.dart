import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'mock_data_source.dart';

final mockDataSourceProvider = Provider<MockDataSource>(
  (ref) => const MockDataSource(),
);
