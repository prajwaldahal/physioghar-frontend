import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_palette.dart';

@immutable
class AppTextStyles {
  const AppTextStyles(this.palette);

  final AppPalette palette;

  // Fraunces and Inter carry no Devanagari glyphs, so Nepali needs a fallback family.
  static List<String> get _devanagari => [
    GoogleFonts.notoSansDevanagari().fontFamily!,
  ];

  static TextStyle _serif({
    required double size,
    required FontWeight weight,
    required Color color,
    double height = 1.2,
  }) => GoogleFonts.fraunces(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
  ).copyWith(fontFamilyFallback: _devanagari);

  static TextStyle _sans({
    required double size,
    required FontWeight weight,
    required Color color,
    double? height,
  }) => GoogleFonts.inter(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
  ).copyWith(fontFamilyFallback: _devanagari);

  TextStyle get display =>
      _serif(size: 32, weight: FontWeight.w600, color: palette.ink, height: 1.15);

  TextStyle get headline =>
      _serif(size: 24, weight: FontWeight.w600, color: palette.ink);

  TextStyle get title =>
      _serif(size: 18, weight: FontWeight.w600, color: palette.ink, height: 1.25);

  TextStyle get statNumber =>
      _serif(size: 28, weight: FontWeight.w700, color: palette.ink, height: 1.1);

  TextStyle get sectionTitle =>
      _sans(size: 15, weight: FontWeight.w600, color: palette.ink);

  TextStyle get body =>
      _sans(size: 14, weight: FontWeight.w400, color: palette.ink, height: 1.45);

  TextStyle get bodyStrong =>
      _sans(size: 14, weight: FontWeight.w600, color: palette.ink);

  TextStyle get bodyMuted => _sans(
    size: 14,
    weight: FontWeight.w400,
    color: palette.inkMid,
    height: 1.45,
  );

  TextStyle get button =>
      _sans(size: 15, weight: FontWeight.w600, color: palette.ink);

  TextStyle get label =>
      _sans(size: 12, weight: FontWeight.w500, color: palette.inkMid);

  TextStyle get chip =>
      _sans(size: 12, weight: FontWeight.w600, color: palette.ink);

  TextStyle get meta =>
      _sans(size: 11, weight: FontWeight.w400, color: palette.inkMute);

  TextStyle get eyebrow => GoogleFonts.ibmPlexMono(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: palette.inkMute,
    letterSpacing: 1.1,
  );
}
