import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tacticum_converter/core/assets/assets.gen.dart';
import 'package:tacticum_converter/features/domain/controllers/converter/converter_controller.dart';

import '../../../../core/ui_kit/snackbar_text_message.dart';

class ExchangeButton extends StatelessWidget {
  const ExchangeButton({
    required this.secondFieldController,
    super.key,
  });

  final TextEditingController secondFieldController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        overlayColor: Colors.white,
        shape: CircleBorder(),
        padding: EdgeInsets.all(20),
        backgroundColor: Colors.blue[800],
      ),
      onPressed: () async {
        final controller = Get.find<ConverterController>();
        await controller.swapCurrencies();
        secondFieldController.text = controller.second!.amountString;
      },
      child: SizedBox(
        width: 22,
        height: 22,
        child: GetBuilder<ConverterController>(
          builder: (controller) {
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
  }
}
