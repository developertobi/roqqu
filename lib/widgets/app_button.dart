import 'package:flutter/material.dart';

import '../core/colors.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? labelColor, buttonColor, borderColor, disabledColor;
  final double? width, height, borderRadius, labelSize;
  final bool isCollapsed;
  final bool hasBorder, showFeedback;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  final Widget? icon;

  const AppButton({
    required this.label,
    this.onTap,
    this.width,
    this.height,
    this.buttonColor = AppColors.primaryColor,
    this.labelColor = AppColors.white,
    this.disabledColor,
    this.borderColor,
    this.isCollapsed = false,
    this.hasBorder = false,
    this.showFeedback = true,
    this.fontWeight,
    this.borderRadius,
    this.padding,
    this.labelSize = 16,
    this.icon,
    super.key,
  });

  const AppButton.outlined({
    required this.label,
    this.onTap,
    this.width,
    this.height,
    this.buttonColor = AppColors.white,
    this.labelColor = AppColors.black,
    this.disabledColor,
    this.borderColor = AppColors.green10,
    this.isCollapsed = false,
    this.hasBorder = true,
    this.showFeedback = true,
    this.fontWeight = FontWeight.w700,
    this.borderRadius,
    this.padding,
    this.labelSize = 16,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? (isCollapsed ? null : double.maxFinite),
      height: height ?? 32,
      child: MaterialButton(
        onPressed: onTap,
        disabledColor: disabledColor ?? buttonColor,
        color: buttonColor,
        clipBehavior: Clip.hardEdge,
        elevation: 0,
        splashColor: showFeedback ? null : buttonColor,
        highlightColor: showFeedback ? null : buttonColor,
        highlightElevation: showFeedback ? 4 : 0,
        padding: padding ?? const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          side: hasBorder
              ? BorderSide(
                  color: borderColor ?? AppColors.green10,
                  width: 1,
                )
              : BorderSide.none,
        ),
        child: Builder(
          builder: (context) {
            return FittedBox(
              child: Center(
                child: Row(
                  children: [
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: labelSize,
                        fontWeight: fontWeight,
                        color: labelColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
