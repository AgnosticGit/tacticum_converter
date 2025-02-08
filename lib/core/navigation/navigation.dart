import 'package:get/get.dart';
import 'package:tacticum_converter/features/pages/exchange/exchange_page.dart';
import 'package:tacticum_converter/features/pages/start/start_page.dart';

class Navigation {
  static const initial = Routes.start;

  static final List<GetPage> pages = [
    GetPage(
      name: Routes.start,
      page: () => const StartPage(),
    ),
    GetPage(
      name: Routes.exchange,
      page: () => const ExchangePage(),
    ),
  ];
}

abstract class Routes {
  static const start = '/start';
  static const exchange = '/exchange';
}
