import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tacticum_converter/core/assets/assets.gen.dart';
import 'package:tacticum_converter/features/domain/controllers/converter/converter_controller.dart';
import 'package:tacticum_converter/features/domain/controllers/converter/exchange_history_controller.dart';


class ExchangeButton extends StatelessWidget {
  const ExchangeButton({
    required this.secondFieldController,
    super.key,
  });

  final TextEditingController secondFieldController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConverterController>(
      builder: (controller) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            overlayColor: Colors.white,
            shape: CircleBorder(),
            padding: EdgeInsets.all(20),
            backgroundColor: controller.hasFailure ? Colors.red : Colors.blue[800],
          ),
          onPressed: onPressed,
          child: SizedBox(
            width: 22,
            height: 22,
            child: Builder(
              builder: (_) {
                if (controller.isLoading) {
                  return CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  );
                }

                return Assets.icons.exchange.svg(
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void onPressed() async {
    final converterController = Get.find<ConverterController>();
    final exchangeHistoryController = Get.find<ExchangeHistoryController>();

    await converterController.swapCurrencies();
    secondFieldController.text = converterController.second!.amountString;
    exchangeHistoryController.loadExchangeHistory();
  }
}
