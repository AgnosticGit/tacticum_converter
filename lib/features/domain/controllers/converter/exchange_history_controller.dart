import 'package:either_dart/either.dart';
import 'package:tacticum_converter/core/constants/enums.dart';
import 'package:tacticum_converter/core/failures/failure.dart';
import 'package:tacticum_converter/features/domain/controllers/abstracts/controller.dart';
import 'package:tacticum_converter/features/domain/models/exchange_rate_model.dart';
import 'package:tacticum_converter/features/domain/models/rate_model.dart';
import 'package:tacticum_converter/features/domain/repositories/converter_repository.dart';
import 'package:tacticum_converter/features/domain/repositories/converter_state_repository.dart';

class ExchangeHistoryController extends Controller {
  ExchangeHistoryController({
    required this.converterRepository,
    required this.converterStateRepository,
  });

  final ConverterRepository converterRepository;
  final ConverterStateRepository converterStateRepository;

  List<RateModel> rates = [];

  ExchangeHistoryRange range = ExchangeHistoryRange.month;

  Future<void> loadExchangeHistory() async {
    resetFailure();
    loadingStarted();

    final now = DateTime.now().subtract(Duration(days: 1));
    final year = now.year;
    final month = now.month;
    final List<Future<Either<Failure, ExchangeRateModel>>> futures = [];
    final (firstSelected, secondSelected) = converterStateRepository.selectedCurrencies();

    if (firstSelected == null || secondSelected == null) return;

    if (range == ExchangeHistoryRange.year) {
      for (int i = 1; i <= month; i++) {
        final ix = i < 10 ? '0$i' : i;
        futures.add(converterRepository.exchangeRate(firstSelected.code, '$year-$ix-01'));
      }
    }

    if (range == ExchangeHistoryRange.month) {
      final days = now.day;
      final formatedMonth = month < 10 ? '0$month' : month;

      for (int i = 1; i <= days; i++) {
        final ix = i < 10 ? '0$i' : i;
        futures.add(
          converterRepository.exchangeRate(firstSelected.code, '$year-$formatedMonth-$ix'),
        );
      }
    }

    final lorList = await Future.wait(futures);
    final List<RateModel> resultList = [];

    for (final lor in lorList) {
      if (lor.isRight) {
        final double rate = lor.right.rates[secondSelected.code.toLowerCase()];
        resultList.add(RateModel(lor.right.date, rate));
      } else {
        setFailure(lor.left);
        break;
      }
    }

    if (!hasFailure) {
      rates = resultList;
    }

    loadingFinished();
  }

  Future<void> setRange(ExchangeHistoryRange value) async {
    range = value;
    update();
    await loadExchangeHistory();
  }
}
