import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:roqqu/core/app_textstyles.dart';
import 'package:roqqu/core/colors.dart';
import 'package:roqqu/core/spacing.dart';
import 'package:roqqu/widgets/app_button.dart';
import 'package:roqqu/widgets/app_vertical_divider.dart';
import 'package:roqqu/widgets/custom_tab.dart';
import 'package:roqqu/widgets/price_change_card.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../core/app_assets.dart';
import '../../../widgets/trade_bottom.dart';

class TradingView extends StatefulWidget {
  const TradingView({super.key});

  @override
  State<TradingView> createState() => _TradingViewState();
}

class _TradingViewState extends State<TradingView> {
  int selectedIndex = 0;
  late List<ChartData> _chartData;
  late ZoomPanBehavior _sharedZoomPanBehavior;

  @override
  void initState() {
    super.initState();
    _chartData = getData();
    _sharedZoomPanBehavior = ZoomPanBehavior(
      enablePanning: true,
      enablePinching: true,
      zoomMode: ZoomMode.x,
    ); // Shared zoom behavior
  }

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
      body: SingleChildScrollView(
        child: Column(
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
                            const Icon(Icons.keyboard_arrow_down_rounded,
                                color: AppColors.textPrimary1),
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
            ),
            const Spacing.smallHeight(),
            Container(
              color: AppColors.primaryColor,
              child: Column(
                children: [
                  CustomTabBar(
                    tabs: const ['Charts', 'Orderbook', 'Recent trades'],
                    onTabSelected: (index) {
                      print('Selected Tab Index: $index');
                    },
                  ),
                  const _TimeIntervalSelector(),
                  Container(
                    height: 300,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: SfCartesianChart(
                      primaryXAxis: DateTimeAxis(
                        isVisible: true,
                        intervalType: DateTimeIntervalType.days,
                        dateFormat: DateFormat('MM/dd'),
                        majorGridLines: const MajorGridLines(width: 1),
                        initialVisibleMinimum: DateTime(2022, 2, 21),
                        initialVisibleMaximum: DateTime(2024, 3, 21),
                      ),
                      primaryYAxis: NumericAxis(
                        minimum: getMinValue(),
                        maximum: getMaxValue(),
                        interval: 50,
                        opposedPosition: true,
                      ),
                      series: <CartesianSeries>[
                        CandleSeries<ChartData, DateTime>(
                          dataSource: _chartData,
                          xValueMapper: (ChartData data, _) => data.date,
                          lowValueMapper: (ChartData data, _) => data.low,
                          highValueMapper: (ChartData data, _) => data.high,
                          openValueMapper: (ChartData data, _) => data.open,
                          closeValueMapper: (ChartData data, _) => data.close,
                          bearColor: AppColors.red,
                          bullColor: AppColors.green10,
                        ),
                      ],
                      tooltipBehavior: TooltipBehavior(enable: true),
                      zoomPanBehavior: _sharedZoomPanBehavior,
                    ),
                  ),
                  Container(
                    height: 100,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: SfCartesianChart(
                      primaryXAxis: DateTimeAxis(
                        intervalType: DateTimeIntervalType.days,
                        dateFormat: DateFormat('MM/dd'),
                        majorGridLines: const MajorGridLines(width: 0),
                      ),
                      primaryYAxis: const NumericAxis(
                        labelFormat: '{value}',
                        opposedPosition: true,
                        majorGridLines: MajorGridLines(width: 0),
                      ),
                      series: <ColumnSeries<ChartData, DateTime>>[
                        ColumnSeries<ChartData, DateTime>(
                          dataSource: _chartData,
                          xValueMapper: (ChartData data, _) => data.date,
                          yValueMapper: (ChartData data, _) => data.volume,
                          color: Colors.grey,
                        ),
                      ],
                      // zoomPanBehavior: _sharedZoomPanBehavior,
                    ),
                  ),
                  CustomTabBar(
                    tabs: const ['Open Orders', 'Positions', 'Orders'],
                    onTabSelected: (index) {
                      print('Selected Tab Index: $index');
                    },
                  ),
                  SizedBox(
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No Open Orders',
                          style: AppTextStyles.regular18.copyWith(
                            color: AppColors.textPrimary1,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Lorem ipsum dolor sit amet, consectetur\nadipiscing elit. Id pulvinar nullam sit imperdiet\npulvinar.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.regular14.copyWith(
                            color: AppColors.textPrimary2,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Spacing.smallHeight(),
            Container(
              color: AppColors.primaryColor,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Buy',
                      buttonColor: AppColors.green10,
                      isCollapsed: true,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) => const CryptoTradeBottomSheet(),
                        );
                      },
                    ),
                  ),
                  const Spacing.smallWidth(),
                  Expanded(
                    child: AppButton(
                      label: 'Sell',
                      buttonColor: AppColors.red,
                      isCollapsed: true,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ChartData> getData() {
    final random = Random();
    final List<ChartData> data = [];
    DateTime date = DateTime(2022, 2, 21);
    double open = 36400;

    return List.generate(50, (index) {
      double high = open + random.nextInt(100).toDouble();
      double low = open - random.nextInt(100).toDouble();
      double close = low + random.nextInt((high - low).toInt()).toDouble();
      double volume = random.nextInt(100).toDouble();

      final dataPoint = ChartData(date, low, high, open, close, volume);

      date = date.add(const Duration(days: 1));
      open = close;

      return dataPoint;
    });
  }

  double getMinValue() {
    double minValue = double.infinity;
    for (var item in _chartData) {
      if (item.low < minValue) {
        minValue = item.low;
      }
    }
    return minValue;
  }

  double getMaxValue() {
    double maxValue = double.negativeInfinity;
    for (var item in _chartData) {
      if (item.high > maxValue) {
        maxValue = item.high;
      }
    }
    return maxValue;
  }
}

class ChartData {
  ChartData(this.date, this.low, this.high, this.open, this.close, this.volume);
  final DateTime date;
  final double low;
  final double high;
  final double open;
  final double close;
  final double volume;
}

class _TimeIntervalSelector extends StatefulWidget {
  const _TimeIntervalSelector({super.key});

  @override
  State<_TimeIntervalSelector> createState() => _TimeIntervalSelectorState();
}

class _TimeIntervalSelectorState extends State<_TimeIntervalSelector> {
  String _selectedInterval = '1D'; // Default selected interval

  @override
  Widget build(BuildContext context) {
    final List<String> intervals = ['Time', '1H', '2H', '4H', '1D', '1W', '1M'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            for (String interval in intervals)
              _buildTimeButton(interval, isSelected: _selectedInterval == interval),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.candlestick_chart),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeButton(String label, {bool isSelected = false}) {
    return SizedBox(
      height: 28,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedInterval = label;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.backgroundPrimary1 : AppColors.primaryColor,
          foregroundColor: isSelected ? AppColors.textPrimary1 : AppColors.textPrimary2,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: Text(label, style: AppTextStyles.regular14),
      ),
    );
  }
}
