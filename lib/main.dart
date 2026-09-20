import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app.dart';

void main() {
  // Every weight used by AppTextStyles ships in assets/google_fonts.
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const ProviderScope(child: PhysioGharApp()));
}
