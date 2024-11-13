import 'package:flutter/material.dart';
import '../core/colors.dart';

class AppVerticalDivider extends StatelessWidget {
  final double height;
  final Color? color;

  const AppVerticalDivider({
    super.key,
    this.height = 48,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: VerticalDivider(
        color: color ?? AppColors.textPrimary2.withOpacity(.1),
      ),
    );
  }
}
