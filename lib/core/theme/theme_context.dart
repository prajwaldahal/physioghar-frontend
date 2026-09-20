import 'package:flutter/material.dart';

import 'app_palette.dart';
import 'app_text_styles.dart';

extension AppThemeX on BuildContext {
  AppPalette get colors =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;

  AppTextStyles get text => AppTextStyles(colors);
}
