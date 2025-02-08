import 'dart:convert';

import 'package:flutter/material.dart';

part 'currency_flags_json.dart';

class CurrencyFlags {
  CurrencyFlags() {
    init();
  }

  final Map<String, Currency> images = {};

  void init() {
    for (int i = 0; i < _currencyFlags.length; i++) {
      final code = _currencyFlags[i]['code'];
      final flagEncodedBase64 = _currencyFlags[i]['flag'];

      if (flagEncodedBase64 == null || code == null) continue;

      final cleanEncodedBase64 = flagEncodedBase64.split(',')[1];
      final decodedBase64 = base64.decode(cleanEncodedBase64);
      final image = Image.memory(decodedBase64);

      images[code] = Currency(code, image);
    }
  }

  Currency? currencyByCode(String code) {
    return images[code.toUpperCase()];
  }
}

class Currency {
  Currency(this.code, this.flag);

  final String code;
  final Image flag;
}
