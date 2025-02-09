import 'dart:convert';

import 'package:either_dart/src/either.dart';
import 'package:tacticum_converter/core/constants/urls.dart';
import 'package:tacticum_converter/core/failures/failure.dart';
import 'package:tacticum_converter/features/domain/models/exchange_rate_model.dart';
import 'package:tacticum_converter/features/domain/repositories/converter_repository.dart';
import 'package:http/http.dart' as http;

class ConverterRepositoryImpl implements ConverterRepository {
  @override
  Future<Either<Failure, List<String>>> currencyCodes() async {
    try {
      final response = await http.get(Uri.parse(Urls.currencyList));
      final Map<String, dynamic> json = jsonDecode(response.body);

      return Right(json.keys.toList());
    } catch (e) {
      return Left(Failure(1000));
    }
  }

  @override
  Future<Either<Failure, ExchangeRateModel>> exchangeRate(String code, String date) async {
    code = code.toLowerCase();

    try {
      final response = await http.get(Uri.parse(Urls.exchangeRate(code, date)));
      final Map<String, dynamic> json = jsonDecode(response.body);
      return Right(ExchangeRateModel.fromJson(code, json));
    } catch (e) {
      return Left(Failure(1000));
    }
  }
}
