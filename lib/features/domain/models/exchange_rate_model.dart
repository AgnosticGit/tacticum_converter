class ExchangeRateModel {
  ExchangeRateModel({required this.code, required this.rates, required this.date});

  final String code;
  final Map<String, dynamic> rates;
  final DateTime date;

  factory ExchangeRateModel.fromJson(String code, Map<String, dynamic> json) {
    final date = DateTime.parse(json['date']);

    return ExchangeRateModel(
      code: code,
      rates: json[code],
      date: date,
    );
  }
}
