import 'package:get/get.dart';
import 'package:tacticum_converter/features/pages/exchange/exchange_page.dart';

class Navigation {
  static const initial = Routes.exchange;

  static final List<GetPage> pages = [
    GetPage(
      name: Routes.exchange,
      page: () => const ExchangePage(),
    ),
  ];
}

abstract class Routes {
  static const exchange = '/exchange';
}
