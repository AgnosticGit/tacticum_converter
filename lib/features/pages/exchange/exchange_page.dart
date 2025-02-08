import 'package:flutter/material.dart';
import 'package:tacticum_converter/features/pages/exchange/widgets/converter.dart';
import 'package:tacticum_converter/features/pages/exchange/widgets/history_line_charts.dart';

class ExchangePage extends StatefulWidget {
  const ExchangePage({super.key});

  @override
  State<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Converter(),
            ),
            const SizedBox(height: 30),
            HistoryLineCharts(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
