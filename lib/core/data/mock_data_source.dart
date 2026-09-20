import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

class MockDataSource {
  const MockDataSource({this.simulateLatency = true});

  final bool simulateLatency;

  static final _random = Random();

  Future<List<Map<String, dynamic>>> loadList(String assetName) async {
    await _delay();
    final raw = await rootBundle.loadString('assets/mock/$assetName.json');
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> loadObject(String assetName) async {
    await _delay();
    final raw = await rootBundle.loadString('assets/mock/$assetName.json');
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> _delay() {
    if (!simulateLatency) return Future.value();
    return Future<void>.delayed(
      Duration(milliseconds: 300 + _random.nextInt(301)),
    );
  }

  // Mock dates are stored relative to today so the seed never goes stale.
  static DateTime resolveDate(int dayOffset, String timeOfDay) {
    final parts = timeOfDay.split(':');
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day + dayOffset,
      int.parse(parts.first),
      int.parse(parts.last),
    );
  }
}
