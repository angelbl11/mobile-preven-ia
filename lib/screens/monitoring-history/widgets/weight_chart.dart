import 'package:flutter/material.dart';
import 'package:mobile_preven_ia_app/firebase/storage/mappers/weight_history.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class WeightChart extends StatelessWidget {
  final List<WeightHistory> data;

  const WeightChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(
          text: 'Historial de Peso',
          textStyle: AppFonts.headline3.copyWith(fontSize: 16)),
      legend: const Legend(isVisible: false),
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: DateTimeAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        dateFormat: DateFormat('dd-MM HH:mm'),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(
            text: 'Peso (kg)',
            textStyle: AppFonts.headline3.copyWith(fontSize: 14)),
      ),
      series: <CartesianSeries<WeightHistory, DateTime>>[
        LineSeries<WeightHistory, DateTime>(
          dataSource: data,
          xValueMapper: (WeightHistory point, _) => point.createdAt,
          yValueMapper: (WeightHistory point, _) => point.weight,
          name: 'Peso',
          markerSettings: const MarkerSettings(isVisible: true),
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}
