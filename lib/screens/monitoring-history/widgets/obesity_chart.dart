// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_preven_ia_app/core/domain/models/monitoring_data.dart';
import 'package:mobile_preven_ia_app/core/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ObesityChart extends StatelessWidget {
  final List<Weight> data;

  const ObesityChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: PviText(
          text: 'No hay datos de peso disponibles',
          variant: TextVariant.body2,
        ),
      );
    }

    final sortedData = List<Weight>.from(data)
      ..sort((a, b) => a.date.compareTo(b.date));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PviText(
            text: 'Historial de Peso',
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
                dateFormat: DateFormat('dd/MM', 'es_MX'),
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
                intervalType: DateTimeIntervalType.days,
                interval: 7,
                minimum: sortedData.first.date,
                maximum: sortedData.last.date,
              ),
              primaryYAxis: NumericAxis(
                minimum: sortedData
                        .map((e) => e.value)
                        .reduce((a, b) => a < b ? a : b) *
                    0.9,
                maximum: sortedData
                        .map((e) => e.value)
                        .reduce((a, b) => a > b ? a : b) *
                    1.1,
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
                title: const AxisTitle(
                  text: 'kg',
                  textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              series: <CartesianSeries<Weight, DateTime>>[
                LineSeries<Weight, DateTime>(
                  name: 'Peso',
                  dataSource: sortedData,
                  xValueMapper: (Weight data, _) => data.date.toLocal(),
                  yValueMapper: (Weight data, _) => data.value,
                  color: AppColors.primary,
                  width: 3,
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 6,
                    width: 6,
                  ),
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.auto,
                    angle: -45,
                    textStyle: const TextStyle(fontSize: 10),
                    builder: (dynamic data, dynamic point, dynamic series,
                        int pointIndex, int seriesIndex) {
                      return Text(
                        DateFormat('dd/MM', 'es_MX').format(data.date),
                        style: const TextStyle(fontSize: 10),
                      );
                    },
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
