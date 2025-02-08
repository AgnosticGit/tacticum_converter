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
  String secondAmount = '';

  Future<void> loadCurrencyCodes() async {
    loadingStarted();

    final lor = await converterRepository.currencyCodes();

    if (lor.isRight) {
      availableCurrencyCodes = lor.right.map((e) => e.toUpperCase()).toList();
      firstSelected = 'USD';
      secondSelected = 'EUR';
    } else {
      setFailure(lor.left);
    }

    loadingFinished();
  }

  Future<void> _getExchangeRate(String code) async {
    final lor = await converterRepository.exchangeRate(code, "2024-03-06");

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
    }
  }

  Future<void> selectSecondCurrency(String? value) async {
    secondSelected = value;
    update();

    if (value != null) {
      await _getExchangeRate(value);
    }
  }
}
