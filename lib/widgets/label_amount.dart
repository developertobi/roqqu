import 'package:flutter/material.dart';
import '../core/app_textstyles.dart';
import '../core/colors.dart';
import '../core/spacing.dart';

class LabelAmount extends StatelessWidget {
  final String label;
  final String value;

  const LabelAmount({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.regular12.copyWith(color: AppColors.textPrimary2),
        ),
        Text(
          value,
          style: AppTextStyles.regular14.copyWith(
            color: AppColors.textPrimary1,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
