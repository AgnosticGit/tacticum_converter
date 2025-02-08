abstract class Urls {
  static const currencyList =
      'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies.json';

  /// `Date` формат YYYY-MM-DD
  static String exchangeRate(String code, String date) =>
      'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@$date/v1/currencies/$code.json';
}
