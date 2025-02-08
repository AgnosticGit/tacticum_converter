import 'package:either_dart/either.dart';
import 'package:tacticum_converter/core/failures/failure.dart';
import 'package:tacticum_converter/features/domain/models/exchange_rate_model.dart';

abstract class ConverterRepository {
  Future<Either<Failure, List<String>>> currencyCodes();

  Future<Either<Failure, ExchangeRateModel>> exchangeRate(String code, String date);
}
