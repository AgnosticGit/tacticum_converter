import 'package:either_dart/either.dart';
import 'package:tacticum_converter/core/constants/enums.dart';
import 'package:tacticum_converter/core/failures/failure.dart';
import 'package:tacticum_converter/features/domain/controllers/abstracts/controller.dart';
import 'package:tacticum_converter/features/domain/models/exchange_rate_model.dart';
import 'package:tacticum_converter/features/domain/repositories/converter_repository.dart';

class ExchangeHistoryController extends Controller {
  ExchangeHistoryController(this.converterRepository);

  final ConverterRepository converterRepository;

  List<ExchangeRateModel> rates = [];

  Future<void> loadCurrencyCodes(ExchangeHistoryRange range) async {
    loadingStarted();

    final now = DateTime.now();

    final List<Future<Either<Failure, ExchangeRateModel>>> futures = [];

    if (range == ExchangeHistoryRange.year) {
      final month = now.month;
      final year = now.year;

      for (int i = 1; i <= month; i++) {
        final ix = month < 10 ? '0$i' : i;
        futures.add(converterRepository.exchangeRate('USD', '$year-$ix-01'));
      }
    }

    final lorList = await Future.wait(futures);
    final List<ExchangeRateModel> resultList = [];

    for (final lor in lorList) {
      if (lor.isRight) {
        resultList.add(lor.right);
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
}
