import 'package:get/get.dart';
import 'package:tacticum_converter/core/failures/failure.dart';

class Controller extends GetxController {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Failure? _failure;

  Failure? get failure => _failure;

  bool get hasFailure => _failure != null;

  bool get hasNotFailure => _failure == null;

  void loadingStarted() {
    _failure = null;
    _isLoading = true;
    update();
  }

  void loadingFinished() {
    _isLoading = false;
    update();
  }

  void setFailure(Failure? newFailure) {
    _failure = newFailure;
    update();
  }

  void resetFailure() {
    _failure = null;
    update();
  }
}