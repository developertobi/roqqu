import 'package:flutter/material.dart';

import 'core/colors.dart';
import 'core/strings.dart';
import 'features/trading/views/trading_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: AppColors.scaffoldBackground,
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: AppColors.grey)),
      title: AppStrings.appName,
      home: const TradingView(),
    );
  }
}
