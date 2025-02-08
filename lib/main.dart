import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tacticum_converter/core/dependency_injection/currency_exchange_injection.dart';
import 'package:tacticum_converter/core/navigation/navigation.dart';

void main() {
  CurrencyExchangeInjection.inject();

  runApp(const TacticumConverter());
}

class TacticumConverter extends StatelessWidget {
  const TacticumConverter({super.key});

  static final snackbarKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: Navigation.initial,
      scaffoldMessengerKey: snackbarKey,
      getPages: Navigation.pages,
    );
  }
}
