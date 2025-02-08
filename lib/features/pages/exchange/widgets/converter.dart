import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tacticum_converter/core/assets/assets.gen.dart';
import 'package:tacticum_converter/features/domain/controllers/converter/converter_controller.dart';
import 'package:tacticum_converter/features/pages/exchange/widgets/currency_selector.dart';

class Converter extends StatelessWidget {
  const Converter({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Amount'),
          const SizedBox(height: 16),
          GetBuilder<ConverterController>(
            builder: (controller) {
              return Row(
                children: [
                  CurrencySelector(
                    selectedCurrency: controller.firstSelected,
                    availableCurrencyCodes: controller.availableCurrencyCodes,
                    onSelected: controller.selectFirstCurrency,
                  ),
                  Spacer(flex: 1),
                  Expanded(
                    flex: 2,
                    child: _AmountTextField(
                      amount: controller.firstAmount,
                      onChange: controller.setFirstAmount,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              Divider(),
              _ExchangeButton(),
            ],
          ),
          const SizedBox(height: 20),
          Text('Converted Amount'),
          const SizedBox(height: 16),
          GetBuilder<ConverterController>(
            builder: (controller) {
              return Row(
                children: [
                  CurrencySelector(
                    selectedCurrency: controller.secondSelected,
                    availableCurrencyCodes: controller.availableCurrencyCodes,
                    onSelected: controller.selectSecondCurrency,
                  ),
                  Spacer(flex: 1),
                  Expanded(
                    flex: 2,
                    child: _AmountTextField(
                      amount: controller.secondAmount,
                      onChange: controller.setFirstAmount,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ExchangeButton extends StatelessWidget {
  const _ExchangeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        overlayColor: Colors.white,
        shape: CircleBorder(),
        padding: EdgeInsets.all(20),
        backgroundColor: Colors.blue[800],
      ),
      onPressed: () {},
      child: SizedBox(
        width: 22,
        height: 22,
        child: Assets.icons.exchange.svg(
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
    );
  }
}

class _AmountTextField extends StatefulWidget {
  _AmountTextField({
    required this.amount,
    required this.onChange,
  });

  final String amount;
  final Function(String value) onChange;

  @override
  State<_AmountTextField> createState() => _AmountTextFieldState();
}

class _AmountTextFieldState extends State<_AmountTextField> {
  final controller = TextEditingController();

  @override
  void didUpdateWidget(covariant _AmountTextField oldWidget) {
    if (oldWidget.amount != widget.amount) {
      controller.value = TextEditingValue(
        text: widget.amount,
        selection: TextSelection.collapsed(offset: widget.amount.length),
      );
      ;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: 130),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: controller,
          onChanged: widget.onChange,
          textAlign: TextAlign.right,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
          decoration: InputDecoration(border: InputBorder.none),
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }
}
