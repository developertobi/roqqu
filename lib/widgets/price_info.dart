import 'package:flutter/material.dart';
import 'package:roqqu/core/app_textstyles.dart';
import 'package:roqqu/core/colors.dart';

class PriceInfo extends StatelessWidget {
  final String label;
  final String amount;
  final VoidCallback? onInfoPressed;

  const PriceInfo({
    super.key,
    required this.label,
    required this.amount,
    this.onInfoPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.textPrimary2.withOpacity(.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                label,
                style: AppTextStyles.regular14.copyWith(
                  color: AppColors.textPrimary2,
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onInfoPressed,
                child: Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
