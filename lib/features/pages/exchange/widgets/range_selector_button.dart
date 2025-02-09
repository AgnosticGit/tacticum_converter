import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tacticum_converter/core/constants/enums.dart';
import 'package:tacticum_converter/features/domain/controllers/converter/exchange_history_controller.dart';

class RangeSelectorButton extends StatelessWidget {
  const RangeSelectorButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExchangeHistoryController>(
      builder: (controller) {
        return CupertinoSlidingSegmentedControl<ExchangeHistoryRange>(
          backgroundColor: Colors.white,
          
          thumbColor: Colors.white,
          groupValue: controller.range,
          onValueChanged: (ExchangeHistoryRange? value) {
            if (value != null) {
              controller.setRange(value);
            }
          },
          children: {
            ExchangeHistoryRange.week: Text('Week'),
            ExchangeHistoryRange.month: Text('Month'),
            ExchangeHistoryRange.year: Text('Year'),
          },
        );
      },
    );
  }
}
