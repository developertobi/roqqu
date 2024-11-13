import 'package:flutter/widgets.dart';

import 'colors.dart';

class AppTextStyles {
  static const satoshi = 'Satoshi';

  static TextStyle dynamic(
    double size, {
    Color? color,
    FontWeight? weight,
    double? height,
    double? spacing,
    FontStyle? style,
    String? fontFamily,
  }) {
    return TextStyle(
      fontFamily: fontFamily ?? satoshi,
      fontSize: size,
      color: color ?? AppColors.textPrimary1,
      fontWeight: weight,
      height: height == null ? null : height / size,
      letterSpacing: spacing,
      fontStyle: style,
    );
  }

  static const regular12 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );
  static const regular14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );
  static const regular16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );
  static const regular18 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
  );
  static const regular20 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.normal,
  );
  static const regular24 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.normal,
  );
  static const regular28 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.normal,
  );
}
