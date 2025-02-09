import 'package:tacticum_converter/core/utils/exchange_ratio_shorter.dart';

class SelectedCurrencyModel {
  SelectedCurrencyModel(this.code, this.amount);

  factory SelectedCurrencyModel.defaultUSD() {
    return SelectedCurrencyModel('USD', 1.0);
  }

  factory SelectedCurrencyModel.defaultEUR() {
    return SelectedCurrencyModel('EUR', 0.0);
  }

  factory SelectedCurrencyModel.defaultRUB() {
    return SelectedCurrencyModel('RUB', 0.0);
  }

  String code;
  double? amount;

  String get amountString => amount != null ? shortRatio(amount!, 3) : "";

  SelectedCurrencyModel copyWith({String? code, double? amount}) {
    return SelectedCurrencyModel(
      code ?? this.code,
      amount ?? this.amount,
    );
  }
}
