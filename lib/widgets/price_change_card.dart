import 'package:flutter/material.dart';
import '../core/app_textstyles.dart';
import '../core/colors.dart';
import '../core/spacing.dart';

class PriceChangeCard extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String value;
  final Color? valueColor;

  const PriceChangeCard({
    super.key,
    this.icon,
    required this.title,
    required this.value,
    this.valueColor = AppColors.textPrimary1,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.textPrimary2, size: 16),
              const Spacing.tinyWidth(),
              Text(
                title,
                style: AppTextStyles.regular12.copyWith(
                  color: AppColors.textPrimary2,
                ),
              ),
            ],
          ),
          const Spacing.tinyHeight(),
          Text(
            value,
            style: AppTextStyles.regular14.copyWith(
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
