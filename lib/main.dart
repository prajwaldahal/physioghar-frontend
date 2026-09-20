import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/theme/app_theme.dart';

void main() {
  // Every weight used by AppTextStyles ships in assets/google_fonts.
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const ProviderScope(child: PhysioGharApp()));
}

class PhysioGharApp extends StatelessWidget {
  const PhysioGharApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhysioGhar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const Scaffold(),
    );
  }
}
