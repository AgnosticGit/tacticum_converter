import 'package:get/get.dart';
import 'package:tacticum_converter/core/constants/currency_flags/currency_flags.dart';
import 'package:tacticum_converter/features/data/datasources/shared_state.dart';
import 'package:tacticum_converter/features/data/repositories/api/converter_repository_impl.dart';
import 'package:tacticum_converter/features/data/repositories/state/converter_state_repository_impl.dart';
import 'package:tacticum_converter/features/domain/controllers/converter/converter_controller.dart';
import 'package:tacticum_converter/features/domain/controllers/converter/exchange_history_controller.dart';

class CurrencyExchangeInjection {
  CurrencyExchangeInjection._();

  static void inject() {
    // Инъектится через Get вместо синглтона для того чтобы можно было удалить из памяти
    // при необходимости через Get.delete
    Get.put(
      CurrencyFlags(),
      permanent: true,
    );

    Get.put(
      SharedState(),
      permanent: true,
    );

    Get.lazyPut(
      () => ConverterRepositoryImpl(),
      fenix: true,
    );

    Get.lazyPut(
      () => ConverterStateRepositoryImpl(Get.find<SharedState>()),
      fenix: true,
    );

    Get.lazyPut(
      () => ConverterController(
        converterRepository: Get.find<ConverterRepositoryImpl>(),
        converterStateRepository: Get.find<ConverterStateRepositoryImpl>(),
      ),
      fenix: true,
    );

    Get.lazyPut(
      () => ExchangeHistoryController(
        converterRepository: Get.find<ConverterRepositoryImpl>(),
        converterStateRepository: Get.find<ConverterStateRepositoryImpl>(),
      ),
      fenix: true,
    );
  }
}
