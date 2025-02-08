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
  String firstAmount = '1.0';
  String secondAmount = '0.0';
  double ratio = 1.0;

  Future<void> loadCurrencyCodes() async {
    loadingStarted();

    final lor = await converterRepository.currencyCodes();

    if (lor.isRight) {
      availableCurrencyCodes = lor.right.map((e) => e.toUpperCase()).toList();
      firstSelected = 'USD';
      secondSelected = 'EUR';
      await _getExchangeRate(firstSelected!);
      setRatio();
    } else {
      setFailure(lor.left);
    }

    loadingFinished();
  }

  Future<void> _getExchangeRate(String code) async {
    final lor = await converterRepository.exchangeRate(code, "2025-01-01");

    if (lor.isRight) {
      exchangeRateModel = lor.right;
    } else {
      setFailure(lor.left);
    }
  }

  Future<void> selectFirstCurrency(String? value) async {
    firstSelected = value;
    update();

    if (value != null) {
      await _getExchangeRate(value);
      setRatio();
    }
  }

  Future<void> selectSecondCurrency(String? value) async {
    secondSelected = value;
    update();

    if (value != null) {
      await _getExchangeRate(value);
      setRatio();
    }
  }

  void setFirstAmount(String value) {
    final newFirstAmount = double.tryParse(value);

    if (newFirstAmount == null) return;

    firstAmount = value;
    secondAmount = _convertFormula(double.parse(firstAmount), ratio).toString();

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
