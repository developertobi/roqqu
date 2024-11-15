import 'package:flutter/material.dart';
import 'package:roqqu/widgets/price_info.dart';

import '../core/app_textstyles.dart';
import '../core/colors.dart';
import '../core/spacing.dart';
import 'app_button.dart';
import 'custom_tab.dart';
import 'label_amount.dart';

class CryptoTradeBottomSheet extends StatefulWidget {
  const CryptoTradeBottomSheet({super.key});

  @override
  CryptoTradeBottomSheetState createState() => CryptoTradeBottomSheetState();
}

class CryptoTradeBottomSheetState extends State<CryptoTradeBottomSheet> {
  String _selectedTab = 'Buy';
  bool _postOnly = false;
  String dropdownValue = 'NGN';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTabBar(
            tabs: const [
              'Buy',
              'Sell',
            ],
            expandTabs: true,
            haveMargin: false,
            onTabSelected: (index) {
              print('Selected Tab Index: $index');
            },
          ),
          CustomTabBar(
            tabs: const [
              'Limit',
              'Market',
              'Stop-Limit',
            ],
            haveMargin: false,
            onTabSelected: (index) {
              print('Selected Tab Index: $index');
            },
          ),
          const Spacing.mediumHeight(),
          const PriceInfo(label: 'Limit price', amount: '0.00 USD'),
          const Spacing.mediumHeight(),
          const PriceInfo(label: 'Amount', amount: '0.00 USD'),
          const Spacing.mediumHeight(),
          const PriceInfo(label: 'Type', amount: '0.00 USD'),
          const SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: Checkbox(
                  value: _postOnly,
                  onChanged: (value) {
                    setState(() {
                      _postOnly = value!;
                    });
                  },
                  side: const BorderSide(color: AppColors.textPrimary1),
                ),
              ),
              const Spacing.smallWidth(),
              Text(
                'Post Only',
                style: AppTextStyles.regular12.copyWith(color: AppColors.textPrimary2),
              ),
              const Spacing.tinyWidth(),
              const Icon(
                Icons.info_outline_rounded,
                size: 12,
                color: AppColors.textPrimary2,
              ),
            ],
          ),
          const Spacing.mediumHeight(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTextStyles.regular12.copyWith(color: AppColors.textPrimary2),
              ),
              Text(
                '0.00',
                style: AppTextStyles.regular12.copyWith(color: AppColors.textPrimary2),
              ),
            ],
          ),
          const Spacing.mediumHeight(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                colors: [
                  Color(0xff483BEB),
                  Color(0xff7847E1),
                  Color(0xffDD568D),
                ],
              ),
            ),
            child: AppButton(
              label: '${_selectedTab} BTC',
              onTap: () {},
              buttonColor: AppColors.transparent,
              labelColor: AppColors.white,
            ),
          ),
          const Spacing.height(15),
          const Divider(height: 1),
          const Spacing.smallHeight(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const LabelAmount(label: 'Open Orders', value: '0.00'),
              DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 12,
                ),
                elevation: 16,
                style: AppTextStyles.regular12.copyWith(color: AppColors.textPrimary2),
                underline: const Spacing.empty(),
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                items: ['NGN', 'USD'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: AppTextStyles.regular12.copyWith(color: AppColors.textPrimary2),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LabelAmount(label: 'Total account value', value: '0.00'),
              LabelAmount(label: 'Available', value: '0.00'),
            ],
          ),
          const SizedBox(height: 20),
          AppButton(
            label: 'Deposit',
            onTap: () {},
            buttonColor: AppColors.blue,
            labelColor: AppColors.white,
            isCollapsed: true,
          ),
        ],
      ),
    );
  }
}
