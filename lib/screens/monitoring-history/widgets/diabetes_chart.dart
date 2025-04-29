// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_preven_ia_app/core/domain/models/monitoring_data.dart';
import 'package:mobile_preven_ia_app/core/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DiabetesChart extends StatelessWidget {
  final List<Glucose> data;

  const DiabetesChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: PviText(
          text: 'No hay datos de glucosa disponibles',
          variant: TextVariant.body2,
        ),
      );
    }

    final sortedData = List<Glucose>.from(data)
      ..sort((a, b) => a.date.compareTo(b.date));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PviText(
            text: 'Niveles de Glucosa',
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
                maximum: sortedData
                        .map((e) => e.value)
                        .reduce((a, b) => a > b ? a : b) *
                    1.2,
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
                title: const AxisTitle(
                  text: 'mg/dL',
                  textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              series: <CartesianSeries<Glucose, DateTime>>[
                LineSeries<Glucose, DateTime>(
                  name: 'Glucosa',
                  dataSource: sortedData,
                  xValueMapper: (Glucose data, _) => data.date,
                  yValueMapper: (Glucose data, _) => data.value,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
