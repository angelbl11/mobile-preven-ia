// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_preven_ia_app/core/domain/models/monitoring_data.dart';
import 'package:mobile_preven_ia_app/core/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HypertensionChart extends StatelessWidget {
  final List<BloodPressure> data;

  const HypertensionChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: PviText(
          text: 'No hay datos de presión arterial disponibles',
          variant: TextVariant.body2,
        ),
      );
    }

    final sortedData = List<BloodPressure>.from(data)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Find the maximum value between systolic and diastolic to set Y axis
    final maxValue = sortedData
        .map((e) => e.systolic > e.diastolic ? e.systolic : e.diastolic)
        .reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PviText(
            text: 'Presión Arterial',
            variant: TextVariant.headline4,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SfCartesianChart(
              zoomPanBehavior: ZoomPanBehavior(
                enablePinching: true,
                enableDoubleTapZooming: true,
                enablePanning: true,
                zoomMode: ZoomMode.xy,
                maximumZoomLevel: 0.1,
                enableSelectionZooming: true,
                selectionRectBorderColor: AppColors.primary,
                selectionRectBorderWidth: 2,
                selectionRectColor: AppColors.primary.withOpacity(0.1),
              ),
              legend: const Legend(
                isVisible: true,
                position: LegendPosition.top,
                orientation: LegendItemOrientation.horizontal,
              ),
              primaryXAxis: DateTimeAxis(
                dateFormat: DateFormat('dd/MM'),
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
                title: const AxisTitle(
                  text: 'Fecha',
                  textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                enableAutoIntervalOnZooming: true,
              ),
              primaryYAxis: NumericAxis(
                minimum: 0,
                maximum: maxValue * 1.2,
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
                title: const AxisTitle(
                  text: 'mmHg',
                  textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              series: <CartesianSeries<BloodPressure, DateTime>>[
                LineSeries<BloodPressure, DateTime>(
                  name: 'Presión Sistólica',
                  dataSource: sortedData,
                  xValueMapper: (BloodPressure data, _) => data.date,
                  yValueMapper: (BloodPressure data, _) =>
                      data.systolic.toDouble(),
                  color: AppColors.primary,
                  width: 3,
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 6,
                    width: 6,
                  ),
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.auto,
                    angle: -45,
                    textStyle: TextStyle(fontSize: 10),
                  ),
                ),
                LineSeries<BloodPressure, DateTime>(
                  name: 'Presión Diastólica',
                  dataSource: sortedData,
                  xValueMapper: (BloodPressure data, _) => data.date,
                  yValueMapper: (BloodPressure data, _) =>
                      data.diastolic.toDouble(),
                  color: AppColors.secondary,
                  width: 3,
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 6,
                    width: 6,
                  ),
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.auto,
                    angle: -45,
                    textStyle: TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
