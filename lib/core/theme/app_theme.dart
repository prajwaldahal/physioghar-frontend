import 'package:flutter/material.dart';

import 'app_palette.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    const palette = AppPalette.light;
    const styles = AppTextStyles(palette);

    final scheme = ColorScheme.fromSeed(
      seedColor: palette.pine,
      brightness: Brightness.light,
    ).copyWith(
      primary: palette.pine,
      onPrimary: Colors.white,
      secondary: palette.amber,
      onSecondary: palette.ink,
      surface: palette.surface,
      onSurface: palette.ink,
      error: palette.danger,
      onError: Colors.white,
      outlineVariant: palette.border,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: palette.cream,
      extensions: const [palette],
      textTheme: TextTheme(
        headlineLarge: styles.display,
        headlineMedium: styles.headline,
        titleLarge: styles.title,
        titleMedium: styles.sectionTitle,
        bodyLarge: styles.body,
        bodyMedium: styles.body,
        bodySmall: styles.meta,
        labelLarge: styles.button,
        labelMedium: styles.label,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.cream,
        surfaceTintColor: Colors.transparent,
        foregroundColor: palette.ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: styles.title,
      ),
      dividerTheme: DividerThemeData(
        color: palette.border,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXl),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        titleTextStyle: styles.title,
        contentTextStyle: styles.bodyMuted,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: palette.pinePale,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? styles.meta.copyWith(
                  color: palette.pine,
                  fontWeight: FontWeight.w600,
                )
              : styles.meta,
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 22,
            color: states.contains(WidgetState.selected)
                ? palette.pine
                : palette.inkMute,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        hintStyle: styles.bodyMuted.copyWith(color: palette.inkMute),
        labelStyle: styles.label,
        errorStyle: styles.meta.copyWith(color: palette.danger),
        border: _inputBorder(palette.border),
        enabledBorder: _inputBorder(palette.border),
        focusedBorder: _inputBorder(palette.pine, width: 1.6),
        errorBorder: _inputBorder(palette.danger),
        focusedErrorBorder: _inputBorder(palette.danger, width: 1.6),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
