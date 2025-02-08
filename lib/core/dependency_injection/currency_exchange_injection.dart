import 'package:get/get.dart';
import 'package:tacticum_converter/core/constants/currency_flags/currency_flags.dart';
import 'package:tacticum_converter/features/data/repositories/converter_repository_impl.dart';
import 'package:tacticum_converter/features/domain/controllers/converter/converter_controller.dart';

class CurrencyExchangeInjection {
  CurrencyExchangeInjection._();

  static void inject() {
    // Инъектится через Get вместо синглтона для того чтобы можно было удалить из памяти
    // при необходимости через Get.delete
    Get.put(
      CurrencyFlags(),
      permanent: true,
    );

    Get.lazyPut(
      () => ConverterRepositoryImpl(),
      fenix: true,
    );

    Get.lazyPut(
      () => ConverterController(
        Get.find<ConverterRepositoryImpl>(),
      ),
      fenix: true,
    );
  }
}
