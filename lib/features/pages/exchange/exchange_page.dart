import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tacticum_converter/features/domain/controllers/converter/converter_controller.dart';
import 'package:tacticum_converter/features/pages/exchange/widgets/converter.dart';

class ExchangePage extends StatefulWidget {
  const ExchangePage({super.key});

  @override
  State<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Get.find<ConverterController>().loadCurrencyCodes();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Converter(),
          ),
        ],
      ),
    );
  }
}
