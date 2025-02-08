import 'package:tacticum_converter/features/domain/controllers/abstracts/controller.dart';
import 'package:tacticum_converter/features/domain/models/exchange_rate_model.dart';
import 'package:tacticum_converter/features/domain/repositories/converter_repository.dart';

class ConverterController extends Controller {
  ConverterController(this.converterRepository);

  final ConverterRepository converterRepository;

  List<String> availableCurrencyCodes = [];
  ExchangeRateModel? exchangeRateModel;

  String? firstSelected;
  String? secondSelected;
  double? _firstAmount;
  double? _secondAmount;
  double ratio = 1.0;

  String get firstAmount => _firstAmount != null ? _firstAmount!.toStringAsPrecision(3) : "";
  String get secondAmount => _secondAmount != null ? _secondAmount!.toStringAsPrecision(3) : "";

  Future<void> loadCurrencyCodes() async {
    loadingStarted();

    final lor = await converterRepository.currencyCodes();

    if (lor.isRight) {
      availableCurrencyCodes = lor.right.map((e) => e.toUpperCase()).toList();
      firstSelected = 'USD';
      secondSelected = 'EUR';
      await _getExchangeRate(firstSelected!);
      setAmounts();
    } else {
      setFailure(lor.left);
    }

    loadingFinished();
  }

  void setAmounts() {
    _firstAmount = 1.0;
    _secondAmount = _convertFormula(_firstAmount!, ratio);
    update();
  }

  Future<void> _getExchangeRate(String code) async {
    final lor = await converterRepository.exchangeRate(code, "2025-01-01");

    if (lor.isRight) {
      exchangeRateModel = lor.right;
      setRatio();
    } else {
      setFailure(lor.left);
    }
  }

  Future<void> selectFirstCurrency(String? value) async {
    firstSelected = value;
    update();
    await updateAmounts(value);
  }

  Future<void> selectSecondCurrency(String? value) async {
    secondSelected = value;
    update();
    await updateAmounts(value);
  }

  Future<void> updateAmounts(String? value) async {
    if (value != null) {
      await _getExchangeRate(value);
      _secondAmount = _convertFormula(_firstAmount!, ratio);
    }
  }

  Future<void> swapCurrencies() async {
    final firstSelectedCash = firstSelected;
    firstSelected = secondSelected;
    secondSelected = firstSelectedCash;
    update();

    await updateAmounts(firstSelected);
    update();
  }

  void setFirstAmount(String value) {
    _firstAmount = double.tryParse(value);
    _secondAmount = _firstAmount == null ? null : _convertFormula(_firstAmount!, ratio);
    update();
  }

  void setSecondAmount(String value) {
    _secondAmount = double.tryParse(value);
    _firstAmount = _secondAmount == null ? null : _convertFormula(_secondAmount!, ratio);
    update();
  }

  double _convertFormula(double amount, double ratio) {
    return amount * ratio;
  }

  void setRatio() {
    if (exchangeRateModel == null) return;

    if (exchangeRateModel!.code == firstSelected) {
      ratio = exchangeRateModel!.rates[secondSelected!.toLowerCase()];
    } else {
      ratio = exchangeRateModel!.rates[firstSelected!.toLowerCase()];
    }
    update();
  }
}
