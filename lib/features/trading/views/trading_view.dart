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
import '../../../services/web_socket_service.dart';
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
  late WebSocketService _webSocketService;

  @override
  void initState() {
    super.initState();
    _chartData = getData();
    _sharedZoomPanBehavior = ZoomPanBehavior(
      enablePanning: true,
      enablePinching: true,
      zoomMode: ZoomMode.x,
    );

    _webSocketService = WebSocketService.connect(
      'wss://stream.binance.com:9443',
    );

    _webSocketService.getCandlestickStream('BTC/USDT', '1m').listen((data) {
      setState(() {
        _chartData = parseCandlestickData(data);
      });
    });

    // _webSocketService.getOrderbookStream('BTC/USDT').listen((data) {
    //   // Handle orderbook data (e.g., update UI or maintain a separate state variable)
    //   print('Orderbook data received: $data');
    // });
  }

  List<ChartData> parseCandlestickData(Map<String, dynamic> data) {
    final DateTime date = DateTime.parse(data['t']);
    final double open = data['o'];
    final double high = data['h'];
    final double low = data['l'];
    final double close = data['c'];
    final double volume = data['v'];

    return [ChartData(date, low, high, open, close, volume)];
  }

  num livePrice = 36500;

  final List<Map<String, dynamic>> orderBookData = [
    {'price': 36920.12, 'amount': 0.758965, 'total': 13020.98},
    {'price': 36920.12, 'amount': 0.758965, 'total': 1020.98},
    {'price': 36920.12, 'amount': 0.758965, 'total': 32020.98},
    {'price': 36920.12, 'amount': 0.758965, 'total': 15020.98},
    {'price': 36920.12, 'amount': 0.758965, 'total': 28020.98},
  ];

  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    double maxTotal =
        orderBookData.map((item) => item['total'] as double).reduce((a, b) => a > b ? a : b);
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
                      setState(() {
                        tabIndex = index;
                      });
                      print('Selected Tab Index: $index');
                    },
                  ),
                  tabIndex == 0
                      ? Column(
                          children: [
                            _TimeIntervalSelector(
                              onIntervalChanged: (interval) {
                                print('Selected Interval: $interval');
                                updateChartData(interval);
                              },
                            ),
                            Container(
                              height: 400,
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: SfCartesianChart(
                                primaryXAxis: DateTimeAxis(
                                  intervalType: DateTimeIntervalType.days,
                                  dateFormat: DateFormat('MM/dd'),
                                  majorGridLines: const MajorGridLines(width: 1),
                                  initialVisibleMinimum: DateTime(2010, 2, 21),
                                  initialVisibleMaximum: DateTime(2024, 3, 21),
                                ),
                                primaryYAxis: NumericAxis(
                                  minimum: getMinValue(),
                                  maximum: getMaxValue(),
                                  interval: 50,
                                  opposedPosition: true,
                                  axisLine: const AxisLine(width: 0),
                                  plotBands: <PlotBand>[
                                    PlotBand(
                                      start: livePrice,
                                      end: livePrice,
                                      borderColor: AppColors.green10,
                                      borderWidth: 1,
                                    ),
                                  ],
                                  plotOffsetStart: 50,
                                ),
                                axes: <ChartAxis>[
                                  NumericAxis(
                                    name: 'volumeAxis',
                                    opposedPosition: true,
                                    majorGridLines: const MajorGridLines(width: 0),
                                    minimum: 0,
                                    interval: 500,
                                    isVisible: false,
                                    plotOffset: 0,
                                  ),
                                ],
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
                                  ColumnSeries<ChartData, DateTime>(
                                    dataSource: _chartData,
                                    xValueMapper: (ChartData data, _) => data.date,
                                    yValueMapper: (ChartData data, _) => data.volume,
                                    color: Colors.grey,
                                    yAxisName: 'volumeAxis',
                                  ),
                                ],
                                tooltipBehavior: TooltipBehavior(enable: true),
                                zoomPanBehavior: _sharedZoomPanBehavior,
                              ),
                            ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Table header
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Price\n(USDT)',
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.regular16.copyWith(
                                        color: AppColors.textPrimary2,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Amounts\n(BTC)',
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.regular16.copyWith(
                                        color: AppColors.textPrimary2,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Total',
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.regular16.copyWith(
                                        color: AppColors.textPrimary2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 190,
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: (orderBookData.length),
                                  itemBuilder: (context, index) {
                                    final item = orderBookData[index];
                                    final double total = item['total'];
                                    final double percentage = total / maxTotal;
                                    return Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            height: 30,
                                            width: percentage * MediaQuery.of(context).size.width,
                                            decoration: BoxDecoration(
                                              color: AppColors.red.withOpacity(.2),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item['price'].toStringAsFixed(2),
                                                  textAlign: TextAlign.center,
                                                  style: AppTextStyles.regular16.copyWith(
                                                    color: AppColors.red,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  item['amount'].toStringAsFixed(6),
                                                  textAlign: TextAlign.center,
                                                  style: AppTextStyles.regular16.copyWith(
                                                    color: AppColors.textPrimary1,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Center(
                                                  child: Text(
                                                    item['total'].toStringAsFixed(2),
                                                    style: AppTextStyles.regular16.copyWith(
                                                      color: AppColors.textPrimary1,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '36,641.20',
                                    style: AppTextStyles.regular16.copyWith(
                                      color: AppColors.green10,
                                    ),
                                  ),
                                  const Icon(Icons.arrow_upward,
                                      color: AppColors.textPrimary2, size: 16),
                                  Text(
                                    '36,641.20',
                                    style: AppTextStyles.regular16.copyWith(
                                      color: AppColors.textPrimary1,
                                    ),
                                  )
                                ],
                              ),
                              const Spacing.mediumHeight(),
                              SizedBox(
                                height: 190,
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: (orderBookData.length),
                                  itemBuilder: (context, index) {
                                    final item = orderBookData[index];
                                    final double total = item['total'];
                                    final double percentage = total / maxTotal;
                                    return Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            height: 30,
                                            width: percentage * MediaQuery.of(context).size.width,
                                            decoration: BoxDecoration(
                                              color: AppColors.green10.withOpacity(.2),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item['price'].toStringAsFixed(2),
                                                  textAlign: TextAlign.center,
                                                  style: AppTextStyles.regular16.copyWith(
                                                    color: AppColors.green10,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  item['amount'].toStringAsFixed(6),
                                                  textAlign: TextAlign.center,
                                                  style: AppTextStyles.regular16.copyWith(
                                                    color: AppColors.textPrimary1,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Center(
                                                  child: Text(
                                                    item['total'].toStringAsFixed(2),
                                                    style: AppTextStyles.regular16.copyWith(
                                                      color: AppColors.textPrimary1,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
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

  void updateChartData(String interval) {
    switch (interval) {
      case '1H':
        _chartData = getHourlyData();
        break;
      case '2H':
        _chartData = get2HourlyData();
        break;
      case '4H':
        _chartData = get4HourlyData();
        break;
      case '1D':
        _chartData = getDailyData();
        break;
      case '1W':
        _chartData = getWeeklyData();
        break;
      case '1M':
        _chartData = getMonthlyData();
        break;
      default:
        _chartData = getIntradayData();
        break;
    }

    setState(() {});
  }

  List<ChartData> getIntradayData() {
    return List.generate(50, (index) {
      final date = DateTime.now().subtract(Duration(minutes: index * 15));
      final open = 36500 + Random().nextDouble() * 100;
      final close = open + Random().nextDouble() * 20;
      final low = open - Random().nextDouble() * 10;
      final high = close + Random().nextDouble() * 20;
      final volume = Random().nextDouble() * 50;
      return ChartData(date, low, high, open, close, volume);
    }).reversed.toList();
  }

  List<ChartData> getHourlyData() {
    return List.generate(50, (index) {
      final date = DateTime.now().subtract(Duration(hours: index));
      final open = 36500 + Random().nextDouble() * 100;
      final close = open + Random().nextDouble() * 50;
      final low = open - Random().nextDouble() * 20;
      final high = close + Random().nextDouble() * 50;
      final volume = Random().nextDouble() * 50;
      return ChartData(date, low, high, open, close, volume);
    }).reversed.toList();
  }

  List<ChartData> getDailyData() {
    return List.generate(30, (index) {
      final date = DateTime.now().subtract(Duration(days: index));
      final open = 36000 + Random().nextDouble() * 500;
      final close = open + Random().nextDouble() * 200;
      final low = open - Random().nextDouble() * 100;
      final high = close + Random().nextDouble() * 300;
      final volume = Random().nextDouble() * 50;
      return ChartData(date, low, high, open, close, volume);
    }).reversed.toList();
  }

  List<ChartData> getWeeklyData() {
    return List.generate(12, (index) {
      final date = DateTime.now().subtract(Duration(days: index * 7));
      final open = 35000 + Random().nextDouble() * 1000;
      final close = open + Random().nextDouble() * 500;
      final low = open - Random().nextDouble() * 300;
      final high = close + Random().nextDouble() * 600;
      final volume = Random().nextDouble() * 50;
      return ChartData(date, low, high, open, close, volume);
    }).reversed.toList();
  }

  List<ChartData> getMonthlyData() {
    return List.generate(12, (index) {
      final date = DateTime.now().subtract(Duration(days: index * 30));
      final open = 34000 + Random().nextDouble() * 2000;
      final close = open + Random().nextDouble() * 1000;
      final low = open - Random().nextDouble() * 500;
      final high = close + Random().nextDouble() * 1500;
      final volume = Random().nextDouble() * 50;
      return ChartData(date, low, high, open, close, volume);
    }).reversed.toList();
  }

  List<ChartData> get4HourlyData() {
    return List.generate(50, (index) {
      final date = DateTime.now().subtract(Duration(hours: index * 4));
      final open = 36000 + Random().nextDouble() * 300;
      final close = open + Random().nextDouble() * 150;
      final low = open - Random().nextDouble() * 80;
      final high = close + Random().nextDouble() * 200;
      final volume = Random().nextDouble() * 50;
      return ChartData(date, low, high, open, close, volume);
    }).reversed.toList();
  }

  List<ChartData> get2HourlyData() {
    return List.generate(50, (index) {
      final date = DateTime.now().subtract(Duration(hours: index * 2));
      final open = 36500 + Random().nextDouble() * 200;
      final close = open + Random().nextDouble() * 100;
      final low = open - Random().nextDouble() * 50;
      final high = close + Random().nextDouble() * 150;
      final volume = Random().nextDouble() * 50;
      return ChartData(date, low, high, open, close, volume);
    }).reversed.toList();
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
      double volume = random.nextInt(50).toDouble();

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
  const _TimeIntervalSelector({
    super.key,
    required this.onIntervalChanged,
  });

  final ValueChanged<String> onIntervalChanged;

  @override
  State<_TimeIntervalSelector> createState() => _TimeIntervalSelectorState();
}

class _TimeIntervalSelectorState extends State<_TimeIntervalSelector> {
  String _selectedInterval = '1D';

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
          widget.onIntervalChanged(label);
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
