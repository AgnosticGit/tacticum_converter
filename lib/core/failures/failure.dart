import 'package:flutter/foundation.dart';
part 'failure_codes.dart';

@immutable
class Failure {
  factory Failure(int code, {bool log = true}) {
    final failure = _codes[code] ?? _codes[-1]!;

    return failure;
  }

  const Failure._(this.code, this.message);

  final int code;
  final String message;

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
    };
  }

  @override
  String toString() => '$code\n$runtimeType\nmessage: $message\n';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure && runtimeType == other.runtimeType && code == other.code;

  @override
  int get hashCode => code.hashCode;
}
