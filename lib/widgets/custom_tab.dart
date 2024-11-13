import 'package:flutter/material.dart';
import 'package:roqqu/core/colors.dart';
import '../core/app_textstyles.dart';

class CustomTabBar extends StatefulWidget {
  final List<String> tabs;
  final ValueChanged<int>? onTabSelected;
  final int selectedIndex;
  final bool expandTabs;
  final bool haveMargin;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.onTabSelected,
    this.selectedIndex = 0,
    this.expandTabs = false,
    this.haveMargin = true,
  });

  @override
  CustomTabBarState createState() => CustomTabBarState();
}

class CustomTabBarState extends State<CustomTabBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      margin: widget.haveMargin ? const EdgeInsets.symmetric(vertical: 8, horizontal: 16) : null,
      decoration: const BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          widget.tabs.length,
          (index) {
            final bool isSelected = _selectedIndex == index;

            final tabItem = GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                if (widget.onTabSelected != null) {
                  widget.onTabSelected!(index);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryColor : AppColors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.textPrimary2.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    widget.tabs[index],
                    style: AppTextStyles.regular14.copyWith(
                      color: isSelected ? AppColors.textPrimary1 : AppColors.textPrimary2,
                    ),
                  ),
                ),
              ),
            );

            return widget.expandTabs ? Expanded(child: tabItem) : tabItem;
          },
        ),
      ),
    );
  }
}
