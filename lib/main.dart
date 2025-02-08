import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tacticum_converter/core/dependency_injection/currency_exchange_injection.dart';
import 'package:tacticum_converter/core/navigation/navigation.dart';

void main() {
  CurrencyExchangeInjection.inject();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: Navigation.initial,
      getPages: Navigation.pages,
    );
  }
}
