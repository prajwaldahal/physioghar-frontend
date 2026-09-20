import 'package:flutter/material.dart';

@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.pine,
    required this.pineLight,
    required this.pinePale,
    required this.mist,
    required this.amber,
    required this.amberPale,
    required this.cream,
    required this.surface,
    required this.border,
    required this.ink,
    required this.inkMid,
    required this.inkMute,
    required this.danger,
    required this.dangerPale,
  });

  final Color pine;
  final Color pineLight;
  final Color pinePale;
  final Color mist;
  final Color amber;
  final Color amberPale;
  final Color cream;
  final Color surface;
  final Color border;
  final Color ink;
  final Color inkMid;
  final Color inkMute;
  final Color danger;
  final Color dangerPale;

  static const light = AppPalette(
    pine: Color(0xFF2F5D50),
    pineLight: Color(0xFF3F7965),
    pinePale: Color(0xFFD1E8DF),
    mist: Color(0xFFEEF1ED),
    amber: Color(0xFFE2962F),
    amberPale: Color(0xFFFBEFD9),
    cream: Color(0xFFFBFBF8),
    surface: Color(0xFFFFFFFF),
    border: Color(0xFFE6EAE4),
    ink: Color(0xFF1E2A2E),
    inkMid: Color(0xFF4A5854),
    inkMute: Color(0xFF8FA8A0),
    danger: Color(0xFFC84B4B),
    dangerPale: Color(0xFFFCE8E8),
  );

  LinearGradient get heroGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [pine, pineLight],
  );

  @override
  AppPalette copyWith({
    Color? pine,
    Color? pineLight,
    Color? pinePale,
    Color? mist,
    Color? amber,
    Color? amberPale,
    Color? cream,
    Color? surface,
    Color? border,
    Color? ink,
    Color? inkMid,
    Color? inkMute,
    Color? danger,
    Color? dangerPale,
  }) {
    return AppPalette(
      pine: pine ?? this.pine,
      pineLight: pineLight ?? this.pineLight,
      pinePale: pinePale ?? this.pinePale,
      mist: mist ?? this.mist,
      amber: amber ?? this.amber,
      amberPale: amberPale ?? this.amberPale,
      cream: cream ?? this.cream,
      surface: surface ?? this.surface,
      border: border ?? this.border,
      ink: ink ?? this.ink,
      inkMid: inkMid ?? this.inkMid,
      inkMute: inkMute ?? this.inkMute,
      danger: danger ?? this.danger,
      dangerPale: dangerPale ?? this.dangerPale,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      pine: Color.lerp(pine, other.pine, t)!,
      pineLight: Color.lerp(pineLight, other.pineLight, t)!,
      pinePale: Color.lerp(pinePale, other.pinePale, t)!,
      mist: Color.lerp(mist, other.mist, t)!,
      amber: Color.lerp(amber, other.amber, t)!,
      amberPale: Color.lerp(amberPale, other.amberPale, t)!,
      cream: Color.lerp(cream, other.cream, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      border: Color.lerp(border, other.border, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      inkMid: Color.lerp(inkMid, other.inkMid, t)!,
      inkMute: Color.lerp(inkMute, other.inkMute, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerPale: Color.lerp(dangerPale, other.dangerPale, t)!,
    );
  }
}
