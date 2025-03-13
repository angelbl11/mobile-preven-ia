import 'package:flutter/material.dart';
import 'package:mobile_preven_ia_app/firebase/storage/mappers/monitoring_data.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class GlucoseChart extends StatelessWidget {
  final List<MonitoringData> data;

  const GlucoseChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(
          text: 'Historial de Glucosa',
          textStyle: AppFonts.headline3.copyWith(fontSize: 16)),
      legend: const Legend(isVisible: false),
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: DateTimeAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        dateFormat: DateFormat('dd-MM HH:mm'),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(
            text: 'Glucosa (mg/dL)',
            textStyle: AppFonts.headline3.copyWith(fontSize: 14)),
      ),
      series: <CartesianSeries<MonitoringData, DateTime>>[
        LineSeries<MonitoringData, DateTime>(
          dataSource: data,
          xValueMapper: (MonitoringData point, _) => point.date,
          yValueMapper: (MonitoringData point, _) => point.glucose,
          name: 'Glucosa',
          markerSettings: const MarkerSettings(isVisible: true),
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}
