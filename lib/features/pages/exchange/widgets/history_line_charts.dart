import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tacticum_converter/core/constants/enums.dart';
import 'package:tacticum_converter/core/constants/time.dart';
import 'package:tacticum_converter/core/utils/exchange_ratio_shorter.dart';
import 'package:tacticum_converter/features/domain/controllers/converter/converter_controller.dart';
import 'package:tacticum_converter/features/domain/controllers/converter/exchange_history_controller.dart';
import 'package:tacticum_converter/features/domain/models/rate_model.dart';

class HistoryLineCharts extends StatefulWidget {
  const HistoryLineCharts({super.key});

  @override
  State<HistoryLineCharts> createState() => _HistoryLineChartsState();
}

class _HistoryLineChartsState extends State<HistoryLineCharts> {
  List<Color> gradientColors = [Colors.grey, Colors.grey[300]!];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 12,
        ),
        child: GetBuilder<ExchangeHistoryController>(
          builder: (controller) {
            return LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey[300],
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (val, meta) => bottomTitleWidgets(
                        val,
                        meta,
                        controller.range,
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      // interval: 1,
                      getTitlesWidget: leftTitleWidgets,
                      reservedSize: 50,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 1,
                maxX: getMaxX(controller.rates.length, controller.range),
                minY: 0,
                maxY: getMaxY(controller.rates),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => Colors.blue[900]!,
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((touchedSpot) {
                        final secondCurrencyCode = Get.find<ConverterController>().second?.code;

                        return LineTooltipItem(
                          '${touchedSpot.y} $secondCurrencyCode',
                          TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: ratesToFlSpots(controller.rates, controller.range),
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: gradientColors,
                    ),
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3,
                          color: Colors.grey,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors:
                            gradientColors.map((color) => color.withValues(alpha: 0.3)).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta, ExchangeHistoryRange range) {
    String text = '';

    if (range == ExchangeHistoryRange.year) {
      final currentMonth = DateTime.now().month;

      if (value <= currentMonth) {
        text = TimeConstants.monthsNames.elementAtOrNull(value.toInt() - 1) ?? '';
      }
    }

    if (range == ExchangeHistoryRange.month) {
      if (value % 2 == 0) {
        text = value.toStringAsFixed(0);
      }
    }

    return SideTitleWidget(
      meta: meta,
      child: Text(
        text,
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    return Text(
      shortRatio(value, 2),
      style: TextStyle(color: Colors.grey),
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
    );
  }

  List<FlSpot> ratesToFlSpots(List<RateModel> rates, ExchangeHistoryRange range) {
    List<FlSpot> result = [];

    if (range == ExchangeHistoryRange.year) {
      result = rates.map((e) => FlSpot(e.date.month.toDouble(), e.rate)).toList();
    }

    if (range == ExchangeHistoryRange.month) {
      result = rates.map((e) => FlSpot(e.date.day.toDouble(), e.rate)).toList();
    }

    return result;
  }

  double getMaxY(List<RateModel> rates) {
    double max = 0;

    for (final r in rates) {
      if (r.rate > max) {
        max = r.rate;
      }
    }

    return max * 1.5;
  }

  double getMaxX(int valuesLength, ExchangeHistoryRange range) {
    if (range == ExchangeHistoryRange.year) {
      return valuesLength.toDouble();
    }

    if (range == ExchangeHistoryRange.month) {
      if (valuesLength < 15) return valuesLength.toDouble();

      return 15;
    }

    return valuesLength.toDouble();
  }
}
