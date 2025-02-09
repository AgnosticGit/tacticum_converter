import 'package:tacticum_converter/features/data/datasources/shared_state.dart';
import 'package:tacticum_converter/features/domain/models/selected_currency_model.dart';
import 'package:tacticum_converter/features/domain/repositories/converter_state_repository.dart';

class ConverterStateRepositoryImpl implements ConverterStateRepository {
  ConverterStateRepositoryImpl(this.sharedState);

  final SharedState sharedState;

  @override
  (SelectedCurrencyModel?, SelectedCurrencyModel?) selectedCurrencies() {
    return (sharedState.firstSelectedCurrency, sharedState.secondSelectedCurrency);
  }

  @override
  void setFirstSelecteCurrency(SelectedCurrencyModel? currency) {
    sharedState.firstSelectedCurrency = currency;
  }

  @override
  void setSecondSelecteCurrency(SelectedCurrencyModel? currency) {
    sharedState.secondSelectedCurrency = currency;
  }
}
