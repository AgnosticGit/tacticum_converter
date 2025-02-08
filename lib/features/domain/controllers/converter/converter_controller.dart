import 'package:tacticum_converter/features/domain/controllers/abstracts/controller.dart';
import 'package:tacticum_converter/features/domain/models/exchange_rate_model.dart';
import 'package:tacticum_converter/features/domain/models/selected_currency_model.dart';
import 'package:tacticum_converter/features/domain/repositories/converter_repository.dart';

class ConverterController extends Controller {
  ConverterController(this.converterRepository);

  final ConverterRepository converterRepository;

  List<String> availableCurrencyCodes = [];
  ExchangeRateModel? exchangeRateModel;

  SelectedCurrencyModel? first;
  SelectedCurrencyModel? second;

  double ratio = 1.0;

  Future<void> loadCurrencyCodes() async {
    loadingStarted();

    final lor = await converterRepository.currencyCodes();

    if (lor.isRight) {
      availableCurrencyCodes = lor.right.map((e) => e.toUpperCase()).toList();
      first = SelectedCurrencyModel.defaultUSD();
      second = SelectedCurrencyModel.defaultRUB()..amount = _convertFormula(first!.amount!, ratio);
      await _getExchangeRate();
    } else {
      setFailure(lor.left);
    }

    loadingFinished();
  }

  Future<void> _getExchangeRate() async {
    final lor = await converterRepository.exchangeRate(first!.code, "2024-05-05");

    if (lor.isRight) {
      exchangeRateModel = lor.right;
      setRatio();
    } else {
      setFailure(lor.left);
    }
  }

  Future<void> selectFirstCurrency(String? value) async {
    if (value == null) return;

    first!.code = value;
    update();
    await updateAmounts(first);
  }

  Future<void> selectSecondCurrency(String? value) async {
    if (value == null) return;

    second!.code = value;
    update();
    await updateAmounts(second);
  }

  Future<void> updateAmounts(SelectedCurrencyModel? value) async {
    if (value != null) {
      await _getExchangeRate();
      second!.amount = _convertFormula(first!.amount!, ratio);
    }
  }

  Future<void> swapCurrencies() async {
    final firstSelectedCopy = first!.code;
    first!.code = second!.code;
    second!.code = firstSelectedCopy;
    update();

    await updateAmounts(first!);
    update();
  }

  void setFirstAmount(String value) {
    first!.amount = double.tryParse(value);
    second!.amount = first?.amount == null ? null : _convertFormula(first!.amount!, ratio);
    update();
  }

  void setSecondAmount(String value) {
    second!.amount = double.tryParse(value);
    first!.amount = second?.amount == null ? null : _convertFormula(second!.amount!, ratio);
    update();
  }

  double _convertFormula(double amount, double ratio) {
    return amount * ratio;
  }

  void setRatio() {
    if (exchangeRateModel == null) return;

    if (exchangeRateModel!.code == first!.code) {
      ratio = exchangeRateModel!.rates[second!.code.toLowerCase()];
    } else {
      ratio = exchangeRateModel!.rates[first!.code.toLowerCase()];
    }

    update();
  }
}
