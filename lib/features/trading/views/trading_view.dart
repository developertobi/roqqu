import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roqqu/core/app_textstyles.dart';
import 'package:roqqu/core/colors.dart';
import 'package:roqqu/core/spacing.dart';
import 'package:roqqu/widgets/app_vertical_divider.dart';
import 'package:roqqu/widgets/price_change_card.dart';

import '../../../core/app_assets.dart';

class TradingView extends StatelessWidget {
  const TradingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: SvgPicture.asset(
            AppSvgAssets.logo,
            fit: BoxFit.scaleDown,
          ),
        ),
        titleSpacing: 0,
        title: Text(
          'Sisyphus',
          style: AppTextStyles.regular24.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        actions: [
          Image.asset(
            AppImgAssets.profile,
            height: 32,
          ),
          const Spacing.largeWidth(),
          SvgPicture.asset(AppSvgAssets.globe),
          const Spacing.mediumWidth(),
          SvgPicture.asset(AppSvgAssets.menu),
          const Spacing.width(20),
        ],
      ),
      body: Column(
        children: [
          const Spacing.smallHeight(),
          Container(
            height: 126,
            color: AppColors.primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 50,
                            child: Stack(
                              children: [
                                SvgPicture.asset(AppSvgAssets.bitcoin),
                                Positioned(
                                  left: 20,
                                  child: SvgPicture.asset(AppSvgAssets.dollar),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            'BTC/USDT',
                            style: AppTextStyles.regular18,
                          ),
                          const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black),
                        ],
                      ),
                      const Spacing.mediumWidth(),
                      Text(
                        '\$20,634',
                        style: AppTextStyles.regular18.copyWith(color: AppColors.green10),
                      ),
                    ],
                  ),
                  const Spacing.mediumHeight(),
                  const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        PriceChangeCard(
                          icon: Icons.access_time,
                          title: '24h change',
                          value: '520.80 +1.25%',
                          valueColor: AppColors.green10,
                        ),
                        AppVerticalDivider(),
                        PriceChangeCard(
                          icon: Icons.arrow_upward,
                          title: '24h high',
                          value: '520.80 +1.25%',
                        ),
                        AppVerticalDivider(),
                        PriceChangeCard(
                          icon: Icons.arrow_downward_sharp,
                          title: '24h low',
                          value: '520.80 +1.25%',
                        ),
                        AppVerticalDivider(),
                        PriceChangeCard(
                          icon: Icons.show_chart,
                          title: 'Volume',
                          value: '1,250 BTC',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
