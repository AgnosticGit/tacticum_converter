import 'package:tacticum_converter/features/domain/models/selected_currency_model.dart';

abstract class ConverterStateRepository {
  (SelectedCurrencyModel? first, SelectedCurrencyModel? second) selectedCurrencies();

  void setFirstSelecteCurrency(SelectedCurrencyModel? currency);

  void setSecondSelecteCurrency(SelectedCurrencyModel? currency);
}
