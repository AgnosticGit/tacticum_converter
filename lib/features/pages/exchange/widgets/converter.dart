import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tacticum_converter/core/ui_kit/snackbar_text_message.dart';
import 'package:tacticum_converter/features/domain/controllers/converter/converter_controller.dart';
import 'package:tacticum_converter/features/domain/controllers/converter/exchange_history_controller.dart';
import 'package:tacticum_converter/features/pages/exchange/widgets/currency_selector.dart';
import 'package:tacticum_converter/features/pages/exchange/widgets/exchange_button.dart';
import 'amount_text_field.dart';

class Converter extends StatefulWidget {
  const Converter({super.key});

  @override
  State<Converter> createState() => _ConverterState();
}

class _ConverterState extends State<Converter> {
  final firstFieldController = TextEditingController();
  final firstFieldFocusNode = FocusNode();

  final secondFieldController = TextEditingController();
  final secondFieldFocusNode = FocusNode();

  static const firstFieldDefaultValue = "1.0";

  @override
  void initState() {
    firstFieldFocusNode.addListener(onUnfocus);
    secondFieldFocusNode.addListener(onUnfocus);
    WidgetsBinding.instance.addPostFrameCallback((_) => onLoad());
    super.initState();
  }

  /// Повторяет попытку загрузки пока не получит данные
  Future<void> onLoad() async {
    while (true) {
      final controller = Get.find<ConverterController>();
      await controller.loadCurrencyCodes();

      if (controller.hasFailure) {
        SnackbarTextMessage.showError(Get.context!, controller.failure!.message);
        await Future.delayed(Duration(seconds: 2));
        continue;
      }

      final exchangeHistoryController = Get.find<ExchangeHistoryController>();
      await exchangeHistoryController.loadExchangeHistory();

      firstFieldController.text = controller.first!.amountString;
      onChangeFirstAmount(controller.first!.amountString);

      SnackbarTextMessage.clearSnackBars();
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConverterController>(builder: (controller) {
      return AbsorbPointer(
        absorbing: controller.isLoading,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.2),
                spreadRadius: 3,
                blurRadius: 3,
                offset: Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Amount'),
              const SizedBox(height: 16),
              Row(
                children: [
                  CurrencySelector(
                    selectedCurrency: controller.first?.code,
                    availableCurrencyCodes: controller.availableCurrencyCodes,
                    onSelected: (value) async {
                      await controller.selectFirstCurrency(value);
                      secondFieldController.text = controller.second!.amountString;
                      await Get.find<ExchangeHistoryController>().loadExchangeHistory();
                    },
                  ),
                  Spacer(flex: 1),
                  Expanded(
                    flex: 2,
                    child: AmountTextField(
                      controller: firstFieldController,
                      focusNode: firstFieldFocusNode,
                      onChange: (value) => onChangeFirstAmount(value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  Divider(),
                  ExchangeButton(secondFieldController: secondFieldController),
                ],
              ),
              const SizedBox(height: 20),
              Text('Converted Amount'),
              const SizedBox(height: 16),
              Row(
                children: [
                  CurrencySelector(
                    selectedCurrency: controller.second?.code,
                    availableCurrencyCodes: controller.availableCurrencyCodes,
                    onSelected: (value) async {
                      await controller.selectSecondCurrency(value);
                      secondFieldController.text = controller.second!.amountString;
                      await Get.find<ExchangeHistoryController>().loadExchangeHistory();
                    },
                  ),
                  Spacer(flex: 1),
                  Expanded(
                    flex: 2,
                    child: AmountTextField(
                      controller: secondFieldController,
                      focusNode: secondFieldFocusNode,
                      onChange: onChangeSecondAmount,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  void onChangeFirstAmount(String value) {
    final controller = Get.find<ConverterController>();

    controller.setFirstAmount(value);
    secondFieldController.value = TextEditingValue(
      text: controller.second!.amountString,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  void onChangeSecondAmount(String value) {
    final controller = Get.find<ConverterController>();

    controller.setSecondAmount(value);
    firstFieldController.value = TextEditingValue(
      text: controller.first!.amountString,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  void onUnfocus() {
    final controller = Get.find<ConverterController>();
    final isUnfocus = !firstFieldFocusNode.hasFocus || !secondFieldFocusNode.hasFocus;
    final someAmountIsEmpty =
        controller.first!.amountString.isEmpty || controller.second!.amountString.isEmpty;

    if (isUnfocus && someAmountIsEmpty) {
      firstFieldController.text = firstFieldDefaultValue;
      onChangeFirstAmount(firstFieldDefaultValue);
    }
  }

  @override
  void dispose() {
    firstFieldController.dispose();
    secondFieldController.dispose();
    firstFieldFocusNode.removeListener(onUnfocus);
    super.dispose();
  }
}
