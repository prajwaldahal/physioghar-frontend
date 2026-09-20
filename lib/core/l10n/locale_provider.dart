import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

const supportedLocaleCodes = ['en', 'ne'];

class LocaleController extends Notifier<Locale> {
  @override
  Locale build() => const Locale('en');

  void select(String languageCode) {
    if (!supportedLocaleCodes.contains(languageCode)) return;
    state = Locale(languageCode);
  }
}

final localeProvider = NotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);
