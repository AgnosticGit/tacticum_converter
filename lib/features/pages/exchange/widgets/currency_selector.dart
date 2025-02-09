import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tacticum_converter/core/constants/currency_flags/currency_flags.dart';

class CurrencySelector extends StatefulWidget {
  const CurrencySelector({
    required this.selectedCurrency,
    required this.availableCurrencyCodes,
    required this.onSelected,
    super.key,
  });

  final String? selectedCurrency;
  final List<String> availableCurrencyCodes;
  final Function(String? value) onSelected;

  @override
  State<CurrencySelector> createState() => _CurrencySelectorState();
}

class _CurrencySelectorState extends State<CurrencySelector> {
  List<DropdownMenuEntry<String>> currencies = [];

  @override
  void didUpdateWidget(covariant CurrencySelector oldWidget) {
    if (oldWidget.availableCurrencyCodes.length < widget.availableCurrencyCodes.length) {
      setCurrencies();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if(widget.availableCurrencyCodes.isEmpty){
      return const SizedBox();
    }

    final currency = Get.find<CurrencyFlags>().currencyByCode(widget.selectedCurrency!);

    return DropdownMenu<String>(
      width: 140,
      leadingIcon: Container(
        margin: const EdgeInsets.only(right: 6),
        width: 36,
        height: 36,
        child: currency!.flag,
      ),
      textStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.blue[900],
      ),
      keyboardType: TextInputType.text,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z]+$')),
      ],
      inputDecorationTheme: InputDecorationTheme(border: InputBorder.none),
      initialSelection: widget.selectedCurrency,
      trailingIcon: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.grey,
      ),
      selectedTrailingIcon: Icon(
        Icons.keyboard_arrow_up,
        color: Colors.grey,
      ),
      onSelected: widget.onSelected,
      dropdownMenuEntries: currencies,
    );
  }

  void setCurrencies() {
    final currencyFlags = Get.find<CurrencyFlags>();

    if (currencies.isEmpty) {
      final onlyWithFlags = widget.availableCurrencyCodes.where(
        (e) => currencyFlags.images.containsKey(e),
      );

      currencies = onlyWithFlags.map((e) {
        return DropdownMenuEntry(
          leadingIcon: SizedBox(
            width: 30,
            height: 30,
            child: currencyFlags.currencyByCode(e)!.flag,
          ),
          value: e,
          label: e,
        );
      }).toList();
    }
  }
}
